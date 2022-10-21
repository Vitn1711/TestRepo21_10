///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Проверка наличия активных соединений с информационной базой.
//
// Возвращаемое значение:
//  Булево       - Истина, если соединения есть,
//                 Ложь, если соединений нет.
Функция НаличиеАктивныхСоединений(СообщенияДляЖурналаРегистрации = Неопределено) Экспорт
	
	ВыполнитьПроверкуПравДоступа("Администрирование", Метаданные);
	ЖурналРегистрации.ЗаписатьСобытияВЖурналРегистрации(СообщенияДляЖурналаРегистрации);
	Возврат СоединенияИБ.КоличествоСеансовИнформационнойБазы(Ложь, Ложь) > 1;
КонецФункции

Процедура ЗаписатьСтатусОбновления(ИмяАдминистратораОбновления, ОбновлениеЗапланировано, ОбновлениеВыполнено,
	РезультатОбновления, ИмяФайлаСкрипта = "", СообщенияДляЖурналаРегистрации = Неопределено) Экспорт
	
	ВыполнитьПроверкуПравДоступа("Администрирование", Метаданные);
	
	КаталогСкрипта = "";
	
	Если Не ПустаяСтрока(ИмяФайлаСкрипта) Тогда 
		КаталогСкрипта = Лев(ИмяФайлаСкрипта, СтрДлина(ИмяФайлаСкрипта) - 10);
	КонецЕсли;
	
	ОбновлениеКонфигурации.ЗаписатьСтатусОбновления(
		ИмяАдминистратораОбновления,
		ОбновлениеЗапланировано,
		ОбновлениеВыполнено,
		РезультатОбновления,
		КаталогСкрипта,
		СообщенияДляЖурналаРегистрации);
	
КонецПроцедуры

Функция ТекстыМакетов(СообщенияДляЖурналаРегистрации, ИнтерактивныйРежим, ВыполнитьОтложенныеОбработчики, ЭтоОтложенноеОбновление) Экспорт
	
	ВыполнитьПроверкуПравДоступа("Администрирование", Метаданные);
	
	ТекстыМакетов = Новый Структура;
	ТекстыМакетов.Вставить("ДопФайлОбновленияКонфигурации");
	ТекстыМакетов.Вставить(?(ИнтерактивныйРежим, "ЗаставкаОбновленияКонфигурации", "НеинтерактивноеОбновлениеКонфигурации"));
	
	Если ЭтоОтложенноеОбновление Тогда
		ТекстыМакетов.Вставить("СкриптСозданияЗадачиПланировщикаЗадач");
	КонецЕсли;
	
	ТекстыМакетов.Вставить("СкриптУдаленияПатчей");
	
	Для Каждого СвойстваМакета Из ТекстыМакетов Цикл
		ТекстыМакетов[СвойстваМакета.Ключ] = Обработки.УстановкаОбновлений.ПолучитьМакет(СвойстваМакета.Ключ).ПолучитьТекст();
	КонецЦикла;
	
	Если ИнтерактивныйРежим Тогда
		ТекстыМакетов.ЗаставкаОбновленияКонфигурации = СформироватьТекстЗаставки(ТекстыМакетов.ЗаставкаОбновленияКонфигурации); 
	КонецЕсли;
	
	// Файл обновления конфигурации: main.js.
	ШаблонСкрипта = Обработки.УстановкаОбновлений.ПолучитьМакет("МакетФайлаОбновленияКонфигурации");
	
	ОбластьПараметров = ШаблонСкрипта.ПолучитьОбласть("ОбластьПараметров");
	ОбластьПараметров.УдалитьСтроку(1);
	ОбластьПараметров.УдалитьСтроку(ОбластьПараметров.КоличествоСтрок());
	ТекстыМакетов.Вставить("ОбластьПараметров", ОбластьПараметров.ПолучитьТекст());
	
	ОбластьОбновленияКонфигурации = ШаблонСкрипта.ПолучитьОбласть("ОбластьОбновленияКонфигурации");
	ОбластьОбновленияКонфигурации.УдалитьСтроку(1);
	ОбластьОбновленияКонфигурации.УдалитьСтроку(ОбластьОбновленияКонфигурации.КоличествоСтрок());
	ТекстыМакетов.Вставить("МакетФайлаОбновленияКонфигурации", ОбластьОбновленияКонфигурации.ПолучитьТекст());
	
	// Запись накопленных событий ЖР.
	ЖурналРегистрации.ЗаписатьСобытияВЖурналРегистрации(СообщенияДляЖурналаРегистрации);
	ВыполнитьОтложенныеОбработчики = ОбновлениеКонфигурации.ВыполнитьОтложенныеОбработчики();
	
	Возврат ТекстыМакетов;
	
КонецФункции

Функция СформироватьТекстЗаставки(Знач ШаблонТекста)
	
	ПараметрыТекста = Новый Соответствие;
	ПараметрыТекста["[ЗаголовокЗаставки]"] = НСтр("ru = 'Обновление конфигурации ""1С:Предприятие""...'");
	ПараметрыТекста["[ТекстЗаставки]"] = НСтр("ru = 'Пожалуйста, подождите.
    	|<br/> Выполняется обновление конфигурации.'");
	ПараметрыТекста["[Шаг1Инициализация]"] = НСтр("ru = 'Инициализация'");
	ПараметрыТекста["[Шаг2ЗавершениеРаботы]"] = НСтр("ru = 'Завершение работы пользователей'");
	ПараметрыТекста["[Шаг3СозданиеРезервнойКопии]"] = НСтр("ru = 'Создание резервной копии информационной базы'");
	ПараметрыТекста["[Шаг4ОбновлениеКонфигурации]"] = НСтр("ru = 'Обновление конфигурации информационной базы'");
	ПараметрыТекста["[Шаг5ОбновлениеИБ]"] = НСтр("ru = 'Выполнение обработчиков обновления'");
	ПараметрыТекста["[Шаг6ОтложенноеОбновление]"] = НСтр("ru = 'Выполнение отложенных обработчиков обновления'");
	ПараметрыТекста["[Шаг7СжатиеТаблиц]"] = НСтр("ru = 'Сжатие таблиц информационной базы'");
	ПараметрыТекста["[Шаг8РазрешениеПодключений]"] = НСтр("ru = 'Разрешение подключения новых соединений'");
	ПараметрыТекста["[Шаг9Завершение]"] = НСтр("ru = 'Завершение'");
	ПараметрыТекста["[Шаг10Восстановление]"] = НСтр("ru = 'Восстановление информационной базы'");
	
	ПараметрыТекста["[Шаг41Загрузка]"] = НСтр("ru = 'Загрузка файла обновления в основную базу'");
	ПараметрыТекста["[Шаг42ОбновлениеКонфигурации]"] = НСтр("ru = 'Обновление конфигурации информационной базы'");
	ПараметрыТекста["[Шаг43ОбновлениеИБ]"] = НСтр("ru = 'Выполнение обработчиков обновления'");
	
	ПараметрыТекста["[ПроцессПрерван]"] = НСтр("ru = 'Внимание: процесс обновления был прерван, и информационная база осталась заблокированной.'");
	ПараметрыТекста["[ПроцессПрерванПодсказка]"] = НСтр("ru = 'Для разблокирования информационной базы воспользуйтесь консолью кластера серверов или запустите ""1С:Предприятие"".'");
	
	Возврат ПодставитьПараметрыВТекст(ШаблонТекста, ПараметрыТекста);;
	
КонецФункции

Функция ПодставитьПараметрыВТекст(Знач Текст, Знач ПараметрыТекста)
	
	Результат = Текст;
	Для каждого ПараметрТекста Из ПараметрыТекста Цикл
		Результат = СтрЗаменить(Результат, ПараметрТекста.Ключ, ПараметрТекста.Значение);
	КонецЦикла;
	Возврат Результат; 
	
КонецФункции

Процедура СохранитьНастройкиОбновленияКонфигурации(Настройки) Экспорт
	ВыполнитьПроверкуПравДоступа("Администрирование", Метаданные);
	ОбновлениеКонфигурации.СохранитьНастройкиОбновленияКонфигурации(Настройки);
КонецПроцедуры

Процедура ОбновитьИсправленияИзСкрипта(НовыеИсправления, УдаляемыеИсправления) Экспорт
	ОбновлениеКонфигурации.ОбновитьИсправленияИзСкрипта(НовыеИсправления, УдаляемыеИсправления);
КонецПроцедуры

#КонецОбласти
