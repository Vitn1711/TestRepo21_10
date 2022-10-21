
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Справочник.Валюты.ПФ_MXL_КлассификаторВалют");

	Макет.Параметры.Расшифровка = Истина; // чтобы работала расшифровка

	ПолеТабличногоДокумента.Очистить();
	ПолеТабличногоДокумента.Вывести(Макет);

	ПолеТабличногоДокумента.ФиксацияСверху = ПолеТабличногоДокумента.Области.ОбластьРасшифровки.Верх - 1;

	ПолеТабличногоДокумента.ОтображатьЗаголовки = Ложь;
	ПолеТабличногоДокумента.ОтображатьСетку     = Ложь;
	ПолеТабличногоДокумента.ТолькоПросмотр      = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	Если ИмяСобытия = "ЗакрытьФормуКлассификатора" И Источник = ЭтаФорма Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ПолеТабличногоДокументаОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;

	ТабличныйДокумент = ПолеТабличногоДокумента;
	ТекущаяОбласть    = ТабличныйДокумент.ТекущаяОбласть;

	ОбластьКодЧисловой = ТабличныйДокумент.Области.КодЧисловой;
	ОбластьНаименованиеКраткое = ТабличныйДокумент.Области.НаименованиеКраткое;
	ОбластьНаименованиеПолное = ТабличныйДокумент.Области.НаименованиеПолное;
	ОбластьЗагружатьКурсИзИнтернета = ТабличныйДокумент.Области.ЗагружатьКурсИзИнтернета;
	
	СтруктураДанных = Новый Структура;

	СтруктураДанных.Вставить("КодЧисловой", ТабличныйДокумент.Область(ТекущаяОбласть.Верх, ОбластьКодЧисловой.Лево, ТекущаяОбласть.Низ, ОбластьКодЧисловой.Право).Текст);
	СтруктураДанных.Вставить("НаименованиеКраткое", ТабличныйДокумент.Область(ТекущаяОбласть.Верх, ОбластьНаименованиеКраткое.Лево, ТекущаяОбласть.Низ, ОбластьНаименованиеКраткое.Право).Текст);
	СтруктураДанных.Вставить("НаименованиеПолное", ТабличныйДокумент.Область(ТекущаяОбласть.Верх, ОбластьНаименованиеПолное.Лево, ТекущаяОбласть.Низ, ОбластьНаименованиеПолное. Право).Текст);
	СтрокаЗагружатьКурсИзИнтернета = ТабличныйДокумент.Область(ТекущаяОбласть.Верх, ОбластьЗагружатьКурсИзИнтернета.Лево, ТекущаяОбласть.Низ, ОбластьЗагружатьКурсИзИнтернета.Право).Текст;
	ЗагружатьКурсИзИнтернета = ?(НРег(СтрокаЗагружатьКурсИзИнтернета) = "загружать", Истина, Ложь);	
	СтруктураДанных.Вставить("ЗагружатьКурсИзИнтернета", ЗагружатьКурсИзИнтернета);
	
	Ссылка = ПолучитьСуществующуюВалюту(СтруктураДанных.КодЧисловой);
	
	Если НЕ Ссылка.Пустая() Тогда
		ТекстВопроса = НСтр("ru='В справочнике ""Валюты"" уже существует элемент с кодом %1! Открыть существующий?'");
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстВопроса, 
			СтруктураДанных.КодЧисловой);
		
		Данные = Новый Структура("Ссылка, СтруктураДанных", Ссылка, СтруктураДанных);
		
		Режим = РежимДиалогаВопрос.ДаНетОтмена;
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаПриПодборе", ЭтотОбъект, Данные);
		ПоказатьВопрос(Оповещение, ТекстВопроса, Режим, 0);
		
	Иначе
		СоздатьНовуюВалюту(СтруктураДанных);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопросаПриПодборе(Результат, Параметры) Экспорт
	                       
	Если Результат = КодВозвратаДиалога.Да Тогда
		
		ОткрытьФорму("Справочник.Валюты.ФормаОбъекта", Новый Структура("Ключ", Параметры.Ссылка), ЭтаФорма);
		
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		
		СоздатьНовуюВалюту(Параметры.СтруктураДанных);
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервереБезКонтекста
Функция ПолучитьСуществующуюВалюту(КодЧисловой)
	
	Возврат Справочники.Валюты.НайтиПоКоду(КодЧисловой);
		
КонецФункции

&НаКлиенте
Процедура СоздатьНовуюВалюту(СтруктураДанных)
	
	ФормаНовогоЭлемента = ПолучитьФорму("Справочник.Валюты.ФормаОбъекта",, ЭтаФорма);

	ОбъектЗаполнения = ФормаНовогоЭлемента.Объект;
	
	ОбъектЗаполнения.Код = СтруктураДанных.КодЧисловой;
	ОбъектЗаполнения.БуквенныйКод = СтрПолучитьСтроку(СтруктураДанных.НаименованиеКраткое, 1);
	ОбъектЗаполнения.Наименование = СтрПолучитьСтроку(СтруктураДанных.НаименованиеКраткое, 1);
	ОбъектЗаполнения.НаименованиеПолное = СтрПолучитьСтроку(СтруктураДанных.НаименованиеПолное, 1);
	ОбъектЗаполнения.ЗагружатьКурсИзИнтернета = СтруктураДанных.ЗагружатьКурсИзИнтернета;
	
	ФормаНовогоЭлемента.Открыть();
	
КонецПроцедуры
