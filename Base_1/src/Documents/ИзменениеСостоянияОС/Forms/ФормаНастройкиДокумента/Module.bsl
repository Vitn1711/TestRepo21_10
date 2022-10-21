
&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы Тогда
		Возврат;	
	КонецЕсли;
	
	Если Модифицированность Тогда
		
		Отказ = Истина;
		
		ТекстВопроса = НСтр("ru='Данные были изменены. Сохранить изменения?'");
		Оповещение = Новый ОписаниеОповещения("ВопросСохранитьИзмененияЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ПеренестиВДокумент Тогда
		ДанныеФормы = ПолучитьСтруктуруДанныхФормы();
		ОповеститьОВыборе(ДанныеФормы);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросСохранитьИзмененияЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Если ПроверитьЗаполнение() Тогда
			Модифицированность = Ложь;
			ПеренестиВДокумент = Истина;
			Закрыть();
		КонецЕсли;
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	ПеренестиВДокумент 	= Ложь;
	
	ИзменениеЗемельногоНалога      = Параметры.ИзменениеЗемельногоНалога;
	ИзменениеИмущественногоНалога  = Параметры.ИзменениеИмущественногоНалога;
	ИзменениеНачисленияАмортизации = Параметры.ИзменениеНачисленияАмортизации;
	ИзменениеТранспортногоНалога   = Параметры.ИзменениеТранспортногоНалога;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
			
	Если ПроверитьЗаполнение() Тогда
		Модифицированность = Ложь;
		ПеренестиВДокумент = Истина;
		Закрыть();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура КомандаЗакрыть(Команда)
	
	Модифицированность = Ложь;
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьСтруктуруДанныхФормы()

	СтруктураДанныхФормы = Новый Структура(
		"ИзменениеЗемельногоНалога, 
		|ИзменениеИмущественногоНалога,
		|ИзменениеНачисленияАмортизации,
		|ИзменениеТранспортногоНалога");

	ЗаполнитьЗначенияСвойств(СтруктураДанныхФормы, ЭтаФорма);
		
	Возврат СтруктураДанныхФормы;

КонецФункции

