#Область ПрограммныйИнтерфейс

// Определить объекты метаданных, в модулях менеджеров которых ограничивается возможность
// редактирования реквизитов с помощью экспортной функции ПолучитьБлокируемыеРеквизитыОбъекта.
//
// Функция ПолучитьБлокируемыеРеквизитыОбъекта должна возвращать значение Массив - строки в формате
// ИмяРеквизита[;ИмяЭлементаФормы,...], где ИмяРеквизита - имя реквизита объекта, ИмяЭлементаФормы -
// имя элемента формы, связанного с реквизитом. Например, "Объект.Автор", "ПолеАвтор".
//
// Поле надписи, связанное с реквизитом, не блокируется. Если требуется блокировать,
// имя элемента надписи нужно указать после точки с запятой, как написано выше.
//
// Параметры:
//   Объекты - Соответствие - в качестве ключа указать полное имя объекта метаданных,
//             подключенного к подсистеме "Запрет редактирования реквизитов объектов",
//             в качестве значения - пустую строку.
//
// Пример:
//   Объекты.Вставить(Метаданные.Документы.ЗаказПокупателя.ПолноеИмя(), "");
//
//   При этом в модуле менеджера документа ЗаказПокупателя размещается код:
//   // См. ЗапретРедактированияРеквизитовОбъектовПереопределяемый.ПриОпределенииОбъектовСЗаблокированнымиРеквизитами.
//   Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
//   	БлокируемыеРеквизиты = Новый Массив;
//   	БлокируемыеРеквизиты.Добавить("Организация"); // заблокировать редактирование реквизита Организация
//   	Возврат БлокируемыеРеквизиты;
//   КонецФункции
//
Процедура ПриОпределенииОбъектовСЗаблокированнымиРеквизитами(Объекты) Экспорт
	
	Объекты.Вставить(Метаданные.ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.ПолноеИмя(), "ПолучитьБлокируемыеРеквизитыОбъекта");
	
	Если ОбщегоНазначенияБККлиентСервер.ЭтоПростаяВерсияКонфигурации() Тогда
		Объекты.Вставить(Метаданные.Документы.ПоступлениеДопРасходов.ПолноеИмя(), "");
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаблокироватьРеквизиты(Форма, ОбъектПроведен, ДанныеОбъекта = Неопределено) Экспорт
	
	Если ОбщегоНазначенияБККлиентСервер.ЭтоПростаяВерсияКонфигурации() И ОбъектПроведен Тогда

		ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(Форма,,,ДанныеОбъекта);
		Форма.РазблокироватьРеквизиты();
			
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаблокироватьКорректировкуДвижений(Форма, ОбъектПроведен, ДокументСсылка) Экспорт
	
	Если ОбщегоНазначенияБККлиентСервер.ЭтоПростаяВерсияКонфигурации() И ОбъектПроведен Тогда

		Форма.Элементы.РучнаяКорректировка.Видимость = Ложь;
		//для розничных продаж нельзя вводить документ корректироовки
		Если ТипЗнч(ДокументСсылка) =  Тип("ДокументСсылка.ОтчетОРозничныхПродажах") 
			ИЛИ ТипЗнч(ДокументСсылка) =  Тип("ДокументСсылка.ЧекККМ") Тогда
			Форма.Элементы.СоздатьНаОсновании.Видимость = Ложь
		КонецЕсли;
					
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
