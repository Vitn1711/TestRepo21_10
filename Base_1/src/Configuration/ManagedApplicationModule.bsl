#Область ОписаниеПеременных

// СтандартныеПодсистемы

// Хранилище глобальных переменных.
//
// ПараметрыПриложения - Соответствие - хранилище переменных, где:
//   * Ключ - Строка - имя переменной в формате "ИмяБиблиотеки.ИмяПеременной";
//   * Значение - Произвольный - значение переменной.
//
// Инициализация (на примере СообщенияДляЖурналаРегистрации):
//   ИмяПараметра = "СтандартныеПодсистемы.СообщенияДляЖурналаРегистрации";
//   Если ПараметрыПриложения[ИмяПараметра] = Неопределено Тогда
//     ПараметрыПриложения.Вставить(ИмяПараметра, Новый СписокЗначений);
//   КонецЕсли;
//  
// Использование (на примере СообщенияДляЖурналаРегистрации):
//   ПараметрыПриложения["СтандартныеПодсистемы.СообщенияДляЖурналаРегистрации"].Добавить(...);
//   ПараметрыПриложения["СтандартныеПодсистемы.СообщенияДляЖурналаРегистрации"] = ...;
Перем ПараметрыПриложения Экспорт;

// Конец СтандартныеПодсистемы

// ЭлектронныеСчетаФактуры
Перем СеансовыеДанныеЭСФ Экспорт;
// Конец ЭлектронныеСчетаФактуры

// ТехнологияСервиса
Перем ОповещениеПриПримененииЗапросовНаИспользованиеВнешнихРесурсовВМоделиСервиса Экспорт;
// Конец ТехнологияСервиса

//РаботаСВнешнимОборудованием
Перем глПодключаемоеОборудование Экспорт; // для кэширования на клиенте

Перем глДоступныеТипыОборудования Экспорт;
//Конец РаботаСВнешнимОборудованием

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередНачаломРаботыСистемы()
	
	// СтандартныеПодсистемы
	СтандартныеПодсистемыКлиент.ПередНачаломРаботыСистемы();
	// Конец СтандартныеПодсистемы
	
	// ИнтернетПоддержкаПользователей
	ИнтернетПоддержкаПользователейКлиент.ПередНачаломРаботыСистемы();
	// Конец ИнтернетПоддержкаПользователей
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.ПередНачаломРаботыСистемы();
	// Конец ПодключаемоеОборудование
	
	Если ПустаяСтрока(ПараметрЗапуска) И НЕ ТЦСервер.ПолучитьНаличиеСценариев() Тогда
		Предупреждение(НСтр("ru = 'Обнаружено некорректное наполнение информационной базы.
		|Чтобы развернуть информационную базу корректно, воспользуйтесь функцией создания информационной базы из шаблона.'"));
		Отказ = Истина;		
		Возврат;
	КонецЕсли; 	
	
КонецПроцедуры

Процедура ПриНачалеРаботыСистемы()
	
	// СтандартныеПодсистемы
	СтандартныеПодсистемыКлиент.ПриНачалеРаботыСистемы();
	// Конец СтандартныеПодсистемы
	
	//РаботаСВнешнимОборудованием
	МенеджерОборудованияКлиент.ПриНачалеРаботыСистемы();
	//Конец РаботаСВнешнимОборудованием 
	
	Попытка
		Если ПустаяСтрока(ПараметрЗапуска) Тогда
			ОткрытьФорму("Обработка.ЗапускСтандартногоНагрузочногоТеста.Форма.Форма",,,, ТЦКлиент.ОсновноеОкно());
		Иначе
			ТЦКлиент.ОбработатьПараметрЗапуска(ПараметрЗапуска);
			Если ТЦСервер.БСППодсистемаИспользуется(ТЦОбщий.БСПИмяПодсистемыУправленияДоступом()) Тогда
				ТЦСервер.БСПСоздатьГруппуДоступаТестЦентр();
			КонецЕсли;
		КонецЕсли;
		
	Исключение
		ТЦОбщий.ЗаписатьВЖурнал(ИнформацияОбОшибке(), "Тест-центр");
	КонецПопытки;

	
КонецПроцедуры

Процедура ПередЗавершениемРаботыСистемы(Отказ, ТекстПредупреждения)
	
	// СтандартныеПодсистемы
	СтандартныеПодсистемыКлиент.ПередЗавершениемРаботыСистемы(Отказ, ТекстПредупреждения);
	// Конец СтандартныеПодсистемы
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.ПередЗавершениемРаботыСистемы();
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

Процедура ОбработкаВнешнегоСобытия(Источник, Событие, Данные)
	
	// ПодключаемоеОборудование
	// Подготовить данные   	
	ОписаниеСобытия = Новый Структура();
	ОписаниеОшибки  = "";
	
	ОписаниеСобытия.Вставить("Источник", Источник);
	ОписаниеСобытия.Вставить("Событие",  Событие);
	ОписаниеСобытия.Вставить("Данные",   Данные);
	
	// Передать на обработку данные.
	Результат = МенеджерОборудованияКлиент.ОбработатьСобытиеОтУстройства(ОписаниеСобытия, ОписаниеОшибки);
	Если Не Результат Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='При обработке внешнего события от устройства произошла ошибка.'")
		                                                 + Символы.ПС + ОписаниеОшибки);
	КонецЕсли;
	// Конец ПодключаемоеОборудование

КонецПроцедуры

#КонецОбласти