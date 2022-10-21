&НаСервере
Функция ПровестиДокумент(ПараметрКоманды)
	
	ДокументОбъект = ПараметрКоманды.ПолучитьОбъект();
	Попытка
		Если НЕ ДокументОбъект.ПроверитьЗаполнение() Тогда 
			Возврат Ложь;
		КонецЕсли;
		
		ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
		
		Возврат Истина;
	Исключение
		Возврат Ложь;
	КонецПопытки;

КонецФункции

&НаСервере
Функция ПолучитьПараметрыДокумента(Ссылка)
	
	МетаданныеДокумента	= Ссылка.Метаданные();
	
	ЕстьРучнаяКорректировка	= ОбщегоНазначенияБК.ЕстьРеквизитДокумента("РучнаяКорректировка", МетаданныеДокумента);
	
	ИменаРеквизитов	= "Проведен, ПометкаУдаления";
	Если ЕстьРучнаяКорректировка Тогда
		ИменаРеквизитов	= ИменаРеквизитов + ", РучнаяКорректировка";
	КонецЕсли;
	
	Результат	= ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, ИменаРеквизитов);
	Если НЕ ЕстьРучнаяКорректировка Тогда
		Результат.Вставить("РучнаяКорректировка", Ложь);
	КонецЕсли;
	
	Результат.Вставить("ОперацияБух",	ТипЗнч(Ссылка) = Тип("ДокументСсылка.ОперацияБух"));
	Результат.Вставить("Сторнирование",	ТипЗнч(Ссылка) = Тип("ДокументСсылка.Сторнирование"));
	Результат.Вставить("ЧекККМ",	    ТипЗнч(Ссылка) = Тип("ДокументСсылка.ЧекККМ"));

	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ОткрытьФормуКорректировкаДвижений(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура("ДокументСсылка", ПараметрКоманды);
	ОткрытьФорму("Обработка.КорректировкаДвижений.Форма", 
					ПараметрыФормы, 
					ПараметрыВыполненияКоманды.Источник, 
					ПараметрКоманды);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыДокумента = ПолучитьПараметрыДокумента(ПараметрКоманды);
	ПараметрыДокумента.Вставить("ПараметрКоманды", ПараметрКоманды);
	ПараметрыДокумента.Вставить("ПараметрыВыполненияКоманды", ПараметрыВыполненияКоманды);
	
	Если НЕ ПараметрыДокумента.ПометкаУдаления
		И НЕ ПараметрыДокумента.ОперацияБух 
		И НЕ ПараметрыДокумента.Сторнирование
		И НЕ ПараметрыДокумента.ЧекККМ
		И НЕ ПараметрыДокумента.РучнаяКорректировка
		И НЕ ПараметрыДокумента.Проведен Тогда
		
		Кнопки = Новый СписокЗначений;
		Кнопки.Вставить(0, КодВозвратаДиалога.Да, "Провести");
		Кнопки.Вставить(1, КодВозвратаДиалога.Нет, "Отмена");
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияЗапроса", ЭтотОбъект, ПараметрыДокумента);
		ПоказатьВопрос(Оповещение, НСтр("ru = 'Перед просмотром проводок документ следует провести'"), Кнопки, ,КодВозвратаДиалога.Да);
	Иначе
		ОткрытьФормуКорректировкаДвижений(ПараметрКоманды, ПараметрыВыполненияКоманды)
	КонецЕсли;
	
 КонецПроцедуры
 
&НаКлиенте
Процедура ПослеЗакрытияЗапроса(Результат, Параметры) Экспорт 
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ДокументПроведен = ПровестиДокумент(Параметры.ПараметрКоманды);
		Если ДокументПроведен Тогда
			ОповеститьОбИзменении(Параметры.ПараметрКоманды);
			Оповестить("ВыполненаЗаписьДокумента",Новый Структура("ДокументСсылка", Параметры.ПараметрКоманды));
		Иначе
			Сообщить(НСтр("ru = 'Не удалось провести документ'"), СтатусСообщения.Важное);
			Возврат;
		КонецЕсли;
		
		ОткрытьФормуКорректировкаДвижений(Параметры.ПараметрКоманды, Параметры.ПараметрыВыполненияКоманды)

	КонецЕсли;

КонецПроцедуры
