#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура ЗаполнитьТабличнуюЧастьТекущимиДанными(Объект) Экспорт 
	
	МенеджерВТ = Новый МенеджерВременныхТаблиц;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВТ;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ОС.ОсновноеСредство КАК ОсновноеСредство
	               |ПОМЕСТИТЬ ОС
	               |ИЗ
	               |	&ОС КАК ОС
	               |
	               |ИНДЕКСИРОВАТЬ ПО
	               |	ОсновноеСредство";
	Запрос.УстановитьПараметр("ОС", Объект.ОС.Выгрузить());
	Запрос.Выполнить();
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ОС.ОсновноеСредство,
	               |	ЕСТЬNULL(ОбъектыЗемельногоНалогаСрезПоследних.НачислятьНалог, ЛОЖЬ) КАК ОбъектЗемельногоНалога,
	               |	ЕСТЬNULL(ОбъектыИмущественногоНалогаСрезПоследних.НачислятьНалог, ЛОЖЬ) КАК ОбъектИмущественногоНалога,
	               |	ЕСТЬNULL(ОбъектыТранспортногоНалогаСрезПоследних.НачислятьНалог, ЛОЖЬ) КАК ОбъектТранспортногоНалога,
				   |	ЕСТЬNULL(НачислениеАмортизацииОСБухгалтерскийУчетСрезПоследних.НачислятьАмортизацию, ЛОЖЬ) КАК НачислятьАмортизацию
	               |ИЗ
	               |	ОС КАК ОС
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОбъектыЗемельногоНалога.СрезПоследних(
	               |				&Дата,
	               |				Налогоплательщик = &Организация) КАК ОбъектыЗемельногоНалогаСрезПоследних
	               |		ПО ОС.ОсновноеСредство = ОбъектыЗемельногоНалогаСрезПоследних.ОбъектНалогообложения
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОбъектыИмущественногоНалога.СрезПоследних(
	               |				&Дата,
	               |				Налогоплательщик = &Организация) КАК ОбъектыИмущественногоНалогаСрезПоследних
	               |		ПО ОС.ОсновноеСредство = ОбъектыИмущественногоНалогаСрезПоследних.ОбъектНалогообложения
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОбъектыТранспортногоНалога.СрезПоследних(
	               |				&Дата,
	               |				Налогоплательщик = &Организация) КАК ОбъектыТранспортногоНалогаСрезПоследних
	               |		ПО ОС.ОсновноеСредство = ОбъектыТранспортногоНалогаСрезПоследних.ОбъектНалогообложения
				   |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НачислениеАмортизацииОСБухгалтерскийУчет.СрезПоследних(
	               |				&Дата,
	               |				Организация = &Организация) КАК НачислениеАмортизацииОСБухгалтерскийУчетСрезПоследних
	               |		ПО ОС.ОсновноеСредство = НачислениеАмортизацииОСБухгалтерскийУчетСрезПоследних.ОсновноеСредство
	               |";
				   
	Запрос.УстановитьПараметр("Дата"	   , КонецДня(Объект.Дата));
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
		
	Результат = Запрос.Выполнить().Выгрузить();
		
	Для Каждого СтрокаОС ИЗ Объект.ОС Цикл
		
		СтрокаТЗ = Результат.Найти(СтрокаОС.ОсновноеСредство, "ОсновноеСредство");
		
		Если Не СтрокаТЗ = Неопределено Тогда
			СтрокаОС.НачислятьАмортизацию 		= СтрокаТЗ.НачислятьАмортизацию;
			СтрокаОС.ОбъектЗемельногоНалога 	= СтрокаТЗ.ОбъектЗемельногоНалога;
			СтрокаОС.ОбъектИмущественногоНалога = СтрокаТЗ.ОбъектИмущественногоНалога;
			СтрокаОС.ОбъектТранспортногоНалога 	= СтрокаТЗ.ОбъектТранспортногоНалога;
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Интерфейс для работы с подсистемой Печать.

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
		
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Заполнение

Процедура ЗаполнитьДокументПоСправочникуОсновныеСредства(Объект, Основание) Экспорт
	
	Если Основание.ЭтоГруппа Тогда
		ТекстСообщения = НСтр("ru = 'Нельзя изменять состояние по группе основных средств.'");
		ВызватьИсключение(ТекстСообщения);
	КонецЕсли;

	Объект.СобытиеОС = УправлениеВнеоборотнымиАктивамиСервер.ПолучитьСобытиеПоОСИзСправочника(Перечисления.ВидыСобытийОС.ПринятиеКУчету);

	СтрокаТабличнойЧасти = Объект.ОС.Добавить();
	СтрокаТабличнойЧасти.ОсновноеСредство = Основание.Ссылка;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Проведение

Функция ПодготовитьПараметрыПроведения(ДокументСсылка, Отказ) Экспорт
	
	ПараметрыПроведения = Новый Структура;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", 									  ДокументСсылка);
	Запрос.УстановитьПараметр("ПоддержкаРаботыСоСтруктурнымиПодразделениями", Константы.ПоддержкаРаботыСоСтруктурнымиПодразделениями.Получить());
	
	НомераТаблиц = Новый Структура;
	
	Запрос.Текст = ТекстЗапросаРеквизитыДокумента(НомераТаблиц);
	Результат = Запрос.ВыполнитьПакет();
	ТаблицаРеквизиты = Результат[НомераТаблиц["Реквизиты"]].Выгрузить();
	ПараметрыПроведения.Вставить("Реквизиты", ТаблицаРеквизиты);
	
	Реквизиты = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(ТаблицаРеквизиты[0]);
	
	Запрос.УстановитьПараметр("ДатаДокумента", Реквизиты.Период);
	Запрос.УстановитьПараметр("Организация",   Реквизиты.Организация);	
	
	
	НомераТаблиц = Новый Структура;
	
	Запрос.Текст = ТекстЗапросаВременныеТаблицыДокумента(НомераТаблиц)
					+ ТекстЗапросаИзменениеСостоянияОС(НомераТаблиц);
	
	Результат = Запрос.ВыполнитьПакет();
	
	Для каждого НомерТаблицы Из НомераТаблиц Цикл
		ПараметрыПроведения.Вставить(НомерТаблицы.Ключ, Результат[НомерТаблицы.Значение].Выгрузить());
	КонецЦикла;
	
	Возврат ПараметрыПроведения;

КонецФункции

Функция ТекстЗапросаРеквизитыДокумента(НомераТаблиц)
	
	НомераТаблиц.Вставить("ВременнаяТаблицаРеквизиты", НомераТаблиц.Количество());
	НомераТаблиц.Вставить("Реквизиты"				 , НомераТаблиц.Количество());
	
	ТекстЗапроса = "ВЫБРАТЬ
	|	""ИзменениеСостоянияОС"" КАК ВидДокумента,
	|	Реквизиты.Ссылка КАК Регистратор,
	|	Реквизиты.Дата КАК Период,
	|	Реквизиты.Организация КАК Организация,
	|	Реквизиты.СтруктурноеПодразделение КАК СтруктурноеПодразделение,
	|	Реквизиты.Номер КАК Номер,
	|	Реквизиты.СобытиеОС КАК СобытиеОС,
	|	Реквизиты.ИзменениеЗемельногоНалога КАК ИзменениеЗемельногоНалога,
	|	Реквизиты.ИзменениеИмущественногоНалога КАК ИзменениеИмущественногоНалога,
	|	Реквизиты.ИзменениеНачисленияАмортизации КАК ИзменениеНачисленияАмортизации,
	|	Реквизиты.ИзменениеТранспортногоНалога КАК ИзменениеТранспортногоНалога
	|ПОМЕСТИТЬ Реквизиты
	|ИЗ
	|	Документ.ИзменениеСостоянияОС КАК Реквизиты
	|ГДЕ
	|	Реквизиты.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Реквизиты.ВидДокумента,
	|	Реквизиты.Регистратор,
	|	Реквизиты.Период,
	|	Реквизиты.Организация,
	|	Реквизиты.СтруктурноеПодразделение,
	|	Реквизиты.Номер,
	|	Реквизиты.СобытиеОС,
	|	&ПоддержкаРаботыСоСтруктурнымиПодразделениями,
	|	Реквизиты.ИзменениеЗемельногоНалога,
	|	Реквизиты.ИзменениеИмущественногоНалога,
	|	Реквизиты.ИзменениеНачисленияАмортизации,
	|	Реквизиты.ИзменениеТранспортногоНалога
	|ИЗ
	|	Реквизиты КАК Реквизиты";

	Возврат ТекстЗапроса + ОбщегоНазначенияБКВызовСервера.ТекстРазделителяЗапросовПакета();
	
КонецФункции

Функция ТекстЗапросаВременныеТаблицыДокумента(НомераТаблиц)

	НомераТаблиц.Вставить("ВременнаяТаблицаОС", НомераТаблиц.Количество());
 	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ТаблицаОС.Ссылка КАК Ссылка,
	|	ТаблицаОС.НомерСтроки,
	|	ТаблицаОС.ОсновноеСредство,
	|	ТаблицаОС.ОбъектИмущественногоНалога КАК ОбъектИмущественногоНалога,
	|	ТаблицаОС.ОбъектТранспортногоНалога КАК ОбъектТранспортногоНалога,
	|	ТаблицаОС.ОбъектЗемельногоНалога КАК ОбъектЗемельногоНалога,
	|	ТаблицаОС.НачислятьАмортизацию КАК НачислятьАмортизацию
	|ПОМЕСТИТЬ ТаблицаОС
	|ИЗ
	|	Документ.ИзменениеСостоянияОС.ОС КАК ТаблицаОС
	|ГДЕ
	|	ТаблицаОС.Ссылка = &Ссылка
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка";
	
	Возврат ТекстЗапроса + ОбщегоНазначенияБКВызовСервера.ТекстРазделителяЗапросовПакета();

КонецФункции

Функция ТекстЗапросаИзменениеСостоянияОС(НомераТаблиц)
	
	НомераТаблиц.Вставить("СобытияОСОрганизацийТаблицаОС"					 , НомераТаблиц.Количество());
	НомераТаблиц.Вставить("НачислениеАмортизацииОСБухгалтерскийУчетТаблицаОС", НомераТаблиц.Количество());
	НомераТаблиц.Вставить("СостоянияОСОрганизацийТаблицаОС"					 , НомераТаблиц.Количество());
	НомераТаблиц.Вставить("ОбъектыИмущественногоНалогаТаблицаОС"			 , НомераТаблиц.Количество());
	НомераТаблиц.Вставить("ИзменениеТранспортногоНалогаТаблицаОС"			 , НомераТаблиц.Количество());
	НомераТаблиц.Вставить("ИзменениеЗемельногоНалогаТаблицаОС"				 , НомераТаблиц.Количество());
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ТаблицаОС.ОсновноеСредство,
	|	0 КАК СуммаЗатратБУ
	|ИЗ
	|	ТаблицаОС КАК ТаблицаОС
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТаблицаОС.НомерСтроки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаОС.ОсновноеСредство,
	|	ТаблицаОС.НачислятьАмортизацию
	|ИЗ
	|	Реквизиты КАК Реквизиты
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаОС КАК ТаблицаОС
	|		ПО (ИСТИНА)
	|ГДЕ
	|	Реквизиты.ИзменениеНачисленияАмортизации = ИСТИНА
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТаблицаОС.НомерСтроки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаОС.ОсновноеСредство,
	|	ВЫБОР
	|		КОГДА Реквизиты.СобытиеОС.ВидСобытияОС = ЗНАЧЕНИЕ(Перечисление.ВидыСобытийОС.Передача) Тогда
	|			ЗНАЧЕНИЕ(Перечисление.ВидыСостоянийОС.СнятоСУчета)
	|		КОГДА Реквизиты.СобытиеОС.ВидСобытияОС = ЗНАЧЕНИЕ(Перечисление.ВидыСобытийОС.Списание) Тогда
	|			ЗНАЧЕНИЕ(Перечисление.ВидыСостоянийОС.СнятоСУчета)
	|		КОГДА Реквизиты.СобытиеОС.ВидСобытияОС = ЗНАЧЕНИЕ(Перечисление.ВидыСобытийОС.ПринятиеКУчету) Тогда
	|			ЗНАЧЕНИЕ(Перечисление.ВидыСостоянийОС.ПринятоКУчету)
	|		Иначе
	|			ЗНАЧЕНИЕ(Перечисление.ВидыСостоянийОС.ПустаяСсылка)
	|	КОНЕЦ КАК СостояниеОС
	|ИЗ
	|	Реквизиты КАК Реквизиты
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаОС КАК ТаблицаОС
	|		ПО (ИСТИНА)
	|ГДЕ
	|	ВЫБОР
	|		КОГДА Реквизиты.СобытиеОС.ВидСобытияОС = ЗНАЧЕНИЕ(Перечисление.ВидыСобытийОС.Передача) Тогда
	|			ИСТИНА
	|		КОГДА Реквизиты.СобытиеОС.ВидСобытияОС = ЗНАЧЕНИЕ(Перечисление.ВидыСобытийОС.Списание) Тогда
	|			ИСТИНА
	|		КОГДА Реквизиты.СобытиеОС.ВидСобытияОС = ЗНАЧЕНИЕ(Перечисление.ВидыСобытийОС.ПринятиеКУчету) Тогда
	|			ИСТИНА
	|		Иначе
	|			ЛОЖЬ
	|	КОНЕЦ
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТаблицаОС.НомерСтроки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаОС.ОсновноеСредство КАК ОбъектНалогообложения,
	|	ТаблицаОС.ОбъектИмущественногоНалога КАК НачислятьНалог,
	|	МестонахождениеОСБухгалтерскийУчетСрезПоследних.Местонахождение,
	|	ОбъектыИмущественногоНалогаСрезПоследних.СтруктурнаяЕдиница КАК СтруктурнаяЕдиницаИмущественногоНалога
	|ИЗ
	|	Реквизиты КАК Реквизиты
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаОС КАК ТаблицаОС
	|		ПО (ИСТИНА)
    |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.МестонахождениеОСБухгалтерскийУчет.СрезПоследних(
    |				&ДатаДокумента,
    |				ОсновноеСредство В (ВЫБРАТЬ ТаблицаОС.ОсновноеСредство ИЗ ТаблицаОС КАК ТаблицаОС)
    |					И Организация = &Организация) КАК МестонахождениеОСБухгалтерскийУчетСрезПоследних
    |		ПО ТаблицаОС.ОсновноеСредство = МестонахождениеОСБухгалтерскийУчетСрезПоследних.ОсновноеСредство
    |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОбъектыИмущественногоНалога.СрезПоследних(
	|				&ДатаДокумента,
	|				ОбъектНалогообложения В (ВЫБРАТЬ ТаблицаОС.ОсновноеСредство ИЗ ТаблицаОС КАК ТаблицаОС)
	|					И Налогоплательщик = &Организация) КАК ОбъектыИмущественногоНалогаСрезПоследних
	|		ПО ТаблицаОС.ОсновноеСредство = ОбъектыИмущественногоНалогаСрезПоследних.ОбъектНалогообложения
	|ГДЕ
	|	Реквизиты.ИзменениеИмущественногоНалога = ИСТИНА
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТаблицаОС.НомерСтроки
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаОС.ОсновноеСредство КАК ОбъектНалогообложения,
	|	ТаблицаОС.ОбъектТранспортногоНалога КАК НачислятьНалог,
	|	ОбъектыТранспортногоНалогаСрезПоследних.СтруктурнаяЕдиница КАК СтруктурнаяЕдиницаТранспортногоНалога,
	|	МестонахождениеОСБухгалтерскийУчетСрезПоследних.Местонахождение
	|ИЗ
	|	Реквизиты КАК Реквизиты
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаОС КАК ТаблицаОС
	|		ПО (ИСТИНА)
    |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.МестонахождениеОСБухгалтерскийУчет.СрезПоследних(
    |				&ДатаДокумента,
    |				ОсновноеСредство В (ВЫБРАТЬ ТаблицаОС.ОсновноеСредство ИЗ ТаблицаОС КАК ТаблицаОС)
    |					И Организация = &Организация) КАК МестонахождениеОСБухгалтерскийУчетСрезПоследних
    |		ПО ТаблицаОС.ОсновноеСредство = МестонахождениеОСБухгалтерскийУчетСрезПоследних.ОсновноеСредство
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОбъектыТранспортногоНалога.СрезПоследних(
	|				&ДатаДокумента,
	|				ОбъектНалогообложения В (ВЫБРАТЬ ТаблицаОС.ОсновноеСредство ИЗ ТаблицаОС КАК ТаблицаОС)
	|					И Налогоплательщик = &Организация) КАК ОбъектыТранспортногоНалогаСрезПоследних
	|		ПО ТаблицаОС.ОсновноеСредство = ОбъектыТранспортногоНалогаСрезПоследних.ОбъектНалогообложения
	|ГДЕ
	|	Реквизиты.ИзменениеТранспортногоНалога = ИСТИНА
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТаблицаОС.НомерСтроки
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаОС.ОсновноеСредство КАК ОбъектНалогообложения,
	|	ТаблицаОС.ОбъектЗемельногоНалога КАК НачислятьНалог,
	|	ОбъектыЗемельногоНалогаСрезПоследних.СтруктурнаяЕдиница КАК СтруктурнаяЕдиницаЗемельногоНалога,
	|	МестонахождениеОСБухгалтерскийУчетСрезПоследних.Местонахождение
	|ИЗ
	|	Реквизиты КАК Реквизиты
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаОС КАК ТаблицаОС
	|		ПО (ИСТИНА)
    |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.МестонахождениеОСБухгалтерскийУчет.СрезПоследних(
    |				&ДатаДокумента,
    |				ОсновноеСредство В (ВЫБРАТЬ ТаблицаОС.ОсновноеСредство ИЗ ТаблицаОС КАК ТаблицаОС)
    |					И Организация = &Организация) КАК МестонахождениеОСБухгалтерскийУчетСрезПоследних
    |		ПО ТаблицаОС.ОсновноеСредство = МестонахождениеОСБухгалтерскийУчетСрезПоследних.ОсновноеСредство
    |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОбъектыЗемельногоНалога.СрезПоследних(
    |				&ДатаДокумента,
    |				ОбъектНалогообложения В (ВЫБРАТЬ ТаблицаОС.ОсновноеСредство ИЗ ТаблицаОС КАК ТаблицаОС)
	|					И Налогоплательщик = &Организация) КАК ОбъектыЗемельногоНалогаСрезПоследних
	|		ПО ТаблицаОС.ОсновноеСредство = ОбъектыЗемельногоНалогаСрезПоследних.ОбъектНалогообложения
	|ГДЕ
	|	Реквизиты.ИзменениеЗемельногоНалога = ИСТИНА
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТаблицаОС.НомерСтроки
	|";
	
	Возврат ТекстЗапроса + ОбщегоНазначенияБКВызовСервера.ТекстРазделителяЗапросовПакета();
		
КонецФункции

#КонецЕсли
