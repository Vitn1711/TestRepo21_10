
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	Если Параметры.Ключ.Пустая() Тогда
		ПодготовитьФормуНаСервере();
	КонецЕсли;
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ПодготовитьФормуНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

	УстановитьДоступностьСубконто();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)

	ОрганизацияПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура БазаРаспределенияПриИзменении(Элемент)
	
	Если Объект.БазаРаспределения = ПредопределенноеЗначение("Перечисление.БазыРаспределенияКосвенныхРасходов.Процентом") Тогда 
		Элементы.АналитикаРаспределения.Подвал = Истина;		
		Элементы.АналитикаРаспределенияПроцентРаспределения.Видимость = Истина;
	Иначе 
		Элементы.АналитикаРаспределения.Подвал = Ложь;
		Элементы.АналитикаРаспределенияПроцентРаспределения.Видимость = Ложь;
		Для Каждого СтрокаТЧ Из Объект.АналитикаРаспределения Цикл 
			СтрокаТЧ.ПроцентРаспределения = 0;
		КонецЦикла;
	КонецЕсли;

	Если Объект.БазаРаспределения = ПредопределенноеЗначение("Перечисление.БазыРаспределенияКосвенныхРасходов.МатериальныеЗатраты") Тогда 
		Элементы.НадписьРасшифровкаБазаРаспределения.Заголовок = "В качестве базы распределения используется сумма " 
																			  +"расходов, отраженных на статьях с категорией  «Материальные расходы»."
	ИначеЕсли Объект.БазаРаспределения = ПредопределенноеЗначение("Перечисление.БазыРаспределенияКосвенныхРасходов.НеРаспределяется") Тогда
		Элементы.НадписьРасшифровкаБазаРаспределения.Заголовок = "";
		
		
	ИначеЕсли Объект.БазаРаспределения = ПредопределенноеЗначение("Перечисление.БазыРаспределенияКосвенныхРасходов.ОбъемВыпуска") Тогда
		Элементы.НадписьРасшифровкаБазаРаспределения.Заголовок = "В качестве базы распределения используется количество " 
																			  +"выпущенной в текущем месяце продукции, оказанных услуг.";
	ИначеЕсли Объект.БазаРаспределения = ПредопределенноеЗначение("Перечисление.БазыРаспределенияКосвенныхРасходов.ОплатаТруда") Тогда
		Элементы.НадписьРасшифровкаБазаРаспределения.Заголовок = "В качестве базы распределения используется сумма " 
																			  +"расходов, отраженных на статьях затрат с категорией «Оплата труда»";
	ИначеЕсли Объект.БазаРаспределения = ПредопределенноеЗначение("Перечисление.БазыРаспределенияКосвенныхРасходов.ПлановаяСебестоимость") Тогда
		Элементы.НадписьРасшифровкаБазаРаспределения.Заголовок = "В качестве базы распределения используется " 
																			  +"плановая стоимость выпущенной в текущем месяце продукции, оказанных услуг.";
	ИначеЕсли Объект.БазаРаспределения = ПредопределенноеЗначение("Перечисление.БазыРаспределенияКосвенныхРасходов.Процентом") Тогда
		Элементы.НадписьРасшифровкаБазаРаспределения.Заголовок = "В качестве базы распределения используется процент, указанный в графе процент распределения.";
		
		
	Иначе 
		Элементы.НадписьРасшифровкаБазаРаспределения.Заголовок = "В зависимости от специфики производственной деятельности предприятия " 
																			  + "при распределении общепроизводственных расходов могут применяться " 
																			  + "разные базы распределения.";
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ АналитикаРаспределения

&НаКлиенте
Процедура АналитикаРаспределенияПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если Объект.БазаРаспределения = ПредопределенноеЗначение("Перечисление.БазыРаспределенияКосвенныхРасходов.Процентом") Тогда 
		
		ИтоговыйПроцент = Объект.АналитикаРаспределения.Итог("ПроцентРаспределения");
	    		
		Для Каждого СтрокаТЧ Из Объект.АналитикаРаспределения Цикл 
			
			Если СтрокаТЧ.ПроцентРаспределения = 0 Тогда 
				
				ТекстСообщения = НСтр("ru = 'Не указан процент распределения'");
				Поле = "АналитикаРаспределения[" + Формат(СтрокаТЧ.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].ПроцентРаспределения";
				ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , Поле, "Объект", ОтменаРедактирования);
				
				Возврат;
				
			Иначе 
				
				Элементы.НадписьРасшифровкаАналитикаРаспределения.Заголовок = "Для косвенных расходов можно устанавливать способ распределения с точностью "
										  										  +"до подразделения и статьи затрат. Это может потребоваться в случае, когда для "
																				  +"разных видов расходов необходимо применение разных способов распределения.";
				
			КонецЕсли;
																			  
		КонецЦикла;
						
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРаспределенияПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	
	ТекущиеДанные = Элементы.АналитикаРаспределения.ТекущиеДанные;
	
	Если ЗначениеЗаполнено(ТекущиеДанные.СчетЗакрытияБУ) И НЕ ОтменаРедактирования Тогда
		
		КоличествоСубконтоНаПроизводственномСчете = КоличествоСубконтоНаПроизводственномСчете(ТекущиеДанные.СчетЗакрытияБУ);
		
		Если НЕ КоличествоСубконтоНаПроизводственномСчете = 0 Тогда
			
			ПустыеСубконто = "";
			
			Для НомерСубконто = 1 По КоличествоСубконтоНаПроизводственномСчете Цикл
				
				Если НЕ (ТипЗнч(ТекущиеДанные["СубконтоБУ" + НомерСубконто]) = Тип("СправочникСсылка.ПодразделенияОрганизаций") ИЛИ
						 ТипЗнч(ТекущиеДанные["СубконтоБУ" + НомерСубконто]) = Тип("СправочникСсылка.СтатьиЗатрат")) И 
						 НЕ ЗначениеЗаполнено(Элемент.ТекущиеДанные["СубконтоБУ" + НомерСубконто]) Тогда
						 
					ПустыеСубконто =  ПустыеСубконто + "СубконтоБУ" + НомерСубконто + ". Тип значения """ + ТипЗнч(ТекущиеДанные["СубконтоБУ" + НомерСубконто])+ """"+ Символы.ПС;
					Отказ = Истина;
					
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЕсли;	
		
		Если Отказ Тогда
			
			ТекстПредупреждения = НСтр("ru='Для корректного отнесения косвенных расходов на непроизводственные счета необходимо заполнить аналитику, которой нет на счете %1.
			|Для счета %2 это аналитика: 
			|%3'");
			
			ТекстПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстПредупреждения,
					Строка(ПредопределенноеЗначение("ПланСчетов.Типовой.НакладныеРасходы")), Строка(ТекущиеДанные.СчетЗакрытияБУ), ПустыеСубконто);
		
			ПоказатьПредупреждение(, ТекстПредупреждения);
			
		КонецЕсли;
		
	КонецЕсли;	

КонецПроцедуры

&НаКлиенте
Процедура АналитикаРаспределенияСтруктурноеПодразделениеПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.АналитикаРаспределения.ТекущиеДанные;

	Если ТипЗнч(ТекущиеДанные.СтруктурноеПодразделение) = Тип("Неопределено") Тогда
		ТекущиеДанные.СтруктурноеПодразделение = ПредопределенноеЗначение("Справочник.ПодразделенияОрганизаций.ПустаяСсылка");
	КонецЕсли;

	Если ТипЗнч(ТекущиеДанные.СтруктурноеПодразделение) = Тип("СправочникСсылка.Организации") Тогда
		ТекущиеДанные.СтруктурноеПодразделение = ПредопределенноеЗначение("Справочник.ПодразделенияОрганизаций.ПустаяСсылка");		
	КонецЕсли;
	
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "БУ", "СчетЗакрытияБУ");	
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "НУ", "СчетЗакрытияНУ");	

	ДанныеСтрокиТаблицы = Новый Структура(
		"СтруктурноеПодразделение, СчетЗакрытияБУ, СубконтоБУ1, СубконтоБУ2,
		|СубконтоБУ3, СчетЗакрытияНУ, СубконтоНУ1, СубконтоНУ2, СубконтоНУ3");
		
	ЗаполнитьЗначенияСвойств(ДанныеСтрокиТаблицы, ТекущиеДанные);
	
	ДанныеОбъекта = Новый Структура(
		"Организация");
		
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Объект);
		
	ПриИзмененииЗначенияСтруктурногоПодразделения(ДанныеСтрокиТаблицы, ДанныеОбъекта);
	
	ЗаполнитьЗначенияСвойств(ТекущиеДанные, ДанныеСтрокиТаблицы);
	
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРаспределенияСтруктурноеПодразделениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.АналитикаРаспределения.ТекущиеДанные;
	
	Если Объект.Организация <> ПредопределенноеЗначение("Справочник.Организации.ПустаяСсылка") Тогда
		Если ТипЗнч(ТекущиеДанные.СтруктурноеПодразделение) = Тип("СправочникСсылка.Организации") Тогда
			ТекущиеДанные.СтруктурноеПодразделение = ПредопределенноеЗначение("Справочник.ПодразделенияОрганизаций.ПустаяСсылка");
		ИначеЕсли ТекущиеДанные.СтруктурноеПодразделение <> ПредопределенноеЗначение("Справочник.ПодразделенияОрганизаций.ПустаяСсылка") Тогда
			ТекущиеДанные.СтруктурноеПодразделение = ТекущиеДанные.СтруктурноеПодразделение;
		Иначе 
			ТекущиеДанные.СтруктурноеПодразделение = ПредопределенноеЗначение("Справочник.ПодразделенияОрганизаций.ПустаяСсылка");
		КонецЕсли;
		
		РаботаСДиалогамиКлиент.СтруктурноеПодразделениеНачалоВыбора(ЭтаФорма, СтандартнаяОбработка, Объект.Организация, ТекущиеДанные.СтруктурноеПодразделение, Ложь);
	
	Иначе
		СтандартнаяОбработка = Ложь;
		ТекстСообщения = НСтр("ru = 'Для выбора структурного подразделения необходимо выбрать организацию'");
		Поле = "Организация";
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , Поле, "Объект");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораСтруктурногоПодразделения(Результат, Параметры) Экспорт
	
	ТекущиеДанные = Элементы.АналитикаРаспределения.ТекущиеДанные;

	РаботаСДиалогамиКлиент.ПослеВыбораСтруктурногоПодразделения(Результат, Объект.Организация, ТекущиеДанные.СтруктурноеПодразделение);
	
	Если Результат.ИзмененоСтруктурноеПодразделение Тогда
		Модифицированность = Истина;
	КонецЕсли;
	
	Если ТипЗнч(ТекущиеДанные.СтруктурноеПодразделение) = Тип("СправочникСсылка.Организации") Тогда
		
		ТекущиеДанные.СтруктурноеПодразделение = ПредопределенноеЗначение("Справочник.ПодразделенияОрганизаций.ПустаяСсылка");
		
	ИначеЕсли ТипЗнч(ТекущиеДанные.СтруктурноеПодразделение) <> Тип("Неопределено") Тогда
		
		ДанныеСтрокиТаблицы = Новый Структура(
			"СтруктурноеПодразделение, СчетЗакрытияБУ, СубконтоБУ1, СубконтоБУ2,
			|СубконтоБУ3, СчетЗакрытияНУ, СубконтоНУ1, СубконтоНУ2, СубконтоНУ3");
			
		ЗаполнитьЗначенияСвойств(ДанныеСтрокиТаблицы, ТекущиеДанные);
		
		ДанныеОбъекта = Новый Структура(
			"Организация");
			
		ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Объект);

		ПриИзмененииЗначенияСтруктурногоПодразделения(ДанныеСтрокиТаблицы, ДанныеОбъекта);
	
		ЗаполнитьЗначенияСвойств(ТекущиеДанные, ДанныеСтрокиТаблицы);

	КонецЕсли;

	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "БУ", "СчетЗакрытияБУ");	
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "НУ", "СчетЗакрытияНУ");	

КонецПроцедуры

&НаКлиенте
Процедура АналитикаРаспределенияСчетЗакрытияБУПриИзменении(Элемент)
	
	СтрокаТаблицы = Элементы.АналитикаРаспределения.ТекущиеДанные;
	
	Если СтрокаТаблицы.СчетЗакрытияБУ = ПредопределенноеЗначение("ПланСчетов.Типовой.НакладныеРасходы") Тогда
		ТекстСообщения = НСтр("ru='Счет %1 нельзя использовать в качестве счета закрытия'");
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения,
				Строка(ПредопределенноеЗначение("ПланСчетов.Типовой.НакладныеРасходы")));
	
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		
		СтрокаТаблицы.СчетЗакрытияБУ = ПредопределенноеЗначение("ПланСчетов.Типовой.ПустаяСсылка");	
	КонецЕсли;
	
	ПоляОбъекта = Новый Структура("Субконто1, Субконто2, Субконто3",
								 "СубконтоБУ1", "СубконтоБУ2", "СубконтоБУ3");

	ПроцедурыБухгалтерскогоУчетаКлиентСервер.ПриИзмененииСчета(СтрокаТаблицы.СчетЗакрытияБУ, СтрокаТаблицы, ПоляОбъекта, Истина);

	
	СтрокаТаблицы.СчетЗакрытияНУ = ПроцедурыБухгалтерскогоУчетаВызовСервераПовтИсп.ПреобразоватьСчетаБУвСчетНУ(Новый Структура("СчетБУ", СтрокаТаблицы.СчетЗакрытияБУ));	
	ПоляОбъекта = Новый Структура("Субконто1, Субконто2, Субконто3",
								 "СубконтоНУ1", "СубконтоНУ2", "СубконтоНУ3");

	ПроцедурыБухгалтерскогоУчетаКлиентСервер.ПриИзмененииСчета(СтрокаТаблицы.СчетЗакрытияНУ, СтрокаТаблицы, ПоляОбъекта, Истина);
	
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "БУ", "СчетЗакрытияБУ");	
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "НУ", "СчетЗакрытияНУ");	
	
	ДанныеСтрокиТаблицы = Новый Структура(
		"СчетЗакрытияБУ, СчетЗакрытияНУ, 
		|СубконтоБУ1, СубконтоБУ2, СубконтоБУ3,
		|СубконтоНУ1, СубконтоНУ2, СубконтоНУ3");
		
	ЗаполнитьЗначенияСвойств(ДанныеСтрокиТаблицы, СтрокаТаблицы);
	
	ДанныеОбъекта = Новый Структура("Организация");
			
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Объект);
		
	АналитикаРаспределенияСчетЗакрытияБУПриИзмененииНаСервере(ДанныеСтрокиТаблицы, ДанныеОбъекта);
	
	ЗаполнитьЗначенияСвойств(СтрокаТаблицы, ДанныеСтрокиТаблицы);
	
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРаспределенияСчетЗакрытияНУПриИзменении(Элемент)
	
	СтрокаТаблицы = Элементы.АналитикаРаспределения.ТекущиеДанные;
	
	Если СтрокаТаблицы.СчетЗакрытияНУ = ПредопределенноеЗначение("ПланСчетов.Налоговый.НакладныеРасходы") Тогда
		ТекстСообщения = НСтр("ru='Счет %1 нельзя использовать в качестве счета закрытия'");
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения,
				Строка(ПредопределенноеЗначение("ПланСчетов.Налоговый.НакладныеРасходы")));
	
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		
		СтрокаТаблицы.СчетЗакрытияНУ = ПредопределенноеЗначение("ПланСчетов.Налоговый.ПустаяСсылка");	
	КонецЕсли;
	
	ПоляОбъекта = Новый Структура("Субконто1, Субконто2, Субконто3",
								 "СубконтоНУ1", "СубконтоНУ2", "СубконтоНУ3");

	ПроцедурыБухгалтерскогоУчетаКлиентСервер.ПриИзмененииСчета(СтрокаТаблицы.СчетЗакрытияНУ, СтрокаТаблицы, ПоляОбъекта, Истина);
    ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "НУ", "СчетЗакрытияНУ");
	
	ДанныеСтрокиТаблицы = Новый Структура(
		"СчетЗакрытияНУ, СубконтоНУ1, СубконтоНУ2, СубконтоНУ3");
		
	ЗаполнитьЗначенияСвойств(ДанныеСтрокиТаблицы, СтрокаТаблицы);
	
	ДанныеОбъекта = Новый Структура("Организация");
			
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Объект);
		
	АналитикаРаспределенияСчетЗакрытияНУПриИзмененииНаСервере(ДанныеСтрокиТаблицы, ДанныеОбъекта);
	
	ЗаполнитьЗначенияСвойств(СтрокаТаблицы, ДанныеСтрокиТаблицы);
	
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРаспределенияСубконтоБУ1ПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.АналитикаРаспределения.ТекущиеДанные;
	
	ОбщегоНазначенияБККлиентСервер.ЗаменитьСубконтоНУ(ТекущиеДанные, ТекущиеДанные.СчетЗакрытияБУ, ТекущиеДанные.СчетЗакрытияНУ, 1, ТекущиеДанные.СубконтоБУ1, "СубконтоНУ");		
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "БУ", "СчетЗакрытияБУ");
	
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРаспределенияСубконтоБУ2ПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.АналитикаРаспределения.ТекущиеДанные;
	
	ОбщегоНазначенияБККлиентСервер.ЗаменитьСубконтоНУ(ТекущиеДанные, ТекущиеДанные.СчетЗакрытияБУ, ТекущиеДанные.СчетЗакрытияНУ, 2, ТекущиеДанные.СубконтоБУ2, "СубконтоНУ");		
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "БУ", "СчетЗакрытияБУ");
	
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРаспределенияСубконтоБУ3ПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.АналитикаРаспределения.ТекущиеДанные;
	
	ОбщегоНазначенияБККлиентСервер.ЗаменитьСубконтоНУ(ТекущиеДанные, ТекущиеДанные.СчетЗакрытияБУ, ТекущиеДанные.СчетЗакрытияНУ, 3, ТекущиеДанные.СубконтоБУ3, "СубконтоНУ");		
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "БУ", "СчетЗакрытияБУ");
	
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРаспределенияСубконтоБУ1НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СубконтоНачалоВыбора(Элемент, "СубконтоБУ", 1, "СчетЗакрытияБУ", СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРаспределенияСубконтоБУ2НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СубконтоНачалоВыбора(Элемент, "СубконтоБУ", 2, "СчетЗакрытияБУ", СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРаспределенияСубконтоБУ3НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СубконтоНачалоВыбора(Элемент, "СубконтоБУ", 3, "СчетЗакрытияБУ", СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРаспределенияСубконтоНУ1НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СубконтоНачалоВыбора(Элемент, "СубконтоНУ", 1, "СчетЗакрытияНУ", СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРаспределенияСубконтоНУ2НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СубконтоНачалоВыбора(Элемент, "СубконтоНУ", 2, "СчетЗакрытияНУ", СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРаспределенияСубконтоНУ3НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СубконтоНачалоВыбора(Элемент, "СубконтоНУ", 3, "СчетЗакрытияНУ", СтандартнаяОбработка);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Объект   = Форма.Объект;
	Элементы = Форма.Элементы;
	
	ОтрисовкаЭлементовФормы(Форма);
	
	Если Форма.ПоддержкаРаботыСоСтруктурнымиПодразделениями Тогда
		Элементы.АналитикаРаспределенияСтруктурноеПодразделение.Видимость = Истина;
	Иначе
		Для Каждого СтрокаТЧ Из Объект.АналитикаРаспределения Цикл
					
			Если ТипЗнч(СтрокаТЧ.СтруктурноеПодразделение) = Тип("СправочникСсылка.ПодразделенияОрганизаций") Тогда
				Элементы.АналитикаРаспределенияСтруктурноеПодразделение.Видимость = Истина;
				Прервать;
			КонецЕсли; 
			
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОтрисовкаЭлементовФормы(Форма)
	
	Объект   = Форма.Объект;
	Элементы = Форма.Элементы;

	Если Объект.БазаРаспределения = ПредопределенноеЗначение("Перечисление.БазыРаспределенияКосвенныхРасходов.Процентом") Тогда 
		Элементы.АналитикаРаспределения.Подвал = Истина;		
		Элементы.АналитикаРаспределенияПроцентРаспределения.Видимость = Истина;
	Иначе 
		Элементы.АналитикаРаспределения.Подвал = Ложь;
		Элементы.АналитикаРаспределенияПроцентРаспределения.Видимость = Ложь;
	КонецЕсли;

	Если Объект.БазаРаспределения = ПредопределенноеЗначение("Перечисление.БазыРаспределенияКосвенныхРасходов.МатериальныеЗатраты") Тогда 
		Элементы.НадписьРасшифровкаБазаРаспределения.Заголовок = "В качестве базы распределения используется сумма " 
																			  +"расходов, отраженных на статьях с категорией  «Материальные расходы»."
	ИначеЕсли Объект.БазаРаспределения = ПредопределенноеЗначение("Перечисление.БазыРаспределенияКосвенныхРасходов.НеРаспределяется") Тогда
		Элементы.НадписьРасшифровкаБазаРаспределения.Заголовок = "";
		
		
	ИначеЕсли Объект.БазаРаспределения = ПредопределенноеЗначение("Перечисление.БазыРаспределенияКосвенныхРасходов.ОбъемВыпуска") Тогда
		Элементы.НадписьРасшифровкаБазаРаспределения.Заголовок = "В качестве базы распределения используется количество " 
																			  +"выпущенной в текущем месяце продукции, оказанных услуг.";
	ИначеЕсли Объект.БазаРаспределения = ПредопределенноеЗначение("Перечисление.БазыРаспределенияКосвенныхРасходов.ОплатаТруда") Тогда
		Элементы.НадписьРасшифровкаБазаРаспределения.Заголовок = "В качестве базы распределения используется сумма " 
																			  +"расходов, отраженных на статьях затрат с категорией «Оплата труда»";
	ИначеЕсли Объект.БазаРаспределения = ПредопределенноеЗначение("Перечисление.БазыРаспределенияКосвенныхРасходов.ПлановаяСебестоимость") Тогда
		Элементы.НадписьРасшифровкаБазаРаспределения.Заголовок = "В качестве базы распределения используется " 
																			  +"плановая стоимость выпущенной в текущем месяце продукции, оказанных услуг.";
	ИначеЕсли Объект.БазаРаспределения = ПредопределенноеЗначение("Перечисление.БазыРаспределенияКосвенныхРасходов.Процентом") Тогда
		Элементы.НадписьРасшифровкаБазаРаспределения.Заголовок = "В качестве базы распределения используется процент, указанный в графе процент распределения.";
		
		
	Иначе 
		Элементы.НадписьРасшифровкаБазаРаспределения.Заголовок = "В зависимости от специфики производственной деятельности предприятия " 
																			  + "при распределении общепроизводственных расходов могут применяться " 
																			  + "разные базы распределения.";
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПодготовитьФормуНаСервере()

	УстановитьДоступностьСубконто();
	
	ПоддержкаРаботыСоСтруктурнымиПодразделениями = ПолучитьФункциональнуюОпцию("ПоддержкаРаботыСоСтруктурнымиПодразделениями");
	Элементы.Организация.ТолькоПросмотр = НЕ ПользователиБКВызовСервераПовтИсп.ПолучитьЗначениеПоУмолчанию(ПользователиКлиентСервер.ТекущийПользователь(), "УчетПоВсемОрганизациям");
		
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьСубконто()
	
	СтруктураЭлементов  = Новый Структура;
	СтруктураЭлементов.Вставить("СчетЗакрытия","Субконто"); 
		
	Для Каждого СтрокаТЧ Из Объект.АналитикаРаспределения Цикл
		
		Для Каждого ЭлементТЧ Из СтруктураЭлементов Цикл
			
			ИмяСчета    = ЭлементТЧ.Ключ; 
			ИмяЭлемента = ЭлементТЧ.Значение;
			
			ПоляОбъекта = Новый Структура("Субконто1, Субконто2, Субконто3",
						ИмяЭлемента + "БУ1", ИмяЭлемента + "БУ2", ИмяЭлемента + "БУ3");
			
			ПроцедурыБухгалтерскогоУчетаКлиентСервер.УстановитьДоступностьИЗаголовкиСубконто(СтрокаТЧ[ИмяСчета + "БУ"], СтрокаТЧ, ПоляОбъекта);
			
			ПоляОбъекта = Новый Структура("Субконто1, Субконто2, Субконто3",
						ИмяЭлемента + "НУ1", ИмяЭлемента + "НУ2", ИмяЭлемента + "НУ3");
			
			ПроцедурыБухгалтерскогоУчетаКлиентСервер.УстановитьДоступностьИЗаголовкиСубконто(СтрокаТЧ[ИмяСчета + "НУ"], СтрокаТЧ, ПоляОбъекта);

		КонецЦикла;
	
	КонецЦикла;
		
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция СписокПараметровВыбораСубконто(Форма, ПараметрыОбъекта, ШаблонИмяПоляОбъекта, ИмяСчета, СтрокаТЧ = Неопределено)
	
	СписокПараметров = Новый Структура;
	Для Индекс = 1 По 3 Цикл
		ИмяПоля = СтрЗаменить(ШаблонИмяПоляОбъекта, "%Индекс%", Индекс);
		Если ТипЗнч(ПараметрыОбъекта[ИмяПоля]) = Тип("СправочникСсылка.Контрагенты") Тогда
			СписокПараметров.Вставить("Контрагент", ПараметрыОбъекта[ИмяПоля]);
		ИначеЕсли ПроцедурыБухгалтерскогоУчетаКлиентСерверПереопределяемый.ПолучитьОписаниеТиповДоговора().СодержитТип(ТипЗнч(ПараметрыОбъекта[ИмяПоля])) Тогда
			СписокПараметров.Вставить("ДоговорКонтрагента", ПараметрыОбъекта[ИмяПоля]);
		ИначеЕсли ТипЗнч(ПараметрыОбъекта[ИмяПоля]) = Тип("СправочникСсылка.Номенклатура") Тогда
			СписокПараметров.Вставить("Номенклатура", ПараметрыОбъекта[ИмяПоля]);
		ИначеЕсли ТипЗнч(ПараметрыОбъекта[ИмяПоля]) = Тип("СправочникСсылка.Склады") Тогда
			СписокПараметров.Вставить("Склад", ПараметрыОбъекта[ИмяПоля]);
		КонецЕсли;
	КонецЦикла;
	СписокПараметров.Вставить("СчетУчета", ПараметрыОбъекта[ИмяСчета]);	
	СписокПараметров.Вставить("Организация", Форма.Объект.Организация);
	Если ЗначениеЗаполнено(СтрокаТЧ.СтруктурноеПодразделение) И ТипЗнч(СтрокаТЧ.СтруктурноеПодразделение) = Тип("СправочникСсылка.ПодразделенияОрганизаций") Тогда
		СписокПараметров.Вставить("СтруктурноеПодразделение", СтрокаТЧ.СтруктурноеПодразделение);
	КонецЕсли;

	Возврат СписокПараметров;

КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьПараметрыВыбораПолейСубконто(Форма, Суффикс, ИмяСчета)
	
	ТекущаяСтрока  = Форма.Элементы.АналитикаРаспределения.ТекущаяСтрока;
	Если НЕ ТекущаяСтрока = Неопределено Тогда
		
		ТекущиеДанные = Форма.Объект.АналитикаРаспределения.НайтиПоИдентификатору(Форма.Элементы.АналитикаРаспределения.ТекущаяСтрока);
		ПараметрыДокумента = СписокПараметровВыбораСубконто(Форма, ТекущиеДанные, "Субконто" + Суффикс + "%Индекс%", ИмяСчета, ТекущиеДанные);
		ПроцедурыБухгалтерскогоУчетаКлиентСервер.ИзменитьПараметрыВыбораПолейСубконто(Форма, ТекущиеДанные, "Субконто" + Суффикс + "%Индекс%", "АналитикаРаспределенияСубконто" + Суффикс + "%Индекс%", ПараметрыДокумента);	
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоНачалоВыбора(Элемент, ИмяЭлементаСубконто, ИндексСубконто, ИмяЭлементаСчета, СтандартнаяОбработка)	
	
	ТекущиеДанные      = Элементы.АналитикаРаспределения.ТекущиеДанные;	
	ПараметрыДокумента = СписокПараметровВыбораСубконто(ЭтаФорма, ТекущиеДанные, ИмяЭлементаСубконто + "%Индекс%", ИмяЭлементаСчета, ТекущиеДанные);
		
	ПроцедурыБухгалтерскогоУчетаКлиент.НачалоВыбораЗначенияСубконто(ЭтаФорма, Элемент, ИндексСубконто, СтандартнаяОбработка, ПараметрыДокумента);	
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура АналитикаРаспределенияСчетЗакрытияБУПриИзмененииНаСервере(СтрокаТабличнойЧасти, ДанныеОбъекта)
	
	ПроцедурыБухгалтерскогоУчета.ПроверитьВладельцаСубконтоПодразделение(СтрокаТабличнойЧасти, 
	                                        ДанныеОбъекта.Организация, 
	                                        Новый Структура("НазваниеСубконтоБУ1, НазваниеСубконтоБУ2, НазваниеСубконтоБУ3, 
	                                                        |СубконтоБУ1, СубконтоБУ2, СубконтоБУ3",
	                                                        "СубконтоБУ1", "СубконтоБУ2", "СубконтоБУ3", 
	                                                        СтрокаТабличнойЧасти.СубконтоБУ1, СтрокаТабличнойЧасти.СубконтоБУ2, СтрокаТабличнойЧасти.СубконтоБУ3));
															
	СчетаУчета = Новый Структура("СчетЗакрытияБУ, СубконтоБУ1,
								 |СубконтоБУ2, СубконтоБУ3", СтрокаТабличнойЧасти.СчетЗакрытияБУ,
								 СтрокаТабличнойЧасти.СубконтоБУ1, СтрокаТабличнойЧасти.СубконтоБУ2,
								 СтрокаТабличнойЧасти.СубконтоБУ3);

	ПроцедурыБухгалтерскогоУчета.ПроверитьВладельцаСубконтоПодразделение(СтрокаТабличнойЧасти, 
	                                        ДанныеОбъекта.Организация, 
	                                        Новый Структура("НазваниеСубконтоБУ1, НазваниеСубконтоБУ2, НазваниеСубконтоБУ3, 
	                                                        |СубконтоБУ1, СубконтоБУ2, СубконтоБУ3",
	                                                        "СубконтоНУ1", "СубконтоНУ2", "СубконтоНУ3", 
	                                                        СтрокаТабличнойЧасти.СубконтоНУ1, СтрокаТабличнойЧасти.СубконтоНУ2, СтрокаТабличнойЧасти.СубконтоНУ3));
															
	СчетаУчета = Новый Структура("СчетЗакрытияНУ, СубконтоНУ1,
								 |СубконтоНУ2, СубконтоНУ3", СтрокаТабличнойЧасти.СчетЗакрытияНУ,
								 СтрокаТабличнойЧасти.СубконтоНУ1, СтрокаТабличнойЧасти.СубконтоНУ2,
								 СтрокаТабличнойЧасти.СубконтоНУ3);

КонецПроцедуры

&НаСервереБезКонтекста
Процедура АналитикаРаспределенияСчетЗакрытияНУПриИзмененииНаСервере(СтрокаТабличнойЧасти, ДанныеОбъекта)
	
	ПроцедурыБухгалтерскогоУчета.ПроверитьВладельцаСубконтоПодразделение(СтрокаТабличнойЧасти, 
	                                        ДанныеОбъекта.Организация, 
	                                        Новый Структура("НазваниеСубконтоБУ1, НазваниеСубконтоБУ2, НазваниеСубконтоБУ3, 
	                                                        |СубконтоБУ1, СубконтоБУ2, СубконтоБУ3",
	                                                        "СубконтоНУ1", "СубконтоНУ2", "СубконтоНУ3", 
	                                                        СтрокаТабличнойЧасти.СубконтоНУ1, СтрокаТабличнойЧасти.СубконтоНУ2, СтрокаТабличнойЧасти.СубконтоНУ3));
															
	СчетаУчета = Новый Структура("СчетЗакрытияНУ, СубконтоНУ1,
								 |СубконтоНУ2, СубконтоНУ3", СтрокаТабличнойЧасти.СчетЗакрытияНУ,
								 СтрокаТабличнойЧасти.СубконтоНУ1, СтрокаТабличнойЧасти.СубконтоНУ2,
								 СтрокаТабличнойЧасти.СубконтоНУ3);

КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()

	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "БУ", "СчетЗакрытияБУ");	
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "НУ", "СчетЗакрытияНУ");	

	Для Каждого СтрокаТабличнойЧасти Из Объект.АналитикаРаспределения Цикл
		
		Если ПоддержкаРаботыСоСтруктурнымиПодразделениями Тогда 
			Если ТипЗнч(СтрокаТабличнойЧасти.СтруктурноеПодразделение) = Тип("СправочникСсылка.Организации") 
				И СтрокаТабличнойЧасти.СтруктурноеПодразделение <> Объект.Организация Тогда 
				СтрокаТабличнойЧасти.СтруктурноеПодразделение = Справочники.Организации.ПустаяСсылка();
			ИначеЕсли ТипЗнч(СтрокаТабличнойЧасти.СтруктурноеПодразделение) = Тип("СправочникСсылка.ПодразделенияОрганизаций") 
				И СтрокаТабличнойЧасти.СтруктурноеПодразделение.Владелец <> Объект.Организация Тогда 
				СтрокаТабличнойЧасти.СтруктурноеПодразделение = Справочники.ПодразделенияОрганизаций.ПустаяСсылка();
			КонецЕсли;
		КонецЕсли;

		ПроцедурыБухгалтерскогоУчета.ПроверитьВладельцаСубконтоПодразделение(СтрокаТабличнойЧасти,
		                                        Объект.Организация, 
		                                        Новый Структура("НазваниеСубконтоБУ1, НазваниеСубконтоБУ2, НазваниеСубконтоБУ3, 
		                                                        |СубконтоБУ1, СубконтоБУ2, СубконтоБУ3",
		                                                        "СубконтоБУ1", "СубконтоБУ2", "СубконтоБУ3", 
		                                                        СтрокаТабличнойЧасти.СубконтоБУ1, СтрокаТабличнойЧасти.СубконтоБУ2, СтрокаТабличнойЧасти.СубконтоБУ3));
																
		ПроцедурыБухгалтерскогоУчета.ПроверитьВладельцаСубконтоПодразделение(СтрокаТабличнойЧасти,
		                                        Объект.Организация, 
		                                        Новый Структура("НазваниеСубконтоБУ1, НазваниеСубконтоБУ2, НазваниеСубконтоБУ3, 
		                                                        |СубконтоБУ1, СубконтоБУ2, СубконтоБУ3",
		                                                        "СубконтоНУ1", "СубконтоНУ2", "СубконтоНУ3", 
		                                                        СтрокаТабличнойЧасти.СубконтоНУ1, СтрокаТабличнойЧасти.СубконтоНУ2, СтрокаТабличнойЧасти.СубконтоНУ3));
		
	КонецЦикла;

КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПриИзмененииЗначенияСтруктурногоПодразделения(СтрокаТабличнойЧасти, Знач ДанныеОбъекта)
	
	// Список структур с реквизитами группы счетов в шапке
	СтруктураСчетовИСубконто = Новый Структура("СчетБУ, СчетНУ, СубконтоБУ1, СубконтоБУ2, СубконтоБУ3, СубконтоНУ1, СубконтоНУ2, СубконтоНУ3",
												СтрокаТабличнойЧасти.СчетЗакрытияБУ,
												СтрокаТабличнойЧасти.СчетЗакрытияНУ,
												СтрокаТабличнойЧасти.СубконтоБУ1,
												СтрокаТабличнойЧасти.СубконтоБУ2,
												СтрокаТабличнойЧасти.СубконтоБУ3,
												СтрокаТабличнойЧасти.СубконтоНУ1,
												СтрокаТабличнойЧасти.СубконтоНУ2,
												СтрокаТабличнойЧасти.СубконтоНУ3);
												
	СписокАналитикиСчетовШапки = Новый СписокЗначений;
	
	СписокАналитикиСчетовШапки.Добавить("БУ"); 	// СчетЗакрытияБУ
	СписокАналитикиСчетовШапки.Добавить("НУ");  // СчетЗакрытияНУ
	
	СтруктураРеквизитовШапки = Новый Структура("Объект, СписокАналитикиСчетовШапки", СтруктураСчетовИСубконто, СписокАналитикиСчетовШапки);
	
	// Очистим некорректные значения Субконто с подразделениями не входящими в выбранное структурное подразделение
	РаботаСДиалогами.ПроверитьСоответствиеПодразделения(ДанныеОбъекта.Организация, СтрокаТабличнойЧасти.СтруктурноеПодразделение, , , СтруктураРеквизитовШапки); 
	
	СтрокаТабличнойЧасти.СчетЗакрытияБУ = СтруктураСчетовИСубконто.СчетБУ;
	СтрокаТабличнойЧасти.СчетЗакрытияНУ = СтруктураСчетовИСубконто.СчетНУ;
	ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, СтруктураСчетовИСубконто, "СубконтоБУ1, СубконтоБУ2, СубконтоБУ3, СубконтоНУ1, СубконтоНУ2, СубконтоНУ3");
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция КоличествоСубконтоНаПроизводственномСчете(ТекСчетЗакрытия)
	
	КоличествоСубконто = 0;
	
	// Счет не производственный.		
	Если НЕ (ТекСчетЗакрытия.ПринадлежитЭлементу(ПланыСчетов.Типовой.ОсновноеПроизводство_)
		 ИЛИ ТекСчетЗакрытия.ПринадлежитЭлементу(ПланыСчетов.Типовой.ПолуфабрикатыСобственногоПроизводства_)
		 ИЛИ ТекСчетЗакрытия.ПринадлежитЭлементу(ПланыСчетов.Типовой.ВспомогательныеПроизводства_)
		 ИЛИ ТекСчетЗакрытия.ПринадлежитЭлементу(ПланыСчетов.Типовой.НакладныеРасходы_)) Тогда
		 
		КоличествоСубконто = ПроцедурыБухгалтерскогоУчетаВызовСервераПовтИсп.ПолучитьСвойстваСчета(ТекСчетЗакрытия).КоличествоСубконто;
			
	КонецЕсли;	

	Возврат КоличествоСубконто;
	
КонецФункции

&НаКлиенте
Процедура АналитикаРаспределенияПриАктивизацииСтроки(Элемент)
	
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "БУ", "СчетЗакрытияБУ");	
	ИзменитьПараметрыВыбораПолейСубконто(ЭтаФорма, "НУ", "СчетЗакрытияНУ");	

КонецПроцедуры
