#Область ОбработчикиСобытийФормы

&НаКлиенте
Перем ВыполняетсяОперация;

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("ФискальноеУстройство") Тогда
		ФискальноеУстройство = Параметры.ФискальноеУстройство;
	КонецЕсли;
	
	Если Параметры.Свойство("Организация") Тогда
		Организация = Параметры.Организация;
	КонецЕсли;

	Если Параметры.Свойство("ТипОперации") Тогда
		ТипОперации = Параметры.ТипОперации;
		Если ТипОперации = 1 Тогда
			Заголовок = НСтр("ru='Регистрация фискального накопителя'")
		ИначеЕсли ТипОперации = 3 Тогда
			Заголовок = НСтр("ru='Закрытие фискального накопителя'");
		Иначе
			Заголовок = НСтр("ru='Изменение параметров регистрации фискального накопителя'");
		КонецЕсли;
		Элементы.ТипОперации.Видимость = Ложь;
	Иначе
		ТипОперации = 2;
		Элементы.ТипОперации.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ВыполняетсяОперация = Ложь;
	КодПричиныПеререгистрации = 3;
	
	ОповещениеПриЗавершении = Новый ОписаниеОповещения("ПолучениеПараметровФискальногоУстройства_Завершение", ЭтотОбъект);
	МенеджерОборудованияКлиент.НачатьПолучениеПараметровФискальногоУстройства(ОповещениеПриЗавершении, УникальныйИдентификатор, ФискальноеУстройство, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучениеПараметровФискальногоУстройства_Завершение(РезультатВыполнения, Параметры) Экспорт
	
	ОчиститьСообщения();
	
	Если РезультатВыполнения.Результат Тогда
		ПараметрыККТ = РезультатВыполнения.ВыходныеПараметры;
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ПараметрыККТ);
		СистемыНалогообложения = СтрРазделить(ПараметрыККТ.КодыСистемыНалогообложения, ",", Ложь);
		КодыСистемыНалогообложения0 = СистемыНалогообложения.Найти("0") <> Неопределено;
		КодыСистемыНалогообложения1 = СистемыНалогообложения.Найти("1") <> Неопределено;
		КодыСистемыНалогообложения2 = СистемыНалогообложения.Найти("2") <> Неопределено;
		КодыСистемыНалогообложения3 = СистемыНалогообложения.Найти("3") <> Неопределено;
		КодыСистемыНалогообложения4 = СистемыНалогообложения.Найти("4") <> Неопределено;
		КодыСистемыНалогообложения5 = СистемыНалогообложения.Найти("5") <> Неопределено;
		
		ПризнакиАгента = СтрРазделить(ПараметрыККТ.ПризнакиАгента, ",", Ложь);
		ПА_БанковскийПлатежныйАгент    = ПризнакиАгента.Найти("0") <> Неопределено;
		ПА_БанковскийПлатежныйСубагент = ПризнакиАгента.Найти("1") <> Неопределено;
		ПА_ПлатежныйАгент              = ПризнакиАгента.Найти("2") <> Неопределено;
		ПА_ПлатежныйСубагент           = ПризнакиАгента.Найти("3") <> Неопределено;
		ПА_Поверенный                  = ПризнакиАгента.Найти("4") <> Неопределено;
		ПА_Комиссионер                 = ПризнакиАгента.Найти("5") <> Неопределено;
		ПА_Агент                       = ПризнакиАгента.Найти("6") <> Неопределено;
		
		ВерсияФФДККТ = ПараметрыККТ.ВерсияФФДККТ; 
		Элементы.ВерсияФФД.Заголовок = "ФФД" + Символы.НПП + ПараметрыККТ.ВерсияФФДККТ;
	Иначе
		ТекстСообщения = РезультатВыполнения.ОписаниеОшибки;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецЕсли; 
	
	ОбновитьСостояниеФормы();
	
	Если ТипОперации = 1 Тогда // Регистрация ФН
		
		Если РезультатВыполнения.Результат И ПараметрыККТ.ПризнакФискализации Тогда
			Элементы.ОперацияПродолжить.Видимость = Ложь;
			ТекстСообщения = НСтр("ru='Фискальный накопитель уже зарегистрирован. Воспользуйтесь функцией изменение параметров регистрации фискального накопителя.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			Возврат;
		КонецЕсли;                                                            
		
		ПараметрыРегистрации = Новый Структура("ОрганизацияНазвание, ОрганизацияИНН, АдресПроведенияРасчетов");
		МенеджерОборудованияВызовСервераПереопределяемый.ЗаполнитьРеквизитыОрганизацииДляРегистрацииФН(Организация, ПараметрыРегистрации); 
		
		Если Не ПустаяСтрока(ПараметрыРегистрации.ОрганизацияНазвание) Тогда
			ОрганизацияНазвание = ПараметрыРегистрации.ОрганизацияНазвание;
		КонецЕсли; 
		Если Не ПустаяСтрока(ПараметрыРегистрации.ОрганизацияИНН) Тогда
			ОрганизацияИНН = ПараметрыРегистрации.ОрганизацияИНН;
		КонецЕсли; 
		Если Не ПустаяСтрока(ПараметрыРегистрации.АдресПроведенияРасчетов) Тогда
			АдресПроведенияРасчетов = ПараметрыРегистрации.АдресПроведенияРасчетов;
		КонецЕсли; 
		
	КонецЕсли; 
	
	ОповещениеПриЗавершении = Новый ОписаниеОповещения("ПолучениеТекущегоСостоянияФискальногоУстройства_Завершение", ЭтотОбъект);
	МенеджерОборудованияКлиент.НачатьПолучениеТекущегоСостоянияФискальногоУстройства(ОповещениеПриЗавершении, УникальныйИдентификатор, ФискальноеУстройство);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучениеТекущегоСостоянияФискальногоУстройства_Завершение(РезультатВыполнения, Параметры) Экспорт
	
	Если РезультатВыполнения.Результат Тогда
		СтатусСмены = РезультатВыполнения.ВыходныеПараметры[2];
		Если СтатусСмены <> 1 Тогда
			Элементы.ОперацияПродолжить.Видимость = Ложь;
			ТекстСообщения = НСтр("ru='Операция доступна только при закрытой смене на фискальном устройстве. Закройте смену и повторите операцию.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		КонецЕсли; 
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПродолжитьОперациюПередПродолжением(РезультатВопроса, ПараметрыЗаписи) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ВыполняетсяОперация = Истина;
		ВыполнитьОперацию();
	КонецЕсли;
        
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьОперацию(Команда)
	
	Если ТипОперации = 3 И Не ВыполняетсяОперация Тогда
		Оповещение = Новый ОписаниеОповещения("ПродолжитьОперациюПередПродолжением", ЭтотОбъект);
		Сообщение = НСтр("ru='Закрытие фискального накопителя - необратимая операция.
		|В дальнейшем фискальный накопитель нельзя будет использовать.
		|Вы уверенны что хотите продолжить операцию?'");
		ПоказатьВопрос(Оповещение, Сообщение, РежимДиалогаВопрос.ДаНет);
		Возврат;
	КонецЕсли;
	
	ВыполнитьОперацию();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОперацию()
	
	Если Элементы.ГруппаРеквизитыОрганизации.Видимость Тогда
		КодыСистемыУстановлен = КодыСистемыНалогообложения0 Или КодыСистемыНалогообложения1 Или КодыСистемыНалогообложения2 
			Или КодыСистемыНалогообложения3 Или КодыСистемыНалогообложения4 Или КодыСистемыНалогообложения5;
			Если Не КодыСистемыУстановлен Тогда
				ПоказатьПредупреждение(, НСтр("ru='Не указан не один код налогообложения.'"));
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ПараметрыНастройки = МенеджерОборудованияКлиентСервер.ПараметрыОперацииФискализацииНакопителя();
	ЗаполнитьЗначенияСвойств(ПараметрыНастройки, ЭтотОбъект);
	
	СистемыНалогообложения = Новый Массив();
	Если КодыСистемыНалогообложения0 Тогда
		СистемыНалогообложения.Добавить("0");
	КонецЕсли;
	Если КодыСистемыНалогообложения1 Тогда
		СистемыНалогообложения.Добавить("1");
	КонецЕсли;
	Если КодыСистемыНалогообложения2 Тогда
		СистемыНалогообложения.Добавить("2");
	КонецЕсли;
	Если КодыСистемыНалогообложения3 Тогда
		СистемыНалогообложения.Добавить("3");
	КонецЕсли;
	Если КодыСистемыНалогообложения4 Тогда
		СистемыНалогообложения.Добавить("4");
	КонецЕсли;
	Если КодыСистемыНалогообложения5 Тогда
		СистемыНалогообложения.Добавить("5");
	КонецЕсли;
	ПараметрыНастройки.КодыСистемыНалогообложения = СтрСоединить(СистемыНалогообложения,",");
	
	ПризнакиАгента = Новый Массив();
	Если ПА_БанковскийПлатежныйАгент Тогда
		ПризнакиАгента.Добавить("0");
	КонецЕсли;
	Если ПА_БанковскийПлатежныйСубагент Тогда
		ПризнакиАгента.Добавить("1");
	КонецЕсли;
	Если ПА_ПлатежныйАгент Тогда
		ПризнакиАгента.Добавить("2");
	КонецЕсли;
	Если ПА_ПлатежныйСубагент Тогда
		ПризнакиАгента.Добавить("3");
	КонецЕсли;
	Если ПА_Поверенный Тогда
		ПризнакиАгента.Добавить("4");
	КонецЕсли;
	Если ПА_Комиссионер Тогда
		ПризнакиАгента.Добавить("5");
	КонецЕсли;
	Если ПА_Агент Тогда
		ПризнакиАгента.Добавить("6");
	КонецЕсли;
	ПараметрыНастройки.ПризнакиАгента = СтрСоединить(ПризнакиАгента,",");
	
	Если Элементы.ГруппаПричиныИзмененияСведенийОККТ.Видимость И ПричиныИзмененияСведенийОККТ.Количество() > 0 Тогда
		ПричиныИзмененияСведений = Новый Массив();
		Для Каждого  ЭлементПричинаИзмененияСведений Из ПричиныИзмененияСведенийОККТ Цикл
			КодПричиныИзмененияСведений = МенеджерОборудованияКлиентСервер.КодПричиныИзмененияСведенийККТ(ЭлементПричинаИзмененияСведений.ПричинаИзмененияСведений);
			ПричиныИзмененияСведений.Добавить(КодПричиныИзмененияСведений);
		КонецЦикла;
		ПараметрыНастройки.КодыПричинИзмененияСведений = СтрСоединить(ПричиныИзмененияСведений,",");
	КонецЕсли;
	
	Кассир = "";
	ВыполненаСтандартнаяОбработка = Истина;
	МенеджерОборудованияКлиентСерверПереопределяемый.ОбработкаЗаполненияИмяКассира(Кассир, ВыполненаСтандартнаяОбработка); 
	ПараметрыНастройки.Кассир = ?(Не ВыполненаСтандартнаяОбработка, Кассир, НСтр("ru='Администратор'")); 
	
	КассирИНН = "";
	ВыполненаСтандартнаяОбработка = Истина;
	МенеджерОборудованияКлиентСерверПереопределяемый.ОбработкаЗаполненияИННКассира(КассирИНН, ВыполненаСтандартнаяОбработка); 
	ПараметрыНастройки.КассирИНН = ?(Не ВыполненаСтандартнаяОбработка, КассирИНН, ""); 
	
	Закрыть(ПараметрыНастройки);  
	
КонецПроцедуры

&НаКлиенте
Процедура ОперацияОтмена(Команда)
	
	Закрыть(Неопределено); 
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСостояниеФормы()
	
	Элементы.КодПричиныПеререгистрации.Видимость = ТипОперации = 2;
	Элементы.НомерАвтоматаДляАвтоматическогоРежима.Доступность = ПризнакАвтоматическогоРежима;
	
	Элементы.ГруппаОператорФискальныхДанных.Видимость = ТипОперации <> 2 Или КодПричиныПеререгистрации = 2 Или КодПричиныПеререгистрации = 1;
	Элементы.ГруппаРеквизитыОрганизации.Видимость = ТипОперации <> 2 Или КодПричиныПеререгистрации = 3 Или КодПричиныПеререгистрации = 1;
	Элементы.ГруппаНастройкиККТ.Видимость = ТипОперации <> 2 Или КодПричиныПеререгистрации = 4 Или КодПричиныПеререгистрации = 1;
	
	Элементы.ГруппаПричиныИзмененияСведенийОККТ.Видимость = (ТипОперации = 2) И (ВерсияФФДККТ = "1.1");
	
	Элементы.ОрганизацияИНН.ТолькоПросмотр = НЕ (ТипОперации = 1);
	Элементы.РегистрационныйНомерККТ.ТолькоПросмотр = НЕ (ТипОперации = 1);
	
КонецПроцедуры

&НаКлиенте
Процедура ПризнакАвтоматическогоРежимаПриИзменении(Элемент)
	
	ОбновитьСостояниеФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура КодПричиныПеререгистрацииПриИзменении(Элемент)
	
	ОбновитьСостояниеФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ТипОперацииПриИзменении(Элемент)
	
	ОбновитьСостояниеФормы();
	
КонецПроцедуры

#КонецОбласти
