 
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьОбменЭСФЧерезAPI") Тогда
		ОтказПриОткрытии = Истина;
	КонецЕсли;
	
КонецПроцедуры
 
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ОтказПриОткрытии Тогда
		Отказ = Истина;
		Предупреждение(ЭСФКлиентСервер.ТекстСообщенияНеУстановленОбменЧерезAPI());
	КонецЕсли;
	
КонецПроцедуры