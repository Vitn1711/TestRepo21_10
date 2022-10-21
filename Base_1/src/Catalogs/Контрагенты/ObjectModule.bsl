
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС
	
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Организации") Тогда
		
		ДанныеЗаполненияСтруктурой = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДанныеЗаполнения, 
			"Наименование,ЮрФизЛицо,НаименованиеПолное,КБЕ,РНН,КодПоОКПО,
			|ИдентификационныйНомер,ДатаСвидетельстваПоНДС,СерияСвидетельстваПоНДС,НомерСвидетельстваПоНДС,
			|СтранаРегистрации,УказыватьРеквизитыГоловнойОрганизацииВСчетеФактуре");
			
		Наименование                 = ДанныеЗаполненияСтруктурой.Наименование;
		ЮрФизЛицо                    = ДанныеЗаполненияСтруктурой.ЮрФизЛицо;
		НаименованиеПолное           = ДанныеЗаполненияСтруктурой.НаименованиеПолное;
		КБЕ                          = ДанныеЗаполненияСтруктурой.КБЕ;
		РНН                          = ДанныеЗаполненияСтруктурой.РНН;
		КодПоОКПО                    = ДанныеЗаполненияСтруктурой.КодПоОКПО;
		ИдентификационныйКодЛичности = ДанныеЗаполненияСтруктурой.ИдентификационныйНомер;
		ДатаСвидетельстваПоНДС 	     = ДанныеЗаполненияСтруктурой.ДатаСвидетельстваПоНДС;
		СерияСвидетельстваПоНДС      = ДанныеЗаполненияСтруктурой.СерияСвидетельстваПоНДС;
		НомерСвидетельстваПоНДС      = ДанныеЗаполненияСтруктурой.НомерСвидетельстваПоНДС;
		СтранаРезидентства           = ДанныеЗаполненияСтруктурой.СтранаРегистрации;
		УказыватьРеквизитыГоловнойОрганизацииВСчетеФактуре = ДанныеЗаполненияСтруктурой.УказыватьРеквизитыГоловнойОрганизацииВСчетеФактуре;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если НЕ ЭтоГруппа Тогда 
		
		Если ЗначениеЗаполнено(ГоловнойКонтрагент) И ГоловнойКонтрагент <> Ссылка Тогда
			
			МассивПодчиненныхКонтрагентов	= Справочники.Контрагенты.ПолучитьМассивПодчиненныхКонтрагентов(Ссылка);
			Если МассивПодчиненныхКонтрагентов.Количество() > 0 Тогда 
				ТекстОшибки	= СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Контрагент ""%1"" не может иметь головного контрагента, т.к. сам является головным для контрагентов:'"),
					Наименование);
				Для Каждого ПодчиненныйКонтрагент Из МассивПодчиненныхКонтрагентов Цикл
					ТекстОшибки = ТекстОшибки + Символы.ПС + Символы.Таб + СокрЛП(ПодчиненныйКонтрагент);
				КонецЦикла;
				ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, ЭтотОбъект, "ГоловнойКонтрагент", , Отказ);
			Иначе 
				СвойстваГоловногоКонтрагента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
					ГоловнойКонтрагент, "Наименование, ГоловнойКонтрагент");
					
				Если ЗначениеЗаполнено(СвойстваГоловногоКонтрагента.ГоловнойКонтрагент) 
					И СвойстваГоловногоКонтрагента.ГоловнойКонтрагент <> ГоловнойКонтрагент Тогда
					ТекстОшибки	= СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Контрагент ""%1"" не может быть выбран головным, т.к. для него самого назначен головной контрагент ""%2""'"),
						СвойстваГоловногоКонтрагента.Наименование,
						СокрЛП(СвойстваГоловногоКонтрагента.ГоловнойКонтрагент));
					ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, ЭтотОбъект, "ГоловнойКонтрагент", , Отказ);
				КонецЕсли;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;

	ДополнительныеСвойства.Вставить("ВыполненаПроверкаЗаполнения", Истина);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда 
		Возврат;
	КонецЕсли;
	
	Если НЕ ДополнительныеСвойства.Свойство("ВыполненаПроверкаЗаполнения") 
		ИЛИ (ДополнительныеСвойства.Свойство("ВыполненаПроверкаЗаполнения") И НЕ ДополнительныеСвойства.ВыполненаПроверкаЗаполнения) Тогда 
		
		Отказ = НЕ ПроверитьЗаполнение();
	КонецЕсли;
	
	Если ЭтоГруппа Тогда 
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ГоловнойКонтрагент) Тогда
		Если ЭтоНовый() Тогда
			Если ДополнительныеСвойства.Свойство("ЗаписьНового") И ДополнительныеСвойства.ЗаписьНового Тогда
				Возврат;
			Иначе
				ДополнительныеСвойства.Вставить("ЗаписьНового", Истина);
				Записать();
			КонецЕсли;
		КонецЕсли;
		ГоловнойКонтрагент = Ссылка;
	КонецЕсли;
	
	Если ЮрФизЛицо = Перечисления.ЮрФизЛицо.ФизЛицо Тогда
		ГосударственноеУчреждение = Ложь;
	КонецЕсли;	
	
	Если ЮрФизЛицо = Перечисления.ЮрФизЛицо.ЮрЛицо Тогда
		ФизЛицо = Справочники.ФизическиеЛица.ПустаяСсылка();
		ДокументУдостоверяющийЛичность = "";
		СИК = "";
		ИндивидуальныйПредпринимательАдвокатЧастныйНотариус = Ложь;
	Иначе
		КодПоОКПО = "";
	КонецЕсли;
	
	Если НЕ ЭтоНовый() И НЕ ЭтоГруппа Тогда
		
		Запрос = Новый Запрос();
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		Запрос.УстановитьПараметр("ПометкаУдаления", ПометкаУдаления);
		Запрос.Текст = "ВЫБРАТЬ
		|	КонтактныеЛица.Ссылка КАК КонтЛицо
		|ИЗ
		|	Справочник.КонтактныеЛица КАК КонтактныеЛица
		|
		|ГДЕ
		|	КонтактныеЛица.ОбъектВладелец = &Ссылка
		|		И КонтактныеЛица.ПометкаУдаления <> &ПометкаУдаления";
		ВыборкаКонтЛиц = Запрос.Выполнить().Выбрать();
		
		Пока ВыборкаКонтЛиц.Следующий() Цикл
			
			КонтЛицо = ВыборкаКонтЛиц.КонтЛицо.ПолучитьОбъект();
			КонтЛицо.УстановитьПометкуУдаления(ПометкаУдаления);
			
		КонецЦикла;
		
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("ПеренестиКИФизЛица", ЮрФизЛицо = Перечисления.ЮрФизЛицо.ФизЛицо И (ЭтоНовый() ИЛИ Ссылка.ФизЛицо <> ФизЛицо));
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда 
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("ЗаписьНового") И ДополнительныеСвойства.ЗаписьНового Тогда
		ДополнительныеСвойства.ЗаписьНового = Ложь;
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("ПеренестиКИФизЛица") И ДополнительныеСвойства.ПеренестиКИФизЛица Тогда
		ПеренестиКИФизЛица();
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Если НЕ ЭтоГруппа Тогда
		ОсновнойДоговорКонтрагента	= Неопределено;
		ОсновнойБанковскийСчет		= Неопределено;
		ОсновноеКонтактноеЛицо		= Неопределено;
		Если ОбъектКопирования.ГоловнойКонтрагент = ОбъектКопирования.Ссылка Тогда
			ГоловнойКонтрагент	= Справочники.Контрагенты.ПустаяСсылка();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура ПеренестиКИФизЛица()
	
	// перенесем только ту контактную информацию, для которой можно определить соответствие
	
	// составим соответствие видов контактной информации, относящейся к физлицам и к контрагентам
	ВидыКИ = Справочники.ВидыКонтактнойИнформации;
	СоответствиеВидовКИ = Новый Соответствие();
	СоответствиеВидовКИ.Вставить(ВидыКИ.ЮрАдресФизЛица,   ВидыКИ.ЮрАдресКонтрагента);
	СоответствиеВидовКИ.Вставить(ВидыКИ.ТелефонФизЛица,   ВидыКИ.ТелефонКонтрагента);
	СоответствиеВидовКИ.Вставить(ВидыКИ.ФактАдресФизЛица, ВидыКИ.ФактАдресКонтрагента);
	
	СписокВидовКИ = Новый СписокЗначений;
	Для Каждого ВидКИ Из СоответствиеВидовКИ Цикл
		СписокВидовКИ.Добавить(ВидКИ.Ключ);
	КонецЦикла;
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("парамФизЛицо",       ФизЛицо);
	Запрос.УстановитьПараметр("парамСписокВидовКИ", СписокВидовКИ);
	
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КИ.*
	|ИЗ
	|	РегистрСведений.КонтактнаяИнформация КАК КИ
	|ГДЕ
	|	КИ.Объект = &парамФизЛицо
	|	И КИ.Вид В (&парамСписокВидовКИ)
	|";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Количество() > 0 Тогда
		
		Пока Выборка.Следующий() Цикл
			
			НоваяЗапись        = РегистрыСведений.КонтактнаяИнформация.СоздатьМенеджерЗаписи();
			НоваяЗапись.Объект = Ссылка;
			НоваяЗапись.Вид    = СоответствиеВидовКИ[Выборка.Вид];
			
			ЗаполнитьЗначенияСвойств(НоваяЗапись, Выборка, , "Объект, Вид");
			
			НоваяЗапись.Записать();
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецЕсли
