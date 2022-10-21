
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	Если Объект.Ссылка.Пустая() Тогда
		Если НЕ ЗначениеЗаполнено(Объект.ВидРезерва) Тогда
		    // пока справочник используется для резервов по отпускам и прочим вознаграждениям работников.
			Объект.ВидРезерва = Перечисления.ВидыРезервов.ПоВознаграждениямРаботникам;
		КонецЕсли;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
        РазмерыОтчислений.Отбор, 
        "Резерв", 
        Объект.Ссылка, 
        ВидСравненияКомпоновкиДанных.Равно, 
        "Резерв", 
        Истина ,
		РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный);

	ПереключательПринятиеКВычету = Объект.ПринятиеКВычетуПоНалоговомуУчету;

	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "ПланВидовРасчета.ОсновныеНачисленияОрганизаций.ФормаВыбора" Тогда
		
		Если Объект.БазовыеВидыРасчета.НайтиСтроки(Новый Структура("ВидРасчета", ВыбранноеЗначение)).Количество() = 0 Тогда
		
			СтрокаБазовыхНачислений = Объект.БазовыеВидыРасчета.Добавить();	
			СтрокаБазовыхНачислений.ВидРасчета = ВыбранноеЗначение;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ПереключательПринятиеКВычетуПриИзменении(Элемент)
	
	Объект.ПринятиеКВычетуПоНалоговомуУчету = ПереключательПринятиеКВычету;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ БазовыеВидыРасчета

&НаКлиенте
Процедура РазмерыОтчисленийПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Объект.Ссылка.Пустая() Тогда
		
		Если НЕ ЗначениеЗаполнено(Объект.Наименование) Тогда
			ТекстСообщения = НСтр("ru = 'Для добавления строки необходимо заполнить наименование'");
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , "Объект.Наименование");
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
		ТекстВопроса = НСтр("ru = 'Перед установкой процентов отчислений в резерв необходимо записать новый элемент, выполнить?'");
		Режим = РежимДиалогаВопрос.ДаНет;
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаЗаписатьВФорме", ЭтотОбъект, Параметры);
		ПоказатьВопрос(Оповещение, ТекстВопроса, Режим, 0);
		Отказ = Истина;

	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопросаЗаписатьВФорме(Результат, Параметры) Экспорт 
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		
		// записываем объет
		Если Записать() Тогда
			
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		        РазмерыОтчислений.Отбор, 
		        "Резерв", 
		        Объект.Ссылка, 
		        ВидСравненияКомпоновкиДанных.Равно, 
		        "Резерв", 
		        Истина ,
				РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный);
				
		КонецЕсли;
			
	КонецЕсли;	
	
КонецПроцедуры	

&НаКлиенте
Процедура ВидРезерваПриИзменении(Элемент)
	УправлениеФормой(ЭтаФорма);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ПодборВидРасчета(Команда)
	
	ПараметрыФормы	= Новый Структура;
	ПараметрыФормы.Вставить("ЗакрыватьПриЗакрытииВладельца",	Истина);
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе",				Ложь);
	ПараметрыФормы.Вставить("РежимВыбора",						Истина);
	ПараметрыФормы.Вставить("МножественныйВыбор",				Ложь);
	
	ОткрытьФорму("ПланВидовРасчета.ОсновныеНачисленияОрганизаций.ФормаВыбора", ПараметрыФормы, ЭтаФорма);

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(ЭтаФорма)
	
	Элементы = ЭтаФорма.Элементы;
	Объект   = ЭтаФорма.Объект;
	
	Если Объект.ВидРезерва = ПредопределенноеЗначение("Перечисление.ВидыРезервов.ПоВознаграждениямРаботникам") Тогда
		Элементы.Страницы.Доступность 	  				  = Истина;
		Элементы.СтатьяЗатрат.Доступность 	 			  = Истина;
		Элементы.ПереключательПринятиеКВычету.Доступность = Истина;
	Иначе
		Элементы.Страницы.Доступность 	 				  = Ложь;
		Элементы.СтатьяЗатрат.Доступность 	 			  = Ложь;
		Элементы.ПереключательПринятиеКВычету.Доступность = Ложь;
    КонецЕсли;

КонецПроцедуры // УстановитьВидимость()
