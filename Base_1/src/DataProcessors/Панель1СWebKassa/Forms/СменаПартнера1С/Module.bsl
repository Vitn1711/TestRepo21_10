#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не Параметры.Свойство("Организация")
		ИЛИ Не Параметры.Свойство("СерийныйНомер") Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Организация = Параметры.Организация;
	СерийныйНомер = Параметры.СерийныйНомер;
	
	ЗаполнитьСписокПартнеров(Параметры.Партнеры);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьСменуПартнера(Команда)
	
	ОчиститьСообщения();
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	ВходныеПараметры = Новый Структура;
	ВходныеПараметры.Вставить("Организация",  Организация);
	ВходныеПараметры.Вставить("СерийныйНомер", СерийныйНомер);
	ВходныеПараметры.Вставить("НомерКарты",    НомерКарты);
	ВходныеПараметры.Вставить("КодАктивации",  КодАктивации);
	ВходныеПараметры.Вставить("НомерПартнера", НомерПартнера);
	ВходныеПараметры.Вставить("КодПартнера",   КодПартнера);
	
	ПараметрыПодключения = Новый Структура;
	ОповещениеПриЗавершении = Новый ОписаниеОповещения("ВыполнитьСменуПартнера_Завершение", ЭтотОбъект);
	ИнтеграцияWebKassaКлиент.НачатьСменуПартнера(ОповещениеПриЗавершении, ВходныеПараметры, ПараметрыПодключения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьСписокПартнеров(МассивПартнеров)
	
	СписокВыбора = Новый СписокЗначений;
	
	Для Каждого ЭлементМассива Из МассивПартнеров Цикл
		Элементы.НомерПартнера.СписокВыбора.Добавить(ЭлементМассива.НомерПартнера, ЭлементМассива.Наименование);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьСменуПартнера_Завершение(Результат, ДополнительныеПараметры) Экспорт
	
	ОчиститьСообщения();
	
	Если Результат.РезультатВыполнения Тогда
		РезультатВыбора = Новый Структура;
		РезультатВыбора.Вставить("РезультатВыполнения", Истина);
		РезультатВыбора.Вставить("СерийныйНомер", СерийныйНомер);
		Закрыть(РезультатВыбора);
	Иначе
		Если Результат.ВыходныеПараметры[0] = 999 Тогда
			ТекстСообщения = НСтр("ru = 'При смене обслуживающего партнера произошла ошибка.
			|Дополнительное описание: %ДополнительноеОписание%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДополнительноеОписание%", Результат.ВыходныеПараметры[1]);
			ИнтеграцияWebKassaКлиентПереопределяемый.СообщитьПользователю(ТекстСообщения);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
