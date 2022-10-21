
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Если ТипЗнч(Параметры.ТипЛинии) = Тип("ТипЛинииЯчейкиТабличногоДокумента") Тогда
		Типы = ТипЛинииЯчейкиТабличногоДокумента;
	ИначеЕсли ТипЗнч(Параметры.ТипЛинии) = Тип("ТипЛинииРисункаТабличногоДокумента") Тогда
		Типы = ТипЛинииРисункаТабличногоДокумента;
	КонецЕсли;
	
	Для Каждого Тип Из Типы Цикл
		Элементы.ТипЛинии.СписокВыбора.Добавить(Тип);
	КонецЦикла;
	
	ТипЛинии = Параметры.ТипЛинии;
	Толщина = Параметры.Толщина;
	
	Если Толщина = 0 Тогда
		Толщина = 1;
	КонецЕсли;
	
	Если ТипЛинии = ТипЛинииЯчейкиТабличногоДокумента.НетЛинии
		Или ТипЛинии = ТипЛинииЯчейкиТабличногоДокумента.Двойная
		Или ТипЛинии = ТипЛинииРисункаТабличногоДокумента.НетЛинии Тогда
		Элементы.Толщина.Доступность = Ложь;
	Иначе
		Элементы.Толщина.Доступность = Истина;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипЛинииПриИзменении(Элемент)
	
	Если ТипЛинии = ТипЛинииЯчейкиТабличногоДокумента.НетЛинии
		Или ТипЛинии = ТипЛинииЯчейкиТабличногоДокумента.Двойная
		Или ТипЛинии = ТипЛинииРисункаТабличногоДокумента.НетЛинии Тогда
		Элементы.Толщина.Доступность = Ложь;
		Толщина = 1;
	Иначе
		Элементы.Толщина.Доступность = Истина;
	КонецЕсли;
	
	Если ТипЛинии = ТипЛинииЯчейкиТабличногоДокумента.Двойная Тогда
		Элементы.Толщина.МаксимальноеЗначение = 1;
	Иначе
		Элементы.Толщина.МаксимальноеЗначение = 3;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	Закрыть(Новый Структура("ТипЛинии, Толщина", ТипЛинии, Толщина));
КонецПроцедуры

#КонецОбласти
