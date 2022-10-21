
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.ФормаПодбор.Доступность = ПравоДоступа("Изменение", Метаданные.Справочники.ДокументыУдостоверяющиеЛичность);
	
	ДоступностьИзменитьВыделенные = ПравоДоступа("Изменение", Метаданные.Справочники.ДокументыУдостоверяющиеЛичность);
	
	КнопкаФормаИзменитьВыделенные = Элементы.Найти("ФормаИзменитьВыделенные");
	
	Если КнопкаФормаИзменитьВыделенные <> Неопределено Тогда
		КнопкаФормаИзменитьВыделенные.Доступность = ДоступностьИзменитьВыделенные;
	КонецЕсли;
	
	КомандаСписокКонтекстноеМенюИзменитьВыделенные = Элементы.Найти("СписокКонтекстноеМенюИзменитьВыделенные");
	
	Если КомандаСписокКонтекстноеМенюИзменитьВыделенные <> Неопределено Тогда
		КомандаСписокКонтекстноеМенюИзменитьВыделенные.Доступность = ДоступностьИзменитьВыделенные;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подбор(Команда)
	
	ФормаПодбора = ПолучитьФорму("Справочник.ДокументыУдостоверяющиеЛичность.Форма.ФормаПодбораИзКлассификатора", , ЭтаФорма, Истина);
	
	ФормаПодбора.Открыть();
	
КонецПроцедуры

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов
&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

#КонецОбласти
