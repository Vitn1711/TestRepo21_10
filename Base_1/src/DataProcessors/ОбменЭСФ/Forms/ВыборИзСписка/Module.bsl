
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Контейнер = ЭСФКлиентСервер.КонтейнерМетодов();	
	Контейнер.ПриОткрытииФормы(ЭтаФорма, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Заголовок = Параметры.Заголовок;
	
	Для Каждого Значение Из Параметры.МассивЗначений Цикл
		СтрокаСписка = Список.Добавить();
		СтрокаСписка.Значение = Значение;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		Закрыть(ТекущиеДанные.Значение);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Изменить(Команда)
	
	Если Элементы.Список.ТекущиеДанные <> Неопределено Тогда
		ПоказатьЗначение(, Элементы.Список.ТекущиеДанные.Значение);
	КонецЕсли;
	
КонецПроцедуры

