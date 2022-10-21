////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТекущаяСтруктурнаяЕдиница = Запись.СтруктурнаяЕдиница;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// Оповестим форму выбранной структурной единицы.
	Оповестить("Запись_ОтветственныеЛица", Новый Структура("ИмяЭлемента","ОтветственноеЛицо"), Запись.СтруктурнаяЕдиница);
	Если ТекущаяСтруктурнаяЕдиница <> Запись.СтруктурнаяЕдиница Тогда

		// Оповестим также форму той структурной единицы, данные которой начинали редактировать.
		Оповестить("Запись_ОтветственныеЛица", Новый Структура("ИмяЭлемента","ОтветственноеЛицо"), ТекущаяСтруктурнаяЕдиница);
		ТекущаяСтруктурнаяЕдиница = Запись.СтруктурнаяЕдиница;
		
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
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры
