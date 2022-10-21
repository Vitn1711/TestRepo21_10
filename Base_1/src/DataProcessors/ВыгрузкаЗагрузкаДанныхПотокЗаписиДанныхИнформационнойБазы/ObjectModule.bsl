#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем ТекущаяИнициализация;
Перем ТекущийПотокЗаписи;
Перем ТекущийСчетчикОбъектов;
Перем ТекущийСериализатор;

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура ОткрытьФайл(Знач ИмяФайла, Знач Сериализатор = Неопределено) Экспорт
	
	Если ТекущаяИнициализация Тогда
		
		ВызватьИсключение НСтр("ru = 'Объект уже был инициализирован ранее'");
		
	Иначе
		
		Если Сериализатор = Неопределено Тогда
			ТекущийСериализатор = СериализаторXDTO;
		Иначе
			ТекущийСериализатор = Сериализатор;
		КонецЕсли;
		
		ТекущийПотокЗаписи = Новый ЗаписьXML();
		ТекущийПотокЗаписи.ОткрытьФайл(ИмяФайла);
		ТекущийПотокЗаписи.ЗаписатьОбъявлениеXML();
		
		ТекущийПотокЗаписи.ЗаписатьНачалоЭлемента("Data");
		
		ПрефиксыПространствИмен = ВыгрузкаЗагрузкаДанныхСлужебный.ПрефиксыПространствИмен();
		Для Каждого ПрефиксПространстваИмен Из ПрефиксыПространствИмен Цикл
			ТекущийПотокЗаписи.ЗаписатьСоответствиеПространстваИмен(ПрефиксПространстваИмен.Значение, ПрефиксПространстваИмен.Ключ);
		КонецЦикла;
		
		ТекущийСчетчикОбъектов = 0;
		
		//
		
		ТекущаяИнициализация = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаписатьОбъектДанныхИнформационнойБазы(Объект, Артефакты) Экспорт
	
	ТекущийПотокЗаписи.ЗаписатьНачалоЭлемента("DumpElement");
	
	Если Артефакты.Количество() > 0 Тогда
		
		ТекущийПотокЗаписи.ЗаписатьНачалоЭлемента("Artefacts");
		Для Каждого Артефакт Из Артефакты Цикл 
			
			ФабрикаXDTO.ЗаписатьXML(ТекущийПотокЗаписи, Артефакт);
			
		КонецЦикла;
		ТекущийПотокЗаписи.ЗаписатьКонецЭлемента();
		
	КонецЕсли;
	
	Попытка
		
		ТекущийСериализатор.ЗаписатьXML(ТекущийПотокЗаписи, Объект);
		
	Исключение
		
		ИсходныйТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ИсходныйТекстОшибкиБезНедопустимыхСимволов = ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыXML(
			ИсходныйТекстОшибки,
			Символ(65533));
		
		ВызватьИсключение СтрШаблон(НСтр("ru = 'При выгрузке объекта %1 произошла ошибка: %2'"),
			Объект,
			ИсходныйТекстОшибкиБезНедопустимыхСимволов);
		
	КонецПопытки;
	
	ТекущийПотокЗаписи.ЗаписатьКонецЭлемента();
	
	ТекущийСчетчикОбъектов = ТекущийСчетчикОбъектов + 1;
	
КонецПроцедуры

Функция КоличествоОбъектов() Экспорт
	
	Возврат ТекущийСчетчикОбъектов;
	
КонецФункции

Процедура Закрыть() Экспорт
	
	ТекущийПотокЗаписи.ЗаписатьКонецЭлемента();
	ТекущийПотокЗаписи.Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область Инициализация

ТекущаяИнициализация = Ложь;

#КонецОбласти

#КонецЕсли