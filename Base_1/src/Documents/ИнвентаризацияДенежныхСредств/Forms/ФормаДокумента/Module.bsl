////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	Если Параметры.Ключ.Пустая() Тогда
		ПодготовитьФормуНаСервере();
		РаботаСДиалогами.УстановитьЗаголовокФормыДокумента(Строка(Объект.ВидОперации), Объект.Ссылка, ЭтаФорма);
		
		Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций") Тогда
			СтруктурноеПодразделениеОрганизация = Справочники.Организации.ОрганизацияПоУмолчанию();
		КонецЕсли;  		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// РедактированиеДокументовПользователей
	ПраваДоступаКОбъектам.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец РедактированиеДокументовПользователей
	
	ПодготовитьФормуНаСервере(Ложь);
	РаботаСДиалогами.УстановитьЗаголовокФормыДокумента(Строка(Объект.ВидОперации), Объект.Ссылка, ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

	РаботаСДиалогами.УстановитьЗаголовокФормыДокумента(Строка(Объект.ВидОперации), Объект.Ссылка, ЭтаФорма);
	ЗаполнитьДобавленныеКолонкиТаблиц();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Справочник.ФизическиеЛица.Форма.ФормаВыбора" Тогда
		
		Для Каждого СтрокаМассива Из ВыбранноеЗначение Цикл
			
			СтрокиТабличногоПоля = Объект.ИнвентаризационнаяКомиссия.НайтиСтроки(Новый Структура("ФизЛицо", СтрокаМассива));
			
			Если СтрокиТабличногоПоля.Количество() > 0 Тогда
				
				ТекстСообщения = НСтр("ru='Физическое лицо < %1 > уже выбрано!'");
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, 
				СтрокаМассива);
				
				ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,,, "Объект");
				
			Иначе
				НоваяСтрока = Объект.ИнвентаризационнаяКомиссия.Добавить();	
				НоваяСтрока.ФизЛицо = СтрокаМассива;
				
				Если Объект.ИнвентаризационнаяКомиссия.Количество() = 1 Тогда
					НоваяСтрока.Председатель = Истина;
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если Не ЗначениеЗаполнено(Объект.Организация) Тогда
		Объект.Организация = СтруктурноеПодразделениеОрганизация;
	КонецЕсли;
	
	КлючеваяОперация = "Документ ""инвентаризация денежных средств"" (запись)";
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, КлючеваяОперация);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_Организации" Тогда
		
		Если Источник = Объект.Организация Тогда
			ОбработатьИзмененияВОрганизацииНаСервере();
			Модифицированность = Истина;
		КонецЕсли;
		
	Иначе
		ОбщегоНазначенияБККлиент.ОбработкаОповещенияФормыДокумента(ЭтаФорма, Объект.Ссылка, ИмяСобытия, Параметр, Источник);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ВидОперацииПриИзменении(Элемент)
	
	Если Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийИнвентаризацияДенежныхСредств.ПоКассе") Тогда 		
		Объект.Касса = ПолучитьЗначениеРеквизита(Объект.Организация, "ОсновнаяКасса");                                                                       
	Иначе 		
		Объект.Касса = ПредопределенноеЗначение("Справочник.Кассы.ПустаяСсылка");
	КонецЕсли;
	
	Если Объект.ДенежныеСредства.Количество() > 0 Тогда
		Режим = РежимДиалогаВопрос.ДаНет;
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаВидОперацииПриИзменении", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, НСтр("ru = 'Перезаполнить таблицу денежных средств в соответствии с новым значением вида операции? Существующая таблица будет очищена.'"), Режим, 0);
	Иначе
		ПослеЗакрытияВопросаВидОперацииПриИзменении(КодВозвратаДиалога.Да,);
	КонецЕсли;
	
	ВидОперацииПриИзмененииНаСервере();
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьЗначениеРеквизита(СсылкаНаОбъект, ИмяРеквизита)
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СсылкаНаОбъект, ИмяРеквизита);	
	
КонецФункции

&НаКлиенте
Процедура ПослеЗакрытияВопросаВидОперацииПриИзменении(Результат, Параметры) Экспорт
	
	Если НЕ Результат = КодВозвратаДиалога.Да Тогда
		ВидОперацииПриИзмененииНаСервере();
		Возврат;	
	КонецЕсли;
	
	Объект.ДенежныеСредства.Очистить();
	
	ВидОперацииПриИзмененииНаСервере(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура КассаПриИзменении(Элемент)
	
	Если НЕ Объект.Касса = ТекущаяКасса Тогда
		
		Режим = РежимДиалогаВопрос.ДаНет;
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаКассаПриИзменении", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, НСтр("ru = 'Перезаполнить таблицу денежных средств в соответствии с новым значением кассы?'"), Режим, 0);
		
		ТекущаяКасса = Объект.Касса;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопросаКассаПриИзменении(Результат, Параметры) Экспорт
	
	Если НЕ Результат = КодВозвратаДиалога.Да Тогда
		КассаПриИзмененииНаСервере();
		Возврат;	
	КонецЕсли;
	
	Объект.ДенежныеСредства.Очистить();
	
	КассаПриИзмененииНаСервере(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект, "Объект.Комментарий");
	
КонецПроцедуры

&НаКлиенте
Процедура СтруктурноеПодразделениеОрганизацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)	
	
	РаботаСДиалогамиКлиент.СтруктурноеПодразделениеНачалоВыбора(ЭтаФорма, СтандартнаяОбработка, Объект.Организация, Объект.СтруктурноеПодразделение, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СтруктурноеПодразделениеОрганизацияПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(СтруктурноеПодразделениеОрганизация) Тогда 
		Объект.Организация = Неопределено;
		Объект.СтруктурноеПодразделение = Неопределено;
	Иначе 
		
		ПолучитьПроверитьДанныеПоОрганизации();
		
		Если ИспользоватьНесколькоКассОрганизации Тогда
			
			Результат = РаботаСДиалогамиКлиент.ПроверитьИзменениеЗначенийОрганизацииСтруктурногоПодразделения(СтруктурноеПодразделениеОрганизация, Объект.Организация, Объект.СтруктурноеПодразделение);
			
			Если Результат.ИзмененаОрганизация ИЛИ Результат.ИзмененоСтруктурноеПодразделение Тогда
				
				ПриИзмененииЗначенияОрганизацииСервер(Результат);
				
				Если Результат.Свойство("ИзмененаКасса") И Результат.ИзмененаКасса Тогда
					
					Если Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийИнвентаризацияДенежныхСредств.ПоКассе") Тогда
						
						Если ЗначениеЗаполнено(Объект.Касса) Тогда
							Режим = РежимДиалогаВопрос.ДаНет;
							Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаПриИзмененииКассы", ЭтотОбъект);
							ПоказатьВопрос(Оповещение, НСтр("ru = 'Перезаполнить таблицу денежных средств в соответствии с новым значением кассы?'"), Режим, 0);
						Иначе 
							ТекстСообщения  = НСтр("ru = 'Не заполнено значение реквизита ""Касса"", заполнение табличной части невозможно'");
							ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , "Касса", "Объект");
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		Иначе
			УстановитьЗначенияРеквизитовПриОтключеннойФОИспользоватьНесколькоКассОрганизации();
		КонецЕсли;
		
		Объект.Организация = СтруктурноеПодразделениеОрганизация;
		Объект.СтруктурноеПодразделение = СтруктурноеПодразделениеОрганизация;
		УстановитьИспользуетсяНесколькоКасс();
	КонецЕсли;
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопросаПриИзмененииКассы(Результат, Параметры) Экспорт
	
	Если НЕ Результат = КодВозвратаДиалога.Да Тогда
		Возврат;	
	КонецЕсли;
	
	Объект.ДенежныеСредства.Очистить();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоОстаткам(Команда)
	
	Если Объект.Организация.Пустая() Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не указана организация'"), , "Организация", "Объект");
		Возврат;
	КонецЕсли;
	
	Если Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийИнвентаризацияДенежныхСредств.ПоКассе") И Объект.Касса.Пустая() Тогда
		Если Объект.Касса.Пустая() Тогда			
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не указана касса'"), , "Касса", "Объект");
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Если Объект.ДенежныеСредства.Количество() > 0 Тогда
		Режим = РежимДиалогаВопрос.ДаНет;
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаЗаполнитьПоОстаткам", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, НСтр("ru = 'Перед заполнением табличная часть будет очищена. Заполнить?'"), Режим, 0);
	Иначе
		ЗаполнитьДенежныеСредстваНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопросаЗаполнитьПоОстаткам(Результат, Параметры) Экспорт
	
	Если НЕ Результат = КодВозвратаДиалога.Да Тогда
		Возврат;	
	КонецЕсли;
	
	Объект.ДенежныеСредства.Очистить();
	
	ЗаполнитьДенежныеСредстваНаСервере();	
	
КонецПроцедуры

&НаКлиенте
Процедура ДенежныеСредстваСуммаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ДенежныеСредства.ТекущиеДанные;
	ТекущиеДанные.Отклонение = ТекущиеДанные.Сумма - ТекущиеДанные.СуммаУчет;
	
КонецПроцедуры

&НаКлиенте
Процедура ДенежныеСредстваСуммаУчетПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ДенежныеСредства.ТекущиеДанные;
	ТекущиеДанные.Отклонение = ТекущиеДанные.Сумма - ТекущиеДанные.СуммаУчет;
	
КонецПроцедуры

&НаКлиенте
Процедура РеквизитыОрганизацииСсылкаОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	ПроверкаРеквизитовОрганизацииКлиент.РеквизитыОрганизацииСсылкаОбработкаНавигационнойСсылки(Объект.Организация, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ ИнвентаризационнаяКомиссия

&НаКлиенте
Процедура ИнвентаризационнаяКомиссияПредседательПриИзменении(Элемент)
	
	Для Каждого Строка Из Объект.ИнвентаризационнаяКомиссия Цикл
		
		Если НЕ (Строка.НомерСтроки = Элементы.ИнвентаризационнаяКомиссия.ТекущиеДанные.НомерСтроки) Тогда
			
			Строка.Председатель = Ложь;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ИнвентаризационнаяКомиссияФизЛицоПриИзменении(Элемент)
	
	Если Объект.ИнвентаризационнаяКомиссия.Количество() = 1 Тогда
		
		Объект.ИнвентаризационнаяКомиссия[0].Председатель = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИнвентаризационнаяКомиссияПослеУдаления(Элемент)
	
	Если Объект.ИнвентаризационнаяКомиссия.Количество() > 0 Тогда
		ПроверитьФлагиПредседателя(Неопределено);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ИнвентаризационнаяКомиссияПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока И Копирование Тогда
		
		Элементы.ИнвентаризационнаяКомиссия.ТекущиеДанные.ФизЛицо = Неопределено;
		Элементы.ИнвентаризационнаяКомиссия.ТекущиеДанные.Председатель = Ложь;
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ИнвентаризационнаяКомиссияПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	
	Если НЕ ОтменаРедактирования Тогда
		
		УсловияПоиска = Новый Структура("ФизЛицо", Элементы.ИнвентаризационнаяКомиссия.ТекущиеДанные.ФизЛицо);
		СтрокиФЛ = Объект.ИнвентаризационнаяКомиссия.НайтиСтроки(УсловияПоиска);
		
		Если СтрокиФЛ.Количество() > 1 Тогда
			
			Отказ = Истина;
			ТекстПредупреждения = НСтр("ru='Физическое лицо %1 уже включено в состав комиссии!'");
			ТекстПредупреждения = СтрЗаменить(ТекстПредупреждения, "%1", 
			Элементы.ИнвентаризационнаяКомиссия.ТекущиеДанные.ФизЛицо);
			ПоказатьПредупреждение(, ТекстПредупреждения);
			Элементы.ИнвентаризационнаяКомиссия.ТекущиеДанные.ФизЛицо = Неопределено;
			ТекущийЭлемент = Элементы.ИнвентаризационнаяКомиссияФизЛицо;
			
		КонецЕсли;	
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ИнвентаризационнаяКомиссияПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если НЕ ОтменаРедактирования Тогда
		
		ТекущиеДанные = Элемент.ТекущиеДанные;
		ПроверитьФлагиПредседателя(Элемент.ТекущиеДанные);
		
	КонецЕсли;	
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ПерезаполнитьУчетныеСуммы(Команда)
	
	Если Объект.ДенежныеСредства.Количество() > 0 Тогда
		Режим = РежимДиалогаВопрос.ДаНет;
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаПерезаполнитьСуммы", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, НСтр("ru = 'Перезаполнить учетные суммы?'"), Режим, 0);
	Иначе
		ПослеЗакрытияВопросаПерезаполнитьСуммы(КодВозвратаДиалога.Да,);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопросаПерезаполнитьСуммы(Результат, Параметры) Экспорт
	
	Если НЕ Результат = КодВозвратаДиалога.Да Тогда
		Возврат;	
	КонецЕсли;
	
	ПерезаполнитьДенежныеСредстваНаСервере();	
	
КонецПроцедуры

&НаКлиенте
Процедура ПодборИнвентаризационнаяКомиссия(Команда)
	
	ПараметрыФормы	= Новый Структура;
	ПараметрыФормы.Вставить("ЗакрыватьПриЗакрытииВладельца",	Истина);
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе",				Ложь);
	ПараметрыФормы.Вставить("РежимВыбора",						Истина);
	ПараметрыФормы.Вставить("МножественныйВыбор",				Истина);
	ПараметрыФормы.Вставить("ПараметрВыборГруппИЭлементов",		ИспользованиеГруппИЭлементов.Элементы);
	
	ОткрытьФорму("Справочник.ФизическиеЛица.ФормаВыбора", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
     ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
     ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры
 
&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
     ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры
 
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
     ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаСервере
Процедура ПодготовитьФормуНаСервере(ПерезаполнитьКассу = Истина)
	
	УстановитьФункциональныеОпцииФормы();
	УстановитьИспользуетсяНесколькоКасс(ПерезаполнитьКассу);
	
	ПоказыватьВДокументахСчетаУчета = Истина;
	ПоддержкаРаботыСоСтруктурнымиПодразделениями = ПолучитьФункциональнуюОпцию("ПоддержкаРаботыСоСтруктурнымиПодразделениями");
	ТекущаяКасса = Объект.Касса;
	
	УстановитьПараметрыВыбораВалюты(Элементы.ДенежныеСредстваВалюта, Объект.Касса.ВалютаДенежныхСредств, Объект.ВидОперации);
	УстановитьПараметрыВыбораСчета(Элементы.ДенежныеСредстваСчетУчетаБУ);
	
	ЗаполнитьДобавленныеКолонкиТаблиц();
	
	РаботаСДиалогамиКлиентСервер.УстановитьВидимостьСтруктурногоПодразделения(Объект.Организация, Объект.СтруктурноеПодразделение, СтруктурноеПодразделениеОрганизация);
	РаботаСДиалогамиКлиентСервер.УстановитьСвойстваЭлементаСтруктурноеПодразделениеОрганизация (Элементы.СтруктурноеПодразделениеОрганизация, Объект.СтруктурноеПодразделение, ПоддержкаРаботыСоСтруктурнымиПодразделениями);
			
	УправлениеФормой(ЭтаФорма);
	
	ОбщегоНазначенияБК.УстановитьТекстАвтора(НадписьАвтор, Объект.Автор);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораСтруктурногоПодразделения(Результат, Параметры) Экспорт
	
	РаботаСДиалогамиКлиент.ПослеВыбораСтруктурногоПодразделения(Результат, Объект.Организация, Объект.СтруктурноеПодразделение, СтруктурноеПодразделениеОрганизация);
	Если Результат.ИзмененаОрганизация ИЛИ Результат.ИзмененоСтруктурноеПодразделение Тогда
		Модифицированность = Истина;
		Результат.Вставить("НеобходимоИзменитьЗначенияРеквизитовОбъекта", Ложь);
		
		Если Результат.ИзмененаОрганизация Тогда
			
			ПриИзмененииЗначенияОрганизацииСервер(Результат);
			
			Если Результат.Свойство("ИзмененаКасса") И Результат.ИзмененаКасса Тогда
				
				Если Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийИнвентаризацияДенежныхСредств.ПоКассе") Тогда
					
					Если ЗначениеЗаполнено(Объект.Касса) Тогда
						Режим = РежимДиалогаВопрос.ДаНет;
						Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаПриИзмененииКассы", ЭтотОбъект);
						ПоказатьВопрос(Оповещение, НСтр("ru = 'Перезаполнить таблицу денежных средств в соответствии с новым значением кассы?'"), Режим, 0);
					Иначе 
						ТекстСообщения  = НСтр("ru = 'Не заполнено значение реквизита ""Касса"", заполнение табличной части невозможно'");
						ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , "Касса", "Объект");
					КонецЕсли;
				КонецЕсли;
			КонецЕсли; 
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	Объект   = Форма.Объект;
	
	Если Форма.ИспользоватьНесколькоКассОрганизации Тогда
		Если Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийИнвентаризацияДенежныхСредств.ПоКассе") Тогда
			Элементы.Касса.Видимость = Истина;
			Элементы.ДенежныеСредстваЗаполнить.ПодчиненныеЭлементы.ДенежныеСредстваЗаполнитьПоОстаткамВКассе.Заголовок = НСтр("ru = 'Заполнить по остаткам в кассе'");		
		Иначе
			Элементы.Касса.Видимость = Ложь;
			Элементы.ДенежныеСредстваЗаполнить.ПодчиненныеЭлементы.ДенежныеСредстваЗаполнитьПоОстаткамВКассе.Заголовок = НСтр("ru = 'Заполнить по остаткам в организации'");
		КонецЕсли;
	Иначе
		Элементы.Касса.Видимость = Ложь;
		Элементы.ДенежныеСредстваЗаполнить.ПодчиненныеЭлементы.ДенежныеСредстваЗаполнитьПоОстаткамВКассе.Заголовок = НСтр("ru = 'Заполнить по остаткам в организации'");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьФункциональныеОпцииФормы()
	
	ОбщегоНазначенияБККлиентСервер.УстановитьПараметрыФункциональныхОпцийФормыДокумента(ЭтаФорма);
		
КонецПроцедуры 

&НаСервере
Процедура УстановитьИспользуетсяНесколькоКасс(ПерезаполнитьКассу = Истина)
	
	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		КассаПоУмолчанию = Справочники.Кассы.КассаПоУмолчанию(Объект);
		ИспользоватьНесколькоКассОрганизации = Справочники.Кассы.ИспользуетсяНесколькоКасс(Объект.Организация);
	Иначе
		ИспользоватьНесколькоКассОрганизации = Истина;
	КонецЕсли;
	
	Если ИспользоватьНесколькоКассОрганизации Тогда
		Элементы.ВидОперации.СписокВыбора.Очистить();
		Элементы.ВидОперации.СписокВыбора.Добавить(Перечисления.ВидыОперацийИнвентаризацияДенежныхСредств.ПоОрганизации);
		Элементы.ВидОперации.СписокВыбора.Добавить(Перечисления.ВидыОперацийИнвентаризацияДенежныхСредств.ПоКассе);
		Если ЗначениеЗаполнено(КассаПоУмолчанию) И ПерезаполнитьКассу Тогда
			Объект.Касса = КассаПоУмолчанию;
		КонецЕсли;
		
	Иначе
		Элементы.ВидОперации.СписокВыбора.Очистить();
		Элементы.ВидОперации.СписокВыбора.Добавить(Перечисления.ВидыОперацийИнвентаризацияДенежныхСредств.ПоОрганизации);
		Если Объект.ВидОперации = Перечисления.ВидыОперацийИнвентаризацияДенежныхСредств.ПоКассе Тогда
			Объект.ВидОперации = Перечисления.ВидыОперацийИнвентаризацияДенежныхСредств.ПоОрганизации;
		КонецЕсли;	
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВидОперацииПриИзмененииНаСервере(Перезаполнить = Ложь)
			
	Если Перезаполнить Тогда
		
		ЗаполнитьДенежныеСредстваНаСервере();
		
	КонецЕсли;
	
	УстановитьПараметрыВыбораВалюты(Элементы.ДенежныеСредства.ПодчиненныеЭлементы.ДенежныеСредстваВалюта, Объект.Касса.ВалютаДенежныхСредств, Объект.ВидОперации);
	
	РаботаСДиалогами.УстановитьЗаголовокФормыДокумента(Строка(Объект.ВидОперации), Объект.Ссылка, ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьПроверитьДанныеПоОрганизации()
	
	УстановитьФункциональныеОпцииФормы();
	
	Справочники.Кассы.ПроверитьЗначениеОпцииИспользоватьНесколькоКасс(СтруктурноеПодразделениеОрганизация);
	ИспользоватьНесколькоКассОрганизации = Справочники.Кассы.ИспользуетсяНесколькоКасс(СтруктурноеПодразделениеОрганизация);
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииЗначенияОрганизацииСервер(СтруктураПараметров)
	
	УстановитьИспользуетсяНесколькоКасс();
	
	Если ЗначениеЗаполнено(СтруктурноеПодразделениеОрганизация.ОсновнаяКасса) Тогда
		Объект.Касса = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтруктурноеПодразделениеОрганизация, "ОсновнаяКасса");
	Иначе
		Объект.Касса = Справочники.Кассы.ПустаяСсылка();
	КонецЕсли;
	
	Если НЕ Объект.Касса = ТекущаяКасса Тогда
		
		Если Объект.Касса.ВалютаДенежныхСредств <> Объект.Организация.ОсновнаяКасса.ВалютаДенежныхСредств Тогда
			Объект.ДенежныеСредства.Очистить();	
		КонецЕсли;
		
		СтруктураПараметров.Вставить("ИзмененаКасса", Истина);
		
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);
	
	ТекущаяКасса = Объект.Касса;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьФлагиПредседателя(СтрокаТЧ)
	
	СтрокаПредседателя = ?(СтрокаТЧ <> Неопределено И СтрокаТЧ.Председатель, СтрокаТЧ, Неопределено);
	
	Для Каждого СтрокаКомиссии Из Объект.ИнвентаризационнаяКомиссия Цикл
		
		Если СтрокаКомиссии.Председатель И СтрокаПредседателя = Неопределено Тогда
			СтрокаПредседателя = СтрокаКомиссии;
			Продолжить;
		КонецЕсли;	
		
		Если СтрокаКомиссии.Председатель И СтрокаКомиссии <> СтрокаПредседателя Тогда
			СтрокаКомиссии.Председатель = Ложь;
		КонецЕсли;	
		
	КонецЦикла;	
	
	Если СтрокаПредседателя = Неопределено И Объект.ИнвентаризационнаяКомиссия.Количество() > 0 Тогда
		Объект.ИнвентаризационнаяКомиссия[0].Председатель = Истина;
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДенежныеСредстваНаСервере()
	
	Если ОценкаПроизводительностиВызовСервераПовтИсп.ВыполнятьЗамерыПроизводительности() Тогда
		Если Объект.ВидОперации = Перечисления.ВидыОперацийИнвентаризацияДенежныхСредств.ПоКассе Тогда
			КлючеваяОперация 	= "Документ ""инвентаризация денежных средств"" (заполнение по остаткам в кассе)";
		Иначе 
			КлючеваяОперация 	= "Документ ""инвентаризация денежных средств"" (заполнение по остаткам в организации)";
		КонецЕсли;	
		ВремяНачалаЗамера 	= ОценкаПроизводительности.НачатьЗамерВремени();
	КонецЕсли;
	
	Если Объект.ВидОперации = Перечисления.ВидыОперацийИнвентаризацияДенежныхСредств.ПоКассе Тогда
		Документы.ИнвентаризацияДенежныхСредств.ЗаполнитьПоОстаткамВКассе(Объект);			
	Иначе
		Документы.ИнвентаризацияДенежныхСредств.ЗаполнитьПоОстаткамОрганизации(Объект);			
	КонецЕсли;
	
	ЗаполнитьДобавленныеКолонкиТаблиц();
	
	ОценкаПроизводительности.ЗакончитьЗамерВремени(КлючеваяОперация, ВремяНачалаЗамера);
	
КонецПроцедуры

&НаСервере
Процедура ПерезаполнитьДенежныеСредстваНаСервере()
	
	Если ОценкаПроизводительностиВызовСервераПовтИсп.ВыполнятьЗамерыПроизводительности() Тогда
		КлючеваяОперация 	= "Документ ""инвентаризация денежных средств"" (перезаполнение учетных сумм)";
		ВремяНачалаЗамера 	= ОценкаПроизводительности.НачатьЗамерВремени();
	КонецЕсли;
	
	Документы.ИнвентаризацияДенежныхСредств.ПерезаполнитьУчетныеСуммы(Объект);
	
	ЗаполнитьДобавленныеКолонкиТаблиц();	
	
	ОценкаПроизводительности.ЗакончитьЗамерВремени(КлючеваяОперация, ВремяНачалаЗамера);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ВалютаКассыРазличается(НоваяКасса, ТекущаяКасса)
	
	Возврат НоваяКасса.ВалютаДенежныхСредств <> ТекущаяКасса.ВалютаДенежныхСредств
	
КонецФункции

&НаСервере
Процедура КассаПриИзмененииНаСервере(Перезаполнить = Ложь) 
	
	Если Перезаполнить Тогда
		ЗаполнитьДенежныеСредстваНаСервере();
	КонецЕсли;
	
	УстановитьПараметрыВыбораВалюты(Элементы.ДенежныеСредства.ПодчиненныеЭлементы.ДенежныеСредстваВалюта, Объект.Касса.ВалютаДенежныхСредств, Объект.ВидОперации);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДобавленныеКолонкиТаблиц()
	
	Для Каждого СтрокаТаблицы Из Объект.ДенежныеСредства Цикл		
		СтрокаТаблицы.Отклонение = СтрокаТаблицы.Сумма - СтрокаТаблицы.СуммаУчет;
	КонецЦикла;
	
КонецПроцедуры  

&НаСервереБезКонтекста
Процедура УстановитьПараметрыВыбораВалюты(Элемент, ВалютаДенежныхСредств, ВидОперации)
	
	МассивПараметровВыбора = Новый Массив;
	
	Если ВидОперации = Перечисления.ВидыОперацийИнвентаризацияДенежныхСредств.ПоКассе Тогда
		МассивПараметровВыбора.Добавить(Новый ПараметрВыбора("Отбор.Ссылка", ВалютаДенежныхСредств));
	КонецЕсли;
	
	Элемент.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметровВыбора);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьПараметрыВыбораСчета(Элемент)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Типовой.Ссылка
	|ИЗ
	|	ПланСчетов.Типовой КАК Типовой
	|ГДЕ
	|	Типовой.Ссылка В ИЕРАРХИИ(&Ссылка)";
	
	Запрос.УстановитьПараметр("Ссылка", ПланыСчетов.Типовой.ДенежныеСредстваВКассе);
	
	МассивСчетов = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	МассивПараметровВыбора = Новый Массив;
	МассивПараметровВыбора.Добавить(Новый ПараметрВыбора("Отбор.Ссылка", Новый ФиксированныйМассив(МассивСчетов)));
	
	Элемент.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметровВыбора);
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьИзмененияВОрганизацииНаСервере()
	
	УстановитьИспользуетсяНесколькоКасс();
		
КонецПроцедуры

&НаСервере
Процедура УстановитьЗначенияРеквизитовПриОтключеннойФОИспользоватьНесколькоКассОрганизации()
	
	Если ЗначениеЗаполнено(СтруктурноеПодразделениеОрганизация.ОсновнаяКасса) Тогда
		Объект.Касса = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтруктурноеПодразделениеОрганизация, "ОсновнаяКасса");
	Иначе
		Объект.Касса = Справочники.Кассы.ПустаяСсылка();
	КонецЕсли;
	
	Объект.ВидОперации = Перечисления.ВидыОперацийИнвентаризацияДенежныхСредств.ПоОрганизации;	
	РаботаСДиалогами.УстановитьЗаголовокФормыДокумента(Строка(Объект.ВидОперации), Объект.Ссылка, ЭтаФорма);
	
КонецПроцедуры
