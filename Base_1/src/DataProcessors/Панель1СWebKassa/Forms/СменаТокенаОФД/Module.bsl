
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ Параметры.Свойство("Организация")
		ИЛИ НЕ Параметры.Свойство("СерийныйНомер")
		ИЛИ НЕ Параметры.Свойство("ТекущийТокенОФД") Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Организация     = Параметры.Организация;
	СерийныйНомер   = Параметры.СерийныйНомер;
	ТекущийТокенОФД = Параметры.ТекущийТокенОФД;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьСменуТокена(Команда)
	
	ОчиститьСообщения();
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	ВходныеПараметры = Новый Структура;
	ВходныеПараметры.Вставить("Организация",   Организация);
	ВходныеПараметры.Вставить("СерийныйНомер", СерийныйНомер);
	ВходныеПараметры.Вставить("ТокенОФД",      НовыйТокенОФД);
	
	ПараметрыПодключения = Новый Структура;
	ОповещениеПриЗавершении = Новый ОписаниеОповещения("ВыполнитьСменуТокена_Завершение", ЭтотОбъект);
	ИнтеграцияWebKassaКлиент.НачатьСменуТокенаОФД(ОповещениеПриЗавершении, ВходныеПараметры, ПараметрыПодключения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыполнитьСменуТокена_Завершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат.РезультатВыполнения Тогда
		РезультатВыбора = Новый Структура;
		РезультатВыбора.Вставить("РезультатВыполнения", Истина);
		РезультатВыбора.Вставить("СерийныйНомер", СерийныйНомер);
		РезультатВыбора.Вставить("НовыйТокенОФД", НовыйТокенОФД);
		Закрыть(РезультатВыбора);
	Иначе
		Если Результат.ВыходныеПараметры[0] = 999 Тогда
			ТекстСообщения = НСтр("ru = 'При смене токена ОФД произошла ошибка.
			|Дополнительное описание: %ДополнительноеОписание%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДополнительноеОписание%", Результат.ВыходныеПараметры[1]);
			ИнтеграцияWebKassaКлиентПереопределяемый.СообщитьПользователю(ТекстСообщения);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
