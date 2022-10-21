////////////////////////////////////////////////////////////////////////////////
// Подсистема "Менеджер сервиса криптографии".
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

#Область ПолучитьЗапросНаСертификат

Функция СоздатьКонтейнерИЗапросНаСертификатРезультат(Выполнено = Ложь, 
											ДанныеЗапросаИлиОшибка = Неопределено, 
											ОткрытыйКлюч = Неопределено, 
											ИмяПровайдера = Неопределено, 
											ТипПровайдера = Неопределено)
											
	Результат = Новый Структура();
	Результат.Вставить("Выполнено", Выполнено);
	Если Выполнено Тогда
		Результат.Вставить("ЗапросСертификата", ДанныеЗапросаИлиОшибка);
		Результат.Вставить("ОткрытыйКлюч", ОткрытыйКлюч);
		Результат.Вставить("ИмяПровайдера", ИмяПровайдера);
		Результат.Вставить("ТипПровайдера", ТипПровайдера);
	Иначе
		Результат.Вставить("ОписаниеОшибки", ДанныеЗапросаИлиОшибка);
	КонецЕсли;
	
	Возврат Результат;
											
КонецФункции

Процедура СоздатьКонтейнерИЗапросНаСертификат(ОповещениеОЗавершении, 
										ИдентификаторЗаявления, 
										СодержаниеЗапроса, 
										ИдентификаторАбонента = Неопределено,
										НотариусАдвокатГлаваКФХ = Ложь) Экспорт
	
	Контекст = Новый Структура;
	Контекст.Вставить("ОповещениеОЗавершении", ОповещениеОЗавершении);
	Контекст.Вставить("ИдентификаторЗаявления", ИдентификаторЗаявления);
	Контекст.Вставить("СодержаниеЗапроса", СодержаниеЗапроса);
	Контекст.Вставить("ИдентификаторАбонента", ИдентификаторАбонента);
	Контекст.Вставить("НотариусАдвокатГлаваКФХ", НотариусАдвокатГлаваКФХ);
	
	Оповещение 		= Новый ОписаниеОповещения("СоздатьКонтейнерИЗапросНаСертификатПослеПодтверждения", ЭтотОбъект, Контекст);
	ПараметрыФормы  = Новый Структура("РежимПроверки", "Подтверждение");
	
	ЭлектроннаяПодписьВМоделиСервисаКлиент.ИзменитьНастройкиПолученияВременныхПаролей(Неопределено, Оповещение, ПараметрыФормы);
	
КонецПроцедуры

Процедура СоздатьКонтейнерИЗапросНаСертификатПослеПодтверждения(Результат, ВходящийКонтекст)	Экспорт
	
	Если Результат <> Неопределено 
		и Результат.Свойство("НомерТелефона") Тогда
		Оповещение 			= Новый ОписаниеОповещения("СоздатьКонтейнерИЗапросНаСертификатПослеПолучения", ЭтотОбъект, ВходящийКонтекст);
		
		ДлительнаяОперация = МенеджерСервисаКриптографииСлужебныйВызовСервера.СоздатьКонтейнерИЗапросНаСертификат(ВходящийКонтекст.ИдентификаторЗаявления,
								ВходящийКонтекст.СодержаниеЗапроса,
								Результат.НомерТелефона,
								Результат.ЭлектроннаяПочта,
								ВходящийКонтекст.ИдентификаторАбонента,
								ВходящийКонтекст.НотариусАдвокатГлаваКФХ);
		
		ОжидатьЗавершенияВыполненияВФоне(Оповещение, ДлительнаяОперация);
		
	Иначе
		ОтрицательныйРезультат = СоздатьКонтейнерИЗапросНаСертификатРезультат(Ложь, , , 
											НСтр("ru = 'Не подтверждены данные для получения временных паролей'"));
		ВыполнитьОбработкуОповещения(ВходящийКонтекст.ОповещениеОЗавершении, ОтрицательныйРезультат);
	КонецЕсли;
	
КонецПроцедуры

Процедура СоздатьКонтейнерИЗапросНаСертификатПослеПолучения(ДлительнаяОперация, ВходящийКонтекст) Экспорт
	
	Результат = ПолучитьРезультатВыполненияВФоне(ДлительнаяОперация);
	
	Если Результат.Выполнено Тогда
		РезультатЗапроса = Результат.РезультатВыполнения;
		Если ТипЗнч(РезультатЗапроса) = Тип("Структура") Тогда
			Если РезультатЗапроса.Выполнено Тогда		
				РезультатВыполнения = СоздатьКонтейнерИЗапросНаСертификатРезультат(Истина, 
										РезультатЗапроса.ЗапросНаСертификат,
										РезультатЗапроса.ОткрытыйКлюч,
										РезультатЗапроса.ИмяПровайдера,
										РезультатЗапроса.ТипПровайдера);
			Иначе
				РезультатВыполнения = СоздатьКонтейнерИЗапросНаСертификатРезультат(Ложь,
										НСтр("ru = 'Операция завершилась с ошибкой'") + " " +  
										РезультатЗапроса.ОписаниеОшибки);
			КонецЕсли;
		Иначе
			РезультатВыполнения = СоздатьКонтейнерИЗапросНаСертификатРезультат(Ложь, 
									НСтр("ru = 'Операция завершилась с ошибкой'"));
		КонецЕсли;
	Иначе
		РезультатВыполнения = СоздатьКонтейнерИЗапросНаСертификатРезультат(Ложь, ПодробноеПредставлениеОшибки(Результат.ИнформацияОбОшибке));
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ВходящийКонтекст.ОповещениеОЗавершении, РезультатВыполнения);
	
КонецПроцедуры

#КонецОбласти

#Область ИнициализироватьКлючевойКонтейнер

Функция УстановитьСертификатВКонтейнерИХранилищеРезультат(Выполнено = Ложь, 
											ОписаниеОшибки = "")
											
	Результат = Новый Структура();
	Результат.Вставить("Выполнено", Выполнено);
	Если НЕ Выполнено Тогда
		Результат.Вставить("ОписаниеОшибки", ОписаниеОшибки);
	КонецЕсли;
	
	Возврат Результат;
											
КонецФункции

Процедура УстановитьСертификатВКонтейнерИХранилище(ОповещениеОЗавершении, ИдентификаторЗаявления, ДанныеСертификата) Экспорт
	
	Контекст = Новый Структура;
	Контекст.Вставить("ОповещениеОЗавершении", ОповещениеОЗавершении);
	
	Оповещение 			= Новый ОписаниеОповещения("УстановитьСертификатВКонтейнерИХранилищеПослеВыполнения", ЭтотОбъект, Контекст);
	ПараметрыПроцедуры 	= Новый Структура;
	ПараметрыПроцедуры.Вставить("ИдентификаторЗаявления", 	ИдентификаторЗаявления);
	ПараметрыПроцедуры.Вставить("ДанныеСертификата", 		ДанныеСертификата);
	
	ДлительнаяОперация = МенеджерСервисаКриптографииСлужебныйВызовСервера.УстановитьСертификатВКонтейнерИХранилище(ИдентификаторЗаявления,
								ДанныеСертификата);
		
	ОжидатьЗавершенияВыполненияВФоне(Оповещение, ДлительнаяОперация);
		
КонецПроцедуры

Процедура УстановитьСертификатВКонтейнерИХранилищеПослеВыполнения(ДлительнаяОперация, ВходящийКонтекст) Экспорт
	
	Результат = ПолучитьРезультатВыполненияВФоне(ДлительнаяОперация);
	
	Если Результат.Выполнено Тогда
		
		РезультатЗапроса = Результат.РезультатВыполнения;
		Если ТипЗнч(РезультатЗапроса) = Тип("Структура") Тогда
			Если РезультатЗапроса.Выполнено Тогда		
				РезультатВыполнения = УстановитьСертификатВКонтейнерИХранилищеРезультат(Истина);
			Иначе
				РезультатВыполнения = УстановитьСертификатВКонтейнерИХранилищеРезультат(Ложь, 
										РезультатЗапроса.ОписаниеОшибки);
			КонецЕсли;
		Иначе
			РезультатВыполнения = УстановитьСертификатВКонтейнерИХранилищеРезультат(Ложь, 
									НСтр("ru = 'Операция завершилась с ошибкой'"));
		КонецЕсли;
	Иначе
		РезультатВыполнения = УстановитьСертификатВКонтейнерИХранилищеРезультат(Ложь, ПодробноеПредставлениеОшибки(Результат.ИнформацияОбОшибке));
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ВходящийКонтекст.ОповещениеОЗавершении, РезультатВыполнения);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОжидатьЗавершенияВыполненияВФоне(ОповещениеОЗавершении, ДлительнаяОперация) Экспорт
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(Неопределено);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);

КонецПроцедуры

Функция ПолучитьРезультатВыполненияВФоне(ДлительнаяОперация)
	
	РезультатВыполнения = Новый Структура("Выполнено", Ложь);
	
	Если ДлительнаяОперация = Неопределено Тогда
		РезультатВыполнения.Вставить("ИнформацияОбОшибке", 
					НСтр("ru = 'Вызов API сервиса криптографии не был завершен штатно.'"));
	ИначеЕсли ДлительнаяОперация.Статус = "Выполнено" Тогда
		РезультатВыполнения.Выполнено = Истина;
		РезультатВыполнения.Вставить("РезультатВыполнения", 
					ПолучитьИзВременногоХранилища(ДлительнаяОперация.АдресРезультата));
	Иначе
		ОписаниеОшибки = ДлительнаяОперация.КраткоеПредставлениеОшибки;
		Если ТипЗнч(ОписаниеОшибки) = Тип("Строка") Тогда
			Попытка
				ВызватьИсключение ОписаниеОшибки;
			Исключение	
				РезультатВыполнения.Вставить("ИнформацияОбОшибке", ИнформацияОбОшибке());
			КонецПопытки;	
		Иначе	
			РезультатВыполнения.Вставить("ИнформацияОбОшибке", ОписаниеОшибки);
		КонецЕсли;
	КонецЕсли;
	
	Возврат РезультатВыполнения;
	
КонецФункции

#КонецОбласти