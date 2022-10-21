////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Процедура вызывается перед записью набора записей регистра.
//
Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;		
	
	// Обработка приведения незаполненого значения составного типа к значению Неопределено
	ИзменятьОтбор = Ложь;
	Для каждого Запись из ЭтотОбъект Цикл
		Если НЕ ЗначениеЗаполнено(Запись.ФиксированныйАктив) и не Запись.ФиксированныйАктив = Неопределено Тогда
			Запись.ФиксированныйАктив = Неопределено;
			ИзменятьОтбор = Истина;
		КонецЕсли;	
	КонецЦикла;	
	
	Если ИзменятьОтбор и ЭтотОбъект.Отбор.ФиксированныйАктив.Использование Тогда
		ЭтотОбъект.Отбор.ФиксированныйАктив.Значение = Неопределено;
	КонецЕсли;		
	
КонецПроцедуры // ПередЗаписью
