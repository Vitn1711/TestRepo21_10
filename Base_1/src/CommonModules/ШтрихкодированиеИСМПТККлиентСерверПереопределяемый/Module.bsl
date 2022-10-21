
// В процедуре нужно реализовать возможность работы с видами продукции, с которыми предполагается работа объектов.
// (См. ШтрихкодированиеИСМПТККлиентСервер.ВключитьПоддержкуВидовПродукцииИС).
Процедура ПриЗаполненииПараметровСканирования(ПараметрыСканирования, Контекст, ВидПродукции) Экспорт
		
	ЗаполнитьБазовыеПараметрыСканирования(ПараметрыСканирования, Контекст);
	
	Возврат;
	
КонецПроцедуры

Процедура ЗаполнитьБазовыеПараметрыСканирования(ПараметрыСканирования, Контекст)
	
	//БМ_ИСМПТ НА_РАЗВИТИЕ	Товарные группы, заполнение параметров сканирования КМ
	Если ШтрихкодированиеИСМПТККлиентСервер.ДопустимВидПродукции(ПараметрыСканирования, ПредопределенноеЗначение("Перечисление.ВидыПродукцииИСМПТК.Табачная")) 
		ИЛИ ШтрихкодированиеИСМПТККлиентСервер.ДопустимВидПродукции(ПараметрыСканирования, ПредопределенноеЗначение("Перечисление.ВидыПродукцииИСМПТК.Обувная")) 
		ИЛИ ШтрихкодированиеИСМПТККлиентСервер.ДопустимВидПродукции(ПараметрыСканирования, ПредопределенноеЗначение("Перечисление.ВидыПродукцииИСМПТК.МолочнаяПродукция"))
		ИЛИ ШтрихкодированиеИСМПТККлиентСервер.ДопустимВидПродукции(ПараметрыСканирования, ПредопределенноеЗначение("Перечисление.ВидыПродукцииИСМПТК.Алкогольная"))
		ИЛИ ШтрихкодированиеИСМПТККлиентСервер.ДопустимВидПродукции(ПараметрыСканирования, ПредопределенноеЗначение("Перечисление.ВидыПродукцииИСМПТК.ЛегкаяПромышленность")) 
		ИЛИ ШтрихкодированиеИСМПТККлиентСервер.ДопустимВидПродукции(ПараметрыСканирования, ПредопределенноеЗначение("Перечисление.ВидыПродукцииИСМПТК.ЛекарственныеПрепараты")) Тогда
		
		Если ТипЗнч(Контекст) = Тип("УправляемаяФорма") Тогда
			Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Контекст, "Объект")
				И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Контекст.Объект, "Организация") Тогда
				ПараметрыСканирования.Организация = Контекст.Объект.Организация;
			ИначеЕсли ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Контекст, "Организация") Тогда
				ПараметрыСканирования.Организация = Контекст.Организация;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

