
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ПодготовитьФормуНаСервере();		            	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ФормаЗакрыта Тогда
		Возврат;
	КонецЕсли;

	Если ЗавершениеРаботы Тогда
		Возврат;	
	КонецЕсли;
	
	Если НЕ ФормаЗакрыта И Не ПеренестиВДокумент И ПодобранныеОС.Количество() > 0 Тогда

		ДополнительныеПараметры = Новый Структура();
		ДополнительныеПараметры.Вставить("Отказ", Отказ);
		ТекстВопроса = НСтр("ru = 'Подобранные основные средства не перенесены в документ.
			|
			|Перенести?'");
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаПеренестиОС", Этаформа, ДополнительныеПараметры);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 0);
		
		Отказ = Истина;
		СтандартнаяОбработка = Ложь;

	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;	
	КонецЕсли;
	
	СтруктураВозврата = ПриЗакрытииНаСервере();

	Если ПеренестиВДокумент Тогда
		ОповеститьОВыборе(СтруктураВозврата);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ФормаЗакрыта = Ложь;
	
	// Настройка формы по сохраненным ранее настройкам
	Если ВосстановленныеНастройкиОбщие <> Неопределено Тогда
		Если ВосстановленныеНастройкиОбщие.Свойство("ИсторияПоискаОС") Тогда
			Элементы.СтрокаПоиска.СписокВыбора.ЗагрузитьЗначения(ВосстановленныеНастройкиОбщие.ИсторияПоискаОС);
		КонецЕсли;
		Если ВосстановленныеНастройкиОбщие.Свойство("ВидПоиска") Тогда
			НайденныйВидПоиска = Элементы.ВидПоиска.СписокВыбора.НайтиПоЗначению(ВосстановленныеНастройкиОбщие.ВидПоиска);
			Если НайденныйВидПоиска <> Неопределено Тогда
				ВидПоиска = НайденныйВидПоиска.Значение;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ВидПоиска) Тогда
		ВидПоиска = Элементы.ВидПоиска.СписокВыбора[0].Значение;
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура СтруктурноеПодразделениеОрганизацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	РаботаСДиалогамиКлиент.СтруктурноеПодразделениеНачалоВыбора(ЭтаФорма, СтандартнаяОбработка, Организация, СтруктурноеПодразделение, Истина);
КонецПроцедуры

&НаКлиенте
Процедура СтруктурноеПодразделениеОрганизацияПриИзменении(Элемент)
	
	Если ТипЗнч(СтруктурноеПодразделениеОрганизация) = Тип("СправочникСсылка.ПодразделенияОрганизаций") Тогда
	    СтруктурноеПодразделение = СтруктурноеПодразделениеОрганизация;
		Организация = ?(ЗначениеЗаполнено(СтруктурноеПодразделение), ПолучитьОрганизациюПодразделения(СтруктурноеПодразделение), Неопределено);
	Иначе
		Организация = СтруктурноеПодразделениеОрганизация;
		СтруктурноеПодразделение = Неопределено;
	КонецЕсли;
	
	УстановитьПарамтрОрганизация(ЭтаФорма);	
	УстановитьПараметрОтбора(ЭтаФорма, "СтруктурноеПодразделение", СтруктурноеПодразделение);
	
	Элементы.ИерархияОС.ТекущаяСтрока = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура МестонахождениеПриИзменении(Элемент)
	
	УстановитьПараметрОтбора(ЭтаФорма, "Местонахождение", Местонахождение);
	Элементы.ИерархияОС.ТекущаяСтрока = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаРасчетовПриИзменении(Элемент)
	УстановитьЗначениеПараметраСпискаОС(ЭтаФорма, "Период", ДатаРасчетов);
КонецПроцедуры

&НаКлиенте
Процедура СчетУчетаПриИзменении(Элемент)
	
	УстановитьПараметрОтбора(ЭтаФорма, "СчетУчетаБУ", СчетУчета);
	Элементы.ИерархияОС.ТекущаяСтрока = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура МОЛПриИзменении(Элемент)
	
	УстановитьПараметрОтбора(ЭтаФорма, "МОЛ", МОЛ);
	Элементы.ИерархияОС.ТекущаяСтрока = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВидовПоискаПриИзменении(Элемент)
	ПрименитьПоиск();	
КонецПроцедуры

&НаКлиенте
Процедура СтрокаПоискаПриИзменении(Элемент)
	ПрименитьПоиск();
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ ИерархияОС

&НаКлиенте
Процедура ДеревоВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Элементы.СписокОС.ТекущаяСтрока = Неопределено;
	УстановитьОтборПоИерархииОС(ВыбраннаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура ИерархияОСПриАктивизацииСтроки(Элемент)
	
	Элементы.СписокОС.ТекущаяСтрока = Неопределено;
	УстановитьОтборПоИерархииОС(Элементы.ИерархияОС.ТекущаяСтрока);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ СписокОС

&НаКлиенте
Процедура СписокОСВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.СписокОС.ТекущиеДанные;
	
	СтрукутраПоиска = Новый Структура("ОсновноеСредство", ТекущиеДанные.ОсновноеСредство); 
	НайденныеСтроки = ПодобранныеОС.НайтиСтроки(СтрукутраПоиска);
	
	Если НайденныеСтроки <> Неопределено И НайденныеСтроки.Количество() > 0 Тогда
		ТекстСообщения = НСтр("ru='Основное средство ""%1"" уже выбрано'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, ТекущиеДанные.ОсновноеСредство);
		Поле = "ПодобранныеОС[" + Формат(НайденныеСтроки[0].НомерСтроки - 1, "ЧН=0; ЧГ=") + "].ОсновноеСредство";
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , Поле); 
		Возврат;
	КонецЕсли; 
	
	НоваяСтрока = ПодобранныеОС.Добавить(); 
	ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекущиеДанные);
	НоваяСтрока.НомерСтроки = ПодобранныеОС.Количество();
	
КонецПроцедуры     


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ВыбратьВсе(Команда)
		
	НПП = 1;
	
	МассивСтруктурПодбора = ВыбратьВсеНаСервере();
	Для Каждого СтруктураПодбора Из МассивСтруктурПодбора Цикл
		
		НоваяСтрока = ПодобранныеОС.Добавить(); 
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтруктураПодбора);
		НоваяСтрока.НомерСтроки = НПП;
		
		НПП = НПП + 1;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиВДокумент(Команда)
	
	ПеренестиВДокумент = Истина;
	Закрыть(КодВозвратаДиалога.OK);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	ПоддержкаРаботыСоСтруктурнымиПодразделениями = ПолучитьФункциональнуюОпцию("ПоддержкаРаботыСоСтруктурнымиПодразделениями");
	
	РаботаСДиалогамиКлиентСервер.УстановитьВидимостьСтруктурногоПодразделения(Организация, СтруктурноеПодразделение, СтруктурноеПодразделениеОрганизация);
	РаботаСДиалогамиКлиентСервер.УстановитьСвойстваЭлементаСтруктурноеПодразделениеОрганизация(Элементы.СтруктурноеПодразделениеОрганизация, СтруктурноеПодразделение, ПоддержкаРаботыСоСтруктурнымиПодразделениями);

	ИмяОбъекта = ?(Параметры.Свойство("ОбъектСсылка"), Параметры.ОбъектСсылка.Метаданные().Имя, "");
	
	СписокСвойств = "ДатаРасчетов, Заголовок, Организация, ВыбиратьВсе, СтруктурноеПодразделение, ИмяТаблицы";
	Если Параметры.Свойство("Местонахождение") Тогда
		СписокСвойств = СписокСвойств + ", Местонахождение";
	КонецЕсли; 
	
	ЗаполнитьЗначенияСвойств(ЭтаФорма, Параметры, СписокСвойств);

	Если ЗначениеЗаполнено(СтруктурноеПодразделение) Тогда
		СтруктурноеПодразделениеОрганизация = СтруктурноеПодразделение;
	Иначе
		СтруктурноеПодразделениеОрганизация = Организация;
	КонецЕсли; 
	                	
	Элементы.ФормаВыбратьВсе.Видимость = ВыбиратьВсе;
	Элементы.СтруктурноеПодразделениеОрганизация.Доступность = НЕ ЗначениеЗаполнено(Организация);
	
	ВосстановленныеНастройкиОбщие = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ПодборОС", "Поиск");
	
	УстановитьПарамтрОрганизация(ЭтаФорма);
	УстановитьПараметрОтбора(ЭтаФорма, "СтруктурноеПодразделение", СтруктурноеПодразделение);
	УстановитьПараметрОтбора(ЭтаФорма, "СнятоСУчета", СнятоСУчета);
	УстановитьЗначениеПараметраСпискаОС(ЭтаФорма, "Период", ДатаРасчетов);
		            	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораСтруктурногоПодразделения(Результат, Параметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		Организация              = Результат.Организация;
		СтруктурноеПодразделение = Результат.СтруктурноеПодразделение;
		СтруктурноеПодразделениеОрганизация = ?(ЗначениеЗаполнено(СтруктурноеПодразделение), СтруктурноеПодразделение, Организация)	
	Иначе
		Организация              = Неопределено;
		СтруктурноеПодразделение = Неопределено;
		СтруктурноеПодразделениеОрганизация = Неопределено;
	КонецЕсли;    
		             	
	УстановитьПарамтрОрганизация(ЭтаФорма);	
	УстановитьПараметрОтбора(ЭтаФорма, "СтруктурноеПодразделение", СтруктурноеПодразделение);
	Элементы.ИерархияОС.ТекущаяСтрока = Неопределено;
		
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьПарамтрОрганизация(Форма)
	
	Если ЗначениеЗаполнено(Форма.Организация) Тогда
		УстановитьЗначениеПараметраСпискаОС(Форма, "Организация", Форма.Организация);
	Иначе
		ПолеОтбора = Форма.СписокОС.Параметры.Элементы.Найти("Организация");
		Если ПолеОтбора <> Неопределено Тогда
			ПолеОтбора.Использование = Ложь;
		КонецЕсли;		 
	КонецЕсли;
	
КонецПроцедуры  

&НаКлиенте
Процедура УстановитьОтборПоИерархииОС(ГруппаОС)

	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(СписокОС, "ОсновноеСредство",
		ГруппаОС, ЗначениеЗаполнено(ГруппаОС), ВидСравненияКомпоновкиДанных.ВИерархии);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьЗначениеПараметраСпискаОС(Форма, ИмяПараметра, ЗначениеПараметра)
	Форма.СписокОС.Параметры.УстановитьЗначениеПараметра(ИмяПараметра, ЗначениеПараметра);
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьОрганизациюПодразделения(СтруктурноеПодразделение)
	Возврат ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СтруктурноеПодразделение, "Владелец").Владелец;		
КонецФункции

&НаКлиенте
Процедура ПрименитьПоиск()
		
	УстановитьПараметрОтбора(ЭтаФорма, ВидПоиска, СтрокаПоиска, ВидСравненияКомпоновкиДанных.Содержит);	
	СпискиВыбораКлиентСервер.ОбновитьСписокВыбора(Элементы.СтрокаПоиска.СписокВыбора, СтрокаПоиска);
	ТекущийЭлемент = Элементы.СписокОС;

КонецПроцедуры

&НаСервере
Функция ВыбратьВсеНаСервере()
	
	ПодобранныеОС.Очистить();
	
	// 1. Сформируем таблицу отобранных ОС - копию динамического списка
	СхемаКомпоновки = Новый СхемаКомпоновкиДанных();

	Источник                    = СхемаКомпоновки.ИсточникиДанных.Добавить();
	Источник.Имя                = "Источник1";
	Источник.СтрокаСоединения   = "";
	Источник.ТипИсточникаДанных = "local";

	НаборДанных = СхемаКомпоновки.НаборыДанных.Добавить(Тип("НаборДанныхЗапросСхемыКомпоновкиДанных"));

	НаборДанных.Имя            = "Запрос";
	НаборДанных.Запрос         = СписокОС.ТекстЗапроса;
	НаборДанных.ИсточникДанных = "Источник1";
	НаборДанных.АвтоЗаполнениеДоступныхПолей = Истина;

	НастройкиКомпоновки = СкомпоноватьНастройки(СхемаКомпоновки);

	СкопироватьЭлементы(НастройкиКомпоновки.Отбор  , СписокОС.Отбор);
	СкопироватьЭлементы(НастройкиКомпоновки.Порядок, СписокОС.Порядок);
	
	Для Каждого ПараметрДанных Из СписокОС.Параметры.Элементы Цикл
		НастройкиКомпоновки.ПараметрыДанных.УстановитьЗначениеПараметра(ПараметрДанных.Параметр, ПараметрДанных.Значение);
	КонецЦикла;
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки   = КомпоновщикМакета.Выполнить(СхемаКомпоновки, НастройкиКомпоновки, , , Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки);
	
	ТаблицаОС = Новый ТаблицаЗначений;

	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ПроцессорВывода.УстановитьОбъект(ТаблицаОС);
	ПроцессорВывода.НачатьВывод();

	Пока Истина Цикл
	    
	    ЭлементРезультатаКомпоновкиДанных      = ПроцессорКомпоновкиДанных.Следующий();
	    Если ЭлементРезультатаКомпоновкиДанных = Неопределено Тогда 
	        Прервать;
	    КонецЕсли;
	    
	    ПроцессорВывода.ВывестиЭлемент(ЭлементРезультатаКомпоновкиДанных);
	    
	КонецЦикла;

	ПроцессорВывода.ЗакончитьВывод(); 	
	
	// 2. Сформируем массив для заполнения таб. части ПодобранныеОС обработки
	МассивВозврата = Новый Массив;
	
	Для Каждого СтрокаПодбора Из ТаблицаОС Цикл
		
		СтруктураПараметрыНоменклатуры = Новый Структура;
		СтруктураПараметрыНоменклатуры.Вставить("ОсновноеСредство", СтрокаПодбора.ОсновноеСредство);
		СтруктураПараметрыНоменклатуры.Вставить("ИнвентарныйНомер", СтрокаПодбора.ИнвентарныйНомер);
		СтруктураПараметрыНоменклатуры.Вставить("Код",              СтрокаПодбора.Код);

		МассивВозврата.Добавить(СтруктураПараметрыНоменклатуры);
		
	КонецЦикла;
	
	Возврат МассивВозврата;
	
КонецФункции

&НаСервереБезКонтекста
Функция СкомпоноватьНастройки(СхемаКомпоновки) Экспорт

	ИсточникНастроек    = Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновки);
	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных();
	КомпоновщикНастроек.Инициализировать(ИсточникНастроек);
	
	// Добавим выбранные поля
	Для Каждого Элемент Из КомпоновщикНастроек.Настройки.Выбор.ДоступныеПоляВыбора.Элементы Цикл
		
		Если НЕ Элемент.Папка Тогда
			ВыбранноеПоле               = КомпоновщикНастроек.Настройки.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
			ВыбранноеПоле.Поле          = Элемент.Поле;
			ВыбранноеПоле.Использование = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	// Добавим группировку
	ГруппировкаНастроек = КомпоновщикНастроек.Настройки.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
	Поле                = ГруппировкаНастроек.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
	
	Возврат КомпоновщикНастроек.Настройки;

КонецФункции

 &НаСервереБезКонтекста
Процедура СкопироватьЭлементы(ПриемникЗначения, ИсточникЗначения, ПроверятьДоступность = Ложь, ОчищатьПриемник = Истина) Экспорт
	
	Если ТипЗнч(ИсточникЗначения) = Тип("УсловноеОформлениеКомпоновкиДанных")
		ИЛИ ТипЗнч(ИсточникЗначения) = Тип("ВариантыПользовательскогоПоляВыборКомпоновкиДанных")
		ИЛИ ТипЗнч(ИсточникЗначения) = Тип("ОформляемыеПоляКомпоновкиДанных")
		ИЛИ ТипЗнч(ИсточникЗначения) = Тип("ЗначенияПараметровДанныхКомпоновкиДанных") Тогда
		СоздаватьПоТипу = Ложь;
	Иначе
		СоздаватьПоТипу = Истина;
	КонецЕсли;
	ПриемникЭлементов = ПриемникЗначения.Элементы;
	ИсточникЭлементов = ИсточникЗначения.Элементы;
	Если ОчищатьПриемник Тогда
		ПриемникЭлементов.Очистить();
	КонецЕсли;
	
	Для каждого ЭлементИсточник Из ИсточникЭлементов Цикл
		
		Если ТипЗнч(ЭлементИсточник) = Тип("ЭлементПорядкаКомпоновкиДанных") Тогда
			// Элементы порядка добавляем в начало
			Индекс = ИсточникЭлементов.Индекс(ЭлементИсточник);
			ЭлементПриемник = ПриемникЭлементов.Вставить(Индекс, ТипЗнч(ЭлементИсточник));
		Иначе
			Если СоздаватьПоТипу Тогда
				ЭлементПриемник = ПриемникЭлементов.Добавить(ТипЗнч(ЭлементИсточник));
			Иначе
				ЭлементПриемник = ПриемникЭлементов.Добавить();
			КонецЕсли;
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(ЭлементПриемник, ЭлементИсточник);
		// В некоторых коллекциях необходимо заполнить другие коллекции
		Если ТипЗнч(ИсточникЭлементов) = Тип("КоллекцияЭлементовУсловногоОформленияКомпоновкиДанных") Тогда
			СкопироватьЭлементы(ЭлементПриемник.Поля, ЭлементИсточник.Поля);
			СкопироватьЭлементы(ЭлементПриемник.Отбор, ЭлементИсточник.Отбор);
			ЗаполнитьЭлементы(ЭлементПриемник.Оформление, ЭлементИсточник.Оформление); 
		ИначеЕсли ТипЗнч(ИсточникЭлементов)	= Тип("КоллекцияВариантовПользовательскогоПоляВыборКомпоновкиДанных") Тогда
			СкопироватьЭлементы(ЭлементПриемник.Отбор, ЭлементИсточник.Отбор);
		КонецЕсли;
		
		// В некоторых элементах коллекции необходимо заполнить другие коллекции
		Если ТипЗнч(ЭлементИсточник) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
			СкопироватьЭлементы(ЭлементПриемник, ЭлементИсточник);
		ИначеЕсли ТипЗнч(ЭлементИсточник) = Тип("ГруппаВыбранныхПолейКомпоновкиДанных") Тогда
			СкопироватьЭлементы(ЭлементПриемник, ЭлементИсточник);
		ИначеЕсли ТипЗнч(ЭлементИсточник) = Тип("ПользовательскоеПолеВыборКомпоновкиДанных") Тогда
			СкопироватьЭлементы(ЭлементПриемник.Варианты, ЭлементИсточник.Варианты);
		ИначеЕсли ТипЗнч(ЭлементИсточник) = Тип("ПользовательскоеПолеВыражениеКомпоновкиДанных") Тогда
			ЭлементПриемник.УстановитьВыражениеДетальныхЗаписей (ЭлементИсточник.ПолучитьВыражениеДетальныхЗаписей());
			ЭлементПриемник.УстановитьВыражениеИтоговыхЗаписей(ЭлементИсточник.ПолучитьВыражениеИтоговыхЗаписей());
			ЭлементПриемник.УстановитьПредставлениеВыраженияДетальныхЗаписей(ЭлементИсточник.ПолучитьПредставлениеВыраженияДетальныхЗаписей ());
			ЭлементПриемник.УстановитьПредставлениеВыраженияИтоговыхЗаписей(ЭлементИсточник.ПолучитьПредставлениеВыраженияИтоговыхЗаписей ());
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаполнитьЭлементы(ПриемникЗначения, ИсточникЗначения, ПервыйУровень = Неопределено) Экспорт
	
	Если ТипЗнч(ПриемникЗначения) = Тип("КоллекцияЗначенийПараметровКомпоновкиДанных") Тогда
		КоллекцияЗначений = ИсточникЗначения;
	Иначе
		КоллекцияЗначений = ИсточникЗначения.Элементы;
	КонецЕсли;
	
	Для каждого ЭлементИсточник Из КоллекцияЗначений Цикл
		Если ПервыйУровень = Неопределено Тогда
			ЭлементПриемник = ПриемникЗначения.НайтиЗначениеПараметра(ЭлементИсточник.Параметр);
		Иначе
			ЭлементПриемник = ПервыйУровень.НайтиЗначениеПараметра(ЭлементИсточник.Параметр);
		КонецЕсли;
		Если ЭлементПриемник = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(ЭлементПриемник, ЭлементИсточник);
		Если ТипЗнч(ЭлементИсточник) = Тип("ЗначениеПараметраКомпоновкиДанных") Тогда
			Если ЭлементИсточник.ЗначенияВложенныхПараметров.Количество() <> 0 Тогда
				ЗаполнитьЭлементы(ЭлементПриемник.ЗначенияВложенныхПараметров, ЭлементИсточник.ЗначенияВложенныхПараметров, ПриемникЗначения);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьПараметрОтбора(Форма, ИмяПараметра, ЗначениеПараметра, ВидСравнения = Неопределено)
	
	Если ВидСравнения = Неопределено Тогда
		ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	КонецЕсли; 
	
	Если ИмяПараметра = "СнятоСУчета" Тогда
		ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораГруппыСписка(
			Форма.СписокОС.Отбор, ИмяПараметра, ЗначениеПараметра,
			Не ЗначениеПараметра, ВидСравнения);
	Иначе
		ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораГруппыСписка(
			Форма.СписокОС.Отбор, ИмяПараметра, ЗначениеПараметра,
			ЗначениеЗаполнено(ЗначениеПараметра), ВидСравнения);
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Функция ПриЗакрытииНаСервере()

	СтруктураВозврата = Новый Структура();
	
	ПараметрыЗакрытияОбщие = Новый Структура;
	ПараметрыЗакрытияОбщие.Вставить("ИсторияПоискаОС", Элементы.СтрокаПоиска.СписокВыбора.ВыгрузитьЗначения());
	ПараметрыЗакрытияОбщие.Вставить("ВидПоиска"      , ВидПоиска);
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ПодборОС", "Поиск" , ПараметрыЗакрытияОбщие);

	Если ПеренестиВДокумент Тогда
		АдресПодобранныхОСВХранилище = ПоместитьПодобранныеОСВХранилище();
		СтруктураВозврата.Вставить("АдресПодобранныхОСВХранилище", АдресПодобранныхОСВХранилище);
	КонецЕсли;
	
	Возврат СтруктураВозврата;

КонецФункции

&НаСервере
Функция ПоместитьПодобранныеОСВХранилище()

	ТаблицаОС = ПодобранныеОС.Выгрузить();

	АдресПодобранныхОСВХранилище = ПоместитьВоВременноеХранилище(ТаблицаОС, УникальныйИдентификатор);
	Возврат АдресПодобранныхОСВХранилище;

КонецФункции

&НаКлиенте
Процедура ПослеЗакрытияВопросаПеренестиОС(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ПеренестиВДокумент = Истина;
		ФормаЗакрыта       = Истина;
		Закрыть();
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		ФормаЗакрыта = Истина;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура СнятоСУчетаПриИзменении(Элемент)
	УстановитьПараметрОтбора(ЭтаФорма, "СнятоСУчета", СнятоСУчета);
	Элементы.ИерархияОС.ТекущаяСтрока = Неопределено;
КонецПроцедуры

