////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВССерверПереопределяемый.ЭДВСФормаСпискаИВыбораПриСозданииНаСервере(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = ВСКлиентСервер.ИмяСобытияЗаписьЭДВС() Тогда
		Элементы.Список.Обновить();
	ИначеЕсли ИмяСобытия = "ВС_ПроверятьОповещенияФоновогоЗадания"
		И ЭтаФорма.КлючУникальности = Источник Тогда
		
		ВСКлиентПереопределяемый.ОбработкаОповещенияВС_ПроверятьОповещенияФоновогоЗадания(ЭтаФорма, Параметр);
		
	КонецЕсли;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	УстановитьБыстрыйОтбор("Организация", Организация);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура УстановитьБыстрыйОтбор(ВидЭлемента, ЗначениеЭлемента)
	
	ЭСФКлиентСерверПереопределяемый.ИзменитьЭлементОтбораСписка(Список, ВидЭлемента, ЗначениеЭлемента, ЗначениеЗаполнено(ЗначениеЭлемента));
	
КонецПроцедуры


// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
     ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
     ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры
 
&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
     ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Элементы.Список);
КонецПроцедуры
 
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
     ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
