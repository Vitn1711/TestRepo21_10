////////////////////////////////////////////////////////////////////////////////
// Подсистема "Контроль динамического обновления конфигурации".
//  
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Обработчик ожидания проверяет, что информационная база была обновлена динамически, и 
// сообщает об этом пользователю.
//
Процедура ПриВыполненииСтандартныхПериодическихПроверок(Параметры, ОбработкаПродолжения) Экспорт
	
	Контекст = Новый Структура;
	Контекст.Вставить("ОбработкаПродолжения", ОбработкаПродолжения);
	
	Если Не Параметры.КонфигурацияБазыДанныхИзмененаДинамически Тогда
		ВыполнитьОбработкуОповещения(Контекст.ОбработкаПродолжения);
		Возврат;
	КонецЕсли;
	
	ТекстСообщения =
		НСтр("ru = 'Версия программы обновлена (внесены изменения в конфигурацию информационной базы).
		           |Для дальнейшей работы рекомендуется перезапустить программу.
		           |Перезапустить?'");
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПриВыполненииСтандартныхПериодическихПроверокЗавершение", ЭтотОбъект, Контекст);
	
	ПоказатьВопрос(ОписаниеОповещения, ТекстСообщения, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

// Продолжение процедуры ПриВыполненииСтандартныхПериодическихПроверок.
Процедура ПриВыполненииСтандартныхПериодическихПроверокЗавершение(Ответ, Контекст) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		СтандартныеПодсистемыКлиент.ПропуститьПредупреждениеПередЗавершениемРаботыСистемы();
		ЗавершитьРаботуСистемы(Истина, Истина);
		Возврат;
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(Контекст.ОбработкаПродолжения);
	
КонецПроцедуры

#КонецОбласти
