
#Область СлужебныйПрограммныйИнтерфейс

Функция МетаданныеИсключаемыеИзВыгрузкиВРежимеДляТехническойПоддержки() Экспорт
	
	МетаданныеИсключаемыеИзВыгрузки = Новый Массив;
	
	ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриЗаполненииМетаданныхИсключаемыхИзВыгрузкиВРежимеДляТехническойПоддержки(МетаданныеИсключаемыеИзВыгрузки);
	
	МетаданныеОпеределямогоТипаПрисоединенныйФайл = Метаданные.ОпределяемыеТипы.Найти("ПрисоединенныйФайл");	
	Если МетаданныеОпеределямогоТипаПрисоединенныйФайл <> Неопределено Тогда		
		Для Каждого ТипПрисоединенногоФайла Из МетаданныеОпеределямогоТипаПрисоединенныйФайл.Тип.Типы() Цикл		
			МетаданныеПрисоединенногоФайла = Метаданные.НайтиПоТипу(ТипПрисоединенногоФайла);
			МетаданныеИсключаемыеИзВыгрузки.Добавить(МетаданныеПрисоединенногоФайла);			
		КонецЦикла;		
	КонецЕсли;

	МетаданныеРегистраВерсииОбъектов = Метаданные.РегистрыСведений.Найти("ВерсииОбъектов");
	Если МетаданныеРегистраВерсииОбъектов <> Неопределено Тогда	
		МетаданныеИсключаемыеИзВыгрузки.Добавить(МетаданныеРегистраВерсииОбъектов);		
	КонецЕсли;
	
	МетаданныеРегистраДвоичныеДанныеФайлов = Метаданные.РегистрыСведений.Найти("ДвоичныеДанныеФайлов");
	Если МетаданныеРегистраДвоичныеДанныеФайлов <> Неопределено Тогда	
		МетаданныеИсключаемыеИзВыгрузки.Добавить(МетаданныеРегистраДвоичныеДанныеФайлов);		
	КонецЕсли;
	
	МетаданныеРегистраСведенияОФайлах = Метаданные.РегистрыСведений.Найти("СведенияОФайлах");
	Если МетаданныеРегистраСведенияОФайлах <> Неопределено Тогда	
		МетаданныеИсключаемыеИзВыгрузки.Добавить(МетаданныеРегистраСведенияОФайлах);		
	КонецЕсли;

	ОбщегоНазначенияКлиентСервер.СвернутьМассив(МетаданныеИсключаемыеИзВыгрузки);
	
	Возврат Новый ФиксированныйМассив(МетаданныеИсключаемыеИзВыгрузки);
	
КонецФункции

Функция МетаданныеИмеющиеСсылкиНаИсключаемыеИзВыгрузкиВРежимеДляТехническойПоддержки() Экспорт
	
	СписокМетаданных = Новый Соответствие;
	
	МетаданныеИсключаемыеИзВыгрузки = ВыгрузкаОбластейДанныхДляТехническойПоддержкиПовтИсп.МетаданныеИсключаемыеИзВыгрузкиВРежимеДляТехническойПоддержки();
	ВсеСсылочныеДанные = ВыгрузкаЗагрузкаДанныхСлужебный.ВсеСсылочныеДанные();
	
	ТипыИсключаемыеИзВыгрузки = Новый Массив;
	
	Для Каждого ОбъектМетаданных Из МетаданныеИсключаемыеИзВыгрузки Цикл
		Если ВсеСсылочныеДанные.Найти(ОбъектМетаданных) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ОбъектМетаданных.ПолноеИмя());
		ТипИсключаемыйИзВыгрузки = ТипЗнч(МенеджерОбъекта.ПустаяСсылка());
		
		ТипыИсключаемыеИзВыгрузки.Добавить(ТипИсключаемыйИзВыгрузки);
			
	КонецЦикла;
	
	Для Каждого МетаданныеОбъекта Из ВыгрузкаЗагрузкаДанныхСлужебный.ВсеКонстанты() Цикл
		ДобавитьКонстантуВСписокМетаданных(МетаданныеОбъекта, СписокМетаданных, ТипыИсключаемыеИзВыгрузки);
	КонецЦикла;
	
	Для Каждого МетаданныеОбъекта Из ВсеСсылочныеДанные Цикл
		ДобавитьСсылочныйТипВСписокМетаданных(МетаданныеОбъекта, СписокМетаданных, ТипыИсключаемыеИзВыгрузки);
	КонецЦикла;
	
	Для Каждого МетаданныеОбъекта Из ВыгрузкаЗагрузкаДанныхСлужебный.ВсеНаборыЗаписей() Цикл
		ДобавитьРегистрВТаблицуМетаданных(МетаданныеОбъекта, СписокМетаданных, ТипыИсключаемыеИзВыгрузки);
	КонецЦикла;
	
	Возврат Новый ФиксированноеСоответствие(СписокМетаданных);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ДобавитьКонстантуВСписокМетаданных(МетаданныеОбъекта, СписокМетаданных, ТипыИсключаемыеИзВыгрузки)
	
	Для Каждого ТипИсключаемыйИзВыгрузки Из ТипыИсключаемыеИзВыгрузки Цикл
		
		Если МетаданныеОбъекта.Тип.СодержитТип(ТипИсключаемыйИзВыгрузки) Тогда 
			СписокМетаданных.Вставить(МетаданныеОбъекта.ПолноеИмя(), Новый Массив);		
			Возврат;
		КонецЕсли;

	КонецЦикла;	
		
КонецПроцедуры

Процедура ДобавитьСсылочныйТипВСписокМетаданных(МетаданныеОбъекта, СписокМетаданных, ТипыИсключаемыеИзВыгрузки)
	
	МассивСтруктур = Новый Массив;
	
	Для Каждого Реквизит Из МетаданныеОбъекта.Реквизиты Цикл 
		
		ДобавитьРеквизитВМассив(МассивСтруктур, Реквизит,, ТипыИсключаемыеИзВыгрузки);
		
	КонецЦикла;
	
	Для Каждого ТабличнаяЧасть Из МетаданныеОбъекта.ТабличныеЧасти Цикл 
		
		Для Каждого Реквизит Из ТабличнаяЧасть.Реквизиты Цикл
			
			ДобавитьРеквизитВМассив(МассивСтруктур, Реквизит, ТабличнаяЧасть, ТипыИсключаемыеИзВыгрузки);
			
		КонецЦикла;
		
	КонецЦикла;
	
	ВставитьОбъектМетаданныхВСоответствие(МетаданныеОбъекта.ПолноеИмя(), СписокМетаданных, МассивСтруктур);
	
КонецПроцедуры

Процедура ДобавитьРегистрВТаблицуМетаданных(МетаданныеОбъекта, Знач СписокМетаданных, ТипыИсключаемыеИзВыгрузки)
	
	МассивСтруктур = Новый Массив;
	
	Для Каждого Измерение Из МетаданныеОбъекта.Измерения Цикл 
		
		Если Метаданные.РегистрыРасчета.Содержит(МетаданныеОбъекта.Родитель()) Тогда
			Измерение = Измерение.ИзмерениеРегистра;
		КонецЕсли;
		ДобавитьРеквизитВМассив(МассивСтруктур, Измерение,, ТипыИсключаемыеИзВыгрузки);
		
	КонецЦикла;
	
	Если Метаданные.Последовательности.Содержит(МетаданныеОбъекта) 
		Или Метаданные.РегистрыРасчета.Содержит(МетаданныеОбъекта.Родитель()) Тогда 
		
		Возврат;
		
	КонецЕсли;
	
	Для Каждого Реквизит Из МетаданныеОбъекта.Реквизиты Цикл 
		
		ДобавитьРеквизитВМассив(МассивСтруктур, Реквизит,, ТипыИсключаемыеИзВыгрузки);
		
	КонецЦикла;
	
	Для Каждого Ресурс Из МетаданныеОбъекта.Ресурсы Цикл 
		
		ДобавитьРеквизитВМассив(МассивСтруктур, Ресурс,, ТипыИсключаемыеИзВыгрузки);
		
	КонецЦикла;
	
	ВставитьОбъектМетаданныхВСоответствие(МетаданныеОбъекта.ПолноеИмя(), СписокМетаданных, МассивСтруктур);
	
КонецПроцедуры

// Параметры:
// 	МассивСтруктур - Массив из Структура -
// 	Реквизит - ОбъектМетаданных -
// 	ТабличнаяЧасть - ОбъектМетаданных - 
// 	ТипыИсключаемыеИзВыгрузки - Массив - 
Процедура ДобавитьРеквизитВМассив(МассивСтруктур, Реквизит, ТабличнаяЧасть = Неопределено, ТипыИсключаемыеИзВыгрузки)
	
	Для Каждого ТипИсключаемыйИзВыгрузки Из ТипыИсключаемыеИзВыгрузки Цикл
		
		Если Реквизит.Тип.СодержитТип(ТипИсключаемыйИзВыгрузки) Тогда 
			ИмяРеквизита      = Реквизит.Имя;
			ИмяТабличнойЧасти = ?(ТабличнаяЧасть = Неопределено, Неопределено, ТабличнаяЧасть.Имя);
			
			Структура = СтруктураРеквизитов();
			Структура.ИмяТабличнойЧасти = ИмяТабличнойЧасти;
			Структура.ИмяРеквизита      = ИмяРеквизита;
			
			МассивСтруктур.Добавить(Структура);
			
			Возврат;
		КонецЕсли;
		
	КонецЦикла;
			
КонецПроцедуры

Процедура ВставитьОбъектМетаданныхВСоответствие(ПолноеИмяМетаданных, СписокМетаданных, МассивСтруктур)
	
	Если МассивСтруктур.Количество() = 0 Тогда 
		Возврат;
	КонецЕсли;
	
	СписокМетаданных.Вставить(ПолноеИмяМетаданных, МассивСтруктур);
	
КонецПроцедуры

Функция СтруктураРеквизитов()
	
	Результат = Новый Структура;
	Результат.Вставить("ИмяТабличнойЧасти");
	Результат.Вставить("ИмяРеквизита");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти