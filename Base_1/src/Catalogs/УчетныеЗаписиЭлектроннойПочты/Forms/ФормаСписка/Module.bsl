///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Элементы.ПоказыватьПерсональныеУчетныеЗаписиПользователей.Видимость = Пользователи.ЭтоПолноправныйПользователь();
	
	ПереключитьВидимостьПерсональныхУчетныхЗаписей(Список,
		ПоказыватьПерсональныеУчетныеЗаписиПользователей,
		Пользователи.ТекущийПользователь());
	
	ПереключитьВидимостьНедействительныхУчетныхЗаписей(Список, ПоказыватьНедействительные);
	Элементы.ВладелецУчетнойЗаписи.Видимость = ПоказыватьПерсональныеУчетныеЗаписиПользователей;
	Элементы.ПоказыватьНедействительные.Доступность = ПоказыватьПерсональныеУчетныеЗаписиПользователей;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПоказыватьПерсональныеУчетныеЗаписиПользователейПриИзменении(Элемент)
	
	ПереключитьВидимостьПерсональныхУчетныхЗаписей(Список,
		ПоказыватьПерсональныеУчетныеЗаписиПользователей,
		ПользователиКлиент.ТекущийПользователь());
	
	Элементы.ВладелецУчетнойЗаписи.Видимость = ПоказыватьПерсональныеУчетныеЗаписиПользователей;
	Элементы.ПоказыватьНедействительные.Доступность = ПоказыватьПерсональныеУчетныеЗаписиПользователей;
	
	ПоказыватьНедействительные = ПоказыватьНедействительные И ПоказыватьПерсональныеУчетныеЗаписиПользователей;
	ПереключитьВидимостьНедействительныхУчетныхЗаписей(Список, ПоказыватьНедействительные);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьНедействительныеПриИзменении(Элемент)
	ПереключитьВидимостьНедействительныхУчетныхЗаписей(Список, ПоказыватьНедействительные);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ПереключитьВидимостьПерсональныхУчетныхЗаписей(Список, ПоказыватьПерсональныеУчетныеЗаписиПользователей, ТекущийПользователь)
	СписокПользователей = Новый Массив;
	СписокПользователей.Добавить(ПредопределенноеЗначение("Справочник.Пользователи.ПустаяСсылка"));
	СписокПользователей.Добавить(ТекущийПользователь);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "ВладелецУчетнойЗаписи", СписокПользователей, ВидСравненияКомпоновкиДанных.ВСписке, ,
			Не ПоказыватьПерсональныеУчетныеЗаписиПользователей);
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПереключитьВидимостьНедействительныхУчетныхЗаписей(Список, ПоказыватьНедействительные)
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "ВладелецНедействителен", Ложь, ВидСравненияКомпоновкиДанных.Равно, ,
			Не ПоказыватьНедействительные);
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	Список.УсловноеОформление.Элементы.Очистить();
	Элемент = Список.УсловноеОформление.Элементы.Добавить();
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ВладелецНедействителен");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	
КонецПроцедуры

#КонецОбласти