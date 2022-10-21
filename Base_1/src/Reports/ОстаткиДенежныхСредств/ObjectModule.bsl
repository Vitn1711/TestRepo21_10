#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	
	Настройки.События.ПриСозданииНаСервере = Истина;
	Настройки.События.ПриОпределенииПараметровВыбора = Истина;
	Настройки.События.ПередЗагрузкойНастроекВКомпоновщик = Истина;
	
КонецПроцедуры 

Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт

	Элементы = Форма.Элементы;
	
	Элементы.ГруппаПериод.Видимость = Ложь;
	Форма.ЕстьНачалоПериодаБК       = Ложь;
	Форма.ЕстьКонецПериодаБК        = Ложь;
	
	Элементы.Период.Видимость = Истина;
	Форма.ЕстьПериодБК        = Истина;
	
	Элементы.ГруппаОрганизацияРегистрНУ.Видимость   = Ложь;
	Элементы.ГруппаОрганизация.Видимость            = Истина;
	
	Элементы.ВыводитьЗаголовок.Видимость            = Истина;
	Элементы.ВыводитьПодписи.Видимость              = Истина;
	Элементы.ВыводитьПодписиРуководителей.Видимость = Ложь;
	
	Если НЕ Форма.РежимРасшифровки Тогда
		Форма.Период = ОбщегоНазначения.ТекущаяДатаПользователя();
	КонецЕсли;
	
	Элементы.ГруппаДополнительные.Видимость = Ложь;
	
КонецПроцедуры

Процедура ПриОпределенииПараметровВыбора(Форма, СвойстваНастройки) Экспорт
	
	Если СвойстваНастройки.Тип = "ЭлементОтбора" Тогда
		ИмяОтбора = Строка(СвойстваНастройки.ПолеКД);
		Если ИмяОтбора = "ВидДенежныхСредств" Тогда
			ЗначенияДляВыбора = Новый СписокЗначений;
			ЗначенияДляВыбора.ТипЗначения = Новый ОписаниеТипов("Строка");
			ЗначенияДляВыбора.Добавить(НСтр("ru = 'Деньги в кассе'"), НСтр("ru = 'Деньги в кассе'"));
			ЗначенияДляВыбора.Добавить(НСтр("ru = 'Деньги на расчетных счетах'"), НСтр("ru = 'Деньги на расчетных счетах'"));
			ЗначенияДляВыбора.Добавить(НСтр("ru = 'Деньги у подотчетных лиц'"), НСтр("ru = 'Деньги у подотчетных лиц'"));
			
			СвойстваНастройки.ОграничиватьВыборУказаннымиЗначениями = Истина;
			СвойстваНастройки.ЗначенияДляВыбора = ЗначенияДляВыбора;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗагрузкойНастроекВКомпоновщик(Контекст, КлючСхемы, КлючВарианта, НовыеНастройкиКД, НовыеПользовательскиеНастройкиКД) Экспорт
	
	ЗаполняемыеНастройки = Новый Структура("Группировка", Истина);
	БухгалтерскиеОтчетыВызовСервера.ПередЗагрузкойНастроекВКомпоновщик(ЭтотОбъект, Контекст, КлючСхемы, КлючВарианта, НовыеНастройкиКД, НовыеПользовательскиеНастройкиКД, ЗаполняемыеНастройки);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДокументРезультат.Очистить();
	
	ОтчетМетаданные = Метаданные();
	ИмяОтчета       = ОтчетМетаданные.ПолноеИмя();
	МенеджерОтчета  = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ИмяОтчета);
	
	РежимВариантаОтчета = БухгалтерскиеОтчетыВызовСервера.ПолучитьРежимВыполненияОтчета(ОтчетМетаданные);
	
	Если НЕ РежимВариантаОтчета Тогда
		
		БухгалтерскиеОтчетыВызовСервера.ОбработкаСобытияПриКомпоновкеРезультата(ЭтотОбъект, ДокументРезультат, ДанныеРасшифровки);
		Возврат;
		
	Иначе
		
		РежимРасшифровки = КомпоновщикНастроек.ФиксированныеНастройки.ДополнительныеСвойства.Свойство("РежимРасшифровки");
		
		ПользовательскиеНастройки = КомпоновщикНастроек.ПользовательскиеНастройки;
		
		//ХранилищеСвойств = БухгалтерскиеОтчетыКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "НастройкиОтчета");
		//Если ХранилищеСвойств <> Неопределено И ТипЗнч(ХранилищеСвойств.Значение) = Тип("ХранилищеЗначения") Тогда
		//	НастройкиОтчета = ХранилищеСвойств.Значение.Получить();
		//Иначе
		//	Возврат;
		//КонецЕсли;
		
		ПараметрНастройкиОтчета = БухгалтерскиеОтчетыКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "НастройкиОтчета");
		Если ПараметрНастройкиОтчета <> Неопределено И ТипЗнч(ПараметрНастройкиОтчета.Значение) = Тип("ХранилищеЗначения") Тогда
			НастройкиОтчета = ПараметрНастройкиОтчета.Значение.Получить();
		КонецЕсли;
		
		Если НастройкиОтчета = Неопределено Тогда
			ПользовательскиеНастройки.ДополнительныеСвойства.Свойство("НастройкиОтчета", НастройкиОтчета);
		КонецЕсли;
		
		Если ТипЗнч(НастройкиОтчета) = Тип("ХранилищеЗначения") Тогда
			НастройкиОтчета = НастройкиОтчета.Получить();
		КонецЕсли;
		
		Если НастройкиОтчета = Неопределено Тогда
			Возврат;
		Иначе
			БухгалтерскиеОтчетыВызовСервера.УстановкаПериодаОтчетаРассылка(НастройкиОтчета, ПользовательскиеНастройки);
		КонецЕсли;
		
		Если НастройкиОтчета.ВыводитьЗаголовок Тогда
			МенеджерОтчета.ПриВыводеЗаголовка(НастройкиОтчета, ДокументРезультат);
		КонецЕсли;
		
		Периодичность = БухгалтерскиеОтчетыКлиентСервер.ПолучитьЗначениеПериодичности(НастройкиОтчета.Периодичность, НастройкиОтчета.НачалоПериода, НастройкиОтчета.КонецПериода);
		
		Если ЗначениеЗаполнено(НастройкиОтчета.НачалоПериода) Тогда
			БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", НачалоДня(НастройкиОтчета.НачалоПериода));
		Иначе
			БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", Дата(1, 1, 1));
		КонецЕсли;
		Если ЗначениеЗаполнено(НастройкиОтчета.КонецПериода) Тогда
			БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", КонецДня(НастройкиОтчета.КонецПериода));
		Иначе
			БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", Дата(3999, 11, 1));
		КонецЕсли;
		
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "Периодичность", Периодичность);
		
		ПользовательскийОтбор = ПользовательскиеНастройки.Элементы.Найти(КомпоновщикНастроек.Настройки.Отбор.ИдентификаторПользовательскойНастройки);
		Если ТипЗнч(ПользовательскийОтбор) = Тип("ОтборКомпоновкиДанных") Тогда
			БухгалтерскиеОтчеты.ДобавитьОтборПоОрганизациямИПодразделениям(ПользовательскийОтбор, НастройкиОтчета);
		КонецЕсли;
		
	КонецЕсли;
	
	
	// Компоновка макета
	
	НастройкиДляКомпоновкиМакета = КомпоновщикНастроек.ПолучитьНастройки();
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	
	Попытка
		
		МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиДляКомпоновкиМакета, ДанныеРасшифровки);

		ВнешниеНаборыДанных = МенеджерОтчета.ПолучитьВнешниеНаборыДанных(НастройкиОтчета, МакетКомпоновки);

		ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
		Если ВнешниеНаборыДанных = Неопределено Тогда
			ПроцессорКомпоновки.Инициализировать(МакетКомпоновки,, ДанныеРасшифровки, Истина);
		Иначе
			ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных, ДанныеРасшифровки, Истина);
		КонецЕсли;	

		ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
		ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
		
		ПроцессорВывода.НачатьВывод();
		ПроцессорВывода.Вывести(ПроцессорКомпоновки, Истина);
		
	Исключение
		// Запись в журнал регистрации не требуется
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		Пока ИнформацияОбОшибке.Причина <> Неопределено Цикл
			ИнформацияОбОшибке = ИнформацияОбОшибке.Причина;
		КонецЦикла;
		ТекстСообщения = НСтр("ru = 'Отчет не сформирован!'") + Символы.ПС + ИнформацияОбОшибке.Описание;
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		Отказ = Истина;
	КонецПопытки;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура ВывестиПодписи(ДокументРезультат) Экспорт
	
	ДополнительныеСвойства = КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства;
	Если ДополнительныеСвойства.Свойство("НастройкиОтчета") И ТипЗнч(ДополнительныеСвойства.НастройкиОтчета) = Тип("Структура") Тогда
		НастройкиОтчета = ДополнительныеСвойства.НастройкиОтчета;
	Иначе
		Возврат;
	КонецЕсли;
	
	Если НастройкиОтчета.ВыводитьПодписи Тогда
		БухгалтерскиеОтчетыВызовСервера.ВыводПодписейОтчета(НастройкиОтчета, ДокументРезультат);
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьНастройкамиПоУмолчанию(ЗаполняемыеНастройки, ОтчетОбъект) Экспорт
	
	Если ОтчетОбъект.РежимРасшифровки Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗаполняемыеНастройки.Свойство("Группировка") И ЗаполняемыеНастройки.Группировка Тогда
	
		ТаблицаГруппировка = ОтчетОбъект.Группировка;

		ТаблицаГруппировка.Очистить();
		
		Если ПользователиБКВызовСервераПовтИсп.ПолучитьЗначениеПоУмолчанию(
				ПользователиКлиентСервер.ТекущийПользователь(), "УчетПоВсемОрганизациям") Тогда
			НоваяСтрока = ТаблицаГруппировка.Добавить();
			НоваяСтрока.Поле           = "Организация";
			НоваяСтрока.Использование  = Ложь;
			НоваяСтрока.Представление  = НСтр("ru = 'Организация'");
			НоваяСтрока.ТипГруппировки = Перечисления.ТипДетализацииСтандартныхОтчетов.Элементы;	
		КонецЕсли;
		
		НоваяСтрока = ТаблицаГруппировка.Добавить();
		НоваяСтрока.Поле           = "ВидДенежныхСредств";
		НоваяСтрока.Использование  = Истина;
		НоваяСтрока.Представление  = НСтр("ru = 'Вид денежных средств'");
		НоваяСтрока.ТипГруппировки = Перечисления.ТипДетализацииСтандартныхОтчетов.Элементы;	
		
		НоваяСтрока = ТаблицаГруппировка.Добавить();
		НоваяСтрока.Поле           = "Аналитика";
		НоваяСтрока.Использование  = Ложь;
		НоваяСтрока.Представление  = НСтр("ru = 'Аналитика'");
		НоваяСтрока.ТипГруппировки = Перечисления.ТипДетализацииСтандартныхОтчетов.Элементы;
			
		ОтчетОбъект.ГруппировкаКолонок.Очистить();
		
		НоваяСтрока = ОтчетОбъект.ГруппировкаКолонок.Добавить();
		НоваяСтрока.Поле           = "Валюта";
		НоваяСтрока.Использование  = Истина;
		НоваяСтрока.Представление  = НСтр("ru = 'Валюта'");
		НоваяСтрока.ТипГруппировки = Перечисления.ТипДетализацииСтандартныхОтчетов.Элементы;	
			
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ

#КонецЕсли