
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ РольДоступна(Метаданные.Роли.ПолныеПрава) Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Недостаточно прав доступа!'"));
		Отказ = Истина;
		Возврат;
	КонецЕсли;

	Если Параметры.Свойство("НаборПрав") Тогда
		НаборПрав = Параметры.НаборПрав;
	Иначе	
		НаборПрав = Справочники.ГруппыПользователей.ВсеПользователи;
	КонецЕсли;	
	
	ЗаполнитьДерево();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтаФорма.Модифицированность Тогда
		Режим 				= РежимДиалогаВопрос.ДаНетОтмена;	
		ПараметрыОповещения = Новый Структура("ЗакрыватьФорму", Истина);
		Оповещение 			= Новый ОписаниеОповещения("ПослеЗакрытияВопросаОСохранении", ЭтотОбъект, ПараметрыОповещения);
		ПоказатьВопрос(Оповещение, НСтр("ru = 'Данные были изменены. Сохранить изменения?'"), Режим, 0);
		
		Отказ = Истина;
	КонецЕсли; 
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура НаборПравПриИзменении(Элемент)
	
	ЗаполнитьДерево();
	
КонецПроцедуры

&НаКлиенте
Процедура НаборПравНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ЭтаФорма.Модифицированность Тогда
		
		Режим 				= РежимДиалогаВопрос.ДаНетОтмена;
		ПараметрыОповещения = Новый Структура("ЗакрыватьФорму", Ложь);
		Оповещение			= Новый ОписаниеОповещения("ПослеЗакрытияВопросаОСохранении", ЭтотОбъект, Параметры);
		ПоказатьВопрос(Оповещение, НСтр("ru = 'Данные были изменены. Сохранить изменения?'"), Режим, 0);
		
		Отказ = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ ДеревоПрав

&НаКлиенте
Процедура ДеревоПравЗначениеПриИзменении(Элемент)
	
	ЭтаФорма.Модифицированность = Истина;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Применить(Команда)
	
	ОбновитьНастройкиНаСервере();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ЗаполнитьДерево()
	
	ЭлементыДерева = ДеревоПрав.ПолучитьЭлементы();
	ЭлементыДерева.Очистить();
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	Права.Родитель,
	                      |	Права.Ссылка,
	                      |	Права.ЭтоГруппа,
	                      |	ЗначениеПрав.Значение
	                      |ИЗ
	                      |	ПланВидовХарактеристик.ПраваПользователей КАК Права
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗначенияПравПользователя КАК ЗначениеПрав
	                      |		ПО (ЗначениеПрав.Право = Права.Ссылка)
	                      |			И (ЗначениеПрав.Пользователь = &НаборПрав)
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	Права.ЭтоГруппа ИЕРАРХИЯ,
	                      |	Права.Наименование");
						  
	Запрос.УстановитьПараметр("НаборПрав", НаборПрав);
		
	Выборка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	Идентификатор = Неопределено;
	
	ВыдатьРекурсивноДеревоПрав(Выборка);
	
КонецПроцедуры

&НаСервере
Процедура ВыдатьРекурсивноДеревоПрав(Выборка, СтрокаДерева = Неопределено)
	
	Пока Выборка.Следующий() Цикл
		
		Если СтрокаДерева = Неопределено Тогда
			НоваяСтрокаДерева = ДеревоПрав.ПолучитьЭлементы().Добавить();
		Иначе
			НоваяСтрокаДерева = СтрокаДерева.ПолучитьЭлементы().Добавить();
		КонецЕсли;	
		
		НоваяСтрокаДерева.Право	    = Выборка.Ссылка;
		НоваяСтрокаДерева.Значение  = Выборка.Ссылка.ТипЗначения.ПривестиЗначение(Выборка.Значение);		
		НоваяСтрокаДерева.ЭтоГруппа = Выборка.ЭтоГруппа;
	
		СпособВыборки = ОбходРезультатаЗапроса.ПоГруппировкамСИерархией;
		Если Выборка.ТипЗаписи() = ТипЗаписиЗапроса.ИтогПоИерархии Тогда
			НоваяВыборка  = Выборка.Выбрать(СпособВыборки, Выборка.Группировка());
		Иначе
			НоваяВыборка  = Выборка.Выбрать(СпособВыборки);
		КонецЕсли;		
		
		ВыдатьРекурсивноДеревоПрав(НоваяВыборка, НоваяСтрокаДерева);
	КонецЦикла;	
	
КонецПроцедуры	

&НаКлиенте
Процедура ПослеЗакрытияВопросаОСохранении(Результат, ПараметрыОповещения) Экспорт

	Если Результат = КодВозвратаДиалога.Да Тогда
		ОбновитьНастройкиНаСервере();
	Иначе
		ЭтаФорма.Модифицированность = Ложь;
	КонецЕсли;
	
	Если ПараметрыОповещения.Свойство("ЗакрыватьФорму") И ПараметрыОповещения.Закрыватьформу Тогда
		Закрыть();
	КонецЕсли;	

КонецПроцедуры

&НаСервере
Процедура ОбновитьНастройкиНаСервере()
	
	Набор = РегистрыСведений.ЗначенияПравПользователя.СоздатьНаборЗаписей();
	
	Набор.Отбор.Пользователь.Использование 	= Истина;
	Набор.Отбор.Пользователь.Значение 		= НаборПрав;
	
	ЗаполнитьНаборЗаписей(ДеревоПрав.ПолучитьЭлементы(), Набор);
	
	Набор.Записать();
	
	ЭтаФорма.Модифицированность = Ложь;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаборЗаписей(ЭлементыДерева, НаборЗаписей)
	
	Для Каждого ЭлементДерева Из ЭлементыДерева Цикл
		Если Не ЭлементДерева.ЭтоГруппа Тогда
			Запись = НаборЗаписей.Добавить();
			
			Запись.Пользователь = НаборПрав;
			Запись.Право	 	= ЭлементДерева.Право;
			Запись.Значение  	= ЭлементДерева.Право.ТипЗначения.ПривестиЗначение(ЭлементДерева.Значение);
		Иначе
			ЗаполнитьНаборЗаписей(ЭлементДерева.ПолучитьЭлементы(), НаборЗаписей);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

