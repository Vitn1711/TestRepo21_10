
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ Параметры.Свойство("Организация") 
		ИЛИ НЕ Параметры.Свойство("СерийныйНомер") Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Организация   = Параметры.Организация;
	СерийныйНомер = Параметры.СерийныйНомер;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьПодтверждениеРегистрации(Команда)
	
	ОчиститьСообщения();
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	ВходныеПараметры = Новый Структура;
	ВходныеПараметры.Вставить("Организация",               Организация);
	ВходныеПараметры.Вставить("СерийныйНомер",             СерийныйНомер);
	ВходныеПараметры.Вставить("РегистрационныйНомерКГД",   РегистрационныйНомерКГД);
	ВходныеПараметры.Вставить("ИдентификационныйНомерОФД", ИдентификационныйНомерОФД);
	ВходныеПараметры.Вставить("ТокенОФД",                  ТокенОФД);
	ВходныеПараметры.Вставить("ОФД",                       ОператорФискальныхДанных);
	
	ПараметрыПодключения = Новый Структура;
	
	ОповещениеПриЗавершении = Новый ОписаниеОповещения("ВыполнитьПодтверждениеРегистрации_Завершение", ЭтотОбъект);
	ИнтеграцияWebKassaКлиент.НачатьПодтверждениеРегистрацииКассы(ОповещениеПриЗавершении, ВходныеПараметры, ПараметрыПодключения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыполнитьПодтверждениеРегистрации_Завершение(Результат, ДополнительныеПараметры) Экспорт
	
	ОчиститьСообщения();
	
	Если Результат.РезультатВыполнения Тогда
		ИнтеграцияWebKassaВызовСервера.ИзменитьРегистрационныйНомер(СерийныйНомер, РегистрационныйНомерКГД);
		РезультатВыбора = Новый Структура;
		РезультатВыбора.Вставить("РезультатВыполнения", Истина);
		РезультатВыбора.Вставить("СерийныйНомер", СерийныйНомер);
		РезультатВыбора.Вставить("ТокенОФД", ТокенОФД);
		Закрыть(РезультатВыбора);
	Иначе
		Если Результат.ВыходныеПараметры[0] = 999 Тогда
			ТекстСообщения = НСтр("ru = 'При подтверждении регистрации кассы произошла ошибка.
			|Дополнительное описание: %ДополнительноеОписание%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДополнительноеОписание%", Результат.ВыходныеПараметры[1]);
			ИнтеграцияWebKassaКлиентПереопределяемый.СообщитьПользователю(ТекстСообщения);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
