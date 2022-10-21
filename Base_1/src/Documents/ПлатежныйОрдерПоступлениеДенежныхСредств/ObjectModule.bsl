#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

#Область УправлениеДоступом

// Процедура ЗаполнитьНаборыЗначенийДоступа по свойствам объекта заполняет наборы значений доступа
// в таблице с полями:
//    НомерНабора     - Число                                     (необязательно, если набор один),
//    ВидДоступа      - ПланВидовХарактеристикСсылка.ВидыДоступа, (обязательно),
//    ЗначениеДоступа - Неопределено, СправочникСсылка или др.    (обязательно),
//    Чтение          - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Добавление      - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Изменение       - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Удаление        - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//
//  Вызывается из процедуры УправлениеДоступомСлужебный.ЗаписатьНаборыЗначенийДоступа(),
// если объект зарегистрирован в "ПодпискаНаСобытие.ЗаписатьНаборыЗначенийДоступа" и
// из таких же процедур объектов, у которых наборы значений доступа зависят от наборов этого
// объекта (в этом случае объект зарегистрирован в "ПодпискаНаСобытие.ЗаписатьЗависимыеНаборыЗначенийДоступа").
//
// Параметры:
//  Таблица      - ТабличнаяЧасть,
//                 РегистрСведенийНаборЗаписей.НаборыЗначенийДоступа,
//                 ТаблицаЗначений, возвращаемая УправлениеДоступом.ТаблицаНаборыЗначенийДоступа().
//
Процедура ЗаполнитьНаборыЗначенийДоступа(Таблица) Экспорт
	
	ОбщегоНазначенияБК.ЗаполнитьНаборыПоОрганизацииСтурктурномуПодразделению(ЭтотОбъект, Таблица, "Организация", "СтруктурноеПодразделениеПолучатель");
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	МассивНепроверяемыхРеквизитов = Новый Массив;
	ПараметрыПострочнойПроверки   = Новый Структура("ПроверятьЗаполнениеСчетаУчетаРасчетовСКонтрагентомБУ, 
													|ПроверятьЗаполнениеСчетаУчетаРасчетовСКонтрагентомНУ,
													|ПроверятьЗаполнениеДоговораКонтрагента",
													Ложь, Ложь, Ложь);
													
	ЕстьРасчетыПоКредитам = (ВидОперации = Перечисления.ВидыОперацийПоступлениеБезналичныхДенежныхСредств.РасчетыПоКредитамИЗаймам);
	ЕстьРасшифровкаПлатежа = Документы.ПлатежныйОрдерПоступлениеДенежныхСредств.ЕстьРасшифровкаПлатежа(ВидОперации); 
	ОрганизацияПлательщикНалогаНаПрибыль 			= УчетнаяПолитикаСервер.ПлательщикНалогаНаПрибыль(Организация, Дата);
	ПоддержкаУчетаВременныхРазницПоНалогуНаПрибыль 	= ОрганизацияПлательщикНалогаНаПрибыль И ПроцедурыНалоговогоУчета.ПоддержкаУчетаВременныхРазницПоНалогуНаПрибыль(Организация, Дата);
	НеобходимостьОтраженияВНУ 						= ОрганизацияПлательщикНалогаНаПрибыль И УчитыватьКПН И (ПоддержкаУчетаВременныхРазницПоНалогуНаПрибыль ИЛИ ВидУчетаНУ = Справочники.ВидыУчетаНУ.НУ);
    ВестиУчетПоДоговорам                            = ПолучитьФункциональнуюОпцию("ВестиУчетПоДоговорам");
    
	ВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	
	//Отключаем проверку реквизитов шапки
	Если Не ОрганизацияПлательщикНалогаНаПрибыль ИЛИ Не УчитыватьКПН Тогда	
		МассивНепроверяемыхРеквизитов.Добавить("ВидУчетаНУ");
	КонецЕсли;

	Если ЕстьРасшифровкаПлатежа Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СчетУчетаРасчетовСКонтрагентомБУ");
        МассивНепроверяемыхРеквизитов.Добавить("СчетУчетаРасчетовСКонтрагентомНУ");		
		
		Если (Не ЕстьРасчетыПоКредитам) Или (ЕстьРасчетыПоКредитам И Не НеобходимостьОтраженияВНУ) Тогда
			МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаПлатежа.СчетУчетаРасчетовСКонтрагентомНУ");
		КонецЕсли;	
	Иначе	
		//Контрагент обязателен только для тех ВО, для которых предусмотрена расшифровка
		МассивНепроверяемыхРеквизитов.Добавить("Контрагент");
		
		//т.к. ТЧ "Расшифровка платежа" имеет хотя бы одну строку всегда (независимо от вида операции) - 
		//удалим из массива проверяемых реквизитов обязательные реквизиты ТЧ при ВО, не используемых ТЧ
	    Для Каждого ПроверяемыйРеквизит Из ПроверяемыеРеквизиты Цикл
			Если Найти(ПроверяемыйРеквизит, "РасшифровкаПлатежа.") > 0 Тогда
				МассивНепроверяемыхРеквизитов.Добавить(ПроверяемыйРеквизит);
			КонецЕсли;
		КонецЦикла;	
		
		Если Не НеобходимостьОтраженияВНУ Тогда				
			МассивНепроверяемыхРеквизитов.Добавить("СчетУчетаРасчетовСКонтрагентомНУ");	
		КонецЕсли;
		
	КонецЕсли; 
    
    Если НЕ ВестиУчетПоДоговорам Тогда
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаПлатежа.ДоговорКонтрагента");
	КонецЕсли; 
    
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);

	Если ВидОперации = Перечисления.ВидыОперацийПоступлениеБезналичныхДенежныхСредств.ПоступленияОтПродажиИностраннойВалюты тогда
		Если Не ВалютаДокумента = ВалютаРегламентированногоУчета Тогда 			
			ТекстСообщения = НСтр("ru = 'При отражении операции реализации иностранной валюты валюта документа должна соответствовать валюте регламентированного учета'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект,,, Отказ);			
		КонецЕсли;
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийПоступлениеБезналичныхДенежныхСредств.ПриобретениеИностраннойВалюты Тогда
		Если ВалютаДокумента = ВалютаРегламентированногоУчета Тогда 			
			ТекстСообщения = НСтр("ru = 'При отражении операции приобретения иностранной валюты валюта документа должна отличаться от валюты регламентированного учета'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект,,, Отказ);						
		КонецЕсли;			
	КонецЕсли;

	// Проверим соответствие суммы по документу в целом, и сумм указанных в расшифровке платежа
	Если Документы.ПлатежныйОрдерПоступлениеДенежныхСредств.ЕстьРасшифровкаПлатежа(ВидОперации) Тогда
		Если РасшифровкаПлатежа.Итог("СуммаПлатежа") <> СуммаДокумента Тогда
			ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Не совпадает сумма документа и ее расшифровка'"), ЭтотОбъект, "РасшифровкаПлатежа", "Объект", Отказ);
		КонецЕсли;
	КонецЕсли;		
	
	Если ЕстьРасшифровкаПлатежа Тогда		
		 ПроверитьЗаполнениеТабличнойЧастиПострочно(РасшифровкаПлатежа, "РасшифровкаПлатежа", Отказ, Новый Структура("ВалютаРегламентированногоУчета", ВалютаРегламентированногоУчета));
	КонецЕсли;
	
	СчетаУчетаВДокументах.ПроверитьЗаполнение(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, Новый Соответствие);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
		
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ДанныеЗаполнения <> Неопределено И ТипДанныхЗаполнения <> Тип("Структура") 
		И Метаданные().ВводитсяНаОсновании.Содержит(ДанныеЗаполнения.Метаданные()) Тогда
		Документы.ПлатежныйОрдерПоступлениеДенежныхСредств.ЗаполнитьПоДокументуОснованию(ЭтотОбъект, ДанныеЗаполнения);
		УправлениеДенежнымиСредствамиСервер.ЗаполнитьРеквизитыРасчетногоДокумента(ЭтотОбъект, РасшифровкаПлатежа);
		Возврат;
	ИначеЕсли ТипДанныхЗаполнения = Тип("Структура") Тогда 
		Если ДанныеЗаполнения.Свойство("Автор") Тогда
			ДанныеЗаполнения.Удалить("Автор");
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;
	
	УправлениеДенежнымиСредствамиСервер.ЗаполнитьРеквизитыРасчетногоДокумента(ЭтотОбъект, РасшифровкаПлатежа);

	//в 2.0 располагались в процедуре "перед записью" формы
	// "Ответственный" заполняется ранее при вызове процедуры ЗаполнитьШапкуДокумента() из настроек пользователя
	Если ЭтотОбъект.Ответственный.Пустая() Тогда
		ЭтотОбъект.Ответственный = Пользователи.ТекущийПользователь();
	КонецЕсли;

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
    
    ЕстьРасшифровкаПлатежа = Документы.ПлатежныйОрдерПоступлениеДенежныхСредств.ЕстьРасшифровкаПлатежа(ВидОперации);

    Если ЕстьРасшифровкаПлатежа И РасшифровкаПлатежа.Количество() > 0 Тогда
		РаботаСДоговорамиКонтрагентов.ЗаполнитьДоговорВТабличнойЧастиПередЗаписью(РасшифровкаПлатежа, ЭтотОбъект);
    КонецЕсли;
    
	Если Не ВидОперации = Перечисления.ВидыОперацийПоступлениеБезналичныхДенежныхСредств.ПрочееПоступлениеБезналичныхДенежныхСредств Тогда
		СтруктурноеПодразделениеОтправитель = СтруктурноеПодразделениеПолучатель;
	КонецЕсли;

	Если Не ЗначениеЗаполнено(Номер) Тогда
		УстановитьНовыйНомер();
	КонецЕсли;
	
	Если Не (ЗначениеЗаполнено(НомерВходящегодокумента) Или ЗначениеЗаполнено(ДатаВходящегоДокумента)) Тогда
		НомерВходящегодокумента = СокрЛП(ПрефиксацияОбъектовКлиентСервер.ПолучитьНомерНаПечать(Номер, ЭтотОбъект, , Истина, Истина));
		ДатаВходящегоДокумента = Дата;
	КонецЕсли;

	ЭтотОбъект.Оплачено = Истина;
	
	СчетаУчетаВДокументах.ЗаполнитьПередЗаписью(ЭтотОбъект, РежимЗаписи);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	НомерВходящегоДокумента = "";
	ДатаВходящегоДокумента  = "";
	УправлениеДенежнымиСредствамиСервер.ЗаполнитьРеквизитыРасчетногоДокумента(ЭтотОбъект, РасшифровкаПлатежа);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, Режим)
	
	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыПроведения = Документы.ПлатежныйОрдерПоступлениеДенежныхСредств.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ИНФОРМАЦИОННОЙ БАЗЫ
	
	ТаблицаВзаиморасчеты = УправлениеВзаиморасчетамиСервер.ПодготовитьТаблицуВзаиморасчетовПогашениеЗадолженности(
		ПараметрыПроведения.РасшифровкаПлатежа, ПараметрыПроведения.Реквизиты, Отказ);
	
	// ФОРМИРОВАНИЕ ДВИЖЕНИЙ
	
	УправлениеВзаиморасчетамиСервер.СформироватьДвиженияПогашениеЗадолженности(ТаблицаВзаиморасчеты, 
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
	
	УправлениеДенежнымиСредствамиСервер.СформироватьДвиженияПриобретениеВалюты(ПараметрыПроведения.ПриобретениеВалюты,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);

	УправлениеДенежнымиСредствамиСервер.СформироватьДвиженияПродажаВалюты(ПараметрыПроведения.ПродажаВалюты,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
	
	УправлениеДенежнымиСредствамиСервер.СформироватьДвиженияПрочееПоступление(ПараметрыПроведения.РеквизитыПрочее, 
		Движения, Отказ);
		
	// Переоценка валютных остатков - после формирования проводок всеми другими механизмами
	ТаблицаПереоценкаДвиженийДокумента = УчетДоходовРасходов.ПодготовитьТаблицуПереоценкаВалютныхОстатковПоПроводкамДокумента(
		ПараметрыПроведения.Реквизиты, Движения, Отказ);

	УчетДоходовРасходов.СформироватьДвиженияПереоценкаВалютныхОстатков(ТаблицаПереоценкаДвиженийДокумента,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);

	ПроцедурыНалоговогоУчета.ОтразитьПостоянныеРазницыВНУ(ПараметрыПроведения.Реквизиты, Движения, Отказ);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура ПроверитьЗаполнениеТабличнойЧастиПострочно(ПроверяемаяТабличнаяЧасть, ИмяТабличнойЧасти, Отказ, ПараметрыПроверки = Неопределено)
	
	Реквизиты = Новый Структура;
	Реквизиты.Вставить("ВалютаДокумента", ВалютаДокумента);
	Реквизиты.Вставить("ВалютаРегламентированногоУчета", ПараметрыПроверки.ВалютаРегламентированногоУчета);
	Реквизиты.Вставить("Регистратор", Ссылка);

	Для Каждого СтрокаТабличнойЧасти ИЗ ПроверяемаяТабличнаяЧасть Цикл
		
		//Сопоставление валюты расчетов по договору и валюты документа
		Если ВидОперации = Перечисления.ВидыОперацийПоступлениеБезналичныхДенежныхСредств.ПоступленияОтПродажиИностраннойВалюты тогда
			Если НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.ДоговорКонтрагента.ВалютаВзаиморасчетов) 
				ИЛИ СтрокаТабличнойЧасти.ДоговорКонтрагента.ВалютаВзаиморасчетов = ПараметрыПроверки.ВалютаРегламентированногоУчета Тогда
				
				ЗначениеПараметра = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
									?(НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.ДоговорКонтрагента.ВалютаВзаиморасчетов), НСтр("ru = 'не заполнена'"),
									НСтр("ru = '(%1) не отличается от валюты регламентированного учета (%2)
									|При отражении операции ""Поступления от продажи иностранной валюты"" валюта договора должна соответствовать реализуемой валюте.'")),
									СтрокаТабличнойЧасти.ДоговорКонтрагента.ВалютаВзаиморасчетов,
									ПараметрыПроверки.ВалютаРегламентированногоУчета);
				
				ОбщегоНазначения.СообщитьПользователю(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Валюта договора %1'", ЗначениеПараметра), ЭтотОбъект,,, Отказ));										
			КонецЕсли;
		ИначеЕсли ВидОперации = Перечисления.ВидыОперацийПоступлениеБезналичныхДенежныхСредств.ПриобретениеИностраннойВалюты Тогда
			Если НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.ДоговорКонтрагента.ВалютаВзаиморасчетов) 
				ИЛИ НЕ СтрокаТабличнойЧасти.ДоговорКонтрагента.ВалютаВзаиморасчетов = ПараметрыПроверки.ВалютаРегламентированногоУчета Тогда
				
				ЗначениеПараметра = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
									?(НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.ДоговорКонтрагента.ВалютаВзаиморасчетов), НСтр("ru = 'не заполнена'"),
									НСтр("ru = '(%1) отличается от валюты регламентированного учета (%2)
									|При отражении операции ""Приобретение иностранной валюты"" валюта договора должна соответствовать валюте регламентированного учета.'")),
									СтрокаТабличнойЧасти.ДоговорКонтрагента.ВалютаВзаиморасчетов,
									ПараметрыПроверки.ВалютаРегламентированногоУчета);
				
				ОбщегоНазначения.СообщитьПользователю(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Валюта договора %1'", ЗначениеПараметра), ЭтотОбъект,,, Отказ));																		
			КонецЕсли;				
		Иначе   			
			ДополнениеКСообщению = НСтр("ru = 'Строка %1 - '");
			
			Реквизиты.Вставить("ДоговорКонтрагента",СтрокаТабличнойЧасти.ДоговорКонтрагента); 
			Реквизиты.Вставить("ВалютаВзаиморасчетов",СтрокаТабличнойЧасти.ДоговорКонтрагента.ВалютаВзаиморасчетов);
			
			УправлениеВзаиморасчетамиСервер.ВозможноПроведениеВ_БУ_НУ(Реквизиты, 
																	  Отказ, 
																	  СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ДополнениеКСообщению,СтрокаТабличнойЧасти.НомерСтроки));				
		КонецЕсли;		
	КонецЦикла;
	
КонецПроцедуры

#КонецЕсли