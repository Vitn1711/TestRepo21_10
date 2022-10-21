
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Запись.ИсходныйКлючЗаписи.Пустой() Тогда
		КопированиеЗаписи = НЕ Параметры.ЗначениеКопирования.Пустой();
		Если НЕ ЗначениеЗаполнено(Запись.Организация) Тогда
			Запись.Организация = Справочники.Организации.ОрганизацияПоУмолчанию(Запись.Организация);
		КонецЕсли;
		ПодготовитьФормуНаСервере();
		НастройкаЗакладкиУчетИП(ЭтаФорма, НЕ КопированиеЗаписи); 
		НастройкаСтавокВзносовОтчисленийИП(НЕ КопированиеЗаписи);
   		НастройкаПримененияВычетовВОСМСиОПВЗаГПХКорректировка(НЕ КопированиеЗаписи);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ПодготовитьФормуНаСервере();
	НастройкаСтавокВзносовОтчисленийИП(Ложь);
    НастройкаПримененияВычетовВОСМСиОПВЗаГПХКорректировка(Ложь);
    НастройкаЗакладкиУчетИП(ЭтаФорма, Ложь); 
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ПроверитьПоддержкуУчетаВременныхРазниц();
		
	// Изменение ключевых реквизитов, возможно только в монопольном режиме.
	
	Если НЕ СтандартныеПодсистемыСервер.ЭтоБазоваяВерсияКонфигурации() 
		И МодифицированностьКлючевыхРеквизитов(ЭтотОбъект) Тогда
		
		Попытка
			
			УстановитьМонопольныйРежим(Истина);
			
		Исключение				
			
			ТекстСообщения = НСтр(
				"ru = 'Изменение реквизитов ""Период"", ""Организация"", ""Плательщик налога на прибыль"", ""Плательщик НДС"", ""Порядок расчета социального налога"" возможно только в монопольном режиме.
				|Не удалось установить монопольный режим для изменения параметров учетной политики! Запись изменений невозможна по причине:
				|%1'"
			);
			
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			КраткоеПредставлениеОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке);
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, КраткоеПредставлениеОшибки);
			
			ОбщегоНазначения.СообщитьПользователю(
				ТекстСообщения,
				,
				,
				"Запись",
				Отказ
			);
			
		КонецПопытки
			
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

	Если НЕ СтандартныеПодсистемыСервер.ЭтоБазоваяВерсияКонфигурации() Тогда
		УстановитьМонопольныйРежим(Ложь);
	КонецЕсли;
	
	ПодготовитьФормуНаСервере();
	
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	КопированиеЗаписи = Ложь;
	Оповестить("ИзменениеУчетнойПолитикиНалоговыйУчет");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	ОбновитьИнтерфейс();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	Запись.ЕжемесячныйРасчетВзносовИОтчисленийЗаИП = Ложь;
	ОбновитьПризнакОрганизацияЯвляетсяИП();
	ОбновитьСписокВыбораПорядокРасчетаСН();
	НастройкаЗакладкиУчетИП(ЭтаФорма);
	НастройкаСтавокВзносовОтчисленийИП();
    НастройкаПримененияВычетовВОСМСиОПВЗаГПХКорректировка();
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияЯвляетсяПлательщикомКПНПриИзменении(Элемент)
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияЯвляетсяПлательщикомНДСПриИзменении(Элемент)
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура НДСНалоговыйПериодПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(Запись.НДСНалоговыйПериод) Тогда
		Запись.НДСНалоговыйПериод = ПредопределенноеЗначение("Перечисление.Периодичность.Месяц");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РаспределятьНалогиПоСтруктурнымЕдиницамПриИзменении(Элемент)
	
	Если Запись.РаспределятьНалогиПоПодразделениямОрганизаций И НЕ Запись.РаспределятьНалогиПоСтруктурнымЕдиницам Тогда
		Запись.РаспределятьНалогиПоПодразделениямОрганизаций = Ложь;
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура УпрощенныйУчетИПНиОПВПриИзменении(Элемент)
	
	Если УпрощенныйУчетИПНиОПВ = 1 Тогда 
		Запись.УпрощенныйУчетИПНиОПВ = Истина;
	Иначе 
		Запись.УпрощенныйУчетИПНиОПВ = Ложь;
	КонецЕсли;
		
	Если Запись.УпрощенныйУчетИПНиОПВ Тогда
		Запись.ЗасчитыватьВВыплаченныеДоходыУдержанияПоИЛ = Истина;
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПорядокРасчетаСНПриИзменении(Элемент)
	
	Если ПорядокРасчетаСН = "УпрощеннаяДекларация" Тогда
	
		Запись.ОрганизацияЯвляетсяПлательщикомСН = Ложь;
	
	Иначе
		
		Запись.ОрганизацияЯвляетсяПлательщикомСН = Истина;
	
	КонецЕсли;
	
	ОбновитьСписокВыбораПорядокРасчетаСН();
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодПриИзменении(Элемент)
	НастройкаЗакладкиУчетИП(ЭтаФорма);
	НастройкаСтавокВзносовОтчисленийИП();
    НастройкаПримененияВычетовВОСМСиОПВЗаГПХКорректировка();
	УправлениеФормой(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура НеПрименятьКорректировкуПрочихНалоговВзносовОтчисленийПриИзменении(Элемент)
	
	Если Запись.Период >= '2020-01-01'
        И (НЕ Запись.НеПрименятьКорректировкуПрочихНалоговВзносовОтчислений
		И Запись.ПрименятьВычетВОСМСДляФизическихЛицИГПХ) Тогда
		
		Запись.ПрименятьВычетВОСМСДляФизическихЛицИГПХ = Ложь;	
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru='Настройка ""Применять вычет ВОСМС для физических лиц (сотрудников) и вычеты ОПВ и ВОСМС для ГПХ"" снята. Вычет ВОСМС не может использоваться совместно с корректировкой дохода'"));
			
	КонецЕсли;		
	
КонецПроцедуры

&НаКлиенте
Процедура ПрименятьВычетВОСМСДляФизическихЛицИГПХПриИзменении(Элемент)
	
	Если Запись.Период >= '2020-01-01'
		И (Запись.ПрименятьВычетВОСМСДляФизическихЛицИГПХ = Истина 
		И НЕ Запись.НеПрименятьКорректировкуПрочихНалоговВзносовОтчислений) Тогда
		
		Запись.НеПрименятьКорректировкуПрочихНалоговВзносовОтчислений = Истина;
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru='Настройка ""Расчет СН, ООСМС, ВОСМС без применения 90% корректировки по ИПН"" установлена. Корректировка дохода не может использоваться совместно с предоставлением вычета ВОСМС.'"));
			
	КонецЕсли;		
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	УчетПоВсемОрганизациям = ПользователиБКВызовСервераПовтИсп.ПолучитьЗначениеПоУмолчанию(
		ПользователиКлиентСервер.ТекущийПользователь(), "УчетПоВсемОрганизациям");
		
	ВедетсяУчетЗарплатыИКадры = ПолучитьФункциональнуюОпцию("ВедетсяУчетЗарплатыИКадры");
	ИспользоватьИсполнительныеЛисты = ПолучитьФункциональнуюОпцию("ИспользоватьИсполнительныеЛисты");
	ИспользоватьОбменЗарплата3Бухгалтерия3 = ПолучитьФункциональнуюОпцию("ИспользоватьОбменЗарплата3Бухгалтерия3");
	ОбновитьПризнакОрганизацияЯвляетсяИП();
	
	ПредыдущийПериод = Запись.Период;
	ПредыдущаяОрганизация = Запись.Организация;
	ПредыдущийПризнакПлательщикаКПН = Запись.ОрганизацияЯвляетсяПлательщикомКПН;
	ПредыдущийПризнакПлательщикаНДС = Запись.ОрганизацияЯвляетсяПлательщикомНДС;
	ПредыдущийПризнакПлательщикаСН  = Запись.ОрганизацияЯвляетсяПлательщикомСН;
	УпрощенныйУчетИПНиОПВ 			= Число(Запись.УпрощенныйУчетИПНиОПВ);
	
	
	ОбновитьСписокВыбораПорядокРасчетаСН();	
	ПроверкаФизЛицоОрганизации();

	УправлениеФормой(ЭтотОбъект);
	УстановитьДоступностьЭлементов();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Запись   = Форма.Запись;
	Элементы = Форма.Элементы;
	
	Элементы.НДСМетодОтнесенияВЗачет.Доступность = Запись.ОрганизацияЯвляетсяПлательщикомНДС;
	Элементы.НДСНалоговыйПериод.Доступность      = Запись.ОрганизацияЯвляетсяПлательщикомНДС;	
	
	Элементы.РаспределятьНалогиПоПодразделениямОрганизаций.Доступность        = Запись.РаспределятьНалогиПоСтруктурнымЕдиницам;
	Элементы.НадписьРаспределятьНалогиПоПодразделениямОрганизаций.Доступность = Запись.РаспределятьНалогиПоСтруктурнымЕдиницам;
	
	Элементы.ЗасчитыватьВВыплаченныеДоходыУдержанияПоИЛ.Доступность = НЕ Запись.УпрощенныйУчетИПНиОПВ;
	
	Элементы.Организация.ТолькоПросмотр = НЕ Форма.УчетПоВсемОрганизациям;
    
    Если Не Запись.ЕжемесячныйРасчетВзносовИОтчисленийЗаИП Тогда
        Элементы.СпособОтраженияОПВИП.Доступность = Форма.ИспользоватьОбменЗарплата3Бухгалтерия3;
        Элементы.СпособОтраженияВОСМС.Доступность  = Форма.ИспользоватьОбменЗарплата3Бухгалтерия3;
        Элементы.СпособОтраженияОПВИП.АвтоОтметкаНезаполненного = Форма.ИспользоватьОбменЗарплата3Бухгалтерия3;
        Элементы.СпособОтраженияВОСМС.АвтоОтметкаНезаполненного = Форма.ИспользоватьОбменЗарплата3Бухгалтерия3;
        Элементы.СпособОтраженияСОИП.Доступность = Ложь;
    Иначе
        Элементы.СпособОтраженияОПВИП.Доступность = Истина;
        Элементы.СпособОтраженияВОСМС.Доступность = Истина;
        Элементы.СпособОтраженияСОИП.Доступность  = Истина;
    КонецЕсли;
	
	Элементы.ГруппаОграничениеНаМинимальныйОбъектОСМС.Видимость =
		Запись.ПрименятьОграничениеНаМинимальныйОбъектОСМС ИЛИ (Запись.Период < Дата(2018, 1, 1));
		
	Элементы.ГруппаПрименятьВычетОПВДляГПХ.Видимость = Запись.Период >= Дата(2019, 1, 1) И Запись.Период < Дата(2019, 12, 31);
	Элементы.ГруппаКорректировкаПрименятьВычетВОСМСДляФизическихЛицИГПХ.Видимость = Запись.Период >= Дата(2020, 1, 1) И Запись.Период < Дата(2020, 12, 31);
	
	Элементы.СтраницаРазделовЗарплата.Видимость               = Форма.ВедетсяУчетЗарплатыИКадры;
	Элементы.СтраницаРазделовНалогиВзносыОтчисления.Видимость = Форма.ВедетсяУчетЗарплатыИКадры;
	Элементы.СтраницаРазделовУчетИП.Видимость                 = Форма.ВедетсяУчетЗарплатыИКадры И Форма.ОрганизацияЯвляетсяИП;
	
	Элементы.НадписьЗасчитыватьВВыплаченныеДоходыУдержанияПоИЛ.Видимость = Форма.ИспользоватьИсполнительныеЛисты;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьЭлементов()
	
	Элементы.ПорядокРасчетаСН.Доступность = РольДоступна("ДобавлениеИзменениеНастроекБухгалтерии") 
											ИЛИ РольДоступна("ДобавлениеИзменениеДанныхБухгалтерии") 
											ИЛИ Пользователи.ЭтоПолноправныйПользователь();
	Элементы.УпрощенныйУчетИПНиОПВ.Доступность = РольДоступна("ДобавлениеИзменениеНастроекБухгалтерии")
											ИЛИ РольДоступна("ДобавлениеИзменениеДанныхБухгалтерии")
											ИЛИ Пользователи.ЭтоПолноправныйПользователь();

КонецПроцедуры

&НаСервере
Процедура ПроверитьПоддержкуУчетаВременныхРазниц()
	
	Если НЕ Запись.ОрганизацияЯвляетсяПлательщикомКПН Тогда
		// если для предприятия не установлен признак Плательщика КПН
		// необходимо снять признак учета временных разниц
		// 
		Если УчетнаяПолитикаСервер.УчетВременныхРазницПоНалогуНаПрибыль(Запись.Организация, Запись.Период) Тогда
			ОбщегоНазначения.СообщитьПользователю(
				НСтр("ru='Для организации установлена поддержка учета временных разниц по налогу на прибыль.
						|Поскольку предприятие не является плательщиком налога на прибыль, необходимо отключить поддержку учета временных разниц.'"),
				,
				,
				"Запись",
				);
		КонецЕсли;	
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция МодифицированностьКлючевыхРеквизитов(Форма)
	
	Запись = Форма.Запись;
	
	Если Запись.Период <> Форма.ПредыдущийПериод ИЛИ
		Запись.Организация <> Форма.ПредыдущаяОрганизация ИЛИ
		Запись.ОрганизацияЯвляетсяПлательщикомКПН <> Форма.ПредыдущийПризнакПлательщикаКПН ИЛИ
		Запись.ОрганизацияЯвляетсяПлательщикомНДС <> Форма.ПредыдущийПризнакПлательщикаНДС ИЛИ
		Запись.ОрганизацияЯвляетсяПлательщикомСН <> Форма.ПредыдущийПризнакПлательщикаСН Тогда
		
		Возврат Истина;
	КонецЕсли;
		
	Возврат Ложь;
	
КонецФункции	

&НаСервере
Процедура ОбновитьСписокВыбораПорядокРасчетаСН()

	СписокВыбора = Элементы.ПорядокРасчетаСН.СписокВыбора;
	СписокВыбора.Очистить();
	
	Если НЕ ОрганизацияЯвляетсяИП Тогда 
	
		// юридическое лицо
		СписокВыбора.Добавить("ОбщеустановленныйПорядок", НСтр("ru = 'Общеустановленный порядок'"));
		СписокВыбора.Добавить("УпрощеннаяДекларация", НСтр("ru = 'Специальный налоговый режим на основе упрощенной декларации для юридического лица'"));
	
	Иначе
	
		// индивидуальный предприниматель
		СписокВыбора.Добавить("ОбщеустановленныйПорядок", НСтр("ru = 'Индивидуальный предприниматель, за исключением применяющего специальные налоговые режимы'"));
		СписокВыбора.Добавить("УпрощеннаяДекларация", НСтр("ru = 'Специальный налоговый режим на основе упрощенной декларации для индивидуального предпринимателя'"));
	
	КонецЕсли;
	
	Если Запись.ОрганизацияЯвляетсяПлательщикомСН Тогда
		ПорядокРасчетаСН = "ОбщеустановленныйПорядок";
	Иначе
		ПорядокРасчетаСН = "УпрощеннаяДекларация";
	КонецЕсли;

	Элементы.ГруппаСНИндивидуальногоПредпринимателя.Видимость = Ложь;
	Элементы.ГруппаСНЮрЛица.Видимость = Ложь;
	
	Если ПорядокРасчетаСН = "ОбщеустановленныйПорядок" И НЕ ОрганизацияЯвляетсяИП Тогда
		// юридическое лицо на общеустановленном порядке
		Элементы.ГруппаСНЮрЛица.Видимость = Истина;
	ИначеЕсли ПорядокРасчетаСН = "ОбщеустановленныйПорядок" И ОрганизацияЯвляетсяИП Тогда
		// ИП-шник на общеустановленном режиме 
		Элементы.ГруппаСНИндивидуальногоПредпринимателя.Видимость = Истина;
	КонецЕсли;
	
	// Видимость закладки УчетИП
	Если Не ОрганизацияЯвляетсяИП Тогда
		Элементы.СтраницаРазделовУчетИП.Видимость = Ложь;
	Иначе
		Элементы.СтраницаРазделовУчетИП.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура НастройкаЗакладкиУчетИП(Форма, ИзменитьСтавку = Ложь)
	
	Запись = Форма.Запись;
	Элементы = Форма.Элементы;
	
	Если Не Запись.ЕжемесячныйРасчетВзносовИОтчисленийЗаИП Тогда
		
		Элементы.ГруппаНастройкиОтраженияОПВ.Доступность = Ложь;
		Элементы.ГруппаНастройкиОтражения.Доступность  	 = Ложь;
		Элементы.ГруппаНастройкиОтраженияСО.Доступность  = Ложь;
		Элементы.ИнформацияОбОшибкеФизЛицо.Видимость  = Ложь;
		Элементы.ОформитьУвольнениеИП.Видимость       = Ложь;
		Элементы.СсылкаДокументУвольнениеИП.Видимость = Ложь;
        
        Если ИзменитьСтавку Тогда
            Запись.ПорядокРасчетаДоходаОПВ = ПредопределенноеЗначение("Перечисление.ПорядокРасчетаДоходовЗаИП.ПустаяСсылка");
            Запись.ПорядокРасчетаДоходаСО  = ПредопределенноеЗначение("Перечисление.ПорядокРасчетаДоходовЗаИП.ПустаяСсылка");
            Запись.ПорядокРасчетаДоходаВОСМС  = ПредопределенноеЗначение("Перечисление.ПорядокРасчетаДоходовЗаИП.ПустаяСсылка");
            Запись.РазмерДоходаОПВ 		   = 0;
            Запись.РазмерДоходаСО		   = 0;
            Запись.РазмерДоходаВОСМС	   = 0;
        КонецЕсли;

	Иначе
		
        Элементы.ГруппаНастройкиОтраженияОПВ.Доступность = Истина;
        Элементы.ГруппаНастройкиОтраженияСО.Доступность  = Истина;
		Если Запись.Период >= Дата(2020, 1, 1) Тогда
			Элементы.ГруппаНастройкиОтражения.Доступность  = Истина;
            Если ИзменитьСтавку Тогда
				Запись.ПорядокРасчетаДоходаВОСМС  = ПредопределенноеЗначение("Перечисление.ПорядокРасчетаДоходовЗаИП.КратноМЗП");
				Запись.РазмерДоходаВОСМС	   = 1.4;
			КонецЕсли;
		Иначе
			Элементы.ГруппаНастройкиОтражения.Доступность  = Ложь;
            Если ИзменитьСтавку Тогда
				Запись.ПорядокРасчетаДоходаВОСМС  = ПредопределенноеЗначение("Перечисление.ПорядокРасчетаДоходовЗаИП.ПустаяСсылка");
				Запись.РазмерДоходаВОСМС	  	  = 0;
			КонецЕсли;
		КонецЕсли;
		
        Если ИзменитьСтавку Тогда
			//Заполнение по умолчанию СО и ОПВ
			Запись.ПорядокРасчетаДоходаОПВ = ПредопределенноеЗначение("Перечисление.ПорядокРасчетаДоходовЗаИП.КратноМЗП");
			Запись.ПорядокРасчетаДоходаСО  = ПредопределенноеЗначение("Перечисление.ПорядокРасчетаДоходовЗаИП.КратноМЗП");
			Запись.РазмерДоходаОПВ 		   = 1;
			Запись.РазмерДоходаСО		   = 1;
		КонецЕсли;

	КонецЕсли;		
	
КонецПроцедуры

&НаСервере
Процедура НастройкаСтавокВзносовОтчисленийИП(ИзменитьСтавку = Истина)
	
	Если Запись.Организация.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ФизЛицо Тогда
		
		Если Запись.Период >= Дата('20200101') Тогда
			Если ИзменитьСтавку Тогда
				Запись.СтавкаВОСМСДляИП = 5;
				Запись.СтавкаОПВдляИП 	= 10;
				Запись.СтавкаСОДляИП 	= 3.5;
			КонецЕсли;
			Элементы.СтавкаВОСМСДляИП.Доступность 		= Истина;
			Элементы.СтавкаОПВдляИП.Доступность 		= Истина;
			Элементы.СтавкаСОДляИП.Доступность 			= Истина;
		Иначе
			Если ИзменитьСтавку Тогда
				Запись.СтавкаВОСМСДляИП = 0;
				Запись.СтавкаОПВдляИП 	= 0;
				Запись.СтавкаСОДляИП 	= 0;
			КонецЕсли;	
			Элементы.СтавкаВОСМСДляИП.Доступность 		= Ложь;
			Элементы.СтавкаОПВдляИП.Доступность 		= Ложь;
			Элементы.СтавкаСОДляИП.Доступность			= Ложь;
			Элементы.ГруппаВОСМС.Доступность 			= Ложь;
		КонецЕсли;
		
	Иначе
		
		Если ИзменитьСтавку Тогда
			Запись.СтавкаВОСМСДляИП = 0;
			Запись.СтавкаОПВдляИП 	= 0;
			Запись.СтавкаСОДляИП 	= 0;
		КонецЕсли;	
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НастройкаПримененияВычетовВОСМСиОПВЗаГПХКорректировка(ИзменитьНастройку = Истина)
    
    Если Запись.Период >= Дата('20210101') Тогда
        Если ИзменитьНастройку Тогда
            Запись.НеПрименятьКорректировкуПрочихНалоговВзносовОтчислений = Истина;
            Запись.ПрименятьВычетВОСМСДляФизическихЛицИГПХ 	= Истина;
            Запись.ПрименятьВычетОПВиВОСМСДляГПХ 	= Истина;
        КонецЕсли;
    Иначе
        Если ИзменитьНастройку Тогда
            Запись.НеПрименятьКорректировкуПрочихНалоговВзносовОтчислений = Ложь;
            Запись.ПрименятьВычетВОСМСДляФизическихЛицИГПХ 	= Ложь;
            Запись.ПрименятьВычетОПВиВОСМСДляГПХ 	= Ложь;
        КонецЕсли;	
    КонецЕсли;
    
КонецПроцедуры

&НаСервере
Процедура ПроверкаФизЛицоОрганизации()
	
	Элементы.ИнформацияОбОшибкеФизЛицо.Видимость  = Ложь;
	Элементы.ОформитьУвольнениеИП.Видимость 	  = Ложь;
	Элементы.СсылкаДокументУвольнениеИП.Видимость = Ложь;
	ИнформацияОбОшибкеФизЛицо = "";
	
	Если Запись.ЕжемесячныйРасчетВзносовИОтчисленийЗаИП Тогда	
		Запрос = Новый Запрос();
		Запрос.УстановитьПараметр("парамПериод", Запись.Период);
		Запрос.УстановитьПараметр("парамОрганизация", Запись.Организация);
		Запрос.УстановитьПараметр("парамИП", Запись.Организация.ИндивидуальныйПредприниматель);
		
		Запрос.Текст = "ВЫБРАТЬ
		|	РаботникиОрганизацийСрезПоследних.Сотрудник
		|ИЗ
		|	РегистрСведений.РаботникиОрганизаций.СрезПоследних(
		|			&парамПериод,
		|			Сотрудник.Физлицо = &парамИП
		|				И Сотрудник.ВидЗанятости = ЗНАЧЕНИЕ(Перечисление.ВидыЗанятостиВОрганизации.ОсновноеМестоРаботы)
		|				И Организация = &парамОрганизация) КАК РаботникиОрганизацийСрезПоследних
		|ГДЕ
		|	РаботникиОрганизацийСрезПоследних.ПричинаИзмененияСостояния <> ЗНАЧЕНИЕ(Перечисление.ПричиныИзмененияСостояния.Увольнение)";
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Пока Выборка.Следующий() Цикл
			ИнформацияОбОшибкеФизЛицо = Новый ФорматированнаяСтрока(
			НСтр("ru='Индивидуальный предприниматель оформлен как сотрудник, для корректного ведения учета необходимо оформить увольнение'"));
			
			Элементы.ИнформацияОбОшибкеФизЛицо.Видимость = Истина;
			Элементы.ОформитьУвольнениеИП.Видимость = Истина;
			Элементы.СсылкаДокументУвольнениеИП.Видимость = Ложь;
			ОформитьУвольнениеИП = "Оформить увольнение ИП"; 
		КонецЦикла;
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ИнформацияОбОшибкеФизЛицо",
		"Заголовок",
		ИнформацияОбОшибкеФизЛицо
		);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЕжемесячныйРасчетВзносовИОтчисленийЗаИППриИзменении(Элемент)
	
	ПроверкаФизЛицоОрганизации();
	НастройкаЗакладкиУчетИП(ЭтаФорма, Истина);
   	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	Если Запись.ЕжемесячныйРасчетВзносовИОтчисленийЗаИП И НЕ ЗначениеЗаполнено(Запись.ПорядокРасчетаДоходаОПВ) Тогда
		
		ОбщегоНазначения.СообщитьПользователю(
		ОбщегоНазначенияБККлиентСервер.ПолучитьТекстСообщения(, , НСтр("ru = 'Порядок расчета дохода для ОПВ'")),
		,
		"ПорядокРасчетаДоходаОПВ",
		"Запись",
		Отказ);
	КонецЕсли;
	
	Если Запись.ЕжемесячныйРасчетВзносовИОтчисленийЗаИП И НЕ ЗначениеЗаполнено(Запись.РазмерДоходаОПВ) Тогда
		ОбщегоНазначения.СообщитьПользователю(
		ОбщегоНазначенияБККлиентСервер.ПолучитьТекстСообщения(, , НСтр("ru = 'Размер дохода для ОПВ'")),
		,
		"РазмерДоходаОПВ",
		"Запись",
		Отказ);
	КонецЕсли;
	
	Если Запись.ЕжемесячныйРасчетВзносовИОтчисленийЗаИП И НЕ ЗначениеЗаполнено(Запись.ПорядокРасчетаДоходаСО) Тогда
		ОбщегоНазначения.СообщитьПользователю(
		ОбщегоНазначенияБККлиентСервер.ПолучитьТекстСообщения(, , НСтр("ru = 'Порядок расчета дохода для СО'")),
		,
		"ПорядокРасчетаДоходаСО",
		"Запись",
		Отказ);
	КонецЕсли;

	Если Запись.ЕжемесячныйРасчетВзносовИОтчисленийЗаИП И НЕ ЗначениеЗаполнено(Запись.РазмерДоходаСО) Тогда
		ОбщегоНазначения.СообщитьПользователю(
		ОбщегоНазначенияБККлиентСервер.ПолучитьТекстСообщения(, , НСтр("ru = 'Размер дохода для СО'")),
		,
		"РазмерДоходаСО",
		"Запись",
		Отказ);
		
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ОформитьУвольнениеИПНаСервере()
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("парамПериод", Запись.Период);
	Запрос.УстановитьПараметр("парамОрганизация", Запись.Организация);
	Запрос.УстановитьПараметр("парамИП", Запись.Организация.ИндивидуальныйПредприниматель);
	
	
	Запрос.Текст = "ВЫБРАТЬ
	|	РаботникиОрганизацийСрезПоследних.Сотрудник,
	|	РаботникиОрганизацийСрезПоследних.ОбособленноеПодразделение,
	|	РаботникиОрганизацийСрезПоследних.СтруктурноеПодразделение
	|ИЗ
	|	РегистрСведений.РаботникиОрганизаций.СрезПоследних(
	|			&парамПериод,
	|			Сотрудник.Физлицо = &парамИП
	|				И Сотрудник.ВидЗанятости = ЗНАЧЕНИЕ(Перечисление.ВидыЗанятостиВОрганизации.ОсновноеМестоРаботы)
	|				И Организация = &парамОрганизация) КАК РаботникиОрганизацийСрезПоследних
	|ГДЕ
	|	РаботникиОрганизацийСрезПоследних.ПричинаИзмененияСостояния <> ЗНАЧЕНИЕ(Перечисление.ПричиныИзмененияСостояния.Увольнение)";
	
	Выборка = Запрос.Выполнить().Выбрать();

	Если Выборка.Следующий() Тогда
		//заполним реквизиты шапки
		Организация 			 = Выборка.ОбособленноеПодразделение;
		Ответственный 			 = ПользователиБКВызовСервераПовтИсп.ПолучитьЗначениеПоУмолчанию(
									Пользователи.ТекущийПользователь(), "ОсновнойОтветственный");
									
		Если ЗначениеЗаполнено(Выборка.СтруктурноеПодразделение) Тогда
			СтруктурноеПодразделение = Выборка.СтруктурноеПодразделение;
		Иначе
			СтруктурноеПодразделение = Организация;
		КонецЕсли;
		
		//заполним табичную часть
		Сотрудник 			 = Выборка.Сотрудник;
		ДатаУвольнения 		 = КонецМесяца(ДобавитьМесяц(Запись.Период, -1));
		
	КонецЕсли;
	
	Возврат Новый Структура("УвольнениеИП, Организация, Ответственный, СтруктурноеПодразделение, Сотрудник, ДатаУвольнения", Истина, Организация, Ответственный, СтруктурноеПодразделение, Сотрудник, ДатаУвольнения) ;
	
КонецФункции

&НаКлиенте
Процедура ОформитьУвольнениеИПНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	НовыйДокументУвольнение = ОформитьУвольнениеИПНаСервере();
 	ОткрытьФорму("Документ.УвольнениеИзОрганизаций.Форма.ФормаДокумента", НовыйДокументУвольнение);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "УвольнениеИП" Тогда
		Элементы.ИнформацияОбОшибке.Видимость = Ложь;
		Элементы.СсылкаДокументУвольнениеИП.Видимость = Истина;
		СсылкаДокументУвольнениеИП = Параметр;
	КонецЕсли;
КонецПроцедуры
 
&НаСервере
Процедура ОбновитьПризнакОрганизацияЯвляетсяИП()
	
	ОрганизацияЯвляетсяИП = НЕ Запись.Организация.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ЮрЛицо;
	
КонецПроцедуры
 