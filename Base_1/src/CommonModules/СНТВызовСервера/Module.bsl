
#Область РаботаСВнешнйОбработкой

Функция ИспользоватьВнешнююОбработку() Экспорт
	Возврат СНТСерверПереопределяемый.ИспользоватьВнешнююОбработку();	
КонецФункции

Функция ПодключитьВнешнююОбработку() Экспорт
	Возврат СНТСерверПереопределяемый.ПодключитьВнешнююОбработку();	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СгруппироватьСНТПоСтруктурнымЕдиницам(Знач МассивСНТ, ОткрыватьСессиюФилиаломПолучателем = Ложь) Экспорт
	
	ОбработкаОбменСНТ = СНТСерверПовтИсп.ОбработкаОбменСНТ();
	КоллекцияСгруппированныхСНТ = ОбработкаОбменСНТ.Переопределяемый_СгруппироватьСНТПоСтруктурнымЕдиницам(МассивСНТ, ОткрыватьСессиюФилиаломПолучателем);
	Возврат КоллекцияСгруппированныхСНТ;
	
КонецФункции

Функция СоздатьСписокПервичныхДокументов(ПараметрыСоздания) Экспорт
	Возврат СНТСерверПовтИсп.ОбработкаОбменСНТ().СоздатьСписокПервичныхДокументов(ПараметрыСоздания);	
КонецФункции

Функция МассивСНТСДокументомОснованияИБез(МассивСНТ) Экспорт
	 Возврат СНТСервер.МассивСНТСДокументомОснованияИБез(МассивСНТ);	
КонецФункции

Функция СгруппироватьСопоставленияСНТПоСтруктурнымЕдиницам(Знач МассивСопоставленийСНТ, ОткрыватьСессиюФилиаломПолучателем = Ложь) Экспорт
	
	ОбработкаОбменСНТ = СНТСерверПовтИсп.ОбработкаОбменСНТ();
	КоллекцияСгруппированныхСопоставленийСНТ = ОбработкаОбменСНТ.Переопределяемый_СгруппироватьСопоставленияСНТПоСтруктурнымЕдиницам(МассивСопоставленийСНТ);
	
	Возврат КоллекцияСгруппированныхСопоставленийСНТ;
	
КонецФункции

Функция СгруппироватьВСКонтрагентовПоСтруктурнымЕдиницам(Знач МассивСкладов, ОткрыватьСессиюФилиаломПолучателем = Ложь) Экспорт
	
	ОбработкаОбменСНТ = СНТСерверПовтИсп.ОбработкаОбменСНТ();
	КоллекцияСгруппированныхВСКонтрагентов = ОбработкаОбменСНТ.Переопределяемый_СгруппироватьВСКонтрагентовПоСтруктурнымЕдиницам(МассивСкладов);
	Возврат КоллекцияСгруппированныхВСКонтрагентов;
	
КонецФункции

Процедура ЗаполнитьСоответствиеИменРеквизитовПолейЗапросов(СоответствиеИменРеквизитов, ИмяРеквизитаИИНБИН) Экспорт
	
	ЭСФСерверПереопределяемый.ЗаполнитьСоответсвиеИменРеквизитовПолейЗапросов(СоответствиеИменРеквизитов);
	ЭСФСервер.ЗаменитьИменаРеквизитовПолейЗапросов(ИмяРеквизитаИИНБИН, СоответствиеИменРеквизитов);
	
КонецПроцедуры

Функция ПолучитьРегНомерПервичнойСНТ(СНТ) Экспорт
	Возврат СНТ.РегистрационныйНомерИСЭСФ;
КонецФункции

Функция МассивСНТНеПоИмпорту(МассивСНТДляСозданияПервичныхДокументов) Экспорт
	
	Возврат СНТСервер.МассивСНТНеПоИмпорту(МассивСНТДляСозданияПервичныхДокументов);
	
КонецФункции

Функция СоздатьСписокСНТ(ПараметрыСоздания) Экспорт
	Возврат СНТСерверПовтИсп.ОбработкаОбменСНТ().СоздатьСписокСНТ(ПараметрыСоздания);	
КонецФункции

// Находит в МассивСНТ документы, у которых дата отличается от параметра Дата.
//
// Параметры:
//  МассивСНТ - Массив - Массив СНТ, среди которых необходимо найти СНТ с отличающейся датой.
//   Каждый элемент массива должен иметь тип ДокументСсылка.СНТ.
//  Дата - Дата - Будут найдены СНТ, дата которых отличается от этой даты.
//
// Возвращаемое значение:
//   Массив - Массив СНТ, дата которых отличается от Дата.
//    Каждый элемент массива имеет тип ДокументСсылка.СНТ.
//
Функция МассивСНТДругаяДата(МассивСНТ, Дата, ИзмененГод = Ложь) Экспорт
	
	МассивСНТДругаяДата = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СНТ.Ссылка КАК СНТ,
	|	ГОД(СНТ.Дата) <> ГОД(&Дата) КАК ИзмененГод,
	|	СНТ.ДатаВыпискиНаБумажномНосителе КАК ДатаВыписки,
	|	НАЧАЛОПЕРИОДА(СНТ.Дата, ДЕНЬ) <> &Дата КАК ДатаСНТОтличнаОтТекущей,
	|	НАЧАЛОПЕРИОДА(ДОкументОснование.Дата, ДЕНЬ) <> &Дата КАК ДатаДокументаОснованияОтличнаОтТекущей,
	|	ДокументОснование.Ссылка КАК ДокументОснование
	|ИЗ
	|	Документ.СНТ КАК СНТ	
	|ГДЕ
	|	СНТ.Ссылка В(&МассивСНТ)
	|	И (НАЧАЛОПЕРИОДА(СНТ.Дата, ДЕНЬ) <> &Дата	
	|	И СНТ.ДатаВыпискиНаБумажномНосителе = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0))
	|";
	
	Запрос.УстановитьПараметр("МассивСНТ", МассивСНТ);	
	Запрос.УстановитьПараметр("Дата", НачалоДня(Дата));	
	
	МассивСостояний = Новый Массив;
	МассивСостояний.Добавить(Перечисления.СостоянияСНТ.Сформирован);
	МассивСостояний.Добавить(Перечисления.СостоянияСНТ.ОтклоненСервером);
	Запрос.УстановитьПараметр("МассивСостояний", МассивСостояний);
	
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();	
		Пока Выборка.Следующий() Цикл
			СтруктураСНТ = Новый Структура();
			СтруктураСНТ.Вставить("СНТ", Выборка.СНТ);
			Если ЗначениеЗаполнено(Выборка.ДатаВыписки) Тогда
				ПризнакВыписки = Истина;
			Иначе 
				ПризнакВыписки = Ложь;
			КонецЕсли;
			СтруктураСНТ.Вставить("ПризнакВыписки", ПризнакВыписки);
			СтруктураСНТ.Вставить("ДатаСНТОтличнаОтТекущей", Выборка.ДатаСНТОтличнаОтТекущей);						
			СтруктураСНТ.Вставить("ДатаДокументаОснованияОтличнаОтТекущей", Выборка.ДатаДокументаОснованияОтличнаОтТекущей);						
			СтруктураСНТ.Вставить("ДокументОснование", Выборка.ДокументОснование);
			МассивСНТДругаяДата.Добавить(СтруктураСНТ);
			Если Выборка.ИзмененГод Тогда
				ИзмененГод = Выборка.ИзмененГод;
			КонецЕсли;
		КонецЦикла;		
	КонецЕсли;
	
	Возврат МассивСНТДругаяДата;
	
КонецФункции

// Устанавливает дату для документов СНТ 
//
// Параметры:
//  МассивСНТ - Массив - Массив документов СНТ, для которых необходимо установить дату.
//   Каждый элемент массива должен иметь тип ДокументСсылка.СНТ.
//  ТекущаяДата - Дата - Дата, которую необходимо установить для документов
//   Должна быть началом дня.
//
Процедура УстановитьТекущуюДатуДляСНТ(Знач МассивСНТ, Знач ТекущаяДата) Экспорт
	
	Запрос 		 = Новый Запрос;
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СНТ.Ссылка КАК СНТ,
	|	СНТ.Дата КАК ДатаСНТ,
	|	СНТ.ДокументОснование КАК ДокументОснование,
	|	НАЧАЛОПЕРИОДА(СНТ.ДокументОснование.Дата, ДЕНЬ) КАК ДатаДокументаОснования,
	|	СНТ.ДатаВыпискиНаБумажномНосителе КАК ДатаВыпискиБумажно
	|ИЗ
	|	Документ.СНТ КАК СНТ
	|ГДЕ
	|	СНТ.Ссылка В(&МассивСНТ)";
	
	
	Запрос.Текст = ТекстЗапроса;
	
	Запрос.УстановитьПараметр("МассивСНТ", МассивСНТ);
	Выборка = Запрос.Выполнить().Выбрать();
	
	НачатьТранзакцию();
	
	Попытка
		
		Пока Выборка.Следующий() Цикл
			Если НачалоДня(Выборка.ДатаСНТ) <> ТекущаяДата Тогда
				ОбъектСНТ = Выборка.СНТ.ПолучитьОбъект();
				ОбъектСНТ.Дата = ТекущаяДата;
				
				ОбъектСНТ.ДополнительныеСвойства.Вставить(ЭСФКлиентСерверПереопределяемый.ИмяПропуститьПроверкуЗапретаИзменения(), Истина);
				ОбъектСНТ.ОбменДанными.Загрузка = Истина;
				ОбъектСНТ.Записать();
			КонецЕсли;
			
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'СНТВызовСервера.УстановитьТекущуюДатуДляСНТ'"), 
			УровеньЖурналаРегистрации.Ошибка,,,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
		ВызватьИсключение ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		
	КонецПопытки;
	
КонецПроцедуры

// См. Обработка.ОбменСНТ.СоздатьXMLДляИмпортаВИСЭСФ()
Функция СоздатьXMLДляИмпортаВИСЭСФ(Знач МассивСНТ) Экспорт
	
	Возврат СНТСерверПовтИсп.ОбработкаОбменСНТ().СоздатьXMLДляИмпортаВИСЭСФ(МассивСНТ);
	
КонецФункции

Функция ДокументСНТОбработкаЗаполнения(НовыйСНТ, ДанныеЗаполнения, СтандартнаяОбработка) Экспорт
	НовыйСНТ = Документы.СНТ.СоздатьДокумент();
	СНТСерверПовтИсп.ОбработкаОбменСНТ().ДокументСНТ_ОбработкаЗаполнения(НовыйСНТ, ДанныеЗаполнения, СтандартнаяОбработка);
КонецФункции

Функция МассивСНТНаВозврат(МассивСНТДляСозданияПервичныхДокументов) Экспорт
	
	Возврат СНТСервер.МассивСНТНаВозврат(МассивСНТДляСозданияПервичныхДокументов);
	
КонецФункции

#КонецОбласти

#Область ОтправкаСНТ

Функция ВыполнитьВФоне(Знач ИмяПроцедуры, Знач ПараметрыПроцедуры, Знач ПараметрыВыполнения) Экспорт

	Возврат СНТСерверПереопределяемый.ВыполнитьВФоне(ИмяПроцедуры, ПараметрыПроцедуры, ПараметрыВыполнения);
	
КонецФункции

Функция ОтправитьИсходящиеSnt(ВерсияВС, Знач КоллекцияДанныеКоллекцииSntXML, Знач КоллекцияПодписей, Знач ДанныеПрофилейИСЭСФ) Экспорт
	
	Результат = СНТСервер.ОтправитьИсходящиеSnt(ВерсияВС, КоллекцияДанныеКоллекцииSntXML, КоллекцияПодписей, ДанныеПрофилейИСЭСФ);
	
КонецФункции

Функция ОтправитьИсходящиеSntВФоне(Знач ПараметрыВыгрузки, Знач АдресХранилища) Экспорт

	Результат = ОтправитьИсходящиеSnt(
					ПараметрыВыгрузки.ВерсияВС, 
					ПараметрыВыгрузки.КоллекцияСоответствиеСНТ, 
					ПараметрыВыгрузки.КоллекцияПодписейСНТ, 
					ПараметрыВыгрузки.ДанныеПрофилейИСЭСФ 
					);
	
	Возврат Результат;
	
КонецФункции

//	 ВАЖНО! Массив изменяется внутрии функции, Знач не устанавливаем перед объявлением переменной
Функция ПроверитьВозможностьОтправкиДокументовПоставитьВОчередьОтправкиСНТ(МассивИсходящихСНТ, ДополнительныеПараметры) Экспорт
	
	Возврат СНТСервер.ПроверитьВозможностьОтправкиДокументовПоставитьВОчередьОтправкиСНТ(МассивИсходящихСНТ, ДополнительныеПараметры);
	
КонецФункции

Процедура ПроверитьИсходящиеСНТ(Знач МассивИсходящихСНТ) Экспорт
	
	СНТСервер.ПроверитьИсходящиеСНТ(МассивИсходящихСНТ);
	
КонецПроцедуры

Функция СоздатьИОтправитьКоллекциюSnt(КоллекцияСгруппированныхСНТ, ДанныеПрофилейИСЭСФ, ДополнительныеПараметры, ВерсияВС) Экспорт

	КоллекцияПодписейИСЭСФ = Новый Соответствие;
	КоллекцияАдресКоллекцииSntXML = Новый Соответствие;
	КоллекцияСоответствиеСНТ = Новый Соответствие;
	ЗапускатьФоновоеЗадание =  ДополнительныеПараметры.ЗапускатьФоновоеЗадание;
		
	Для Каждого СгруппированныеСНТ Из КоллекцияСгруппированныхСНТ Цикл
		
		СтруктурнаяЕдиница = СгруппированныеСНТ.Ключ;
		МассивСНТ = СгруппированныеСНТ.Значение;
		
		ДанныеКлючаЭЦП = ДанныеПрофилейИСЭСФ.Получить(СтруктурнаяЕдиница);
		
		ДанныеПрофиляИСЭСФ = ЭСФВызовСервера.ДанныеПрофиляИСЭСФ(ДанныеКлючаЭЦП.ПрофильИСЭСФ);

		АдресКоллекцииSntXML = Неопределено;
		КоллекцияSignedContentXML = Неопределено;
		
		ТипПодписиЭСФ = ЭСФКлиентСервер.ТипПодписиЭСФ(ДанныеКлючаЭЦП, ДанныеПрофиляИСЭСФ);
		
		СоздатьИсходящиеSnt(МассивСНТ, Истина, ТипПодписиЭСФ, АдресКоллекцииSntXML, КоллекцияSignedContentXML, ВерсияВС);
		
		КоллекцияПодписей = ЭСФКлиентСервер.НоваяКоллекцияПодписейЭСФ(КоллекцияSignedContentXML, ДанныеКлючаЭЦП);
		СоответствиеСНТ = ПолучитьИзВременногоХранилища(АдресКоллекцииSntXML);
		
		КоллекцияСоответствиеСНТ.Вставить(СтруктурнаяЕдиница, СоответствиеСНТ);
		КоллекцияПодписейИСЭСФ.Вставить(СтруктурнаяЕдиница, КоллекцияПодписей);
		КоллекцияАдресКоллекцииSntXML.Вставить(СтруктурнаяЕдиница, АдресКоллекцииSntXML);
		
	КонецЦикла;
	
	Если ЗапускатьФоновоеЗадание Тогда
		
		КлючФоновогоЗадания = Новый УникальныйИдентификатор;
		
		ПараметрыЗадания = Новый Структура("ВерсияВС, КоллекцияСоответствиеСНТ, КоллекцияПодписейСНТ, ДанныеПрофилейИСЭСФ", ВерсияВС, КоллекцияСоответствиеСНТ, КоллекцияПодписейИСЭСФ, ДанныеПрофилейИСЭСФ);
		ПараметрыВыполнения = ЭСФКлиентСерверПереопределяемый.ПараметрыВыполненияВФоне();
		ПараметрыВыполнения.КлючФоновогоЗадания = КлючФоновогоЗадания;
		
		РезультатОтправки = СНТСерверПереопределяемый.ВыполнитьВФоне("СНТВызовСервера.ОтправитьИсходящиеSntВФоне", ПараметрыЗадания, ПараметрыВыполнения);

	Иначе
	
		Результат = ОтправитьИсходящиеSNT(
					ВерсияВС,
					КоллекцияАдресКоллекцииSntXML, 
					КоллекцияПодписейИСЭСФ, 
					ДанныеПрофилейИСЭСФ
					);
	
			
	КонецЕсли;
	
	// Принудительное удаление, иначе значение не удалится.
	УдалитьИзВременногоХранилища(АдресКоллекцииSntXML);

	Возврат РезультатОтправки;
		
КонецФункции

Процедура СоздатьИсходящиеSnt(Знач МассивСНТ, Знач УстанавливатьПодпись, Знач ТипПодписи, АдресКоллекцииSntXML, КоллекцияSignedContentXML, ВерсияВС = "1") Экспорт
	
	КоллекцияSntXML = Неопределено;                                               
	СНТСервер.СоздатьИсходящиеSnt(МассивСНТ, УстанавливатьПодпись, ТипПодписи, КоллекцияSntXML, КоллекцияSignedContentXML, ВерсияВС);
	
	// После того, как переменная АдресКоллекцииInvoiceXML станет не нужна, 
	// необходимо самостоятельно очистить временное хранилище,
	// иначе значение будет удалено только после перезапуска сервера.
	АдресКоллекцииSntXML = ПоместитьВоВременноеХранилище(КоллекцияSntXML, Новый УникальныйИдентификатор);
	
КонецПроцедуры

#КонецОбласти

#Область ОтправкаСопоставленияСНТиФНО

Процедура СоздатьИсходящиеfnoMatching(Знач МассивСопоставленийСНТиФНО, Знач УстанавливатьПодпись, Знач ТипПодписи, АдресКоллекцииfnoMatchingXML, КоллекцияSignedContentXML, ВерсияВС = "1") Экспорт
	
	КоллекцияfnoMatchingXML = Неопределено;                                               
	СНТСервер.СоздатьИсходящиеfnoMatching(МассивСопоставленийСНТиФНО, УстанавливатьПодпись, ТипПодписи, КоллекцияfnoMatchingXML, КоллекцияSignedContentXML,ВерсияВС);
	
	// После того, как переменная АдресКоллекцииfnoMatchingXML станет не нужна, 
	// необходимо самостоятельно очистить временное хранилище,
	// иначе значение будет удалено только после перезапуска сервера.
	АдресКоллекцииfnoMatchingXML = ПоместитьВоВременноеХранилище(КоллекцияfnoMatchingXML, Новый УникальныйИдентификатор);
	
КонецПроцедуры

Функция ОтправитьИсходящиеfnoMatchingВФоне(Знач ПараметрыВыгрузки, Знач АдресХранилища) Экспорт

	Результат = ОтправитьИсходящиеfnoMatching(
					ПараметрыВыгрузки.ВерсияВС, 
					ПараметрыВыгрузки.КоллекцияСоответствиеСопоставленийСНТиФНО, 
					ПараметрыВыгрузки.КоллекцияПодписейСопоставленийСНТиФНО, 
					ПараметрыВыгрузки.ДанныеПрофилейИСЭСФ 
					);
	
	Возврат Результат;
	
КонецФункции

Функция ОтправитьИсходящиеfnoMatching(ВерсияВС, Знач КоллекцияДанныеКоллекцииfnoMatchingXML, Знач КоллекцияПодписей, Знач ДанныеПрофилейИСЭСФ) Экспорт
	
	Результат = СНТСервер.ОтправитьИсходящиеfnoMatching(ВерсияВС, КоллекцияДанныеКоллекцииfnoMatchingXML, КоллекцияПодписей, ДанныеПрофилейИСЭСФ);
	
КонецФункции

Функция СоздатьИОтправитьКоллекциюfnoMatching(КоллекцияСгруппированныхСНТиФНО, ДанныеПрофилейИСЭСФ, ДополнительныеПараметры, ВерсияВС) Экспорт

	КоллекцияПодписейИСЭСФ 					= Новый Соответствие;
	КоллекцияАдресКоллекцииfnoMatchingXML	= Новый Соответствие;
	КоллекцияСоответствиеСопоставленийСНТиФНО = Новый Соответствие;
	ЗапускатьФоновоеЗадание 				= ДополнительныеПараметры.ЗапускатьФоновоеЗадание;
		
	Для Каждого СгруппированныеСНТиФНО Из КоллекцияСгруппированныхСНТиФНО Цикл
		
		СтруктурнаяЕдиница = СгруппированныеСНТиФНО.Ключ;
		МассивСНТиФНО = СгруппированныеСНТиФНО.Значение;
		
		ДанныеКлючаЭЦП = ДанныеПрофилейИСЭСФ.Получить(СтруктурнаяЕдиница);
		
		ДанныеПрофиляИСЭСФ = ЭСФВызовСервера.ДанныеПрофиляИСЭСФ(ДанныеКлючаЭЦП.ПрофильИСЭСФ);

		АдресКоллекцииfnoMatchingXML = Неопределено;
		КоллекцияSignedContentXML = Неопределено;
		
		ТипПодписиЭСФ = ЭСФКлиентСервер.ТипПодписиЭСФ(ДанныеКлючаЭЦП, ДанныеПрофиляИСЭСФ);
		
		СоздатьИсходящиеfnoMatching(МассивСНТиФНО, Истина, ТипПодписиЭСФ, АдресКоллекцииfnoMatchingXML, КоллекцияSignedContentXML, ВерсияВС);
		
		КоллекцияПодписей = ЭСФКлиентСервер.НоваяКоллекцияПодписейЭСФ(КоллекцияSignedContentXML, ДанныеКлючаЭЦП);
		СоответствиеСНТиФНО = ПолучитьИзВременногоХранилища(АдресКоллекцииfnoMatchingXML);
		
		КоллекцияСоответствиеСопоставленийСНТиФНО.Вставить(СтруктурнаяЕдиница, СоответствиеСНТиФНО);
		КоллекцияПодписейИСЭСФ.Вставить(СтруктурнаяЕдиница, КоллекцияПодписей);
		КоллекцияАдресКоллекцииfnoMatchingXML.Вставить(СтруктурнаяЕдиница, АдресКоллекцииfnoMatchingXML);
		
	КонецЦикла;
	
	Если ЗапускатьФоновоеЗадание Тогда
		
		КлючФоновогоЗадания = Новый УникальныйИдентификатор;
		
		ПараметрыЗадания = Новый Структура("ВерсияВС, КоллекцияСоответствиеСопоставленийСНТиФНО, КоллекцияПодписейСопоставленийСНТиФНО, ДанныеПрофилейИСЭСФ", 
											ВерсияВС, КоллекцияСоответствиеСопоставленийСНТиФНО, КоллекцияПодписейИСЭСФ, ДанныеПрофилейИСЭСФ);
		ПараметрыВыполнения = ЭСФКлиентСерверПереопределяемый.ПараметрыВыполненияВФоне();
		ПараметрыВыполнения.КлючФоновогоЗадания = КлючФоновогоЗадания;
		
		РезультатОтправки = ЭСФСерверПереопределяемый.ВыполнитьВФоне("СНТВызовСервера.ОтправитьИсходящиеfnoMatchingВФоне", ПараметрыЗадания, ПараметрыВыполнения);
		
	Иначе
	
		Результат = ОтправитьИсходящиеfnoMatching(
					ВерсияВС,
					КоллекцияАдресКоллекцииfnoMatchingXML, 
					КоллекцияПодписейИСЭСФ, 
					ДанныеПрофилейИСЭСФ
					);
	
			
	КонецЕсли;
	
	// Принудительное удаление, иначе значение не удалится.
	УдалитьИзВременногоХранилища(АдресКоллекцииfnoMatchingXML);

	Возврат РезультатОтправки;
		
КонецФункции

#КонецОбласти

#Область ОбновлениеСопоставлениеСНТсФНО

Процедура ОбновитьДокументыСопоставлениеСНТсФНОИзИСЭСФВФоне(Знач ПараметрыВыгрузки, Знач АдресХранилища) Экспорт
	
	ОбновитьДокументыСопоставлениеСНТсФНОИзИСЭСФ(ПараметрыВыгрузки.КоллекцияСгруппированныхСопСНТсФНО, ПараметрыВыгрузки.ДанныеПрофилейИСЭСФ);
	
КонецПроцедуры

Процедура ОбновитьДокументыСопоставлениеСНТсФНОИзИСЭСФ(Знач КоллекцияСгруппированныхСопСНТсФНО, Знач ДанныеПрофилейИСЭСФ) Экспорт
	
	ОбработкаОбменСНТ = СНТСерверПовтИсп.ОбработкаОбменСНТ();
	
	Для Каждого СгруппированныеСопСНТсФНО Из КоллекцияСгруппированныхСопСНТсФНО Цикл
		
		СтруктурнаяЕдиница = СгруппированныеСопСНТсФНО.Ключ;
		СгруппированныйМассивСопСНТсФНО = СгруппированныеСопСНТсФНО.Значение;
		
		ДанныеСтруктурнойЕдиницы = ДанныеПрофилейИСЭСФ.Получить(СтруктурнаяЕдиница);
		
		ДанныеПрофиляИСЭСФ = ЭСФСервер.ДанныеПрофиляИСЭСФ(ДанныеСтруктурнойЕдиницы.ПрофильИСЭСФ);
		
		ДанныеПрофиляИСЭСФ.ТекущийПарольАутентификации = ДанныеСтруктурнойЕдиницы.ПарольИСЭСФ;
		
		ОбработкаОбменСНТ.ОбновитьДокументыСопоставлениеСНТсФНОИзИСЭСФ(СгруппированныйМассивСопСНТсФНО, ДанныеПрофиляИСЭСФ);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПолучитьОшибкиСопоставлениеСНТсФНОПоИдентификаторамВФоне(Знач ПараметрыВыгрузки, Знач АдресХранилища) Экспорт
	
	ПолучитьОшибкиСопоставлениеСНТсФНОПоИдентификаторам(ПараметрыВыгрузки.КоллекцияСгруппированныхСопСНТсФНО, ПараметрыВыгрузки.ДанныеПрофилейИСЭСФ);
	
КонецПроцедуры

Процедура ПолучитьОшибкиСопоставлениеСНТсФНОПоИдентификаторам(Знач КоллекцияСгруппированныхСопСНТсФНО, Знач ДанныеПрофилейИСЭСФ) Экспорт
	
	ОбработкаОбменСНТ = СНТСерверПовтИсп.ОбработкаОбменСНТ();
	
	Для Каждого СгруппированныеСопСНТсФНО Из КоллекцияСгруппированныхСопСНТсФНО Цикл
		
		СтруктурнаяЕдиница = СгруппированныеСопСНТсФНО.Ключ;
		СгруппированныйМассивСопСНТсФНО = СгруппированныеСопСНТсФНО.Значение;
		
		ДанныеСтруктурнойЕдиницы = ДанныеПрофилейИСЭСФ.Получить(СтруктурнаяЕдиница);
		
		ДанныеПрофиляИСЭСФ = ЭСФСервер.ДанныеПрофиляИСЭСФ(ДанныеСтруктурнойЕдиницы.ПрофильИСЭСФ);
		
		ДанныеПрофиляИСЭСФ.ТекущийПарольАутентификации = ДанныеСтруктурнойЕдиницы.ПарольИСЭСФ;
		
		ОбработкаОбменСНТ.ПолучитьОшибкиСопоставлениеСНТсФНО(СгруппированныйМассивСопСНТсФНО, ДанныеПрофиляИСЭСФ);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти


#Область ПолучениеФормСНТ
	
// Вызывает процедуру ПолучитьНовыеУТТН для фоновых заданий
Функция ПолучитьНовыеСНТ(Знач ПараметрыВыгрузки, Знач АдресХранилища = Неопределено) Экспорт
	
	Возврат СНТСервер.ПолучитьНовыеСНТ(ПараметрыВыгрузки);
	
КонецФункции

#КонецОбласти

#Область ИзменениеСтатусовСНТ

Функция СоздатьЗапросНаИзменениеСтатусов(Знач Действие, Знач КоллецияДляИзмененияСтатусов, Знач ДанныеКлючаЭЦП, Знач ТипПодписиЭСФ) Экспорт
	
	Возврат СНТСервер.СоздатьЗапросНаИзменениеСтатусов(Действие, КоллецияДляИзмененияСтатусов, ДанныеКлючаЭЦП, ТипПодписиЭСФ);
	
КонецФункции

// Выполняет методы ИС ЭСФ для изменения статусов СНТ.
// Обновляет документы СНТ. Возвращает результат работы выполненного метода.
//
// Параметры:
//  Действие - Строка - Определяет, какой метод ИС ЭСФ будет выполняться.
//  ТекстЗапроса - Строка - Текст XML запроса на изменение статусов, 
//   формируется функцией СНТСервер.СоздатьЗапросНаИзменениеСтатусов().
//  ПрофильИСЭСФ - СправочникСсылка.ПрофилиИСЭСФ - Профиль для установки сессии с ИС ЭСФ.
//  ИдентификаторСессии - Строка - Идентификатор сессии, для выполения запроса к ИС ЭСФ.
//
// Возвращаемое значение:
//  Соответствие - Результат выполнения метода ИС ЭСФ. Содержит данные по всем идентификаторам из ТекстЗапроса.
//   |- Ключ - Строка - Идентификатор СНТ, для которого изменялся статус.
//   |- Значение - Структура - Результат изменения статуса.
//       |- СтатусИзменился - Булево - Признак того, что выполненный запрос изменил статус СНТ.
//       |- ТекущийСтатус - Структура, Неопределено - Текущий статус СНТ.
Функция ВыполнитьЗапросНаИзменениеСтатусов(Знач Действие, Знач ТекстЗапроса, Знач ПрофильИСЭСФ, ИдентификаторСессии = Неопределено, Знач СоответствиеПодписейСНТ = Неопределено) Экспорт
	
	Возврат СНТСерверПовтИсп.ОбработкаОбменСНТ().ВыполнитьЗапросНаИзменениеСтатусовСНТ(Действие, ТекстЗапроса, ПрофильИСЭСФ, ИдентификаторСессии, СоответствиеПодписейСНТ);
	
КонецФункции

Функция ВыполнитьЗапросНаИзменениеСтатусовВФоне(Знач ПараметрыВыгрузки, Знач АдресХранилища) Экспорт
	
	ДанныеИзмененияСтатусов = ВыполнитьЗапросНаИзменениеСтатусов(ПараметрыВыгрузки.Действие, ПараметрыВыгрузки.ТекстЗапроса, ПараметрыВыгрузки.ДанныеПрофиляИСЭСФ,,ПараметрыВыгрузки.СоответствиеПодписейСНТ);
	ПоместитьВоВременноеХранилище(ДанныеИзмененияСтатусов, АдресХранилища);
	
	Возврат ДанныеИзмененияСтатусов;

КонецФункции

Функция ИзменитьСтатусыСНТВФоне(Знач ПараметрыВыгрузки, Знач АдресХранилища) Экспорт

	ДанныеИзмененияСтатусов = ИзменитьСтатусыСНТ(ПараметрыВыгрузки.Действие, ПараметрыВыгрузки.КоллецияДляИзмененияСтатусов, ПараметрыВыгрузки.ДанныеКлючаЭЦП, ПараметрыВыгрузки.ДанныеПрофиляИСЭСФ);
	ПоместитьВоВременноеХранилище(ДанныеИзмененияСтатусов, АдресХранилища);
	Возврат ДанныеИзмененияСтатусов;
	
КонецФункции

Функция ИзменитьСтатусыСНТ(Действие, КоллецияДляИзмененияСтатусов, ДанныеКлючаЭЦП, ДанныеПрофиляИСЭСФ) Экспорт
	
	ТипПодписиСНТ = ЭСФКлиентСервер.ТипПодписиЭСФ(ДанныеКлючаЭЦП, ДанныеПрофиляИСЭСФ);	
	СоответствиеПодписейСНТ = Новый Соответствие();
	
	Результат = СоздатьЗапросНаИзменениеСтатусов(Действие, КоллецияДляИзмененияСтатусов, ДанныеКлючаЭЦП, ТипПодписиСНТ); 
	Контейнер = ЭСФКлиентСервер.КонтейнерМетодов();
	sntActionInfoList = "";                                                   
	ТекстЗапроса = Результат.ТекстЗапроса; 
	
	Для Каждого ЭлементМассива из Результат.МассивЧастейЗапроса Цикл
		Подпись = Контейнер.СоздатьЭЦП(
		ЭлементМассива.СтрокаДляПодписи, 
		ДанныеКлючаЭЦП.КлючBase64, 
		ДанныеКлючаЭЦП.Пароль);
		ТекстЧастиЗапроса = СтрЗаменить(ЭлементМассива.ЧастьЗапроса, "[Signature]", Подпись);
	    sntActionInfoList = sntActionInfoList + ТекстЧастиЗапроса;
		
		СоответствиеПодписейСНТ.Вставить(ЭлементМассива.ИД, Новый Структура("Подпись, ТипПодписи", Подпись, ТипПодписиСНТ));

	КонецЦикла;
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[sntActionInfoList]", sntActionInfoList);
	
	Возврат ВыполнитьЗапросНаИзменениеСтатусов(Действие, ТекстЗапроса, ДанныеПрофиляИСЭСФ,,СоответствиеПодписейСНТ);	

КонецФункции

Функция СоздатьСписокИсходящихЭСФиСФИзСНТ(ПараметрыСоздания) Экспорт
	
	Возврат СНТСерверПовтИсп.ОбработкаОбменСНТ().СоздатьСписокИсходящихЭСФиСФИзСНТ(ПараметрыСоздания);
	
КонецФункции

Функция ПроверитьАктуальныйЭСФДляСНТ(МассивСНТ, ПерезаполняемыйЭСФ = Неопределено) Экспорт
	
	Возврат СНТСерверПовтИсп.ОбработкаОбменСНТ().ПроверитьАктуальныйЭСФДляСНТ(МассивСНТ, ПерезаполняемыйЭСФ);
	
КонецФункции

#КонецОбласти

#Область ОбновлениеСНТ

Процедура ОбновитьДокументыСНТИзИСЭСФВФоне(Знач ПараметрыВыгрузки, Знач АдресХранилища) Экспорт
	
	ОбновитьДокументыСНТИзИСЭСФ(ПараметрыВыгрузки.КоллекцияСгруппированныхСНТ, ПараметрыВыгрузки.ДанныеПрофилейИСЭСФ);
	
КонецПроцедуры

Процедура ОбновитьДокументыСНТИзИСЭСФ(Знач КоллекцияСгруппированныхСНТ, Знач ДанныеПрофилейИСЭСФ) Экспорт
	
	ОбработкаОбменСНТ = СНТСерверПовтИсп.ОбработкаОбменСНТ();
	
	Для Каждого СгруппированныеСНТ Из КоллекцияСгруппированныхСНТ Цикл
		
		СтруктурнаяЕдиница = СгруппированныеСНТ.Ключ;
		СгруппированныйМассивСНТ = СгруппированныеСНТ.Значение;
		
		ДанныеСтруктурнойЕдиницы = ДанныеПрофилейИСЭСФ.Получить(СтруктурнаяЕдиница);
		
		ДанныеПрофиляИСЭСФ = ЭСФСервер.ДанныеПрофиляИСЭСФ(ДанныеСтруктурнойЕдиницы.ПрофильИСЭСФ);
		
		ДанныеПрофиляИСЭСФ.ТекущийПарольАутентификации = ДанныеСтруктурнойЕдиницы.ПарольИСЭСФ;
		
		ОбработкаОбменСНТ.ОбновитьДокументыСНТИзИСЭСФ(СгруппированныйМассивСНТ, ДанныеПрофиляИСЭСФ);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ПолучениеСозданиеСкладов

Функция ПолучитьВСКонтрагента(Знач ПрофильИСЭСФ, Знач МассивКонтрагентов, ВерсияВС = Неопределено) Экспорт
	
	Возврат СНТСервер.ПолучитьВСКонтрагента(ПрофильИСЭСФ, МассивКонтрагентов, ВерсияВС);
	
КонецФункции

Процедура ОбновитьВСКонтрагентовИзВСВФоне(Знач ПараметрыВыгрузки, Знач АдресХранилища) Экспорт
	
	ОбновитьВСКонтрагентовИзВС(ПараметрыВыгрузки.КоллекцияСгруппированныхКонтрагентов, ПараметрыВыгрузки.ДанныеПрофиляИСЭСФ);
	
КонецПроцедуры

Процедура ОбновитьВСКонтрагентовИзВС(Знач КоллекцияСгруппированныхКонтрагентов, Знач ДанныеПрофиляИСЭСФ) Экспорт
	
	ОбработкаОбменСНТ = СНТСерверПовтИсп.ОбработкаОбменСНТ();

	МассивКонтрагентов = Новый Массив;
	
	Для Каждого СгруппированныеСклады Из КоллекцияСгруппированныхКонтрагентов Цикл
		МассивКонтрагентов.Добавить(СгруппированныеСклады.Ключ);
	КонецЦикла;
	
	Если ДанныеПрофиляИСЭСФ <> Неопределено Тогда
		Для Каждого Элемент Из ДанныеПрофиляИСЭСФ Цикл
			ДанныеПрофиляИСЭСФ = Неопределено;
			ПрофильИСЭСФ = Элемент.Значение.ПрофильИСЭСФ;
			ПарольПрофиляИСЭСФ = Элемент.Значение.ПарольИСЭСФ;
			
			Если ДанныеПрофиляИСЭСФ = Неопределено Тогда
				ДанныеПрофиляИСЭСФ = ЭСФСервер.ДанныеПрофиляИСЭСФ(ПрофильИСЭСФ);
			КонецЕсли;
			
			Если ДанныеПрофиляИСЭСФ.ТекущийПарольАутентификации = "" Тогда
				ДанныеПрофиляИСЭСФ.ТекущийПарольАутентификации = ПарольПрофиляИСЭСФ;
			КонецЕсли;
			
			Если Не ЗначениеЗаполнено(ДанныеПрофиляИСЭСФ) Тогда
				Возврат;
			КонецЕсли;
			
			ОбработкаОбменСНТ.ОбновитьВСКонтрагентовИзВС(МассивКонтрагентов, КоллекцияСгруппированныхКонтрагентов, ДанныеПрофиляИСЭСФ);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПерезаполнениеСНТПоДокументуОснованию

Функция НовоеСоответствиеДляОбновленияАктуальныхОснований(Знач МассивСНТ) Экспорт
	
	// Соответствие СНТ и актуальных оснований, по которым можно выполнить перезаполнение
	СоответствиеДляОбновленияАктуальныхОснований = Новый Соответствие;
	
	// Массив СНТ, у которых нет актуальных оснований.
	ОтсутствуетАктуальноеОснование = Новый Массив;
	
	// Массив СНТ, которые имеют актуальные основания в недопустимом состоянии. 
	НедопустимоеСостояние = Новый Массив;
	
	// Найти актуальные основания для СНТ.
	СоответствиеАктуальныхОснований = СНТВызовСервера.НайтиАктуальныеОснованияПоСНТ(МассивСНТ);
	
	// Заполнить коллекции СоответствиеАктуальныхОснований, ОтсутствуетАктуальноеОснование, НедопустимоеСостояниеОснования.
	Для Каждого ЭлементСоответствия Из СоответствиеАктуальныхОснований Цикл
		
		СсылкаСНТ = ЭлементСоответствия.Ключ;
		ДанныеОснования = ЭлементСоответствия.Значение;
		
		Если ДанныеОснования = Неопределено Тогда
			ОтсутствуетАктуальноеОснование.Добавить(СсылкаСНТ);
		ИначеЕсли Не СсылкаСНТ.Состояние = ПредопределенноеЗначение("Перечисление.СостоянияСНТ.Сформирован")
			И Не СсылкаСНТ.Состояние = ПредопределенноеЗначение("Перечисление.СостоянияСНТ.ОтклоненСервером") Тогда
			НедопустимоеСостояние.Добавить(СсылкаСНТ);
		Иначе
			СоответствиеДляОбновленияАктуальныхОснований.Вставить(СсылкаСНТ, ДанныеОснования);
		КонецЕсли;
		
	КонецЦикла;
	
	// Сформировать и показать текст сообщения, если нельзя обновить все СНТ.
	Если СоответствиеДляОбновленияАктуальныхОснований.Количество() <> МассивСНТ.Количество() Тогда
		
		ТекстСообщения = "";
		
		// Сформировать текст по СНТ, у которых нет актуальных оснований.
		Если ОтсутствуетАктуальноеОснование.Количество() <> 0 Тогда
			
			ТекстСообщения = ТекстСообщения + НСтр(
				"ru = 'Невозможно перезаполнить электронные сопроводительные накладные:
	            |%СписокСНТ%
	            |Так как эти СНТ не отражены в учете.'");
				
			СписокСНТ = "";
			Для Каждого СсылкаСНТ Из ОтсутствуетАктуальноеОснование Цикл
				СписокСНТ = СписокСНТ + "- " + СсылкаСНТ + Символы.ПС;	
			КонецЦикла;
			
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%СписокСНТ%", СокрЛП(СписокСНТ));
				
		КонецЕсли;
		
		ТекстСообщения = СокрЛП(ТекстСообщения) + Символы.ПС + Символы.ПС;
		
		// Сформировать текст по СНТ, у которых есть актуальные основания с недопустимым состоянием.
		Если НедопустимоеСостояние.Количество() <> 0 Тогда
			
			ТекстСообщения = ТекстСообщения + НСтр(
				"ru = 'Невозможно перезаполнить электронные сопроводительные накладные:
				|%СписокСНТ%
				|Так как они находятся в состояниях, недопустимых для обновления.
				|Возможно обновление СНТ только в состоянии ""%Сформирован%"", ""%ОтклоненСервером%"".'");
				
			СписокСНТ = "";
			Для Каждого СсылкаСНТ Из НедопустимоеСостояние Цикл
				СписокСНТ = СписокСНТ + "- " + СсылкаСНТ + Символы.ПС;	
			КонецЦикла;
			
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%СписокСНТ%", 	   СокрЛП(СписокСНТ));
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Сформирован%", 	   Перечисления.СостоянияСНТ.Сформирован);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ОтклоненСервером%", Перечисления.СостоянияСНТ.ОтклоненСервером);
			
		КонецЕсли;
		
		ТекстСообщения = СокрЛП(ТекстСообщения) + Символы.ПС + Символы.ПС;
		
		// Сформировать текст по СНТ, которые можно перезаполнить.
		Если СоответствиеДляОбновленияАктуальныхОснований.Количество() <> 0 Тогда
			
			ТекстСообщения = ТекстСообщения + НСтр(
				"ru = 'Перезаполнение по данным документа-основания возможно только для СНТ:
                 |%СписокСНТ%'");
				
			СписокСНТ = "";
			Для Каждого ЭлементСоответствия Из СоответствиеДляОбновленияАктуальныхОснований Цикл
				СписокСНТ = СписокСНТ + "- " + ЭлементСоответствия.Ключ + Символы.ПС;	
			КонецЦикла;
			
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%СписокСНТ%", СокрЛП(СписокСНТ));
			
		КонецЕсли;
		
		Сообщить(СокрЛП(ТекстСообщения));
		
	КонецЕсли;
	
	Возврат СоответствиеДляОбновленияАктуальныхОснований;
	
КонецФункции

Функция НайтиАктуальныеОснованияПоСНТ(Знач МассивСНТ) Экспорт
	
	Возврат СНТСервер.НайтиАктуальныеОснованияПоСНТ(МассивСНТ);
	
КонецФункции

Процедура ОбновитьАктуальныеСНТ(Знач СоответствиеДляОбновленияАктуальныхОснований) Экспорт
	
	НачатьТранзакцию();
	
	Попытка
		
		Для Каждого ЭлементСоответствия Из СоответствиеДляОбновленияАктуальныхОснований Цикл
			СсылкаСНТ = ЭлементСоответствия.Ключ.ПолучитьОбъект();
			Основание = ЭлементСоответствия.Значение;
			ДополнительныеПараметры = Новый Структура;
			ДополнительныеПараметры.Вставить("ЭтоИсправленнаяСНТ", СсылкаСНТ.ТипСНТ = Перечисления.ТипыСНТ.Исправленная);
			ЭСФСервер.ОчиститьОбъект(СсылкаСНТ, "СвязанныйСНТ, РегистрационныйНомерСвязанногоСНТ");
			СНТСервер.ЗаполнитьИсходящийСНТ(Основание, СсылкаСНТ, ДополнительныеПараметры);
			СсылкаСНТ.Записать();
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'СНТВызовСервера.ОбновитьАктуальныеСНТ'"), 
			УровеньЖурналаРегистрации.Ошибка,,,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
	ВызватьИсключение ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		
	КонецПопытки;
	
КонецПроцедуры

Процедура ОбработкаВыбораСНТ(ПТУ, СНТ) Экспорт
	
	СНТСерверПереопределяемый.ОбработкаВыбораСНТ(ПТУ, СНТ);
	
КонецПроцедуры

Процедура ПолучитьАдресПоставщикаПолучателяВЭСФИзСНТ(ПриемникДокументЭСФ, Организация, Дата) Экспорт
	
	//Для заполнения адреса поставщика и получателя в ЕРП, когда на основании СНТ вводится ЭСФ
	СНТСерверПереопределяемый.ПолучитьАдресПоставщикаПолучателяВЭСФИзСНТ(ПриемникДокументЭСФ, Организация, Дата);
	
КонецПроцедуры

Функция ПолучитьСтавкуНДС(СтавкаНДС) Экспорт 
	
	Возврат СНТСерверПереопределяемый.ПолучитьСтавкуНДС(СтавкаНДС);
	
КонецФункции

Функция ПолучитьФОКонтрагентыПартнеры() Экспорт
	Возврат СНТСерверПереопределяемый.ПолучитьФОКонтрагентыПартнеры();
КонецФункции

#КонецОбласти