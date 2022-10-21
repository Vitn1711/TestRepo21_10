#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьПредопределенныеЭлементы() Экспорт
	
	ЗаполнитьЭлемент("ВычетОПВ"												, 1, "ПоИсчисленнойСуммеВзносов", "ОбязательныеПенсионныеВзносы", 0 , "ВПределахМесяца"			 , Ложь);
	ЗаполнитьЭлемент("ВычетВОСМС"											, 2, "ПоИсчисленнойСуммеВзносов", "ВзносыОбязательноеСоциальноеМедицинскоеСтрахование", 0 , "ВПределахМесяца", Ложь);
	ЗаполнитьЭлемент("Стандартный1МЗП"										, 3, "Стандартный"				, ""							, 1 , "ВПределахМесяца"			 , Ложь);
	ЗаполнитьЭлемент("Стандартный75МЗПИнвалиды"								, 4, "Стандартный"				, ""							, 75, "ВПределахКалендарногоГода", Ложь);
	ЗаполнитьЭлемент("Стандартный75МЗПРодители"								, 5, "Стандартный"				, ""							, 75, "ВПределахКалендарногоГода", Ложь);
	ЗаполнитьЭлемент("ДобровольныеПенсионныеВзносы"							, 6, "ПоПериодическимПлатежам"	, ""							, 0 , "ВПределахМесяца"			 , Ложь);
	ЗаполнитьЭлемент("НаОплатуМедицинскихУслуг"								, 7, "ПоПериодическимПлатежам"	, ""							, 8 , "ВПределахКалендарногоГода", Ложь);
	ЗаполнитьЭлемент("ПогашениеВознагражденияПоЖилищнымЗаймам"				, 8, "ПоПериодическимПлатежам"	, ""							, 0 , "ВПределахМесяца"			 , Ложь);
	ЗаполнитьЭлемент("СтраховыеПремииПоДоговорамНакопительногоСтрахования"	, 9, ""							, ""							, 0	, ""						 , Истина);
	
КонецПроцедуры	

Процедура ЗаполнитьЭлемент(ИмяЭлемента, Приоритет, ПредоставлениеВычета, ВидВзносов, ПределВычета, ПериодПредоставления, НеИспользуется)
	
	СправочникОъект 			= Справочники.ВычетыИПН[ИмяЭлемента].ПолучитьОбъект();
	СправочникОъект.Приоритет	= Приоритет;
	Если НеИспользуется Тогда
		СправочникОъект.НеИспользуется	= Истина;
	Иначе
		СправочникОъект.ПредоставлениеВычета = Перечисления.ВидыПредоставленияВычетов[ПредоставлениеВычета];
		Если  ВидВзносов <> "" Тогда
			СправочникОъект.ВидВзносов 		 = Справочники.НалогиСборыОтчисления[ВидВзносов];
		КонецЕсли;	
		СправочникОъект.ПределВычета		 = ПределВычета;
		СправочникОъект.ПериодПредоставления = Перечисления.ПериодыРасчетаВычетовИКорректировокДоходов[ПериодПредоставления];
	КонецЕсли;
	
	СправочникОъект.ОбменДанными.Загрузка= Истина;
	
	Попытка
		СправочникОъект.Записать();
	Исключение
		ТекстСообщения = НСтр("ru='Операция не выполнена'");
		ЗаписьЖурналаРегистрации(ТекстСообщения, УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
КонецПроцедуры	

Функция МаксимальныйПриоритет() Экспорт 
	Запрос		 = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	|	МАКСИМУМ(ВычетыИПН.Приоритет) КАК Приоритет
	|ИЗ
	|	Справочник.ВычетыИПН КАК ВычетыИПН";
	
	
	ВыборкаЗапроса = Запрос.Выполнить().Выбрать();
	
	Если ВыборкаЗапроса.Следующий() Тогда
		Возврат ВыборкаЗапроса.Приоритет;
	Иначе
		Возврат 0;
	КонецЕсли;	
КонецФункции

Процедура ОбновитьСправочникВычетыИПНИПН2019() Экспорт 
	
	Стандартный75МЗПИнвалидыОбъект = Справочники.ВычетыИПН.Стандартный75МЗПИнвалиды.ПолучитьОбъект();
	Стандартный75МЗПИнвалидыобъект.Наименование = НСтр("ru = 'Стандартный вычет (инвалидам, участникам ВОВ)'");
	Стандартный75МЗПИнвалидыобъект.ОбменДанными.Загрузка = Истина;
	Стандартный75МЗПИнвалидыобъект.Записать();
	
	Стандартный75МЗПРодителиОбъект = Справочники.ВычетыИПН.Стандартный75МЗПРодители.ПолучитьОбъект();
	Стандартный75МЗПРодителиОбъект.Наименование = НСтр("ru = 'Стандартный вычет (родителям инвалидов, приемным родителям)'");
	Стандартный75МЗПРодителиОбъект.ОбменДанными.Загрузка = Истина;
	Стандартный75МЗПРодителиОбъект.Записать();
	
КонецПроцедуры

Процедура ЗаполнитьВычетВОСМС() Экспорт
	
	Если НЕ ПланыОбмена.ГлавныйУзел() = Неопределено Тогда // В подчиненных узлах РИБ не выполняется
		Возврат;	
	КонецЕсли;
	
	Справочники.ВычетыИПН.ЗаполнитьПредопределенныеЭлементы();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВидыВычетовИПН.Ссылка КАК Ссылка,
		|	ВидыВычетовИПН.Приоритет КАК Приоритет
		|ИЗ
		|	Справочник.ВычетыИПН КАК ВидыВычетовИПН
		|ГДЕ
		|	НЕ ВидыВычетовИПН.Предопределенный
		|
		|УПОРЯДОЧИТЬ ПО
		|	ВидыВычетовИПН.Приоритет УБЫВ";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ВычетИПН = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
		ВычетИПН.Приоритет = ВыборкаДетальныеЗаписи.Приоритет + 1;
		ВычетИПН.ОбменДанными.Загрузка = Истина;
		Попытка
			ВычетИПН.Записать();
		Исключение
			ТекстСообщения = НСтр("ru='Операция не выполнена'");
			ЗаписьЖурналаРегистрации(ТекстСообщения, УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли