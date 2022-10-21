///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает данные кэша версий из ресурса типа ХранилищеЗначения регистра КэшПрограммныхИнтерфейсов.
//
// Параметры:
//   Идентификатор - Строка - идентификатор записи кэша.
//   ТипДанных     - ПеречислениеСсылка.ТипыДанныхКэшаПрограммныхИнтерфейсов - 
//   ПараметрыПолучения - Строка - массив параметров сериализованный в XML для передачи в метод обновления кэша.
//   ИспользоватьУстаревшиеДанные - Булево - флаг определяющий необходимость ожидания обновления
//      данных в кэше перед возвратом значения, в случае обнаружения факта их устаревания.
//      Истина - всегда использовать данные из кэша, если они там есть. Ложь - ожидать
//      обновления данных кэша, в случае обнаружения факта устаревания данных.
//
// Возвращаемое значение:
//   ФиксированныйМассив, ДвоичныеДанные - .
//
Функция ДанныеКэшаВерсий(Знач Идентификатор, Знач ТипДанных, Знач ПараметрыПолучения, Знач ИспользоватьУстаревшиеДанные = Истина) Экспорт
		
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ТаблицаКэша.ДатаОбновления КАК ДатаОбновления,
		|	ТаблицаКэша.Данные КАК Данные,
		|	ТаблицаКэша.ТипДанных КАК ТипДанных
		|ИЗ
		|	РегистрСведений.КэшПрограммныхИнтерфейсов КАК ТаблицаКэша
		|ГДЕ
		|	ТаблицаКэша.Идентификатор = &Идентификатор
		|	И ТаблицаКэша.ТипДанных = &ТипДанных";
	Запрос.УстановитьПараметр("Идентификатор", Идентификатор);
	Запрос.УстановитьПараметр("ТипДанных", ТипДанных);
	
	НачатьТранзакцию();
	Попытка
		// Не устанавливаем управляемую блокировку, чтобы другие сеансы могли изменять значение пока эта транзакция активна.
		УстановитьПривилегированныйРежим(Истина);
		Результат = Запрос.Выполнить();
		УстановитьПривилегированныйРежим(Ложь);
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	ТребуетсяВыполнитьОбновление = Ложь;
	ТребуетсяПеречитатьДанные = Ложь;
	
	Если Результат.Пустой() Тогда
		
		ТребуетсяВыполнитьОбновление = Истина;
		ТребуетсяПеречитатьДанные = Истина;
		
	Иначе
		
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		Если Не КэшПрограммногоИнтерфейсаАктуален(Выборка.ДатаОбновления) Тогда
			ТребуетсяВыполнитьОбновление = Истина;
			ТребуетсяПеречитатьДанные = НЕ ИспользоватьУстаревшиеДанные;
		КонецЕсли;
	КонецЕсли;
	
	Если ТребуетсяВыполнитьОбновление Тогда
		
		ОбновлениеВТекущемСеансе = ТребуетсяПеречитатьДанные
			Или ОбщегоНазначения.ИнформационнаяБазаФайловая()
			Или МонопольныйРежим()
			Или ОбщегоНазначения.РежимОтладки()
			Или ТекущийРежимЗапуска() = Неопределено;
		
		Если ОбновлениеВТекущемСеансе Тогда
			ОбновитьДанныеКэшаВерсий(Идентификатор, ТипДанных, ПараметрыПолучения);
			ТребуетсяПеречитатьДанные = Истина;
		Иначе
			ИмяМетодаЗадания = "РегистрыСведений.КэшПрограммныхИнтерфейсов.ОбновитьДанныеКэшаВерсий";
			НаименованиеЗадания = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Обновление кэша версий. Идентификатор записи %1. Тип данных %2.'"),
				Идентификатор,
				ТипДанных);
			ПараметрыЗадания = Новый Массив;
			ПараметрыЗадания.Добавить(Идентификатор);
			ПараметрыЗадания.Добавить(ТипДанных);
			ПараметрыЗадания.Добавить(ПараметрыПолучения);
			
			ОтборЗаданий = Новый Структура;
			ОтборЗаданий.Вставить("ИмяМетода", ИмяМетодаЗадания);
			ОтборЗаданий.Вставить("Наименование", НаименованиеЗадания);
			ОтборЗаданий.Вставить("Состояние", СостояниеФоновогоЗадания.Активно);
			
			Задания = ФоновыеЗадания.ПолучитьФоновыеЗадания(ОтборЗаданий);
			Если Задания.Количество() = 0 Тогда
				// Запустим новое.
				ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(Неопределено);
				ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеЗадания;
				БезопасныйРежим = БезопасныйРежим();
				УстановитьОтключениеБезопасногоРежима(Истина);
				ДлительныеОперации.ЗапуститьФоновоеЗаданиеСКонтекстомКлиента(ИмяМетодаЗадания,
					ПараметрыВыполнения, ПараметрыЗадания, БезопасныйРежим);
				УстановитьОтключениеБезопасногоРежима(Ложь);
			КонецЕсли;
		КонецЕсли;
		
		Если ТребуетсяПеречитатьДанные Тогда
			
			НачатьТранзакцию();
			Попытка
				// Не устанавливаем управляемую блокировку, чтобы другие сеансы могли изменять значение пока эта транзакция активна.
				УстановитьПривилегированныйРежим(Истина);
				Результат = Запрос.Выполнить();
				УстановитьПривилегированныйРежим(Ложь);
				ЗафиксироватьТранзакцию();
			Исключение
				ОтменитьТранзакцию();
				ВызватьИсключение;
			КонецПопытки;
			
			Если Результат.Пустой() Тогда
				ШаблонСообщения = НСтр("ru = 'Ошибка при обновлении кэша версий. Данные не получены.
					|Идентификатор записи: %1
					|Тип данных: %2'");
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, Идентификатор, ТипДанных);
					
				ВызватьИсключение(ТекстСообщения);
			КонецЕсли;
			
			Выборка = Результат.Выбрать();
			Выборка.Следующий();
		КонецЕсли;
		
	КонецЕсли;
		
	Возврат Выборка.Данные.Получить();
	
КонецФункции

// Обновляет данные в кэше версий.
//
// Параметры:
//  Идентификатор      - Строка - идентификатор записи кэша.
//  ТипДанных          - ПеречислениеСсылка.ТипыДанныхКэшаПрограммныхИнтерфейсов - тип обновляемых данных.
//  ПараметрыПолучения - Массив - дополнительные параметры получения данных в кэш.
//
Процедура ОбновитьДанныеКэшаВерсий(Знач Идентификатор, Знач ТипДанных, Знач ПараметрыПолучения) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	СтруктураКлюча = Новый Структура("Идентификатор, ТипДанных", Идентификатор, ТипДанных);
	Ключ = СоздатьКлючЗаписи(СтруктураКлюча);
	
	Попытка
		ЗаблокироватьДанныеДляРедактирования(Ключ);
	Исключение
		// Данные уже обновляются из другого сеанса.
		Возврат;
	КонецПопытки;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ТаблицаКэша.ДатаОбновления КАК ДатаОбновления,
		|	ТаблицаКэша.Данные КАК Данные,
		|	ТаблицаКэша.ТипДанных КАК ТипДанных
		|ИЗ
		|	РегистрСведений.КэшПрограммныхИнтерфейсов КАК ТаблицаКэша
		|ГДЕ
		|	ТаблицаКэша.Идентификатор = &Идентификатор
		|	И ТаблицаКэша.ТипДанных = &ТипДанных";
	Запрос.УстановитьПараметр("Идентификатор", Идентификатор);
	Запрос.УстановитьПараметр("ТипДанных", ТипДанных);
	
	НачатьТранзакцию();
	
	Попытка
		
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.КэшПрограммныхИнтерфейсов");
		ЭлементБлокировки.УстановитьЗначение("Идентификатор", Идентификатор);
		ЭлементБлокировки.УстановитьЗначение("ТипДанных", ТипДанных);
		Блокировка.Заблокировать();
		
		Результат = Запрос.Выполнить();
		
		// Не удерживаем транзакцию для того, чтобы другие сеансы могли выполнять чтение данных.
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		РазблокироватьДанныеДляРедактирования(Ключ);
		ВызватьИсключение;
		
	КонецПопытки;
	
	Попытка
		
		// Убедимся, что данные требуют обновления.
		Если Не Результат.Пустой() Тогда
			
			Выборка = Результат.Выбрать();
			Выборка.Следующий();
			Если КэшПрограммногоИнтерфейсаАктуален(Выборка.ДатаОбновления) Тогда
				РазблокироватьДанныеДляРедактирования(Ключ);
				Возврат;
			КонецЕсли;
			
		КонецЕсли;
		
		Набор = СоздатьНаборЗаписей();
		Набор.Отбор.Идентификатор.Установить(Идентификатор);
		Набор.Отбор.ТипДанных.Установить(ТипДанных);
		
		Запись = Набор.Добавить();
		Запись.Идентификатор = Идентификатор;
		Запись.ТипДанных = ТипДанных;
		Запись.ДатаОбновления = ТекущаяУниверсальнаяДата();
		
		Набор.ДополнительныеСвойства.Вставить("ПараметрыПолучения", ПараметрыПолучения);
		Набор.ПодготовитьДанныеДляЗаписи();
		
		Набор.Записать();
		
		РазблокироватьДанныеДляРедактирования(Ключ);
		
	Исключение
		
		РазблокироватьДанныеДляРедактирования(Ключ);
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

// Подготавливает данные для кэша программных интерфейсов.
//
// Параметры:
//  ТипДанных          - ПеречислениеСсылка.ТипыДанныхКэшаПрограммныхИнтерфейсов - тип обновляемых данных.
//  ПараметрыПолучения - Массив - дополнительные параметры получения данных в кэш.
//  
// Возвращаемое значение:
//  ФиксированныйМассив, ДвоичныеДанные - 
//
Функция ПодготовитьДанныеКэшаВерсий(Знач ТипДанных, Знач ПараметрыПолучения) Экспорт
	
	Если ТипДанных = Перечисления.ТипыДанныхКэшаПрограммныхИнтерфейсов.ВерсииИнтерфейса Тогда
		Данные = ПолучитьВерсииИнтерфейсаВКэш(ПараметрыПолучения[0], ПараметрыПолучения[1]);
	ИначеЕсли ТипДанных = Перечисления.ТипыДанныхКэшаПрограммныхИнтерфейсов.ОписаниеWebСервиса Тогда
		Данные = ПолучитьWSDL(ПараметрыПолучения[0], ПараметрыПолучения[1], ПараметрыПолучения[2], ПараметрыПолучения[3], ПараметрыПолучения[4]);
	Иначе
		ШаблонТекста = НСтр("ru = 'Неизвестный тип данных кэша версий: %1'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонТекста, ТипДанных);
		ВызватьИсключение(ТекстСообщения);
	КонецЕсли;
	
	Возврат Данные;
	
КонецФункции

// Формирует идентификатор записи кэша версий из адреса сервера и имени ресурса.
//
// Параметры:
//  Адрес - Строка - адрес сервера.
//  Имя   - Строка - имя ресурса.
//
// Возвращаемое значение:
//  Строка - идентификатор записи кэша версий.
//
Функция ИдентификаторЗаписиКэшаВерсий(Знач Адрес, Знач Имя) Экспорт
	
	Возврат Адрес + "|" + Имя;
	
КонецФункции

Функция ВнутренняяWSПрокси(Параметры) Экспорт
	
	АдресWSDL = Параметры.АдресWSDL;
	URIПространстваИмен = Параметры.URIПространстваИмен;
	ИмяСервиса = Параметры.ИмяСервиса;
	ИмяТочкиПодключения = Параметры.ИмяТочкиПодключения;
	ИмяПользователя = Параметры.ИмяПользователя;
	Пароль = Параметры.Пароль;
	Таймаут = Параметры.Таймаут;
	Местоположение = Параметры.Местоположение;
	ИспользоватьАутентификациюОС = Параметры.ИспользоватьАутентификациюОС;
	ЗащищенноеСоединение = Параметры.ЗащищенноеСоединение;
	
	Протокол = "";
	Позиция = СтрНайти(АдресWSDL, "://");
	Если Позиция > 0 Тогда
		Протокол = НРег(Лев(АдресWSDL, Позиция - 1));
	КонецЕсли;
		
	Если (Протокол = "https" Или Протокол = "ftps") И ЗащищенноеСоединение = Неопределено Тогда
		ЗащищенноеСоединение = ОбщегоНазначенияКлиентСервер.НовоеЗащищенноеСоединение();
	КонецЕсли;
	
	WSОпределения = WSОпределения(АдресWSDL, ИмяПользователя, Пароль,, ЗащищенноеСоединение);
	
	Если ПустаяСтрока(ИмяТочкиПодключения) Тогда
		ИмяТочкиПодключения = ИмяСервиса + "Soap";
	КонецЕсли;
	
	ИнтернетПрокси = Неопределено;
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПолучениеФайловИзИнтернета") Тогда
		МодульПолучениеФайловИзИнтернета = ОбщегоНазначения.ОбщийМодуль("ПолучениеФайловИзИнтернета");
		ИнтернетПрокси = МодульПолучениеФайловИзИнтернета.ПолучитьПрокси(АдресWSDL);
	КонецЕсли;
	
	Прокси = Новый WSПрокси(WSОпределения, URIПространстваИмен, ИмяСервиса, ИмяТочкиПодключения,
		ИнтернетПрокси, Таймаут, ЗащищенноеСоединение, Местоположение, ИспользоватьАутентификациюОС);
	
	Прокси.Пользователь = ИмяПользователя;
	Прокси.Пароль       = Пароль;
	
	Возврат Прокси;
КонецФункции

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Функция КэшПрограммногоИнтерфейсаАктуален(ДатаОбновления)
	
	Если ЗначениеЗаполнено(ДатаОбновления) Тогда
		Возврат ДатаОбновления + 24 * 60 * 60 > ТекущаяУниверсальнаяДата(); // кешируем не более чем на 24 часа
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

Функция WSОпределения(Знач АдресWSDL, Знач ИмяПользователя, Знач Пароль, Знач Таймаут = 10, Знач ЗащищенноеСоединение = Неопределено)
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПолучениеФайловИзИнтернета") Тогда
		Попытка
			ИнтернетПрокси = Неопределено; // По умолчанию.
			Определения = Новый WSОпределения(АдресWSDL, ИмяПользователя, Пароль, ИнтернетПрокси, Таймаут, ЗащищенноеСоединение);
		Исключение
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось получить WS-определения по адресу 
				           |%1
				           |по причине:
				           |%2'"),
				АдресWSDL,
				КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПолучениеФайловИзИнтернета") Тогда
				МодульПолучениеФайловИзИнтернета = ОбщегоНазначения.ОбщийМодуль("ПолучениеФайловИзИнтернета");
				РезультатДиагностики = МодульПолучениеФайловИзИнтернета.ДиагностикаСоединения(АдресWSDL);
				
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = '%1
					           |Результат диагностики:
					           |%2'"),
					РезультатДиагностики.ОписаниеОшибки);
			КонецЕсли;
			
			ВызватьИсключение ТекстОшибки;
		КонецПопытки;
		Возврат Определения;
	КонецЕсли;
	
	ПараметрыПолучения = Новый Массив;
	ПараметрыПолучения.Добавить(АдресWSDL);
	ПараметрыПолучения.Добавить(ИмяПользователя);
	ПараметрыПолучения.Добавить(Пароль);
	ПараметрыПолучения.Добавить(Таймаут);
	ПараметрыПолучения.Добавить(ЗащищенноеСоединение);

	ДанныеWSDL = ДанныеКэшаВерсий(
		АдресWSDL, 
		Перечисления.ТипыДанныхКэшаПрограммныхИнтерфейсов.ОписаниеWebСервиса, 
		ПараметрыПолучения,
		Ложь);
		
	ИмяФайлаWSDL = ПолучитьИмяВременногоФайла("wsdl");
	ДанныеWSDL.Записать(ИмяФайлаWSDL);
	
	ИнтернетПрокси = Неопределено;
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПолучениеФайловИзИнтернета") Тогда
		МодульПолучениеФайловИзИнтернета = ОбщегоНазначения.ОбщийМодуль("ПолучениеФайловИзИнтернета");
		ИнтернетПрокси = МодульПолучениеФайловИзИнтернета.ПолучитьПрокси(АдресWSDL);
	КонецЕсли;
	
	Попытка
		Определения = Новый WSОпределения(ИмяФайлаWSDL, ИмяПользователя, Пароль, ИнтернетПрокси, Таймаут, ЗащищенноеСоединение);
	Исключение
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось получить WS-определения из кэша 
			           |по причине:
			           |%1'"),
			КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение ТекстОшибки;
	КонецПопытки;
	
	Попытка
		УдалитьФайлы(ИмяФайлаWSDL);
	Исключение
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Получение WSDL'", ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
	Возврат Определения;
КонецФункции

// Возвращаемое значение:
//  ФиксированныйМассив - 
//
Функция ПолучитьВерсииИнтерфейсаВКэш(Знач ПараметрыПодключения, Знач ИмяИнтерфейса)
	
	Если Не ПараметрыПодключения.Свойство("URL") 
		Или Не ЗначениеЗаполнено(ПараметрыПодключения.URL) Тогда
		
		ВызватьИсключение(НСтр("ru = 'Не задан URL сервиса.'"));
	КонецЕсли;
	
	Если ПараметрыПодключения.Свойство("UserName")
		И ЗначениеЗаполнено(ПараметрыПодключения.UserName) Тогда
		
		ИмяПользователя = ПараметрыПодключения.UserName;
		
		Если ПараметрыПодключения.Свойство("Password") Тогда
			ПарольПользователя = ПараметрыПодключения.Password;
		Иначе
			ПарольПользователя = Неопределено;
		КонецЕсли;
		
	Иначе
		ИмяПользователя = Неопределено;
		ПарольПользователя = Неопределено;
	КонецЕсли;
	
	АдресСервиса = ПараметрыПодключения.URL + "/ws/InterfaceVersion?wsdl";
	
	
	ПараметрыПодключения = Новый Структура;
	ПараметрыПодключения.Вставить("АдресWSDL", АдресСервиса);
	ПараметрыПодключения.Вставить("URIПространстваИмен", "http://www.1c.ru/SaaS/1.0/WS");
	ПараметрыПодключения.Вставить("ИмяСервиса", "InterfaceVersion");
	ПараметрыПодключения.Вставить("ИмяПользователя", ИмяПользователя);
	ПараметрыПодключения.Вставить("Пароль", ПарольПользователя);
	ПараметрыПодключения.Вставить("Таймаут", 7);
	
	ПроксиВерсионирования = ОбщегоНазначения.СоздатьWSПрокси(ПараметрыПодключения);
	
	МассивXDTO = ПроксиВерсионирования.GetVersions(ИмяИнтерфейса);
	Если МассивXDTO = Неопределено Тогда
		Возврат Новый ФиксированныйМассив(Новый Массив);
	Иначе	
		Сериализатор = Новый СериализаторXDTO(ПроксиВерсионирования.ФабрикаXDTO);
		Возврат Новый ФиксированныйМассив(Сериализатор.ПрочитатьXDTO(МассивXDTO));
	КонецЕсли;
	
КонецФункции

Функция ПолучитьWSDL(Знач Адрес, Знач ИмяПользователя, Знач Пароль, Знач Таймаут, Знач ЗащищенноеСоединение = Неопределено)
	
	ПараметрыПолучения = Новый Структура;
	Если НЕ ПустаяСтрока(ИмяПользователя) Тогда
		ПараметрыПолучения.Вставить("Пользователь", ИмяПользователя);
		ПараметрыПолучения.Вставить("Пароль", Пароль);
	КонецЕсли;
	ПараметрыПолучения.Вставить("Таймаут", Таймаут);
	ПараметрыПолучения.Вставить("ЗащищенноеСоединение", ЗащищенноеСоединение);
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПолучениеФайловИзИнтернета") Тогда
		МодульПолучениеФайловИзИнтернета = ОбщегоНазначения.ОбщийМодуль("ПолучениеФайловИзИнтернета");
		ОписаниеФайла = МодульПолучениеФайловИзИнтернета.СкачатьФайлНаСервере(Адрес, ПараметрыПолучения);
	Иначе
		ВызватьИсключение 
			НСтр("ru = 'Подсистема ""Получение файлов из интернета"" не доступна.'");
	КонецЕсли;
	
	Если Не ОписаниеФайла.Статус Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось получить файл описания web-сервиса %1 по причине:
				|%2'"),
			Адрес, ОписаниеФайла.СообщениеОбОшибке);
	КонецЕсли;
	
	ИнтернетПрокси = МодульПолучениеФайловИзИнтернета.ПолучитьПрокси(Адрес);
	Попытка
		Определения = Новый WSОпределения(ОписаниеФайла.Путь, ИмяПользователя, Пароль, ИнтернетПрокси, Таймаут, ЗащищенноеСоединение);
	Исключение
		РезультатДиагностики = МодульПолучениеФайловИзИнтернета.ДиагностикаСоединения(Адрес);
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось получить файл описания web-сервиса %1 по причине:
				|%2
				|
				|Результат диагностики:
			    |%3'"),
			Адрес,
			КраткоеПредставлениеОшибки(ИнформацияОбОшибке()),
			РезультатДиагностики.ОписаниеОшибки);
			
		СообщениеОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1
			           |
			           |Трассировка:
			           |ЗащищенноеСоединение: %2
			           |Таймаут: %3'"),
			ТекстОшибки,
			Формат(ЗащищенноеСоединение, НСтр("ru = 'БЛ=Нет; БИ=Да'")),
			Формат(Таймаут, "ЧГ=0"));
			
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Получение WSDL'", ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка, , , СообщениеОбОшибке);
		ВызватьИсключение ТекстОшибки;
	КонецПопытки;
	
	Если Определения.Сервисы.Количество() = 0 Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось получить файл описания web-сервиса по причине:
			           |В полученном файле не содержится ни одного описания сервиса.
			           |Возможно, адрес файла описания указан неверно:
			           |%1'"),
			Адрес);
	КонецЕсли;
	Определения = Неопределено;
	
	ДанныеФайла = Новый ДвоичныеДанные(ОписаниеФайла.Путь);
	
	Попытка
		УдалитьФайлы(ОписаниеФайла.Путь);
	Исключение
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Получение WSDL'", ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
	Возврат ДанныеФайла;
	
КонецФункции

#КонецОбласти

#КонецЕсли