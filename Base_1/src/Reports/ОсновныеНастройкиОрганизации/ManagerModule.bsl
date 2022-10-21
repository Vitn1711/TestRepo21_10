#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

Процедура СформироватьОтчет(ПараметрыОтчета, АдресХранилища) Экспорт
	
	Отказ = Ложь;
	
	ДанныеРасшифровкиОбъект = Неопределено;
	
	Результат = Новый ТабличныйДокумент;
	
	Результат.НачатьАвтогруппировкуСтрок();
	
	Макет = ПолучитьМакет("Макет");
	
	ВыводитьШапкуОрганизации = Истина;
	ВывестиДанныеПоОрганизации(ПараметрыОтчета, Макет, Результат, 1, ВыводитьШапкуОрганизации);
	
	Результат.ЗакончитьАвтогруппировкуСтрок();
	
	Если Не Отказ Тогда
		БухгалтерскиеОтчетыВызовСервера.ОбработкаРезультатаОтчета(ПараметрыОтчета.ИдентификаторОтчета, Результат);
		Результат.ФиксацияСверху = 0;
		Результат.ФиксацияСлева  = 0;
	КонецЕсли;
	
	ПоместитьВоВременноеХранилище(Новый Структура("Результат, ДанныеРасшифровки", Результат, Неопределено), АдресХранилища);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Формирует выборку данных организации.
//
Функция ПолучитьДанныеОрганизации(ПараметрыОтчета)
	
	ДатаПериода =  ТекущаяДата();	
	
	ИмяРеквизитаБИК = ?(ДатаПериода >= Дата(2010,06,07), "БИК", "БИКДоРеформыБанковскихСчетов");
	
	ЗапросОрг = Новый Запрос();
	ЗапросОрг.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Организации.Ссылка КАК Организация,
	|	Организации.Наименование,
	|	Организации.Префикс,
	|	Организации.РНН,
	|	Организации.ИдентификационныйНомер КАК БИН_ИИН,
	|	Организации.КБе,
	|	ВЫРАЗИТЬ(Организации.НаименованиеПолное КАК СТРОКА(1000)) КАК НаименованиеПолное,
	|	Организации.ЮрФизЛицо,
	|	Организации.ОсновнойБанковскийСчет,
	|	Организации.ОсновнойБанковскийСчет.Наименование,
	|	Организации.ОсновнойБанковскийСчет.НомерСчета,
	|	Организации.ОсновнойБанковскийСчет.Банк."+ИмяРеквизитаБИК+" КАК БанкКод,
	|	Организации.ОсновнойБанковскийСчет.Банк.Наименование,
	|	Организации.ОсновнойБанковскийСчет.Банк.Город,
	|	Организации.ОсновнойБанковскийСчет.Банк.КоррСчет,
	|	Организации.ОсновнойБанковскийСчет.БанкДляРасчетов."+ИмяРеквизитаБИК+" КАК БанкДляРасчетовКод,
	|	Организации.ОсновнойБанковскийСчет.БанкДляРасчетов.Наименование,
	|	Организации.ОсновнойБанковскийСчет.БанкДляРасчетов.Город,
	|	Организации.ОсновнойБанковскийСчет.БанкДляРасчетов.КоррСчет
	|ИЗ
	|	Справочник.Организации КАК Организации
	|ГДЕ
	|	Организации.Ссылка = &Организация";
	
	ЗапросОрг.УстановитьПараметр("Организация", ПараметрыОтчета.Организация);
	ВыборкаОрганизаций = ЗапросОрг.Выполнить().Выбрать();
	
	Возврат ВыборкаОрганизаций;
	
КонецФункции	

// Выводит область с общими настройками.
//
Процедура ВывестиОбщиеНастройки(ПараметрыОтчета, Макет, ТабДокумент, УровеньОрганизации, ВыводитьШапкуОрганизации)
	
	//Запрос по способам оценки запасов
	ЗапросЗапасы = Новый Запрос;
	ЗапросЗапасы.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СпособОценкиЗапасовБУ.СчетЗапасов КАК СчетЗапасов,
	|	СпособОценкиЗапасовБУ.СпособОценки
	|ИЗ
	|	РегистрСведений.СпособОценкиЗапасовБУ КАК СпособОценкиЗапасовБУ
	|
	|УПОРЯДОЧИТЬ ПО
	|	СчетЗапасов";
	
	РезультатЗапасы = ЗапросЗапасы.Выполнить(); 

	Секция = Макет.ПолучитьОбласть("ШапкаНастройки");
	ТабДокумент.Вывести(Секция,УровеньОрганизации);
	
	Секция = Макет.ПолучитьОбласть("ШапкаАналитУчет");
	ТабДокумент.Вывести(Секция,УровеньОрганизации+1);
			
	// если включен признак ВыводитьДопИнф, тогда выводим дополнительные справочные подписи
	//
	Если ПараметрыОтчета.ВыводитьДопИнф Тогда
		Секция = Макет.ПолучитьОбласть("ДопНастройки");
		ТабДокумент.Вывести(Секция,УровеньОрганизации+1);
	КонецЕсли;	

	Секция = Макет.ПолучитьОбласть("Настройки");

	БУ = ПланыСчетов.Типовой.Товары.ПолучитьОбъект();

	ВестиСкладскойУчет  = ?(БУ.ВидыСубконто.Найти(ПланыВидовХарактеристик.ВидыСубконтоТиповые.Склады, "ВидСубконто") = Неопределено, Ложь, Истина);
	Если ВестиСкладскойУчет Тогда
		ВестиСуммовойУчетПоСкладам = БУ.ВидыСубконто.Найти(ПланыВидовХарактеристик.ВидыСубконтоТиповые.Склады, "ВидСубконто").Суммовой;
	Иначе
		ВестиСуммовойУчетПоСкладам = Ложь;
	КонецЕсли;
	
	Секция.Параметры.ВестиСкладскойУчет = ВестиСкладскойУчет;
	Секция.Параметры.ВестиСуммовойУчетПоСкладам = ВестиСуммовойУчетПоСкладам;
	ТабДокумент.Вывести(Секция, УровеньОрганизации+1);   	
	
	//Способ оценки запасов 
	ВыборкаЗапасы = РезультатЗапасы.Выбрать();
	Секция = Макет.ПолучитьОбласть("ШапкаЗапасы");
	ТабДокумент.Вывести(Секция, УровеньОрганизации + 1);
	
	// если включен признак ВыводитьДопИнф, тогда выводим дополнительные справочные подписи
	//
	Если ПараметрыОтчета.ВыводитьДопИнф Тогда
		Секция = Макет.получитьОбласть("ДопЗапасы");
		ТабДокумент.Вывести(Секция, УровеньОрганизации + 1);
	КонецЕсли;	


	Секция = Макет.ПолучитьОбласть("ШапкаТаблицыЗапасы");
	ТабДокумент.Вывести(Секция, УровеньОрганизации + 1);
	Пока ВыборкаЗапасы.Следующий() Цикл		
		
		Секция = Макет.ПолучитьОбласть("Запасы");
		Секция.Параметры.СчетЗапасов = ВыборкаЗапасы.СчетЗапасов;
		Секция.Параметры.СпособОценки = ВыборкаЗапасы.СпособОценки;						
		ТабДокумент.Вывести(Секция, УровеньОрганизации + 1);
		
	КонецЦикла;

Конецпроцедуры

// Выводит общие сведения организации.
//
Процедура ВывестиОбщиеСведения(ПараметрыОтчета, ДанныеОрганизации, Макет, ТабДокумент, УровеньОрганизации, ВыводитьШапкуОрганизации)
	
	Если ДанныеОрганизации.Следующий() Тогда
		
		Если ВыводитьШапкуОрганизации Тогда
			ШапкаОрганизаци = Макет.ПолучитьОбласть("ШапкаОрганизации");
			ТабДокумент.Вывести(ШапкаОрганизаци, УровеньОрганизации);			
			ВыводитьШапкуОрганизации = Ложь;
		КонецЕсли;	
		
		ОбластьМакета = Макет.ПолучитьОбласть("ШапкаОбщиеСведения");
		ТабДокумент.Вывести(ОбластьМакета, УровеньОрганизации+1);
		
		// если включен признак ВыводитьДопИнф, тогда выводим дополнительные справочные подписи
		//
		Если ПараметрыОтчета.ВыводитьДопИнф Тогда
			ОбластьМакета = Макет.получитьОбласть("ДопОбщиеСведения");
			ТабДокумент.Вывести(ОбластьМакета, УровеньОрганизации+1);
		КонецЕсли;	
		
		ОбластьМакета = Макет.ПолучитьОбласть("ОбщиеСведения");
		ОбластьМакета.Параметры.ОргНаименование = ?(НЕ ЗначениеЗаполнено(ДанныеОрганизации.Наименование ), НСтр("ru = '<Наименование не заполнено>'"), ДанныеОрганизации.Наименование );
		ОбластьМакета.Параметры.ОргНаименованиеПолное = ?(НЕ ЗначениеЗаполнено(ДанныеОрганизации.НаименованиеПолное ), "", ДанныеОрганизации.НаименованиеПолное );
		ОбластьМакета.Параметры.ЮрФизЛицо = ?(НЕ ЗначениеЗаполнено(ДанныеОрганизации.ЮрФизЛицо ), "", ДанныеОрганизации.ЮрФизЛицо );
		ОбластьМакета.Параметры.Префикс = ?(НЕ ЗначениеЗаполнено(ДанныеОрганизации.Префикс ), "", ДанныеОрганизации.Префикс );
		ОбластьМакета.Параметры.РНН = ?(НЕ ЗначениеЗаполнено(ДанныеОрганизации.РНН ), "", ДанныеОрганизации.РНН );
		ОбластьМакета.Параметры.КБЕ = ?(НЕ ЗначениеЗаполнено(ДанныеОрганизации.КБЕ ), "", ДанныеОрганизации.КБЕ );
		ОбластьМакета.Параметры.БИН_ИИН = ?(НЕ ЗначениеЗаполнено(ДанныеОрганизации.БИН_ИИН ), "", ДанныеОрганизации.БИН_ИИН );
		
		ТабДокумент.Вывести(ОбластьМакета, УровеньОрганизации+2);
		
	КонецЕсли;	

КонецПроцедуры	

// Выводит основной банковский счет организации.
//
Процедура ВывестиОсновнойБС(ПараметрыОтчета, ДанныеОрганизации, Макет, ТабДокумент, УровеньОрганизации, ВыводитьШапкуОрганизации)
	
	Если ДанныеОрганизации.Следующий() Тогда
		
		Если ВыводитьШапкуОрганизации Тогда
			ШапкаОрганизаци = Макет.ПолучитьОбласть("ШапкаОрганизации");
			ТабДокумент.Вывести(ШапкаОрганизаци, УровеньОрганизации);			
			ВыводитьШапкуОрганизации = Ложь;
		КонецЕсли;	
		
		ОбластьМакета = Макет.ПолучитьОбласть("ШапкаОсновнойБанковскийСчет");
		ТабДокумент.Вывести(ОбластьМакета, УровеньОрганизации + 1);
		
		// если включен признак ВыводитьДопИнф, тогда выводим дополнительные справочные подписи
		//
		Если ПараметрыОтчета.ВыводитьДопИнф Тогда
			ОбластьМакета = Макет.ПолучитьОбласть("ДопОсновнойБанковскийСчет");
			ТабДокумент.Вывести(ОбластьМакета,УровеньОрганизации + 1);
		КонецЕсли;	
		
		ОбластьМакета = Макет.ПолучитьОбласть("ОсновнойБанковскийСчет");
		ОбластьМакета.Параметры.БСНаименование = ?(НЕ ЗначениеЗаполнено(ДанныеОрганизации.ОсновнойБанковскийСчетНаименование ), "", ДанныеОрганизации.ОсновнойБанковскийСчетНаименование );
		ОбластьМакета.Параметры.БСНомер = ?(НЕ ЗначениеЗаполнено(ДанныеОрганизации.ОсновнойБанковскийСчетНомерСчета ), "", ДанныеОрганизации.ОсновнойБанковскийСчетНомерСчета );
		ОбластьМакета.Параметры.БанкНаименование = ?(НЕ ЗначениеЗаполнено(ДанныеОрганизации.ОсновнойБанковскийСчетБанкНаименование), "", ДанныеОрганизации.ОсновнойБанковскийСчетБанкНаименование) +
		" " + ?(НЕ ЗначениеЗаполнено(ДанныеОрганизации.ОсновнойБанковскийСчетБанкГород), "", ДанныеОрганизации.ОсновнойБанковскийСчетБанкГород);
		ОбластьМакета.Параметры.БанкБИК = ?(НЕ ЗначениеЗаполнено(ДанныеОрганизации.БанкКод), "", ДанныеОрганизации.БанкКод);
		ОбластьМакета.Параметры.БанкСчет = ?(НЕ ЗначениеЗаполнено(ДанныеОрганизации.ОсновнойБанковскийСчетБанкКоррСчет ), "", ДанныеОрганизации.ОсновнойБанковскийСчетБанкКоррСчет );
		
		ОбластьМакета.Параметры.БанкКоррНаименование = ?(НЕ ЗначениеЗаполнено(ДанныеОрганизации.ОсновнойБанковскийСчетБанкДляРасчетовНаименование), "", ДанныеОрганизации.ОсновнойБанковскийСчетБанкДляРасчетовНаименование) +
		" " + ?(НЕ ЗначениеЗаполнено(ДанныеОрганизации.ОсновнойБанковскийСчетБанкДляРасчетовГород), "", ДанныеОрганизации.ОсновнойБанковскийСчетБанкДляРасчетовГород);
		ОбластьМакета.Параметры.БанкКоррБИК = ?(НЕ ЗначениеЗаполнено(ДанныеОрганизации.БанкДляРасчетовКод), "", ДанныеОрганизации.БанкДляРасчетовКод);
		ОбластьМакета.Параметры.БанкКоррСчет = ?(НЕ ЗначениеЗаполнено(ДанныеОрганизации.ОсновнойБанковскийСчетБанкДляРасчетовКоррСчет), "", ДанныеОрганизации.ОсновнойБанковскийСчетБанкДляРасчетовКоррСчет);
		
		ТабДокумент.Вывести(ОбластьМакета, УровеньОрганизации+2);
		
	КонецЕсли;	

КонецПроцедуры	

// Выводит записи учетной политики по БУ.
//
Процедура ВывестиУПБУ(ПараметрыОтчета, Макет, ТабДокумент, УровеньОрганизации, ВыводитьШапкуОрганизации)
	
	Если ВыводитьШапкуОрганизации Тогда
		ШапкаОрганизаци = Макет.ПолучитьОбласть("ШапкаОрганизации");
		ТабДокумент.Вывести(ШапкаОрганизаци, УровеньОрганизации);			
		ВыводитьШапкуОрганизации = Ложь;
	КонецЕсли;	
		
	//Запрос по учетной политику БУ
	ЗапросУПБУ = Новый Запрос;
	ЗапросУПБУ.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	УчетнаяПолитикаБухгалтерскийУчет.СпособРасчетаСебестоимостиПроизводства,
	|	УчетнаяПолитикаБухгалтерскийУчет.УчетВременныхРазницПоНалогуНаПрибыль,
	|	УчетнаяПолитикаБухгалтерскийУчет.Организация КАК Организация,
	|	УчетнаяПолитикаБухгалтерскийУчет.Период КАК Период
	|ИЗ
	|	РегистрСведений.УчетнаяПолитикаБухгалтерскийУчет КАК УчетнаяПолитикаБухгалтерскийУчет
	|ГДЕ
	|	УчетнаяПолитикаБухгалтерскийУчет.Организация = &Организация
	|
	|УПОРЯДОЧИТЬ ПО
	|	Период
	|";
	
	ЗапросУПБУ.УстановитьПараметр("Организация", ПараметрыОтчета.Организация);
	РезультатУПБУ = ЗапросУпБУ.Выполнить();
	
	//Учетная политика БУ 
	ВыборкаУПБУ = РезультатУПБУ.Выбрать();
	
	ОбластьМакета = Макет.ПолучитьОбласть("ШапкаУПБУ");
	ТабДокумент.Вывести(ОбластьМакета, УровеньОрганизации+1);
	
	// если включен признак ВыводитьДопИнф, тогда выводим дополнительные справочные подписи
	//
	Если ПараметрыОтчета.ВыводитьДопИнф Тогда
		ОбластьМакета = Макет.ПолучитьОбласть("ДопУПБУ");
		ТабДокумент.Вывести(ОбластьМакета,УровеньОрганизации + 1);
	КонецЕсли;
		
	ОбластьМакета = Макет.ПолучитьОбласть("ШапкаТаблицыУПБУ");
	ТабДокумент.Вывести(ОбластьМакета, УровеньОрганизации+2);
	
	ОбластьМакета = Макет.ПолучитьОбласть("УПБУ");
	
	Пока ВыборкаУПБУ.Следующий() Цикл
		
		ОбластьМакета.Параметры.ПериодУПБУ 		= Формат(ВыборкаУПБУ.Период, "ДЛФ=DD");
		ОбластьМакета.Параметры.СпособРасчетаСебестоимостиПроизводства = ВыборкаУПБУ.СпособРасчетаСебестоимостиПроизводства;
		ОбластьМакета.Параметры.УчетВрБУ	    					   = ?(ВыборкаУПБУ.УчетВременныхРазницПоНалогуНаПрибыль, НСтр("ru = 'Да'"), НСтр("ru = 'Нет'"));
		
		ТабДокумент.Вывести(ОбластьМакета, УровеньОрганизации+2);
		
	КонецЦикла;

	
КонецПроцедуры	

// Выводит записи учетной политики по НУ.
//
Процедура ВывестиУПНУ(ПараметрыОтчета, Макет, ТабДокумент, УровеньОрганизации, ВыводитьШапкуОрганизации)
	
	Если ВыводитьШапкуОрганизации Тогда
		ШапкаОрганизаци = Макет.ПолучитьОбласть("ШапкаОрганизации");
		ТабДокумент.Вывести(ШапкаОрганизаци, УровеньОрганизации);			
		ВыводитьШапкуОрганизации = Ложь;
	КонецЕсли;	
	
	//Запрос по учетной политику НУ
	ЗапросУПНУ = Новый Запрос;
	ЗапросУПНУ.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	УчетнаяПолитикаНалоговыйУчет.Организация КАК Организация,
	|	УчетнаяПолитикаНалоговыйУчет.Период КАК Период,
	|	УчетнаяПолитикаНалоговыйУчет.НДСНалоговыйПериод,
	|	УчетнаяПолитикаНалоговыйУчет.НДСМетодОтнесенияВЗачет,
	|	УчетнаяПолитикаНалоговыйУчет.ОрганизацияЯвляетсяПлательщикомНДС,
	|	УчетнаяПолитикаНалоговыйУчет.ОрганизацияЯвляетсяПлательщикомКПН,
	|	УчетнаяПолитикаНалоговыйУчет.ОрганизацияЯвляетсяПлательщикомАкциза,
	|	УчетнаяПолитикаНалоговыйУчет.УпрощенныйУчетИПНиОПВ,
	|	УчетнаяПолитикаНалоговыйУчет.ОтражениеПоПериодуРегистрации,
	|	УчетнаяПолитикаНалоговыйУчет.ЗасчитыватьВВыплаченныеДоходыУдержанияПоИЛ,
	|	УчетнаяПолитикаНалоговыйУчет.ОрганизацияЯвляетсяПлательщикомСН,
	|	УчетнаяПолитикаНалоговыйУчет.Организация.ЮрФизЛицо КАК ЮрФизЛицо,
	|	УчетнаяПолитикаНалоговыйУчет.КоэффициентМРПДляРасчетаСНЗаИндивидуальногоПредпринимателя,
	|	УчетнаяПолитикаНалоговыйУчет.КоэффициентМРПДляРасчетаСНЗаНаемногоРаботника
	|ИЗ
	|	РегистрСведений.УчетнаяПолитикаНалоговыйУчет КАК УчетнаяПолитикаНалоговыйУчет
	|ГДЕ
	|	УчетнаяПолитикаНалоговыйУчет.Организация = &Организация
	|
	|УПОРЯДОЧИТЬ ПО
	|	Период
	|";
	
	ЗапросУПНУ.УстановитьПараметр("Организация", ПараметрыОтчета.Организация); 
	РезультатУПНУ = ЗапросУПНУ.Выполнить();
	
	//Учетная политика НУ 
	ВыборкаУПНУ = РезультатУПНУ.Выбрать();
	ОбластьМакета = Макет.ПолучитьОбласть("ШапкаУПНУ");
	ТабДокумент.Вывести(ОбластьМакета, УровеньОрганизации+1); 		
	
	// если включен признак ВыводитьДопИнф, тогда выводим дополнительные справочные подписи
	//
	Если ПараметрыОтчета.ВыводитьДопИнф Тогда
		ОбластьМакета = Макет.получитьОбласть("ДопУПНУ");
		ТабДокумент.Вывести(ОбластьМакета, УровеньОрганизации+1);
	КонецЕсли;	
	
	ОбластьМакета = Макет.ПолучитьОбласть("ШапкаТаблицыУПНУ");
	ТабДокумент.Вывести(ОбластьМакета, УровеньОрганизации+2);	
	
	Пока ВыборкаУПНУ.Следующий() Цикл
		
		ОбластьМакета = Макет.ПолучитьОбласть("УПНУ");
		ОбластьМакета.Параметры.ПериодУПНУ 									= Формат(ВыборкаУПНУ.Период, "ДЛФ=DD");
		ОбластьМакета.Параметры.ОрганизацияЯвляетсяПлательщикомНДС	  		= ?(ВыборкаУПНУ.ОрганизацияЯвляетсяПлательщикомНДС, НСтр("ru = 'Да'"), НСтр("ru = 'Нет'"));
		ОбластьМакета.Параметры.ОрганизацияЯвляетсяПлательщикомКПН	  		= ?(ВыборкаУПНУ.ОрганизацияЯвляетсяПлательщикомКПН, НСтр("ru = 'Да'"), НСтр("ru = 'Нет'"));
		ОбластьМакета.Параметры.ОрганизацияЯвляетсяПлательщикомАкциза 		= ?(ВыборкаУПНУ.ОрганизацияЯвляетсяПлательщикомАкциза, НСтр("ru = 'Да'"), НСтр("ru = 'Нет'"));
		ОбластьМакета.Параметры.НДСНалоговыйПериод 					  		= ВыборкаУПНУ.НДСНалоговыйПериод;
		ОбластьМакета.Параметры.НДСМетодОтнесенияВЗачет 			  		= ВыборкаУПНУ.НДСМетодОтнесенияВЗачет;
		ОбластьМакета.Параметры.УпрощенныйУчетИПНиОПВ				  		= ?(ВыборкаУПНУ.УпрощенныйУчетИПНиОПВ, НСтр("ru = 'Да'"), НСтр("ru = 'Нет'"));
		ОбластьМакета.Параметры.ОтражениеПоПериодуРегистрации		  		= ?(ВыборкаУПНУ.ОтражениеПоПериодуРегистрации, НСтр("ru = 'Да'"), НСтр("ru = 'Нет'"));
		ОбластьМакета.Параметры.ЗасчитыватьВВыплаченныеДоходыУдержанияПоИЛ	= ?(ВыборкаУПНУ.ЗасчитыватьВВыплаченныеДоходыУдержанияПоИЛ, НСтр("ru = 'Да'"), НСтр("ru = 'Нет'"));

		ОбластьМакета.Параметры.КоэффициентМРПДляРасчетаСНЗаИндивидуальногоПредпринимателя 	= "";
		ОбластьМакета.Параметры.КоэффициентМРПДляРасчетаСНЗаНаемногоРаботника 				= "";
		
		Если ВыборкаУПНУ.ОрганизацияЯвляетсяПлательщикомСН Тогда
			Если ВыборкаУПНУ.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ФизЛицо Тогда
				ОбластьМакета.Параметры.ПорядокРасчетаСН 	= НСтр("ru = 'Общеустановленный для ИП'");
				ОбластьМакета.Параметры.КоэффициентМРПДляРасчетаСНЗаИндивидуальногоПредпринимателя 	= ВыборкаУПНУ.КоэффициентМРПДляРасчетаСНЗаИндивидуальногоПредпринимателя;
				ОбластьМакета.Параметры.КоэффициентМРПДляРасчетаСНЗаНаемногоРаботника 				= ВыборкаУПНУ.КоэффициентМРПДляРасчетаСНЗаНаемногоРаботника;
			Иначе
				ОбластьМакета.Параметры.ПорядокРасчетаСН 	= НСтр("ru = 'Общеустановленный для ЮЛ'");
			КонецЕсли;
		Иначе
			Если ВыборкаУПНУ.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ФизЛицо Тогда
				ОбластьМакета.Параметры.ПорядокРасчетаСН 	= НСтр("ru = 'Упрощенная декларация для ИП'");
			Иначе
				ОбластьМакета.Параметры.ПорядокРасчетаСН 	= НСтр("ru = 'Упрощенная декларация для ЮЛ'");
			КонецЕсли;
		КонецЕсли;
		
		ТабДокумент.Вывести(ОбластьМакета, УровеньОрганизации+2);  			
	КонецЦикла;

	
	
КонецПроцедуры	

// Выводит записи учетной политики по персоналу организации.
// 
Процедура ВывестиУППоПерсоналу(ПараметрыОтчета, Макет, ТабДокумент, УровеньОрганизации, ВыводитьШапкуОрганизации)
	
	Если ВыводитьШапкуОрганизации Тогда
		ШапкаОрганизаци = Макет.ПолучитьОбласть("ШапкаОрганизации");
		ТабДокумент.Вывести(ШапкаОрганизаци, УровеньОрганизации);			
		ВыводитьШапкуОрганизации = Ложь;
	КонецЕсли;	
		
	//Запрос по учетной политику по персоналу организации
	ЗапросПоПерсоналу =  Новый Запрос;
	ЗапросПоПерсоналу.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	УчетнаяПолитикаПоПерсоналуОрганизаций.Организация КАК Организация,
	|	УчетнаяПолитикаПоПерсоналуОрганизаций.ВестиУчетПоГоловнойОрганизации
	|ИЗ
	|	РегистрСведений.УчетнаяПолитикаПоПерсоналуОрганизаций КАК УчетнаяПолитикаПоПерсоналуОрганизаций
	|ГДЕ
	|	УчетнаяПолитикаПоПерсоналуОрганизаций.Организация = &Организация
	|";
	
	ЗапросПоПерсоналу.УстановитьПараметр("Организация", ПараметрыОтчета.Организация);
	РезультатПоПерсоналу = ЗапросПоПерсоналу.Выполнить();
	
	//Учетная политика по персоналу организации
		
	ВыборкаПоПерсоналу = РезультатПоПерсоналу.Выбрать();
	ОбластьМакета = Макет.ПолучитьОбласть("ШапкаУППерсонал");
	ТабДокумент.Вывести(ОбластьМакета, УровеньОрганизации+1); 		
	
	// если включен признак ВыводитьДопИнф, тогда выводим дополнительные справочные подписи
	//
	Если ПараметрыОтчета.ВыводитьДопИнф Тогда
		ОбластьМакета = Макет.получитьОбласть("ДопУППерсонал");
		ТабДокумент.Вывести(ОбластьМакета, УровеньОрганизации+1);
	КонецЕсли;	
	
	ОбластьМакета = Макет.ПолучитьОбласть("ШапкаТаблицыУППерсонал");
	ТабДокумент.Вывести(ОбластьМакета, УровеньОрганизации+2);
	
	Пока ВыборкаПоПерсоналу.Следующий() Цикл
		
		ОбластьМакета = Макет.ПолучитьОбласть("УППерсонал");
		
		ОбластьМакета.Параметры.ВестиУчетПоГоловнойОрганизации = ?(ВыборкаПоПерсоналу.ВестиУчетПоГоловнойОрганизации, НСтр("ru = 'Да'"), НСтр("ru = 'Нет'"));
		
		ТабДокумент.Вывести(ОбластьМакета, УровеньОрганизации+2);
		
	КонецЦикла;
	
КонецПроцедуры	

// Выводит список всей контактной информации организации.
//
Процедура ВывестиКИ(ПараметрыОтчета, Макет, ТабДокумент, УровеньОрганизации, ВыводитьШапкуОрганизации)
	
	Если ВыводитьШапкуОрганизации Тогда
		ШапкаОрганизаци = Макет.ПолучитьОбласть("ШапкаОрганизации");
		ТабДокумент.Вывести(ШапкаОрганизаци, УровеньОрганизации);			
		ВыводитьШапкуОрганизации = Ложь;
	КонецЕсли;	
		
	//запрос по контактной информации	
	ЗапросКИ = Новый Запрос();
	ЗапросКИ.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КонтактнаяИнформация.Объект КАК Организация,
	|	КонтактнаяИнформация.Вид,
	|	ВЫРАЗИТЬ(КонтактнаяИнформация.Представление КАК СТРОКА(1000)) КАК Представление
	|ИЗ
	|	РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
	|ГДЕ
	|	//КонтактнаяИнформация.Объект ССЫЛКА Справочник.Организации
	|	КонтактнаяИнформация.Объект = &Организация
	|";
	
	ЗапросКИ.УстановитьПараметр("Организация", ПараметрыОтчета.Организация);
	РезультатКИ = ЗапросКИ.Выполнить();

	//КИ
	ВыборкаКИ = РезультатКИ.Выбрать(ОбходРезультатаЗапроса.Прямой);
	ОбластьМакета = Макет.ПолучитьОбласть("ШапкаКИ");
	ТабДокумент.Вывести(ОбластьМакета, УровеньОрганизации+1);
	
	// если включен признак ВыводитьДопИнф, тогда выводим дополнительные справочные подписи
	//
	Если ПараметрыОтчета.ВыводитьДопИнф Тогда
		ОбластьМакета = Макет.получитьОбласть("ДопКИ");
		ТабДокумент.Вывести(ОбластьМакета, УровеньОрганизации+1);
	КонецЕсли;	
	
	ОбластьМакета = Макет.ПолучитьОбласть("ШапкаТаблицыКИ");
	ТабДокумент.Вывести(ОбластьМакета, УровеньОрганизации+2);
	
	Пока ВыборкаКИ.Следующий() Цикл
		Если НЕ ЗначениеЗаполнено(ВыборкаКИ.Вид) Тогда
			Продолжить;
		КонецЕсли;
		
		ОбластьМакета = Макет.ПолучитьОбласть("КИ");
		ОбластьМакета.Параметры.Вид = ВыборкаКИ.Вид;
		ОбластьМакета.Параметры.Представление = ВыборкаКИ.Представление;
		
		ТабДокумент.Вывести(ОбластьМакета, УровеньОрганизации+2);
		
	КонецЦикла;
	
	ОбластьМакета = Макет.ПолучитьОбласть("ПодвалКИ");
	ТабДокумент.Вывести(ОбластьМакета, УровеньОрганизации+1);

	
КонецПроцедуры	

// Выводит ответственные лица организации.
//
Процедура ВывестиОЛ(ПараметрыОтчета, Макет, ТабДокумент, УровеньОрганизации, ВыводитьШапкуОрганизации)
	
	Если ВыводитьШапкуОрганизации Тогда
		ШапкаОрганизаци = Макет.ПолучитьОбласть("ШапкаОрганизации");
		ТабДокумент.Вывести(ШапкаОрганизаци, УровеньОрганизации);			
		ВыводитьШапкуОрганизации = Ложь;
	КонецЕсли;	
		
	//запрос по ответсвенным лицам
	ЗапросОЛ = Новый Запрос();
	ЗапросОЛ.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ОтветственныеЛицаОрганизаций.Период КАК Период,
	|	ОтветственныеЛицаОрганизаций.СтруктурнаяЕдиница КАК Организация,
	|	ОтветственныеЛицаОрганизаций.ОтветственноеЛицо КАК ОтветственноеЛицо,
	|	ОтветственныеЛицаОрганизаций.ФизическоеЛицо,
	|	ОтветственныеЛицаОрганизаций.Должность
	|ИЗ
	|	РегистрСведений.ОтветственныеЛицаОрганизаций КАК ОтветственныеЛицаОрганизаций
	|ГДЕ
	|	//ОтветственныеЛицаОрганизаций.СтруктурнаяЕдиница ССЫЛКА Справочник.Организации
	|	ОтветственныеЛицаОрганизаций.СтруктурнаяЕдиница = &Организация
	|
	|УПОРЯДОЧИТЬ ПО
	|	ОтветственноеЛицо,
	|	Период";
	
	ЗапросОЛ.УстановитьПараметр("Организация", ПараметрыОтчета.Организация);
	РезультатОЛ = ЗапросОЛ.Выполнить();
	
	//ОЛ
	ВыборкаОЛ = РезультатОЛ.Выбрать(ОбходРезультатаЗапроса.Прямой);
	ОбластьМакета = Макет.ПолучитьОбласть("ШапкаОЛ");
	ТабДокумент.Вывести(ОбластьМакета, УровеньОрганизации+1);
	
	// если включен признак ВыводитьДопИнф, тогда выводим дополнительные справочные подписи
	//
	Если ПараметрыОтчета.ВыводитьДопИнф Тогда
		ОбластьМакета = Макет.получитьОбласть("ДопОЛ");
		ТабДокумент.Вывести(ОбластьМакета, УровеньОрганизации+1);
	КонецЕсли;	
	
	ОбластьМакета = Макет.ПолучитьОбласть("ШапкаТаблицыОЛ");
	ТабДокумент.Вывести(ОбластьМакета, УровеньОрганизации+2);
						
	Пока ВыборкаОЛ.Следующий() Цикл
		
		ОбластьМакета = Макет.ПолучитьОбласть("ОЛ");
		ОбластьМакета.Параметры.ПериодОЛ = Формат(ВыборкаОЛ.Период, "ДЛФ=DD");
		ОбластьМакета.Параметры.ОтветственноеЛицо = ВыборкаОЛ.ОтветственноеЛицо;
		ОбластьМакета.Параметры.ФизическоеЛицо = ВыборкаОЛ.ФизическоеЛицо;
		ОбластьМакета.Параметры.Должность = ВыборкаОЛ.Должность;
		
		ТабДокумент.Вывести(ОбластьМакета, УровеньОрганизации+2);
		
	КонецЦикла;
	
	ОбластьМакета = Макет.ПолучитьОбласть("ПодвалОЛ");
	ТабДокумент.Вывести(ОбластьМакета, УровеньОрганизации+1);
	
КонецПроцедуры	
    
// Процедура заполняет поле табличного документа
//
// Переметры
//  Таб - поле табличного документа
//  ПорядковыйНомер - порядковый номер выводимого параметра
//  Имя - строка, имя выводимого параметра
//
// Возвращаемое значение
//  НЕТ
Процедура ВывестиДанные(ПараметрыОтчета, Таб, Имя, УровеньОрганизации, ВыводитьШапкуОрганизации)

	Макет = ПолучитьМакет("Макет");
	
	ДанныеОрганизации = ПолучитьДанныеОрганизации(ПараметрыОтчета);
	
	Если Имя = "ОбщиеНастройки" Тогда
		ВывестиОбщиеНастройки(ПараметрыОтчета, Макет, Таб, УровеньОрганизации, ВыводитьШапкуОрганизации);
	ИначеЕсли Имя = "ОбщиеСведения"	Тогда
		ВывестиОбщиеСведения(ПараметрыОтчета, ДанныеОрганизации, Макет, Таб, УровеньОрганизации, ВыводитьШапкуОрганизации);
	ИначеЕсли Имя = "ОсновнойБанковскийСчет" Тогда
		ВывестиОсновнойБС(ПараметрыОтчета, ДанныеОрганизации, Макет, Таб, УровеньОрганизации, ВыводитьШапкуОрганизации);
	ИначеЕсли Имя = "УчПолитикаБух" Тогда	
		ВывестиУПБУ(ПараметрыОтчета, Макет, Таб, УровеньОрганизации, ВыводитьШапкуОрганизации);
	ИначеЕсли Имя = "УчПолитикаНал" Тогда	
		ВывестиУПНУ(ПараметрыОтчета, Макет, Таб, УровеньОрганизации, ВыводитьШапкуОрганизации);
	ИначеЕсли Имя = "УчПолитикаПоПерсоналу" Тогда	
		ВывестиУППоПерсоналу(ПараметрыОтчета, Макет, Таб, УровеньОрганизации, ВыводитьШапкуОрганизации);
	ИначеЕсли Имя = "КонтИнф" Тогда	
		ВывестиКИ(ПараметрыОтчета, Макет, Таб, УровеньОрганизации, ВыводитьШапкуОрганизации);
	Иначе
		ВывестиОЛ(ПараметрыОтчета, Макет, Таб, УровеньОрганизации, ВыводитьШапкуОрганизации);
	КонецЕсли;
	
КонецПроцедуры

Процедура ВывестиДанныеПоОрганизации(ПараметрыОтчета, Макет, Таб, УровеньОрганизации, ВыводитьШапкуОрганизации)
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.Организация) Тогда
	
		//Шапка
		Секция = Макет.ПолучитьОбласть("Шапка");
		Секция.Параметры.НаимОрганизации = ПараметрыОтчета.Организация.НаименованиеПолное;
		Таб.Вывести(Секция, УровеньОрганизации);
		
		Для Каждого СтрокаНастройки Из ПараметрыОтчета.СписокНастроек Цикл
			
			Если Не СтрокаНастройки.Пометка Тогда
				Продолжить;
			КонецЕсли;
			
			ВывестиДанные(ПараметрыОтчета, Таб, СтрокаНастройки.Значение, УровеньОрганизации, ВыводитьШапкуОрганизации);
			
		КонецЦикла;	
		
	КонецЕсли;	
	
КонецПроцедуры

#КонецЕсли