////////////////////////////////////////////////////////////////////////////////
// ПроцедурыБухгалтерскогоУчетаКлиентПереопределяемый:
//  
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

//Открывает форму для выбора значения договора с установленными отборами
//
Процедура ОткрытьФормуВыбораДоговора(ПараметрыФормы, Элемент) Экспорт
	
	ОткрытьФорму("Справочник.ДоговорыКонтрагентов.ФормаВыбора", ПараметрыФормы, Элемент);
	
КонецПроцедуры

//Открывает форму для выбора значения банковского счета с установленными отборами
//
Процедура ОткрытьФормуВыбораБанковскогоСчетОрганизации(ПараметрыФормы, Элемент) Экспорт
	
	ОткрытьФорму("Справочник.БанковскиеСчета.ФормаВыбора", ПараметрыФормы, Элемент);
	
КонецПроцедуры

//Открывает форму для выбора значения подразделениям с установленными отборами
//
Процедура ОткрытьФормуВыбораПодразделения(ПараметрыФормы, Элемент) Экспорт
	
	ОткрытьФорму("Справочник.ПодразделенияОрганизаций.ФормаВыбора", ПараметрыФормы, Элемент);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
