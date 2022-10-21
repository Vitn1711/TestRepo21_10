#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
		
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
		
	Если ДанныеЗаполнения <> Неопределено И ТипДанныхЗаполнения <> Тип("Структура") 
		И Метаданные().ВводитсяНаОсновании.Содержит(ДанныеЗаполнения.Метаданные()) Тогда
		Документы.ОплатаОтПокупателяПлатежнойКартой.ЗаполнитьПоДокументуОснования(ЭтотОбъект, ДанныеЗаполнения);
		УправлениеДенежнымиСредствамиСервер.ЗаполнитьРеквизитыРасчетногоДокумента(ЭтотОбъект, РасшифровкаПлатежа);
		Возврат;
	ИначеЕсли ТипДанныхЗаполнения = Тип("Структура") Тогда 
		Если ДанныеЗаполнения.Свойство("Автор") Тогда
			ДанныеЗаполнения.Удалить("Автор");
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;
	
	УправлениеДенежнымиСредствамиСервер.ЗаполнитьРеквизитыРасчетногоДокумента(ЭтотОбъект, РасшифровкаПлатежа);

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	ОрганизацияПлательщикНалогаНаПрибыль 			= ПроцедурыНалоговогоУчета.ПолучитьПризнакПлательщикаНалогаНаПрибыль(Организация, Дата);
	ПоддержкаУчетаВременныхРазницПоНалогуНаПрибыль 	= ОрганизацияПлательщикНалогаНаПрибыль И ПроцедурыНалоговогоУчета.ПоддержкаУчетаВременныхРазницПоНалогуНаПрибыль(Организация, Дата);
	
	НеобходимостьОтраженияВНУ 						= ОрганизацияПлательщикНалогаНаПрибыль И УчитыватьКПН И (ПоддержкаУчетаВременныхРазницПоНалогуНаПрибыль ИЛИ ВидУчетаНУ = Справочники.ВидыУчетаНУ.НУ);
    ВестиУчетПоДоговорам                            = ПолучитьФункциональнуюОпцию("ВестиУчетПоДоговорам");
    
	МассивНепроверяемыхРеквизитов = Новый Массив();

	Если ЭтотОбъект.РасшифровкаПлатежа.Количество() > 0 Тогда 
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаПлатежа");
	КонецЕсли;
	
	// Проверка заполнения табличной части "Товары"
	Если НЕ НеобходимостьОтраженияВНУ Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("ВидУчетаНУ");
		
	КонецЕсли;
    
    Если НЕ ВестиУчетПоДоговорам Тогда
        МассивНепроверяемыхРеквизитов.Добавить("ДоговорВзаиморасчетовЭквайрера");    
        МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаПлатежа.ДоговорКонтрагента");    
    КонецЕсли;
    
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);

	Если НЕ РасшифровкаПлатежа.Итог("СуммаПлатежа") = СуммаДокумента Тогда
		
		ТекстСообщения = ОбщегоНазначенияБККлиентСервер.ПолучитьТекстСообщения("Поле", "Корректность", НСтр("ru = 'Сумма документа'"),
			НСтр("ru = 'не совпадают сумма документа и ее расшифровка"));
			
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "СуммаДокумента", "Объект", Отказ);

	КонецЕсли;
	
	Если ЗначениеЗаполнено(СчетУчетаРасчетовСЭквайрером) Тогда
		
		Если НЕ ПроцедурыБухгалтерскогоУчетаВызовСервераПовтИсп.НаСчетеВедетсяУчетПоКонтрагентам(СчетУчетаРасчетовСЭквайрером) Тогда
			ТекстСообщения = ОбщегоНазначенияБККлиентСервер.ПолучитьТекстСообщения("Поле", "Корректность", НСтр("ru = 'Счет учета расчетов с эквайрером'"),
				,,НСтр("ru = 'На выбранном cчете учета расчетов с контрагентом отсутствует аналитика по контрагентам'"));
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "СчетУчетаРасчетовСЭквайрером", "Объект", Отказ);
		КонецЕсли;
		
		Если НЕ ПроцедурыБухгалтерскогоУчетаВызовСервераПовтИсп.НаСчетеВедетсяУчетПоДоговорам(СчетУчетаРасчетовСЭквайрером) Тогда
			ТекстСообщения = ОбщегоНазначенияБККлиентСервер.ПолучитьТекстСообщения("Поле", "Корректность", НСтр("ru = 'Счет учета расчетов с эквайрером'"),
				,,НСтр("ru = 'На выбранном cчете учета расчетов с контрагентом отсутствует аналитика по договорам'"));
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "СчетУчетаРасчетовСЭквайрером", "Объект", Отказ);
		КонецЕсли;
		
	КонецЕсли;

	ПроверитьЗаполнениеТабличнойЧастиПострочно(Отказ, );
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
    
    Если РасшифровкаПлатежа.Количество() > 0 Тогда
		РаботаСДоговорамиКонтрагентов.ЗаполнитьДоговорВТабличнойЧастиПередЗаписью(РасшифровкаПлатежа, ЭтотОбъект);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ЭтотОбъект.ДоговорВзаиморасчетовЭквайрера) Тогда
		ДоговорВзаиморасчетовЭквайрера = РаботаСДоговорамиКонтрагентов.ДоговорКонтрагентаИзОбъекта(ЭтотОбъект, "Эквайрер");
	Конецесли;

	Если НЕ УчитыватьКПН Тогда
		ВидУчетаНУ = Справочники.ВидыУчетаНУ.ПустаяСсылка();
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	НомерЧекаККМ      = 0;
	
	УправлениеДенежнымиСредствамиСервер.ЗаполнитьРеквизитыРасчетногоДокумента(ЭтотОбъект, РасшифровкаПлатежа);
	
	НомерПлатежнойКарты = "";
	СсылочныйНомер = "";
	НомерЧекаЭТ = "";
	ДанныеПереданыВБанк = Ложь;

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;

	ПараметрыПроведения = Документы.ОплатаОтПокупателяПлатежнойКартой.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;

	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ИНФОРМАЦИОННОЙ БАЗЫ	
	ТаблицаВзаиморасчеты = УправлениеВзаиморасчетамиСервер.ПодготовитьТаблицуВзаиморасчетовПогашениеЗадолженности(
		ПараметрыПроведения.РасшифровкаПлатежа, ПараметрыПроведения.Реквизиты, Отказ);
	
	// ФОРМИРОВАНИЕ ДВИЖЕНИЙ
	
	УправлениеВзаиморасчетамиСервер.СформироватьДвиженияПогашениеЗадолженности(ТаблицаВзаиморасчеты, 
		ПараметрыПроведения.Реквизиты, Движения, Отказ);

	// Переоценка валютных остатков - после формирования проводок всеми другими механизмами
	ТаблицаПереоценка = УчетДоходовРасходов.ПодготовитьТаблицуПереоценкаВалютныхОстатковПоПроводкамДокумента(
		ПараметрыПроведения.Реквизиты, Движения, Отказ);

	УчетДоходовРасходов.СформироватьДвиженияПереоценкаВалютныхОстатков(ТаблицаПереоценка,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура ПроверитьЗаполнениеТабличнойЧастиПострочно(Отказ, ПараметрыПроверки = Неопределено)
	
	Реквизиты = Новый Структура;
	Реквизиты.Вставить("ВалютаДокумента", ВалютаДокумента);
	Реквизиты.Вставить("ВалютаРегламентированногоУчета", ОбщегоНазначенияБКВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета());
	Реквизиты.Вставить("Регистратор", Ссылка);

	Для Каждого СтрокаТабличнойЧасти Из РасшифровкаПлатежа Цикл
		
		Если НЕ ПроцедурыБухгалтерскогоУчетаВызовСервераПовтИсп.НаСчетеВедетсяУчетПоКонтрагентам(СтрокаТабличнойЧасти.СчетУчетаРасчетовСКонтрагентомБУ) Тогда
			ТекстСообщения = ОбщегоНазначенияБККлиентСервер.ПолучитьТекстСообщения("Колонка", "Корректность", НСтр("ru = 'Счет учета расчетов с контрагентом'"),
				СтрокаТабличнойЧасти.НомерСтроки, "РасшифровкаПлатежа", НСтр("ru = 'На выбранном cчете учета расчетов с контрагентом отсутствует аналитика по контрагентам'"));
			Поле = "РасшифровкаПлатежа[" + Формат(СтрокаТабличнойЧасти.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].СчетУчетаРасчетовСКонтрагентомБУ";
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
		КонецЕсли;
		
		Если НЕ ПроцедурыБухгалтерскогоУчетаВызовСервераПовтИсп.НаСчетеВедетсяУчетПоДоговорам(СтрокаТабличнойЧасти.СчетУчетаРасчетовСКонтрагентомБУ) Тогда
			ТекстСообщения = ОбщегоНазначенияБККлиентСервер.ПолучитьТекстСообщения("Колонка", "Корректность", НСтр("ru = 'Счет учета расчетов с контрагентом'"),
				СтрокаТабличнойЧасти.НомерСтроки, "РасшифровкаПлатежа", НСтр("ru = 'На выбранном cчете учета расчетов с контрагентом отсутствует аналитика по договорам'"));
			Поле = "РасшифровкаПлатежа[" + Формат(СтрокаТабличнойЧасти.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].СчетУчетаРасчетовСКонтрагентомБУ";
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СтрокаТабличнойЧасти.СчетУчетаРасчетовПоАвансам) Тогда
			
			Если НЕ ПроцедурыБухгалтерскогоУчетаВызовСервераПовтИсп.НаСчетеВедетсяУчетПоКонтрагентам(СтрокаТабличнойЧасти.СчетУчетаРасчетовПоАвансам) Тогда
				ТекстСообщения = ОбщегоНазначенияБККлиентСервер.ПолучитьТекстСообщения("Колонка", "Корректность", НСтр("ru = 'Счет учета расчетов с контрагентом'"),
					СтрокаТабличнойЧасти.НомерСтроки, "РасшифровкаПлатежа", НСтр("ru = 'На выбранном cчете учета расчетов с контрагентом отсутствует аналитика по контрагентам'"));
				Поле = "РасшифровкаПлатежа[" + Формат(СтрокаТабличнойЧасти.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].СчетУчетаРасчетовСКонтрагентомБУ";
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
			КонецЕсли;
			
			Если НЕ ПроцедурыБухгалтерскогоУчетаВызовСервераПовтИсп.НаСчетеВедетсяУчетПоДоговорам(СтрокаТабличнойЧасти.СчетУчетаРасчетовПоАвансам) Тогда
				ТекстСообщения = ОбщегоНазначенияБККлиентСервер.ПолучитьТекстСообщения("Колонка", "Корректность", НСтр("ru = 'Счет учета расчетов с контрагентом'"),
					СтрокаТабличнойЧасти.НомерСтроки, "РасшифровкаПлатежа", НСтр("ru = 'На выбранном cчете учета расчетов с контрагентом отсутствует аналитика по договорам'"));
				Поле = "РасшифровкаПлатежа[" + Формат(СтрокаТабличнойЧасти.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].СчетУчетаРасчетовСКонтрагентомБУ";
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
			КонецЕсли;
			
		КонецЕсли;
			
		Реквизиты.Вставить("ДоговорКонтрагента", СтрокаТабличнойЧасти.ДоговорКонтрагента); 
		Реквизиты.Вставить("ВалютаВзаиморасчетов", СтрокаТабличнойЧасти.ДоговорКонтрагента.ВалютаВзаиморасчетов);
		
		ДополнениеКСообщению = НСтр("ru = 'Строка %1 - '");
		ДополнениеКСообщению = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ДополнениеКСообщению, СтрокаТабличнойЧасти.НомерСтроки);

		УправлениеВзаиморасчетамиСервер.ВозможноПроведениеВ_БУ_НУ(Реквизиты, Отказ, ДополнениеКСообщению);

	КонецЦикла;
	
КонецПроцедуры

#КонецЕсли

