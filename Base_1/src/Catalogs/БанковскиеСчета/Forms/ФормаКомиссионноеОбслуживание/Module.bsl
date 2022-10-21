
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	Если Параметры.Свойство("БанковскийСчет") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры.БанковскийСчет);
		БанковскийСчет = Параметры.БанковскийСчет;
	КонецЕсли;
	
	Если Параметры.Свойство("КонтрагентБанк") Тогда
		КонтрагентБанк = Параметры.КонтрагентБанк;
	КонецЕсли;
	
	Если Параметры.Свойство("Владелец") Тогда
		Владелец = Параметры.Владелец;
	КонецЕсли;
	
	Если Параметры.Свойство("Банк") Тогда
		Банк = Параметры.Банк;
	КонецЕсли;
	
	ПоляФормы		= Новый Структура("Субконто1, Субконто2, Субконто3",
	"СубконтоЗатратБУ1", "СубконтоЗатратБУ2", "СубконтоЗатратБУ3");
	
	ЗаголовкиПолей	= Новый Структура("Субконто1, Субконто2, Субконто3",
	"ЗаголовокСубконтоЗатратБУ1", "ЗаголовокСубконтоЗатратБУ2", "ЗаголовокСубконтоЗатратБУ3");
	
	НастроитьВидимостьЭлементов();
	
	УстановитьЗаголовкиИДоступностьСубконто(ЭтотОбъект.СчетЗатратБУ, ПоляФормы, ЗаголовкиПолей, ЭтотОбъект.СчетЗатратНУ);
	СохранитьЗначенияПриОткрытии();
	
	ТолькоПросмотр = НЕ ПравоДоступа("Изменение", Метаданные.Справочники.БанковскиеСчета);
	Попытка
		Для Каждого ЭлементУправленияФормы Из Элементы Цикл
			ЭлементУправленияФормы.Доступность = НЕ ТолькоПросмотр;
		КонецЦикла;
	Исключение
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзмененБанк" Тогда
		Если Параметр.Ссылка = ЭтотОбъект.Банк Тогда
			
			БанкПриИзмененииНаСервере();
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ДоговорКонтрагентаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	КонтрагентПоБанку = ПолучитьЗначениеКонтрагентаИзБанка(Банк);
	
	Если Не ЗначениеЗаполнено(КонтрагентБанк) И Не ЗначениеЗаполнено(КонтрагентПоБанку) Тогда
		Текст = НСтр("ru = 'Не указан ""Контрагент"". Контрагент заполняется из реквизитов банка!'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(
		Текст,
		ЭтотОбъект.БанковскийСчет,
		"Банк",
		"Объект"
		);   		
		СтандартнаяОбработка = Ложь;		
		Возврат;
	ИначеЕсли ЗначениеЗаполнено(КонтрагентБанк) Тогда
		
		НовыеПараметры = Новый Массив();
		НовыеПараметры.Добавить(Новый ПараметрВыбора("Отбор.Владелец", ЭтаФорма.КонтрагентБанк));
		НовыеПараметры.Добавить(Новый ПараметрВыбора("Отбор.Организация", ЭтотОбъект.Владелец));
		ПараметрыОтбора = Новый ФиксированныйМассив(НовыеПараметры);
		Элемент.ПараметрыВыбора = ПараметрыОтбора; 
		
	ИначеЕсли ЗначениеЗаполнено(КонтрагентПоБанку) Тогда
		
		НовыеПараметры = Новый Массив();
		НовыеПараметры.Добавить(Новый ПараметрВыбора("Отбор.Владелец", КонтрагентПоБанку));
		НовыеПараметры.Добавить(Новый ПараметрВыбора("Отбор.Организация", ЭтотОбъект.Владелец));
		ПараметрыОтбора = Новый ФиксированныйМассив(НовыеПараметры);
		Элемент.ПараметрыВыбора = ПараметрыОтбора; 
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьЗначениеКонтрагентаИзБанка(Банк)
	Возврат Банк.Контрагент;
КонецФункции

&НаКлиенте
Процедура ДекорацияКонтрагентНажатие(Элемент)
	
	КонтрагентПоБанку = ПолучитьЗначениеКонтрагентаИзБанка(Банк);
	
	Если ЗначениеЗаполнено(КонтрагентБанк) И Не ЗначениеЗаполнено(КонтрагентПоБанку) Тогда
		
		ОткрытьФорму("Справочник.Контрагенты.ФормаОбъекта", Новый Структура("Ключ",КонтрагентБанк),ЭтаФорма, Новый УникальныйИдентификатор());
		
	Иначе
		Если ЗначениеЗаполнено(ЭтотОбъект.Банк) Тогда
			
			ОткрытьФорму("Справочник.Банки.ФормаОбъекта", Новый Структура("Ключ",ЭтотОбъект.Банк), ЭтаФорма,Новый УникальныйИдентификатор());
			
		Иначе
			
			Текст = НСтр("ru = 'У организации не заполнено поле ""Банк"". Контрагент заполняется из реквизитов банка!'");
			ОбщегоНазначенияКлиент.СообщитьПользователю(
			Текст,
			ЭтотОбъект.БанковскийСчет,
			"Банк",
			"Объект"
			);			
		КонецЕсли;
	КонецЕсли;  
	
	
КонецПроцедуры

&НаКлиенте
Процедура СчетЗатратБУПриИзменении(Элемент)
	
	ЭтотОбъект.СчетЗатратНУ = ПроцедурыБухгалтерскогоУчетаВызовСервераПовтИсп.ПреобразоватьСчетаБУвСчетНУ(Новый Структура("СчетБУ", ЭтотОбъект.СчетЗатратБУ));
	
	ПоляФормы		= Новый Структура("Субконто1, Субконто2, Субконто3",
	"СубконтоЗатратНУ1", "СубконтоЗатратНУ2", "СубконтоЗатратНУ3");
	
	ЗаголовкиПолей	= Новый Структура("Субконто1, Субконто2, Субконто3",
	"ЗаголовокСубконтоЗатратНУ1", "ЗаголовокСубконтоЗатратНУ2", "ЗаголовокСубконтоЗатратНУ3"); 
	
	ПроцедурыБухгалтерскогоУчетаКлиентСервер.ПриИзмененииСчета(ЭтотОбъект.СчетЗатратНУ, ЭтотОбъект, ПоляФормы);
	
	ПоляФормы		= Новый Структура("Субконто1, Субконто2, Субконто3",
	"СубконтоЗатратБУ1", "СубконтоЗатратБУ2", "СубконтоЗатратБУ3");
	
	ЗаголовкиПолей	= Новый Структура("Субконто1, Субконто2, Субконто3",
	"ЗаголовокСубконтоЗатратБУ1", "ЗаголовокСубконтоЗатратБУ2", "ЗаголовокСубконтоЗатратБУ3"); 
	
	УстановитьЗаголовкиИДоступностьСубконто(ЭтотОбъект.СчетЗатратБУ, ПоляФормы, ЗаголовкиПолей, ЭтотОбъект.СчетЗатратНУ);
	
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "ЗатратБУ", "СчетЗатратБУ");
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "ЗатратНУ", "СчетЗатратНУ");
	
	ДанныеОбъекта = Новый Структура("СубконтоЗатратБУ1, СубконтоЗатратБУ2, СубконтоЗатратБУ3,
	|СубконтоЗатратНУ1, СубконтоЗатратНУ2, СубконтоЗатратНУ3");
	
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, ЭтотОбъект);
	
	ДанныеОбъекта.Вставить("Организация", ЭтотОбъект.Владелец);
	
	СчетЗатратБУПриИзмененииНаСервере(ДанныеОбъекта);
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеОбъекта);
	
	УстановитьСтатьюДДСВАналитикеСчета();
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоЗатратБУ1ПриИзменении(Элемент)
	
	ОбщегоНазначенияБККлиентСервер.ЗаменитьСубконтоНУ(ЭтотОбъект, ЭтотОбъект.СчетЗатратБУ, ЭтотОбъект.СчетЗатратНУ, 1, ЭтотОбъект.СубконтоЗатратБУ1, "СубконтоЗатратНУ");
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "ЗатратБУ", "СчетЗатратБУ");
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "ЗатратНУ", "СчетЗатратНУ", Истина);   
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоЗатратБУ2ПриИзменении(Элемент)
	
	ОбщегоНазначенияБККлиентСервер.ЗаменитьСубконтоНУ(ЭтотОбъект, ЭтотОбъект.СчетЗатратБУ, ЭтотОбъект.СчетЗатратНУ, 2, ЭтотОбъект.СубконтоЗатратБУ2, "СубконтоЗатратНУ");
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "ЗатратБУ", "СчетЗатратБУ");
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "ЗатратНУ", "СчетЗатратНУ", Истина);   
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоЗатратБУ3ПриИзменении(Элемент)
	
	ОбщегоНазначенияБККлиентСервер.ЗаменитьСубконтоНУ(ЭтотОбъект, ЭтотОбъект.СчетЗатратБУ, ЭтотОбъект.СчетЗатратНУ, 3, ЭтотОбъект.СубконтоЗатратБУ3, "СубконтоЗатратНУ");
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "ЗатратБУ", "СчетЗатратБУ");
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "ЗатратНУ", "СчетЗатратНУ", Истина);   
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоЗатратБУ1НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СубконтоНачалоВыбора(Элемент, "СубконтоЗатратБУ", 1, "СчетЗатратБУ", ЭтотОбъект, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоЗатратБУ2НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СубконтоНачалоВыбора(Элемент, "СубконтоЗатратБУ", 2, "СчетЗатратБУ", ЭтотОбъект, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоЗатратБУ3НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СубконтоНачалоВыбора(Элемент, "СубконтоЗатратБУ", 3, "СчетЗатратБУ", ЭтотОбъект, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СчетЗатратНУПриИзменении(Элемент)
	
	ПоляФормы		= Новый Структура("Субконто1, Субконто2, Субконто3",
	"СубконтоЗатратНУ1", "СубконтоЗатратНУ2", "СубконтоЗатратНУ3");
	
	ЗаголовкиПолей	= Новый Структура("Субконто1, Субконто2, Субконто3",
	"ЗаголовокСубконтоЗатратНУ1", "ЗаголовокСубконтоЗатратНУ2", "ЗаголовокСубконтоЗатратНУ3"); 
	
	УстановитьЗаголовкиИДоступностьСубконто(ЭтотОбъект.СчетЗатратНУ, ПоляФормы, ЗаголовкиПолей);
	
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "ЗатратНУ", "СчетЗатратНУ");
	
	ДанныеОбъекта = Новый Структура("СубконтоЗатратНУ1, СубконтоЗатратНУ2, СубконтоЗатратНУ3");
	
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, ЭтотОбъект);
	
	ДанныеОбъекта.Вставить("Организация", ЭтотОбъект.Владелец);
	
	СчетЗатратНУПриИзмененииНаСервере(ДанныеОбъекта);
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеОбъекта);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоЗатратНУПриИзменении(Элемент)
	
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "ЗатратНУ", "СчетЗатратНУ");
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоЗатратНУ1НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СубконтоНачалоВыбора(Элемент, "СубконтоЗатратНУ", 1, "СчетЗатратНУ", ЭтотОбъект, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоЗатратНУ2НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СубконтоНачалоВыбора(Элемент, "СубконтоЗатратНУ", 2 , "СчетЗатратНУ", ЭтотОбъект, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоЗатратНУ3НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СубконтоНачалоВыбора(Элемент, "СубконтоЗатратНУ", 3 , "СчетЗатратНУ", ЭтотОбъект, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура УчитыватьНДСПриИзменении(Элемент)
	
	ЗаполнитьРеквизитыНДС();	
	
	НастроитьВидимостьЭлементов();
	
КонецПроцедуры

#КонецОбласти

#Область КомандыФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ЗакрытьСохраняяИзменения();
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Если ЗначенияИзменились(ЭтаФорма) Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ПослеЗакрытияВопроса", ЭтаФорма);
		ПоказатьВопрос(ОписаниеОповещения, НСтр("ru = 'Данные были изменены. Сохранить изменения?'"), РежимДиалогаВопрос.ДаНетОтмена);
	Иначе
		ЗакрытьБезСохраненияИзменений();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопроса(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ЗакрытьСохраняяИзменения();
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		ЗакрытьБезСохраненияИзменений();	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьСохраняяИзменения()
	
	Если ЗначенияИзменились(ЭтаФорма) Тогда
		
		ПараметрОповещения = Новый Структура();
		ПараметрОповещения.Вставить("ИзмененныеДанные", ЭтотОбъект);
		
		Оповестить("КомиссионноеОбслуживаниеИзменилось", ПараметрОповещения);
		Закрыть();		
	Иначе
		
		ЗакрытьБезСохраненияИзменений();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьБезСохраненияИзменений()
	
	Закрыть(Неопределено);	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗаполнитьРеквизитыНДС()
	
	Если ЭтотОбъект.УчитыватьНДС Тогда
		Если НЕ ЗначениеЗаполнено(ЭтотОбъект.НДСВидПоступления) Тогда
			ЭтотОбъект.НДСВидПоступления = ПредопределенноеЗначение("Справочник.ВидыПоступления.КомиссияБанка");
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(ЭтотОбъект.НДСВидОборота) 
			И ПолучитьМетодОтнесенияНДСВЗачет(ЭтотОбъект.Владелец,ТекущаяДата()) = ПредопределенноеЗначение("Перечисление.МетодыОтнесенияНДСВЗачет.Пропорциональный") Тогда
			ЭтотОбъект.НДСВидОборота = ПредопределенноеЗначение("Перечисление.ВидыОборотовПоРеализации.Общий");
		Иначе
			ЭтотОбъект.НДСВидОборота = ПредопределенноеЗначение("Перечисление.ВидыОборотовПоРеализации.Облагаемый");
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(ЭтотОбъект.СчетУчетаНДС)  Тогда
			ЭтотОбъект.СчетУчетаНДС = ПредопределенноеЗначение("ПланСчетов.Типовой.НалогНаДобавленнуюСтоимостьКВозмещению");
		КонецЕсли; 	
	Иначе
		ЭтотОбъект.НДСВидПоступления = ПредопределенноеЗначение("Справочник.ВидыПоступления.ПустаяСсылка");
		ЭтотОбъект.НДСВидОборота     = ПредопределенноеЗначение("Перечисление.ВидыОборотовПоРеализации.ПустаяСсылка");
		ЭтотОбъект.СчетУчетаНДС      = ПредопределенноеЗначение("ПланСчетов.Типовой.ПустаяСсылка");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НастроитьВидимостьЭлементов()
	
	Элементы.ГруппаНДСКолонки.Доступность = ЭтотОбъект.УчитыватьНДС;
	
	Если ЗначениеЗаполнено(КонтрагентБанк) Тогда
		// Если открыли форму при уже заполненном контрагенте
		Элементы.ДекорацияКонтрагент.Заголовок = КонтрагентБанк;
	ИначеЕсли ЗначениеЗаполнено(Банк.Контрагент) Тогда
		// Если контрагент заполнен по предупреждению
		Элементы.ДекорацияКонтрагент.Заголовок = Банк.Контрагент;
	Иначе
		Элементы.ДекорацияКонтрагент.Заголовок = НСтр("ru='Контрагент не указан в спр. ""Банки""'");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗаголовкиИДоступностьСубконто(СчетУчета, ПоляФормы, ЗаголовкиПолей, СчетУчетаНУ = Неопределено, ЭтоТаблица = Ложь)
	
	ПроцедурыБухгалтерскогоУчетаКлиентСервер.ПриВыбореСчета(СчетУчета, ЭтаФорма, ПоляФормы, ЗаголовкиПолей);
	
	Если НЕ СчетУчетаНУ = Неопределено Тогда
		
		Для Каждого ПолеФормы Из ПоляФормы Цикл
			
			ПоляФормы.Вставить(ПолеФормы.Ключ, СтрЗаменить(ПолеФормы.Значение, "БУ", "НУ"));
			
		КонецЦикла;
		
		Для Каждого ЗаголовоеПоля Из ЗаголовкиПолей Цикл
			
			ЗаголовкиПолей.Вставить(ЗаголовоеПоля.Ключ, СтрЗаменить(ЗаголовоеПоля.Значение, "БУ", "НУ"));
			
		КонецЦикла;
		
		ПроцедурыБухгалтерскогоУчетаКлиентСервер.ПриВыбореСчета(СчетУчетаНУ, ЭтаФорма, ПоляФормы, ЗаголовкиПолей);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьПараметрыВыбораПолейСубконто(Форма, Суффикс, ИмяСчета, ЗаменаСубконтоНУ = Ложь)
	
	ПараметрыСправочника = СписокПараметровВыбораСубконто(Форма.ЭтотОбъект, Форма.ЭтотОбъект, "Субконто" + Суффикс + "%Индекс%", ИмяСчета, Форма.КонтрагентБанк);
	ПроцедурыБухгалтерскогоУчетаКлиентСервер.ИзменитьПараметрыВыбораПолейСубконто(Форма, Форма.ЭтотОбъект, "Субконто" + Суффикс + "%Индекс%", "Субконто" + Суффикс + "%Индекс%", ПараметрыСправочника, ЗаменаСубконтоНУ);	
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция СписокПараметровВыбораСубконто(ДанныеОбъекта, ПараметрыОбъекта, ШаблонИмяПоляОбъекта, ИмяСчета, Контрагент)
	
	СписокПараметров = Новый Структура;
	Для Индекс = 1 По 3 Цикл
		ИмяПоля = СтрЗаменить(ШаблонИмяПоляОбъекта, "%Индекс%", Индекс);
		Если ТипЗнч(ПараметрыОбъекта[ИмяПоля]) = Тип("СправочникСсылка.Контрагенты") Тогда
			СписокПараметров.Вставить("Контрагент", Контрагент);
		ИначеЕсли ТипЗнч(ПараметрыОбъекта[ИмяПоля]) = Тип("СправочникСсылка.ДоговорыКонтрагентов") Тогда
			СписокПараметров.Вставить("ДоговорКонтрагента", ПараметрыОбъекта[ИмяПоля]);
		КонецЕсли;
	КонецЦикла;
	СписокПараметров.Вставить("СчетУчета", 				  ПараметрыОбъекта[ИмяСчета]);	
	СписокПараметров.Вставить("Организация", 			  ДанныеОбъекта.Владелец);
	
	Возврат СписокПараметров; 
	
КонецФункции

&НаСервереБезКонтекста
Процедура СчетЗатратБУПриИзмененииНаСервере(ДанныеОбъекта)
	
	ПроцедурыБухгалтерскогоУчета.ПроверитьВладельцаСубконтоПодразделение(ДанныеОбъекта, 
	ДанныеОбъекта.Организация, 
	Новый Структура("НазваниеСубконтоБУ1, НазваниеСубконтоБУ2, НазваниеСубконтоБУ3, 
	|СубконтоБУ1, СубконтоБУ2, СубконтоБУ3",
	"СубконтоЗатратБУ1", "СубконтоЗатратБУ2", "СубконтоЗатратБУ3", 
	ДанныеОбъекта.СубконтоЗатратБУ1, ДанныеОбъекта.СубконтоЗатратБУ2, ДанныеОбъекта.СубконтоЗатратБУ3));
	
	ПроцедурыБухгалтерскогоУчета.ПроверитьВладельцаСубконтоПодразделение(ДанныеОбъекта, 
	ДанныеОбъекта.Организация, 
	Новый Структура("НазваниеСубконтоБУ1, НазваниеСубконтоБУ2, НазваниеСубконтоБУ3, 
	|СубконтоБУ1, СубконтоБУ2, СубконтоБУ3",
	"СубконтоЗатратНУ1", "СубконтоЗатратНУ2", "СубконтоЗатратНУ3", 
	ДанныеОбъекта.СубконтоЗатратНУ1, ДанныеОбъекта.СубконтоЗатратНУ2, ДанныеОбъекта.СубконтоЗатратНУ3));
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СчетЗатратНУПриИзмененииНаСервере(ДанныеОбъекта)
	
	ПроцедурыБухгалтерскогоУчета.ПроверитьВладельцаСубконтоПодразделение(ДанныеОбъекта, 
	ДанныеОбъекта.Организация, 
	Новый Структура("НазваниеСубконтоБУ1, НазваниеСубконтоБУ2, НазваниеСубконтоБУ3, 
	|СубконтоБУ1, СубконтоБУ2, СубконтоБУ3",
	"СубконтоЗатратНУ1", "СубконтоЗатратНУ2", "СубконтоЗатратНУ3", 
	ДанныеОбъекта.СубконтоЗатратНУ1, ДанныеОбъекта.СубконтоЗатратНУ2, ДанныеОбъекта.СубконтоЗатратНУ3));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатьюДДСВАналитикеСчета()
	
	// Если ДДС не заполнена устанавливать субконто не нужно
	Если НЕ ЗначениеЗаполнено(ЭтотОбъект.СтатьяДвиженияДенежныхСредств) Тогда
		
		Возврат;
		
	КонецЕсли;	
	
	// статья ДДС определена в аналитике счета расчетов
	СвойстваСчета = ПроцедурыБухгалтерскогоУчетаВызовСервераПовтИсп.ПолучитьСвойстваСчета(ЭтотОбъект.СчетЗатратБУ);
	
	Индекс = 1;
	Пока Индекс < 3  Цикл
		
		Если СвойстваСчета["ВидСубконто" + Индекс] = ПредопределенноеЗначение("ПланВидовХарактеристик.ВидыСубконтоТиповые.СтатьиДвиженияДенежныхСредств") Тогда
			ЭтотОбъект["СубконтоЗатратБУ" + Индекс] = ЭтотОбъект.СтатьяДвиженияДенежныхСредств;
			ОбщегоНазначенияБККлиентСервер.ЗаменитьСубконтоНУ(ЭтотОбъект, ЭтотОбъект.СчетЗатратБУ, ЭтотОбъект.СчетЗатратНУ, Индекс, ЭтотОбъект["СубконтоЗатратБУ" + Индекс], "СубконтоЗатратНУ");
			Прервать;
			
		КонецЕсли;
		
		Индекс = Индекс + 1;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоНачалоВыбора(Элемент, ИмяЭлементаСубконто, ИндексСубконто, ИмяЭлементаСчета, СтрокаТаблицы, СтандартнаяОбработка)	
	
	ПараметрыСправочника = СписокПараметровВыбораСубконто(ЭтотОбъект, СтрокаТаблицы, ИмяЭлементаСубконто + "%Индекс%", ИмяЭлементаСчета, КонтрагентБанк);
	ПроцедурыБухгалтерскогоУчетаКлиент.НачалоВыбораЗначенияСубконто(ЭтаФорма, Элемент, ИндексСубконто, СтандартнаяОбработка, ПараметрыСправочника);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьМетодОтнесенияНДСВЗачет(Организация, Дата)
	
	Возврат УчетнаяПолитикаСервер.ПолучитьМетодОтнесенияНДСВЗачет(Организация, Дата);
	
КонецФункции

&НаСервере
Процедура БанкПриИзмененииНаСервере()
	
	НастроитьВидимостьЭлементов();
	
КонецПроцедуры

&НаСервере
Процедура СохранитьЗначенияПриОткрытии()
	
	ЗначенияПриОткрытии = Новый Структура();
	
	ЗначенияПриОткрытии.Вставить("СтатьяДвиженияДенежныхСредств", СтатьяДвиженияДенежныхСредств);
	ЗначенияПриОткрытии.Вставить("ДоговорКонтрагента"			, ДоговорКонтрагента);
	ЗначенияПриОткрытии.Вставить("ПроцентКомиссии"				, ПроцентКомиссии);
	ЗначенияПриОткрытии.Вставить("СчетЗатратБУ"					, СчетЗатратБУ);
	ЗначенияПриОткрытии.Вставить("СчетЗатратНУ"                 , СчетЗатратНУ);
	ЗначенияПриОткрытии.Вставить("СубконтоЗатратБУ1"            , СубконтоЗатратБУ1);
	ЗначенияПриОткрытии.Вставить("СубконтоЗатратБУ2"            , СубконтоЗатратБУ2);
	ЗначенияПриОткрытии.Вставить("СубконтоЗатратБУ3"            , СубконтоЗатратБУ3);
	ЗначенияПриОткрытии.Вставить("СубконтоЗатратНУ1"            , СубконтоЗатратНУ1);
	ЗначенияПриОткрытии.Вставить("СубконтоЗатратНУ2"            , СубконтоЗатратНУ2);
	ЗначенияПриОткрытии.Вставить("СубконтоЗатратНУ3"            , СубконтоЗатратНУ3);
	ЗначенияПриОткрытии.Вставить("УчитыватьНДС"                 , УчитыватьНДС);
	ЗначенияПриОткрытии.Вставить("СчетУчетаНДС"                 , СчетУчетаНДС);
	ЗначенияПриОткрытии.Вставить("СтавкаНДС"                    , СтавкаНДС);
	ЗначенияПриОткрытии.Вставить("НДСВидПоступления"            , НДСВидПоступления);
	ЗначенияПриОткрытии.Вставить("НДСВидОборота"                , НДСВидОборота);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ЗначенияИзменились(Форма)
	
	ЗначенияИзменились = Ложь; 
	
	Для Каждого НачальноеЗначение Из Форма.ЗначенияПриОткрытии Цикл
		ТекущееЗначение = Форма[НачальноеЗначение.Ключ];
		Если ТекущееЗначение <> НачальноеЗначение.Значение Тогда
			ЗначенияИзменились = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ЗначенияИзменились;
	
КонецФункции

#КонецОбласти