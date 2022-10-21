
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если Справочники.Организации.ИспользуетсяНесколькоОрганизаций() Тогда
		Возврат;
	Иначе
		
		Если ДанныеЗаполнения = Неопределено Тогда
			ДанныеЗаполнения = Новый Структура; 			
		ИначеЕсли ТипЗнч(ДанныеЗаполнения) <> Тип("Структура") Тогда
			Возврат;
		КонецЕсли;
		
		Если НЕ ДанныеЗаполнения.Свойство("Организация") Тогда
			
			ОрганизацияПоУмолчанию = Справочники.Организации.ОрганизацияПоУмолчанию();
			ДанныеЗаполнения.Вставить("Организация", ОрганизацияПоУмолчанию);			
		КонецЕсли; 		
	КонецЕсли;  
	
КонецПроцедуры

#КонецЕсли