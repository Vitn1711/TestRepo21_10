////////////////////////////////////////////////////////////////////////////////
// РеализацияТоваровУслугФормыКлиент: клиентские процедуры и функции, вызываемые 
// из форм документа "Реализация (акт, накладная)".
//  
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

Процедура ПриОткрытии(Форма,Отказ)Экспорт
		
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(Форма);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	МенеджерОборудованияКлиентПереопределяемый.НачатьПодключениеОборудованиеПриОткрытииФормы(Форма, "СканерШтрихкода");
	
	СчетаУчетаВДокументахКлиентСервер.ПолучитьЗаголовокСчетаУчетаРасчетов(Форма);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)Экспорт
	
	Если ПараметрыЗаписи.РежимЗаписи = ПредопределенноеЗначение("РежимЗаписиДокумента.Проведение") Тогда
		КлючеваяОперация = "Документ ""реализация тмз и услуг"" (проведение)";
		ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, КлючеваяОперация);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗакрытии(Форма, ЗавершениеРаботы)Экспорт
	
	МенеджерОборудованияКлиентПереопределяемый.НачатьОтключениеОборудованиеПриЗакрытииФормы(Форма);
	
КонецПроцедуры

// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

Процедура ЦеныИВалютаНажатие(Форма, Элемент, СтандартнаяОбработка)Экспорт
	
	СтандартнаяОбработка = Ложь;
	УправлениеЦенообразованиемКлиентСервер.ОбработатьИзмененияПоКнопкеЦеныИВалюты(Форма);

КонецПроцедуры

Процедура СтруктурноеПодразделениеОрганизацияНачалоВыбора(Форма, Элемент, ДанныеВыбора, СтандартнаяОбработка)Экспорт
	
	Объект = Форма.Объект;

	РаботаСДиалогамиКлиент.СтруктурноеПодразделениеНачалоВыбора(Форма, СтандартнаяОбработка, Объект.Организация, Объект.СтруктурноеПодразделение, Истина);
	
КонецПроцедуры

Процедура СделкаНачалоВыбора(Форма, Элемент, ДанныеВыбора, СтандартнаяОбработка)Экспорт
	
	Объект = Форма.Объект;
	
	СтандартнаяОбработка = Ложь;
	
	СтруктураПараметров = Новый Структура("Организация, Контрагент, ДоговорКонтрагента, Дата, ТипыДокументов",
		Объект.Организация, Объект.Контрагент, Объект.ДоговорКонтрагента, Объект.Дата, "Метаданные.Документы.РеализацияТоваровУслуг.Реквизиты.Сделка.Тип");

	Если НЕ ЗначениеЗаполнено(Объект.СчетУчетаРасчетовПоАвансам) Тогда
		СчетДляОпределенияОстатков = Объект.СчетУчетаРасчетовСКонтрагентом;
	Иначе
		СчетДляОпределенияОстатков = Объект.СчетУчетаРасчетовПоАвансам;
	КонецЕсли; 
	
	СтруктураПараметров.Вставить("СчетУчета"     , СчетДляОпределенияОстатков);
	СтруктураПараметров.Вставить("ОстаткиОбороты", "Кт");
	
	ПараметрыФормы = Новый Структура("ПараметрыОбъекта", СтруктураПараметров);
	ОткрытьФорму("Документ.ДокументРасчетовСКонтрагентом.ФормаВыбора", ПараметрыФормы, Элемент);
	
КонецПроцедуры

Процедура НадписьСчетФактураНажатие(Форма, Элемент, СтандартнаяОбработка)Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	УчетНДСиАкцизаКлиент.ОткрытьСчетФактуру(Форма, Форма.СчетФактура, "СчетФактураВыданный");
	
КонецПроцедуры

// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

Процедура ОткрытьНомераГТД(Форма, ПараметрыФормы) Экспорт
	
	НомераГТДКлиент.ОткрытьФормуРедактированияНомеровГТД(ПараметрыФормы, Форма);
	
КонецПроцедуры

Процедура Подбор(Форма, ИмяТаблицы, УникальныйИдентификатор)Экспорт
	
	ПараметрыПодбора = ПолучитьПараметрыПодбора(Форма,ИмяТаблицы);
	Если ПараметрыПодбора <> Неопределено Тогда
		ОткрытьФорму("Обработка.ПодборНоменклатуры.Форма.ОсновнаяФорма", ПараметрыПодбора,
			Форма, УникальныйИдентификатор);
	КонецЕсли;
	
КонецПроцедуры

Процедура ВвестиНовыйСчетФактуру(Форма)Экспорт

	УчетНДСиАкцизаКлиент.ОбработатьДействиеПоВводуСчетаФактуры(Форма, "СоздатьСчетФактуру", "СчетФактураВыданный");
	
	УчетНДСиАкцизаКлиентСервер.УправлениеГруппойСчетаФактуры(Форма, Истина);
	
КонецПроцедуры

Процедура ДополнитьСчетФактуру(Форма)Экспорт
	
	УчетНДСиАкцизаКлиент.ОбработатьДействиеПоВводуСчетаФактуры(Форма, "ДополнитьСчетФактуру", "СчетФактураВыданный");
	
КонецПроцедуры

Процедура ПоискПоШтрихкоду(ЭтотОбъект) Экспорт
	
	ОписаниеОповещенияПоискПоШтрихкоду = Новый ОписаниеОповещения("ПоискПоШтрихкодуЗавершение", ЭтотОбъект);
	
	ОткрытьФорму("РегистрСведений.ШтрихкодыНоменклатуры.Форма.ФормаВводШтрихкода", , ЭтотОбъект,,,,ОписаниеОповещенияПоискПоШтрихкоду , РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

Процедура ЗаполнитьПоПоступлениюТовары(Форма)Экспорт
	
	Объект = Форма.Объект;
	
	Если Объект.Товары.Количество() > 0 Тогда
		ТекстВопроса = НСтр("ru = 'Перед заполнением табличная часть будет очищена. Заполнить?'");
		ОписаниеОповещения = Новый ОписаниеОповещения("ПослеЗакрытияВопросаОчисткаТабличнойЧастиТовары", Форма);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Да);
	Иначе 
		ОткрытьФормуВыбораПоступленияТоваровУслуг(Форма,"Товары", "Заполнить");
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьПоПоступлениюУслуги(Форма)Экспорт
	
	Объект = Форма.Объект;
	
	Если Объект.Услуги.Количество() > 0 Тогда
		ТекстВопроса = НСтр("ru = 'Перед заполнением табличная часть будет очищена. Заполнить?'");
		ОписаниеОповещения = Новый ОписаниеОповещения("ПослеЗакрытияВопросаОчисткаТабличнойЧастиУслуги", Форма);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Да);
	Иначе 
		ОткрытьФормуВыбораПоступленияТоваровУслуг(Форма,"Услуги", "Заполнить");
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьТабличнуюЧастьПоСчету(Форма, ТабличнаяЧасть)Экспорт
	
	Объект = Форма.Объект;
	
	Если Объект[ТабличнаяЧасть].Количество() > 0 Тогда
		
		ТекстВопроса = НСтр("ru = 'Перед заполнением табличная часть будет очищена. Заполнить?'");
		ОписаниеОповещения = Новый ОписаниеОповещения("ПослеЗакрытияВопросаОчисткаТабличнойЧастиПриЗаполненииПоСчету", Форма, Новый Структура("ТабличнаяЧасть", ТабличнаяЧасть));
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Да);
		
	Иначе 
		ОткрытьФормуВыбораСчетаНаОплату(Форма,ТабличнаяЧасть);
	КонецЕсли;
	
КонецПроцедуры

Процедура Дополнительно(Форма)Экспорт
	
	РаботаСДиалогамиКлиент.ОткрытьФормуДополнительно(Форма, "РеализацияТоваровУслуг");
	
КонецПроцедуры

Процедура СчетаУчетаРасчетов(Форма)Экспорт
	
	СчетаУчетаВДокументахКлиентСервер.ОткрытьФормуСчетаУчета(Форма);
	
КонецПроцедуры

Процедура ОткрытьУчастникиСД(Форма)Экспорт
	
	Объект = Форма.Объект;
	
	Если НЕ Форма.ТолькоПросмотр Тогда
		Форма.ЗаблокироватьДанныеФормыДляРедактирования();
	КонецЕсли;

	СтруктураПараметров = Новый Структура();
	СтруктураПараметров.Вставить("УчастникиСовместнойДеятельности",  	Объект.УчастникиСовместнойДеятельности);
	СтруктураПараметров.Вставить("ТипОбъекта",                      	"РеализацияТоваровУслуг");
	СтруктураПараметров.Вставить("Договор",                      		Объект.ДоговорКонтрагента);
	
	ОткрытьФорму("ОбщаяФорма.ФормаУчастникиСовместнойДеятельности", СтруктураПараметров, Форма);
	
КонецПроцедуры

// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ

Процедура СубконтоДоходовБУПриИзменении(Форма,Номер, ИмяТабличнойЧасти)Экспорт
	
	ТекущиеДанные = Форма.Элементы[ИмяТабличнойЧасти].ТекущиеДанные;
	
	ОбщегоНазначенияБККлиентСервер.ЗаменитьСубконтоНУ(ТекущиеДанные, ТекущиеДанные.СчетДоходовБУ, ТекущиеДанные.СчетДоходовНУ, Номер, ТекущиеДанные["СубконтоДоходовБУ" + Номер], "СубконтоДоходовНУ");		
	
	РеализацияТоваровУслугФормыКлиентСервер.ИзменитьПараметрыВыбораПолейСубконто(Форма, "ДоходовБУ", "СчетДоходовБУ", ИмяТабличнойЧасти);
	РеализацияТоваровУслугФормыКлиентСервер.ИзменитьПараметрыВыбораПолейСубконто(Форма, "ДоходовНУ", "СчетДоходовНУ", ИмяТабличнойЧасти, Истина);

КонецПроцедуры

Процедура СубконтоНачалоВыбора(Форма, Элемент, ИмяЭлементаСубконто, ИндексСубконто, ИмяЭлементаСчета, СтрокаТаблицы, СтандартнаяОбработка)Экспорт	
	
	Объект = Форма.Объект;
		
	ПараметрыДокумента = РеализацияТоваровУслугФормыКлиентСервер.СписокПараметровВыбораСубконто(Объект, СтрокаТаблицы, ИмяЭлементаСубконто + "%Индекс%", ИмяЭлементаСчета);
	
	ПроцедурыБухгалтерскогоУчетаКлиент.НачалоВыбораЗначенияСубконто(Форма, Элемент, ИндексСубконто, СтандартнаяОбработка, ПараметрыДокумента);	
	
КонецПроцедуры

Процедура СубконтоСписанияСебестоимостиБУПриИзменении(Форма,Номер)Экспорт
	
	ТекущиеДанные = Форма.Элементы.Товары.ТекущиеДанные;
	
	ОбщегоНазначенияБККлиентСервер.ЗаменитьСубконтоНУ(ТекущиеДанные, ТекущиеДанные.СчетСписанияСебестоимостиБУ, ТекущиеДанные.СчетСписанияСебестоимостиНУ, Номер, ТекущиеДанные["СубконтоСписанияСебестоимостиБУ" + Номер], "СубконтоСписанияСебестоимостиНУ");		
	РеализацияТоваровУслугФормыКлиентСервер.ИзменитьПараметрыВыбораПолейСубконто(Форма, "СписанияСебестоимостиБУ", "СчетСписанияСебестоимостиБУ", "Товары");	
	РеализацияТоваровУслугФормыКлиентСервер.ИзменитьПараметрыВыбораПолейСубконто(Форма, "СписанияСебестоимостиНУ", "СчетСписанияСебестоимостиНУ", "Товары", Истина);	
	
КонецПроцедуры

Процедура ИзменитьТовары(Форма,АдресХранилищаТовары, УникальныйИдентификатор) Экспорт
	
	ПараметрыФормы = ПолучитьПараметрыОбработкиТабличнойЧастиТовары(Форма, АдресХранилищаТовары);
	Если ПараметрыФормы <> Неопределено Тогда
		ОткрытьФорму("Обработка.ОбработкаТабличнойЧастиТовары.Форма.Форма", ПараметрыФормы,
			Форма, УникальныйИдентификатор);
	КонецЕсли;
		
КонецПроцедуры

Процедура ИзменитьТабличнуюЧасть(Форма, ИмяТабличнойЧасти, СинонимТабличнойЧасти, ПараметрыФормы,УникальныйИдентификатор) Экспорт
	
	Если ПараметрыФормы <> Неопределено Тогда
		ОткрытьФорму("Обработка.ОбработкаТабличнойЧастиДокументов.Форма.Форма", ПараметрыФормы,
			Форма, УникальныйИдентификатор);
	КонецЕсли;
		
КонецПроцедуры

// ПРОЧИЕ ПРОЦЕДУРЫ И ФУНКЦИИ ФОРМ ДОКУМЕНТА РеализацияТоваровУслуг

Процедура ОткрытьРеквизитыПечатиРеализации(Форма, УникальныйИдентификатор)Экспорт
	
	Объект = Форма.Объект;
	
	СтруктураПараметров = Новый Структура();
	СтруктураПараметров.Вставить("ДоверенностьВыдана",              Объект.ДоверенностьВыдана);
	СтруктураПараметров.Вставить("ДоверенностьДата",                Объект.ДоверенностьДата);
	СтруктураПараметров.Вставить("ДоверенностьЛицо",                Объект.ДоверенностьЛицо);
	СтруктураПараметров.Вставить("ДоверенностьНомер",               Объект.ДоверенностьНомер);
	СтруктураПараметров.Вставить("УдалитьДоверенность",             Объект.УдалитьДоверенность);
	СтруктураПараметров.Вставить("ТолькоПросмотр",                  Форма.ТолькоПросмотр);
	СтруктураПараметров.Вставить("Грузополучатель",                 Объект.Грузополучатель);
	СтруктураПараметров.Вставить("АдресДоставки",                   Объект.АдресДоставки);
	СтруктураПараметров.Вставить("БанковскийСчетОрганизации",       Объект.БанковскийСчетОрганизации);
	СтруктураПараметров.Вставить("Организация",                     Объект.Организация);
	СтруктураПараметров.Вставить("Контрагент",                      Объект.Контрагент);
	СтруктураПараметров.Вставить("ТипОбъекта",                      "РеализацияТоваровУслуг");
	СтруктураПараметров.Вставить("ПереченьДокументации",            Объект.ПереченьДокументации);
	СтруктураПараметров.Вставить("ДатаНачалаОтчетногоПериода",      Объект.ДатаНачалаОтчетногоПериода);
	СтруктураПараметров.Вставить("ДатаОкончанияОтчетногоПериода",   Объект.ДатаОкончанияОтчетногоПериода);
	СтруктураПараметров.Вставить("НомерДокументаГЗ",                Объект.НомерДокументаГЗ);
	СтруктураПараметров.Вставить("ДатаДокументаГЗ",                 Объект.ДатаДокументаГЗ);
	СтруктураПараметров.Вставить("ДатаПодписанияГЗ",                Объект.ДатаПодписанияГЗ);
	СтруктураПараметров.Вставить("Дата",                            Объект.Дата);
	СтруктураПараметров.Вставить("СпособВыпискиАктовВыполненныхРабот",       Объект.СпособВыпискиАктовВыполненныхРабот);
	СтруктураПараметров.Вставить("ВидОперации",                     Объект.ВидОперации);
	
	ОткрытьФорму("ОбщаяФорма.РеквизитыПечатиРеализации", СтруктураПараметров, Форма, УникальныйИдентификатор,,, Неопределено, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция ПолучитьПараметрыПодбора(Форма, ИмяТаблицы)
	
	Объект = Форма.Объект;
	
	ДатаРасчетов		 = ?(НачалоДня(Объект.Дата) = НачалоДня(ТекущаяДата()), Неопределено, Объект.Дата);
	
	ЗаголовокПодбора	 = НСтр("ru = 'Подбор номенклатуры в %1 (%2)'");
	ПредставлениеТаблицы = НСтр("ru = '" + ИмяТаблицы + "'");
	
	ЗаголовокПодбора     = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ЗаголовокПодбора, Объект.Ссылка, ПредставлениеТаблицы);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ДатаРасчетов"            , ДатаРасчетов);
	ПараметрыФормы.Вставить("Организация"             , Объект.Организация);
	ПараметрыФормы.Вставить("СтруктурноеПодразделение", Объект.СтруктурноеПодразделение);
	ПараметрыФормы.Вставить("Склад"                   , Объект.Склад);
	ПараметрыФормы.Вставить("Заголовок"               , ЗаголовокПодбора);
	ПараметрыФормы.Вставить("ИмяТаблицы"              , ИмяТаблицы);
	ПараметрыФормы.Вставить("Товар"                   , ИмяТаблицы = "Товары");
	ПараметрыФормы.Вставить("Услуги"                  , ИмяТаблицы = "Услуги");
	ПараметрыФормы.Вставить("ЕстьЦена"                , Истина);
	ПараметрыФормы.Вставить("ТипЦен"                  , Объект.ТипЦен);
	ПараметрыФормы.Вставить("ВалютаДокумента"         , Объект.ВалютаДокумента);
	ПараметрыФормы.Вставить("ВыбиратьВсе"             , Истина);	
	
	СписокЗапросов = Новый СписокЗначений();
	СписокЗапросов.Добавить("ПоСправочнику", "По справочнику");
	Если ИмяТаблицы = "Товары" Тогда
		СписокЗапросов.Добавить("ОстаткиНоменклатуры", "Остатки номенклатуры");
		Если ЗначениеЗаполнено(Объект.ТипЦен) Тогда 
			СписокЗапросов.Добавить("ЦеныНоменклатуры", "Цены номенклатуры");
			СписокЗапросов.Добавить("ОстаткиИЦеныНоменклатуры", "Остатки и цены номенклатуры");
		Иначе
			СписокЗапросов.Добавить("ЦеныНоменклатурыДокументов", "Цены продажи");
			СписокЗапросов.Добавить("ОстаткиИЦеныНоменклатурыДокументов", "Остатки и цены продажи");
			ПараметрыФормы.Вставить("ЗаполнятьЦеныПоПродаже", Истина);
		КонецЕсли;
	ИначеЕсли ИмяТаблицы = "Услуги" Тогда
		Если ЗначениеЗаполнено(Объект.ТипЦен) Тогда 
			СписокЗапросов.Добавить("ЦеныУслуг", "Цены услуг");
		Иначе
			СписокЗапросов.Добавить("ЦеныНоменклатурыДокументов", "Цены продажи");
			ПараметрыФормы.Вставить("ЗаполнятьЦеныПоПродаже", Истина);
		КонецЕсли;
	КонецЕсли;
	
	ПараметрыФормы.Вставить("СписокВидовПодбора", СписокЗапросов);
	ПараметрыФормы.Вставить("ОбъектСсылка"      , Объект.Ссылка);
	
	Возврат ПараметрыФормы;

КонецФункции

Функция ПолучитьПараметрыОбработкиТабличнойЧастиТовары(Форма, АдресХранилищаТовары)
	
	Объект = Форма.Объект;
	
	ПараметрыОбработки = Новый Структура;
	
	ПараметрыОбработки.Вставить("АдресХранилищаТовары", 		АдресХранилищаТовары);
	
	ПараметрыОбработки.Вставить("ДокументСсылка", 				Объект.Ссылка);
	ПараметрыОбработки.Вставить("ДокументДата", 				Объект.Дата);
	ПараметрыОбработки.Вставить("ДокументОрганизация", 			Объект.Организация);
	ПараметрыОбработки.Вставить("ДокументВалюта", 			    Объект.ВалютаДокумента);
	ПараметрыОбработки.Вставить("ДокументКурс", 			    Объект.КурсВзаиморасчетов);
	ПараметрыОбработки.Вставить("ДокументКратность", 			Объект.КратностьВзаиморасчетов);
	ПараметрыОбработки.Вставить("ДокументСуммаВключаетНДС", 	Объект.СуммаВключаетНДС);
	ПараметрыОбработки.Вставить("ДокументУчитыватьНДС", 		Объект.УчитыватьНДС); 
	ПараметрыОбработки.Вставить("ДокументСуммаВключаетАкциз", 	Объект.СуммаВключаетАкциз);
	ПараметрыОбработки.Вставить("ДокументУчитыватьАкциз", 		Объект.УчитыватьАкциз); 
	ПараметрыОбработки.Вставить("ДокументТипЦен", 				Объект.ТипЦен);	

	Возврат ПараметрыОбработки;
	
КонецФункции

Процедура ОткрытьФормуВыбораПоступленияТоваровУслуг(Форма,ТабличнаяЧасть, СпособЗаполнения) Экспорт

	Объект = Форма.Объект;
	
	СтруктураОтбора	= Новый Структура;
	СтруктураОтбора.Вставить("Организация",	Объект.Организация);
	СтруктураОтбора.Вставить("Проведен",	Истина);
	
	СтруктураПараметров	= Новый Структура;
	СтруктураПараметров.Вставить("Отбор",              СтруктураОтбора);
	СтруктураПараметров.Вставить("РежимВыбора",        Истина);
	СтруктураПараметров.Вставить("МножественныйВыбор", Ложь);
	СтруктураПараметров.Вставить("ИмяТаблицы", 		   ТабличнаяЧасть);
	
	ОткрытьФорму("Документ.ПоступлениеТоваровУслуг.ФормаВыбора", СтруктураПараметров, Форма);

КонецПроцедуры

Процедура ОткрытьФормуВыбораСчетаНаОплату(Форма, ТабличнаяЧасть)Экспорт
	
	Объект = Форма.Объект;
	
	СтруктураОтбора	= Новый Структура;
	СтруктураОтбора.Вставить("Организация",	Объект.Организация);
	
	СтруктураПараметров	= Новый Структура;
	СтруктураПараметров.Вставить("Отбор",              СтруктураОтбора);
	СтруктураПараметров.Вставить("РежимВыбора",        Истина);
	СтруктураПараметров.Вставить("МножественныйВыбор", Ложь);
	СтруктураПараметров.Вставить("ИмяТаблицы",         ТабличнаяЧасть);
	
	ОткрытьФорму("Документ.СчетНаОплатуПокупателю.ФормаВыбора", СтруктураПараметров, Форма);
	
КонецПроцедуры
