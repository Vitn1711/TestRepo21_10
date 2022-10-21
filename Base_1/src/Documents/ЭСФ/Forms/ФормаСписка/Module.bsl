////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьОбменЭСФЧерезAPI")
		И НЕ ПолучитьФункциональнуюОпцию("ИспользоватьОбменЭСФЧерезXML") Тогда
		ОтказПриОткрытии = Истина;
	КонецЕсли;
	
	СписокНаправленийЭСФ.Добавить(Перечисления.НаправленияЭСФ.Входящий, НСтр("ru = 'Полученные электронные счета-фактуры'"));
	СписокНаправленийЭСФ.Добавить(Перечисления.НаправленияЭСФ.Исходящий, НСтр("ru = 'Выданные электронные счета-фактуры'"));
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВыборГруппИЭлементов", Параметры.ВыборГруппИЭлементов);
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе", Параметры.ЗакрыватьПриВыборе);
	ПараметрыФормы.Вставить("ЗакрыватьПриЗакрытииВладельца", Параметры.ЗакрыватьПриЗакрытииВладельца);
	ПараметрыФормы.Вставить("КлючНазначенияИспользования", Параметры.КлючНазначенияИспользования);
	ПараметрыФормы.Вставить("МножественныйВыбор", Параметры.МножественныйВыбор);
	ПараметрыФормы.Вставить("Отбор", Параметры.Отбор);
	ПараметрыФормы.Вставить("ПараметрыФункциональныхОпций", Параметры.ПараметрыФункциональныхОпций);
	ПараметрыФормы.Вставить("РазрешитьВыборКорня", Параметры.РазрешитьВыборКорня);
	ПараметрыФормы.Вставить("РежимВыбора", Параметры.РежимВыбора);
	ПараметрыФормы.Вставить("ТекущаяСтрока", Параметры.ТекущаяСтрока);
	ПараметрыФормы.Вставить("ТолькоПросмотр", Параметры.ТолькоПросмотр);
	ПараметрыФормы.Вставить("ФиксированныеНастройки", Параметры.ФиксированныеНастройки);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Контейнер = ЭСФКлиентСервер.КонтейнерМетодов();	
	Контейнер.ПриОткрытииФормы(ЭтаФорма, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Если ОтказПриОткрытии Тогда
		Отказ = Истина;
		ПоказатьПредупреждение(, ЭСФКлиентСервер.ТекстСообщенияНеУстановленыОбеКонстанты());
	КонецЕсли;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ

&НаКлиенте
Процедура СписокНаправленийЭСФВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтрокаТаблицы = СписокНаправленийЭСФ.НайтиПоИдентификатору(ВыбраннаяСтрока);	
	ОткрытьСписокЭСФ(СтрокаТаблицы.Значение);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ОткрытьСписок(Команда)
	
	СтрокаТаблицы = Элементы.СписокНаправленийЭСФ.ТекущиеДанные;
	
	Если НЕ СтрокаТаблицы = Неопределено Тогда
		ОткрытьСписокЭСФ(СтрокаТаблицы.Значение);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ОткрытьСписокЭСФ(НаправлениеЭСФ)
	
	Если НаправлениеЭСФ = ПредопределенноеЗначение("Перечисление.НаправленияЭСФ.Входящий") Тогда
		ОткрытьФорму("Документ.ЭСФ.Форма.ФормаСпискаВходящих", ПараметрыФормы);
	Иначе
		ОткрытьФорму("Документ.ЭСФ.Форма.ФормаСпискаИсходящих", ПараметрыФормы);
	КонецЕсли;
	
	Закрыть();
	
КонецПроцедуры
