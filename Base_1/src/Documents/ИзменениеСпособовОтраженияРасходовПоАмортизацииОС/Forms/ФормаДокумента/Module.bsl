////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

	Если Параметры.Ключ.Пустая() Тогда
		ПодготовитьФормуНаСервере();
		РаботаСДиалогами.УстановитьЗаголовокФормыДокумента("", Объект.Ссылка, ЭтаФорма);
	Иначе 
		ЗаполнитьИнвентарныеНомераОС();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	// РедактированиеДокументовПользователей
	ПраваДоступаКОбъектам.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец РедактированиеДокументовПользователей
	
	ПодготовитьФормуНаСервере();
	РаботаСДиалогами.УстановитьЗаголовокФормыДокумента("", Объект.Ссылка, ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

	ЗаполнитьИнвентарныеНомераОС();
	РаботаСДиалогами.УстановитьЗаголовокФормыДокумента("", Объект.Ссылка, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_ИзменениеСпособовОтраженияРасходовПоАмортизацииОС", ПараметрыЗаписи, Объект.Ссылка); 
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Справочник.ОсновныеСредства.Форма.ФормаПодбора" Тогда 
		ОбработкаВыбораПодборОСНаСервере(ВыбранноеЗначение, ИсточникВыбора.ИмяТаблицы);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
		
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если ПараметрыЗаписи.РежимЗаписи = ПредопределенноеЗначение("РежимЗаписиДокумента.Проведение") Тогда
		КлючеваяОперация = "Документ ""изменение способа отражения расходов по амортизации ос"" (проведение)";
		ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, КлючеваяОперация);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект, "Объект.Комментарий");
	
КонецПроцедуры

&НаКлиенте
Процедура СтруктурноеПодразделениеОрганизацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	РаботаСДиалогамиКлиент.СтруктурноеПодразделениеНачалоВыбора(ЭтаФорма, СтандартнаяОбработка, Объект.Организация, Объект.СтруктурноеПодразделение, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СтруктурноеПодразделениеОрганизацияПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(СтруктурноеПодразделениеОрганизация) Тогда 
		Объект.Организация = Неопределено;
		Объект.СтруктурноеПодразделение = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)

	Если НачалоДня(Объект.Дата) = НачалоДня(ТекущаяДатаДокумента) Тогда
		// Изменение времени не влияет на поведение документа.
		ТекущаяДатаДокумента = Объект.Дата;
		Возврат;
	КонецЕсли;

	ТребуетсяВызовСервера = Ложь;

	// Проверим наличие строк в табличной части.
	Если Объект.ОС.Количество() > 0 Тогда
		ТребуетсяВызовСервера = НЕ ЗначениеЗаполнено(МаксПериодПервоначальныхСведенийОС) 
			ИЛИ (МаксПериодПервоначальныхСведенийОС >= Объект.Дата);
	КонецЕсли;
		
	// Если определили, что изменение даты может повлиять на какие-либо параметры, 
	// то передаем обработку на сервер.
	Если ТребуетсяВызовСервера Тогда
		ДатаПриИзмененииНаСервере();
	КонецЕсли;
	
	// Запомним новую дату документа.
	ТекущаяДатаДокумента = Объект.Дата;

КонецПроцедуры

&НаКлиенте
Процедура ДокументОснованиеПриИзменении(Элемент)

	Если ТекущийДокументОснование = Объект.ДокументОснование Тогда
		Возврат;
	КонецЕсли;

	Если ЗначениеЗаполнено(Объект.ДокументОснование) Тогда
		ТекстВопроса = НСтр("ru='Заполнить текущий документ данными документа-основания?'");
		Режим = РежимДиалогаВопрос.ДаНет;
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаПриИзмененииДокументОснование", ЭтотОбъект, Параметры);
		ПоказатьВопрос(Оповещение, ТекстВопроса, Режим, 0);
	КонецЕсли;
	ТекущийДокументОснование = Объект.ДокументОснование;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ ОС

&НаКлиенте
Процедура ОСОсновноеСредствоПриИзменении(Элемент)
	
	СтрокаТЧ 			= Элементы.ОС.ТекущиеДанные;
	ОсновноеСредство 	= СтрокаТЧ.ОсновноеСредство;
	Если НЕ ЗначениеЗаполнено(ОсновноеСредство) Тогда
		СтрокаТЧ.ИнвентарныйНомер = "";
	Иначе
		СтруктураСведений 					= СведенияОбИнвентарномНомереОС(ОсновноеСредство, Объект.Организация, Объект.Дата);
		СтрокаТЧ.ИнвентарныйНомер 			= СтруктураСведений.ИнвентарныйНомер;
		МаксПериодПервоначальныхСведенийОС 	= Макс(МаксПериодПервоначальныхСведенийОС, СтруктураСведений.Период);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ЗаполнитьПоНаименованию(Команда)
	                   
	ОсновноеСредство = УправлениеВнеоборотнымиАктивамиКлиент.ПолучитьОСДляЗаполнениеПоНаименованию(
		ПараметрыЗаполненияПоНаименованию(ЭтаФорма));

	Если ЗначениеЗаполнено(ОсновноеСредство) Тогда
		ЗаполнитьПоНаименованиюСервер(ОсновноеСредство);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Подбор(Команда)
	
	ПараметрыПодбора = ПолучитьПараметрыПодбораОС("ОС");
	Если ПараметрыПодбора <> Неопределено Тогда
		ОткрытьФорму("Справочник.ОсновныеСредства.Форма.ФормаПодбора", ПараметрыПодбора, ЭтаФорма, УникальныйИдентификатор);
	КонецЕсли;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ПодготовитьФормуНаСервере()

	УстановитьФункциональныеОпцииФормы();
	
	НастройкиПользователя = ПользователиБКВызовСервераПовтИсп.ЗначенияНастроекПользователя(
								Пользователи.ТекущийПользователь(), "УчетПоВсемОрганизациям");
	
	Элементы.СтруктурноеПодразделениеОрганизация.ТолькоПросмотр = НЕ НастройкиПользователя.УчетПоВсемОрганизациям;
	
	ПоддержкаРаботыСоСтруктурнымиПодразделениями = ПолучитьФункциональнуюОпцию("ПоддержкаРаботыСоСтруктурнымиПодразделениями");
	
	РаботаСДиалогамиКлиентСервер.УстановитьВидимостьСтруктурногоПодразделения(Объект.Организация, Объект.СтруктурноеПодразделение, СтруктурноеПодразделениеОрганизация);
	РаботаСДиалогамиКлиентСервер.УстановитьСвойстваЭлементаСтруктурноеПодразделениеОрганизация(Элементы.СтруктурноеПодразделениеОрганизация, Объект.СтруктурноеПодразделение, ПоддержкаРаботыСоСтруктурнымиПодразделениями);
	
	ТекущаяДатаДокумента 	 = Объект.Дата;
	ТекущийДокументОснование = Объект.ДокументОснование;

	ОбщегоНазначенияБК.УстановитьТекстАвтора(НадписьАвтор, Объект.Автор);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьФункциональныеОпцииФормы()

	ОбщегоНазначенияБККлиентСервер.УстановитьПараметрыФункциональныхОпцийФормыДокумента(ЭтаФорма);
	
КонецПроцедуры 

&НаКлиенте
Процедура ПослеВыбораСтруктурногоПодразделения(Результат, Параметры) Экспорт
	
	РаботаСДиалогамиКлиент.ПослеВыбораСтруктурногоПодразделения(Результат, Объект.Организация, Объект.СтруктурноеПодразделение, СтруктурноеПодразделениеОрганизация);
	Если Результат.ИзмененаОрганизация ИЛИ Результат.ИзмененоСтруктурноеПодразделение Тогда
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьИнвентарныеНомераОС()

	ТаблицаОС = Объект.ОС.Выгрузить();
					
	ТаблицаНомеров = УправлениеВнеоборотнымиАктивамиСервер.ПолучитьТаблицуИнвентарныхНомеровОС(
		ТаблицаОС,
		Объект.Организация,
		Объект.Дата);

	ТаблицаОС.ЗагрузитьКолонку(ТаблицаНомеров.ВыгрузитьКолонку("ИнвентарныйНомер"), "ИнвентарныйНомер");
	Объект.ОС.Загрузить(ТаблицаОС);
	
	// Запомним максимальную дату первоначальных сведений ОС
	ТаблицаНомеров.Сортировать("Период");
	Если ТаблицаНомеров.Количество() > 0 Тогда
		МаксПериодПервоначальныхСведенийОС = ТаблицаНомеров[ТаблицаНомеров.Количество() - 1].Период;
	Иначе
		МаксПериодПервоначальныхСведенийОС = '0001-01-01';
	КонецЕсли;

КонецПроцедуры

&НаСервереБезКонтекста
Функция СведенияОбИнвентарномНомереОС(ОсновноеСредство, Организация, Дата)
	
	Возврат УправлениеВнеоборотнымиАктивамиСервер.СведенияОбИнвентарномНомереОСЗ(ОсновноеСредство, Организация, Дата);

КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПараметрыЗаполненияПоНаименованию(Форма)

	Результат = Новый Структура;
	Результат.Вставить("Форма", Форма);
	Результат.Вставить("Объект", Форма.Объект);

	Возврат Результат;

КонецФункции

&НаСервере
Процедура ЗаполнитьПоНаименованиюСервер(Знач ОсновноеСредство)
	
	УправлениеВнеоборотнымиАктивамиСервер.ДозаполнитьТабличнуюЧастьОсновнымиСредствамиПоНаименованию(
		ПараметрыЗаполненияПоНаименованию(ЭтаФорма), ОсновноеСредство);

КонецПроцедуры

&НаСервере
Процедура ДатаПриИзмененииНаСервере()

	ЗаполнитьИнвентарныеНомераОС();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопросаПриИзмененииДокументОснование(Результат, Параметры) Экспорт
	
	Если НЕ Результат = КодВозвратаДиалога.Да Тогда
		Возврат;	
	КонецЕсли;

	ПослеЗакрытияВопросаПриИзмененииДокументОснованиеНаСервере();

КонецПроцедуры

&НаСервере
Процедура ПослеЗакрытияВопросаПриИзмененииДокументОснованиеНаСервере()
	
	ЗаполнитьПоДокументуОснованиюНаСервере();
	
	УстановитьФункциональныеОпцииФормы();
	
	РаботаСДиалогамиКлиентСервер.УстановитьВидимостьСтруктурногоПодразделения(Объект.Организация, Объект.СтруктурноеПодразделение, СтруктурноеПодразделениеОрганизация);
	РаботаСДиалогамиКлиентСервер.УстановитьСвойстваЭлементаСтруктурноеПодразделениеОрганизация(Элементы.СтруктурноеПодразделениеОрганизация, Объект.СтруктурноеПодразделение, ПоддержкаРаботыСоСтруктурнымиПодразделениями);
	
	ЗаполнитьИнвентарныеНомераОС();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоДокументуОснованиюНаСервере()

	Если ТипЗнч(Объект.ДокументОснование) = Тип("ДокументСсылка.ПеремещениеОС") Тогда
		Документы.ИзменениеСпособовОтраженияРасходовПоАмортизацииОС.ЗаполнитьДокументПоПеремещениеОС(Объект, Объект.ДокументОснование);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьПараметрыПодбораОС(ИмяТаблицы)
    
	ДатаРасчетов		 = ?(НачалоДня(Объект.Дата) = НачалоДня(ТекущаяДата()), Неопределено, Объект.Дата);
	                                                                                          
	ЗаголовокПодбора	 = НСтр("ru = 'Подбор основных средств в %1 (%2)'");
	ПредставлениеТаблицы = НСтр("ru = '" + ИмяТаблицы + "'");
	
	ЗаголовокПодбора     = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ЗаголовокПодбора, Объект.Ссылка, ПредставлениеТаблицы);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ДатаРасчетов",             ДатаРасчетов);
	ПараметрыФормы.Вставить("Организация",              Объект.Организация);
	ПараметрыФормы.Вставить("СтруктурноеПодразделение", Объект.СтруктурноеПодразделение);
	ПараметрыФормы.Вставить("Заголовок",                ЗаголовокПодбора);
	ПараметрыФормы.Вставить("ВыбиратьВсе",              Истина);	
	ПараметрыФормы.Вставить("ОбъектСсылка",             Объект.Ссылка);
	ПараметрыФормы.Вставить("ИмяТаблицы",               ИмяТаблицы);
	
	Возврат ПараметрыФормы;

КонецФункции

&НаСервере
Процедура ОбработкаВыбораПодборОСНаСервере(ВыбранноеЗначение, ИмяТаблицы)
	
	Если ИмяТаблицы <> "ОС" Тогда
        // Ошибочное имя табличной части
		Возврат;
	КонецЕсли;

	ТаблицаОС = ПолучитьИзВременногоХранилища(ВыбранноеЗначение.АдресПодобранныхОСВХранилище);
	
	Для каждого СтрокаОС Из ТаблицаОС Цикл
		
		// Ищем выбранную позицию в таблице подобранной номенклатуры.
		СтруктураОтбора = Новый Структура();
		СтруктураОтбора.Вставить("ОсновноеСредство", СтрокаОС.ОсновноеСредство);
		
		СтрокаТабличнойЧасти = ОбработкаТабличныхЧастейКлиентСервер.НайтиСтрокуТабЧасти(Объект, ИмяТаблицы, СтруктураОтбора);
		
		Если СтрокаТабличнойЧасти = Неопределено Тогда
			СтрокаТабличнойЧасти = Объект[ИмяТаблицы].Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, СтрокаОС);						
		Иначе
			ТекстСообщения = НСтр("ru='Основное средство - %1 уже подобрано!'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, СтрокаОС.ОсновноеСредство);
			Поле = "ОС[" + Формат(СтрокаТабличнойЧасти.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].ОсновноеСредство";
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, Объект.Ссылка, Поле, "Объект"); 
		КонецЕсли;
		
	КонецЦикла;

	УдалитьИзВременногоХранилища(ВыбранноеЗначение.АдресПодобранныхОСВХранилище);
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
     ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
     ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры
 
&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
     ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры
 
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
     ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

