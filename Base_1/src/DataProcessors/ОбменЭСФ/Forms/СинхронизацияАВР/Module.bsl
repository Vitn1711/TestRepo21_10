#Область ОбработчикиСобытийФорм
	
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьТаблицуПрофилейДляСинхронизации();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Контейнер = ЭСФКлиентСервер.КонтейнерМетодов();	
	Контейнер.ПриОткрытииФормы(ЭтаФорма, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "Синхронизация_АВР" Тогда
		ОбновитьТаблицуПрофилейДляСинхронизации(); // Обновление даты синхронизации по результататм работы события
	КонецЕсли;	
КонецПроцедуры

#КонецОбласти  

#Область ОбработчикиСобытийФорм

&НаКлиенте
Процедура ТаблицаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)	
	Отказ = Истина;	
	ОткрытьФорму("Справочник.ПрофилиИСЭСФ.ФормаВыбора", , Элемент);	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)	
	СтандартнаяОбработка = Ложь;
	ТаблицаОбработкаВыбораНаСервере(ВыбранноеЗначение);
КонецПроцедуры

&НаСервере
Процедура ТаблицаОбработкаВыбораНаСервере(ВыбранноеЗначение)	
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.ПрофилиИСЭСФ") Тогда
		СтрокаТаблицы = Таблица.Добавить();
		СтрокаТаблицы.Пометка = Истина;
		СтрокаТаблицы.СтруктурнаяЕдиница = ВыбранноеЗначение.СтруктурнаяЕдиница;
		СтрокаТаблицы.ПрофильИСЭСФ = ВыбранноеЗначение;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаСтруктурнаяЕдиницаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаСтруктурнаяЕдиницаОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаПрофильИСЭСФНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаПрофильИСЭСФОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаКомментарийОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

#КонецОбласти  

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Синхронизировать(Команда)
	
	// Очистить комментарий.
	Для Каждого СтрокаТаблицы Из Таблица Цикл
		СтрокаТаблицы.Комментарий = "";	
	КонецЦикла;
	
	// Создать массив профилей ИС ЭСФ из помеченных строк таблицы.
	МассивПрофилейИСЭСФ = Новый Массив;	
	МассивПрофилейИСЭСФСДатойСинхронизации = Новый Массив; // Для получения входящих ЭСФ в версии 5.0, в свзяи с вводом параметра LastEventDate
	
	Для Каждого СтрокаТаблицы Из Таблица Цикл
		Если СтрокаТаблицы.Пометка Тогда
			МассивПрофилейИСЭСФ.Добавить(СтрокаТаблицы.ПрофильИСЭСФ);
			МассивПрофилейИСЭСФСДатойСинхронизации.Добавить(Новый Структура("ПрофильИСЭСФ, ДатаНачалаСинхронизацииВходящихЭСФ, ДатаНачалаСинхронизацииИсходящихЭСФ", СтрокаТаблицы.ПрофильИСЭСФ, СтрокаТаблицы.НачальнаяДатаАВР));	
		КонецЕсли;
	КонецЦикла;
	
	Если МассивПрофилейИСЭСФ.Количество() = 0 Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru = 'Выберите хотя бы один профиль для синхронизации с ИС ЭСФ.'");
		Сообщение.Поле = "Таблица";
		Сообщение.Сообщить();
		Возврат;	
	КонецЕсли;
	
		
	// Получить пароли для пользователей ИС ЭСФ, которые не имеют сохраненных паролей.
	МассивПользователейИСЭСФБезПароля = ЭСФВызовСервера.ПользователиИСЭСФБезПароляАутентификации(МассивПрофилейИСЭСФ);	
	
	ДополнительныеПараметры = Новый Структура("МассивПрофилейИСЭСФ, МассивПользователейИСЭСФБезПароля, МассивПрофилейИСЭСФСДатойСинхронизации", МассивПрофилейИСЭСФ, МассивПользователейИСЭСФБезПароля, МассивПрофилейИСЭСФСДатойСинхронизации);
	
	Если МассивПользователейИСЭСФБезПароля.Количество() > 0 Тогда
		СинхронизироватьЗавершение = Новый ОписаниеОповещения("СинхронизироватьЗавершение", ЭтаФорма, ДополнительныеПараметры);
		ЭСФКлиент.ПаролиАутентификации(СинхронизироватьЗавершение, МассивПользователейИСЭСФБезПароля);
	Иначе
		СинхронизироватьЗавершение(МассивПрофилейИСЭСФ, ДополнительныеПараметры);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СинхронизироватьНаСервере(МассивДанныхПрофилейИСЭСФ, МассивПрофилейИСЭСФСДатойСинхронизации)
	
	ПараметрыЗадания = Новый Структура("МассивДанныхПрофилейИСЭСФ, МассивПрофилейИСЭСФСДатойСинхронизации, ПолучитьОднуПорцию, ТолькоСоздатьОбновитьФайлы, ЗапускатьФоновоеЗадание");
	ПараметрыЗадания.Вставить("МассивДанныхПрофилейИСЭСФ", МассивДанныхПрофилейИСЭСФ);
	ПараметрыЗадания.Вставить("ПолучитьОднуПорцию", Истина);
	ПараметрыЗадания.Вставить("ТолькоСоздатьОбновитьФайлы", Ложь);
	ПараметрыЗадания.Вставить("ЗапускатьФоновоеЗадание", АВРКлиентСервер.ИспользоватьФоновуюОтправкуАВР());
	ПараметрыЗадания.Вставить("МассивПрофилейИСЭСФСДатойСинхронизации", МассивПрофилейИСЭСФСДатойСинхронизации);	
	
	Если ПараметрыЗадания.ЗапускатьФоновоеЗадание Тогда
		
		РезультатРаботыЗадания = Неопределено;
	
		ИмяПроцедурыПолученияАВР = "АВРВызовСервера.ПолучитьНовыеАВР";
		
		СтруктураВыполненияЗадания = АВРСерверПереопределяемый.ФоновоеЗаданиеЗапущено(ИмяПроцедурыПолученияАВР);
		
		Если НЕ СтруктураВыполненияЗадания.ЗаданиеАктивно Тогда
			
			ПараметрыВыполнения = ЭСФКлиентСерверПереопределяемый.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
			НаименованиеЗадания = НСтр("ru = 'Синхронизация АВР'");
			ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеЗадания;
			
			РезультатРаботыЗадания = АВРВызовСервера.ВыполнитьВФоне(ИмяПроцедурыПолученияАВР, ПараметрыЗадания, ПараметрыВыполнения);
				
		Иначе
			
			ТекстСообщения = НСтр("ru = 'В информационной базе уже запущен процесс получения документов АВР. 
										|Перед запуском нового процесса синхронизации, необходимо дождаться завершения предыдущего (запущено на %1, время запуска %2'");
										
			ТекстСообщения = ЭСФКлиентСерверПереопределяемый.ПодставитьПараметрыВСтроку(ТекстСообщения, СтруктураВыполненияЗадания.Расположение, СтруктураВыполненияЗадания.Начало);
										
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = ТекстСообщения;
			Сообщение.Сообщить();
				
		КонецЕсли;
			
	Иначе
		
		АВРВызовСервера.ПолучитьНовыеАВР(ПараметрыЗадания);
		
	КонецЕсли;
	
	Возврат РезультатРаботыЗадания;

КонецФункции

&НаКлиенте
Процедура УстановитьФлажки(Команда)	
	Для Каждого СтрокаТаблицы Из Таблица Цикл
		СтрокаТаблицы.Пометка = Истина;
	КонецЦикла;	
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	Для Каждого СтрокаТаблицы Из Таблица Цикл
		СтрокаТаблицы.Пометка = Ложь;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СинхронизироватьЗавершение(Результат = Неопределено, ДополнительныеПараметры) Экспорт
	
	МассивПрофилейИСЭСФ = ДополнительныеПараметры.МассивПрофилейИСЭСФ;
	МассивПользователейИСЭСФБезПароля = ДополнительныеПараметры.МассивПользователейИСЭСФБезПароля;
	МассивПрофилейИСЭСФСДатойСинхронизации = ДополнительныеПараметры.МассивПрофилейИСЭСФСДатойСинхронизации; 
	
	Если НЕ Результат = Неопределено Тогда
		
		КоллецияПаролей = Результат;
		МассивДанныхПрофилейИСЭСФ = ДанныеПрофилейДляСинхронизацииНаСервере(МассивПрофилейИСЭСФ, КоллецияПаролей);
	
	КонецЕсли;

	Если МассивДанныхПрофилейИСЭСФ = Неопределено ИЛИ МассивДанныхПрофилейИСЭСФ.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;

	ОчиститьСообщения();
	
	РезультатРаботыЗадания = СинхронизироватьНаСервере(МассивДанныхПрофилейИСЭСФ, МассивПрофилейИСЭСФСДатойСинхронизации);
	
	Если Параметры.ЗапускатьФоновоеЗадание Тогда
		
		Если ТипЗнч(РезультатРаботыЗадания) = Тип("Структура") Тогда
			РезультатРаботыЗадания.Вставить("ТекстСообщения", НСтр("ru = 'Получение электронных актов выполненных работ из ИС ЭСФ'"));
			
			СтруктураОповещений = Новый Структура(АВРКлиентСервер.ИмяСобытияСинхронизацияАВР());
			РезультатРаботыЗадания.Вставить("ДополнительныеОповещения", СтруктураОповещений);
		КонецЕсли;
				
		АВРКлиент.ОбработкаОповещенияАВР_ПроверятьОповещенияФоновогоЗадания(ЭтаФорма, РезультатРаботыЗадания);
		
	Иначе
		ЭСФКлиент.ОповеститьФормы(АВРКлиентСервер.ИмяСобытияЗаписьАВР());
		ЭСФКлиент.ОповеститьФормы(АВРКлиентСервер.ИмяСобытияСинхронизацияАВР());
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ДанныеПрофилейДляСинхронизацииНаСервере(Знач МассивПрофилейИСЭСФ, Знач КоллецияПаролей)
	
	// Создать массив, содержащий данные профилей ИС ЭСФ.
	МассивДанныхПрофилейИСЭСФ = Новый Массив();
	Для Каждого ПрофильИСЭСФ Из МассивПрофилейИСЭСФ Цикл
		ДанныеПрофиляИСЭСФ = ЭСФСервер.ДанныеПрофиляИСЭСФ(ПрофильИСЭСФ);
		МассивДанныхПрофилейИСЭСФ.Добавить(ДанныеПрофиляИСЭСФ);
	КонецЦикла;
	
	// Заполнить пароли, у пользователей, которые не имеют сохраненных паролей. 
	Для Каждого ДанныеПрофиляИСЭСФ Из МассивДанныхПрофилейИСЭСФ Цикл
		Если ПустаяСтрока(ДанныеПрофиляИСЭСФ.ТекущийПарольАутентификации) Тогда
			ДанныеПрофиляИСЭСФ.ТекущийПарольАутентификации = КоллецияПаролей[ДанныеПрофиляИСЭСФ.ПользовательИСЭСФ.Ссылка];	
		КонецЕсли;
	КонецЦикла;
	
	Возврат МассивДанныхПрофилейИСЭСФ;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьТаблицуПрофилейДляСинхронизации()
	
	// Запрос организован таким образом, чтобы сработал RLS.
		
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Организации.Ссылка КАК СтруктурнаяЕдиница,
	|	Организации.Наименование
	|ПОМЕСТИТЬ СтруктурныеЕдиницы
	|ИЗ
	|	Справочник.Организации КАК Организации
	|
	| [ЗапросПоСтруктурнымЕдиницам]
	|
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ПрофилиИСЭСФ.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ПрофилиИСЭСФ.Ссылка КАК ПрофильИСЭСФ
	|ПОМЕСТИТЬ ВТ_ПрофилиСинхронизации	
	|ИЗ
	|	Справочник.ПрофилиИСЭСФ КАК ПрофилиИСЭСФ	
	|ГДЕ
	|	НЕ ПрофилиИСЭСФ.ПометкаУдаления
	|	И ПрофилиИСЭСФ.ИспользоватьДляСинхронизации
	|	И ПрофилиИСЭСФ.СтруктурнаяЕдиница В
	|			(ВЫБРАТЬ
	|				СтруктурныеЕдиницы.СтруктурнаяЕдиница
	|			ИЗ
	|				СтруктурныеЕдиницы КАК СтруктурныеЕдиницы);
	|
	|ВЫБРАТЬ
	|	ПрофилиСинхронизации.СтруктурнаяЕдиница,
	|	ПрофилиСинхронизации.ПрофильИСЭСФ,
	|	ЕСТЬNULL(ПараметрыМетодовИСЭСФВходящихЭСФ.ЗначениеПараметра, &ДатаПоУмолчанию) КАК НачальнаяДатаАВР
	//|	ЕСТЬNULL(ПараметрыМетодовИСЭСФИсходящихЭСФ.ЗначениеПараметра, &ДатаПоУмолчанию) КАК ДатаНачалаСинхронизацииИсходящихАВР
	|ИЗ
	|	ВТ_ПрофилиСинхронизации КАК ПрофилиСинхронизации
	|ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПараметрыМетодовИСЭСФ КАК ПараметрыМетодовИСЭСФВходящихЭСФ
	|		ПО (ПрофилиСинхронизации.СтруктурнаяЕдиница = ПараметрыМетодовИСЭСФВходящихЭСФ.СтруктурнаяЕдиница
	|				И ПараметрыМетодовИСЭСФВходящихЭСФ.ИмяМетода = &ИмяМетода     // дата начала синхронизации
	|				И ПараметрыМетодовИСЭСФВходящихЭСФ.НаправлениеЭСФ = &Направление
	|				И ПараметрыМетодовИСЭСФВходящихЭСФ.ИмяПараметра = &ИмяПараметра)
	//|ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПараметрыМетодовИСЭСФ КАК ПараметрыМетодовИСЭСФИсходящихЭСФ
	//|		ПО (ПрофилиСинхронизации.СтруктурнаяЕдиница = ПараметрыМетодовИСЭСФИсходящихЭСФ.СтруктурнаяЕдиница
	//|				И ПараметрыМетодовИСЭСФИсходящихЭСФ.ИмяМетода = &ИмяМетода     // дата начала синхронизации
	//|				И ПараметрыМетодовИСЭСФИсходящихЭСФ.НаправлениеЭСФ = Значение(Перечисление.НаправленияЭСФ.Исходящий)
	//|				И ПараметрыМетодовИСЭСФИсходящихЭСФ.ИмяПараметра = &ИмяПараметра)
	
	|
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПрофилиСинхронизации.СтруктурнаяЕдиница.Наименование";
	
	// Не все конфигурации поддерживают структурные единицы.
	Если ЭСФКлиентСерверПереопределяемый.ИспользуютсяСтруктурныеПодразделения() Тогда
		ЗапросПоСтруктурнымЕдиницам = 
		"ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ПодразделенияОрганизаций.Ссылка,
		|	ПодразделенияОрганизаций.Наименование
		|ИЗ
		|	Справочник.ПодразделенияОрганизаций КАК ПодразделенияОрганизаций
		|ГДЕ
		|	ПодразделенияОрганизаций.ЯвляетсяСтруктурнымПодразделением";		
	Иначе
		ЗапросПоСтруктурнымЕдиницам = "";
	КонецЕсли;	
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "[ЗапросПоСтруктурнымЕдиницам]", ЗапросПоСтруктурнымЕдиницам);
	
	Запрос.УстановитьПараметр("ИмяМетода",	"AWPQUERYUPDATES");	
	Запрос.УстановитьПараметр("ИмяПараметра", "LASTEVENTDATE");
	Запрос.УстановитьПараметр("Направление", Перечисления.НаправленияЭСФ.ПустаяСсылка());
	Запрос.УстановитьПараметр("ДатаПоУмолчанию", Дата(2019, 1, 1, 0, 0, 0));
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		СтрокаТаблицы = Таблица.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТаблицы, Выборка);
		//СтрокаТаблицы.Пометка = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьТаблицуПрофилейДляСинхронизации()
	МассивПрофилейИСЭСФ = Новый Массив;
	Для Каждого СтрокаТаблицы Из Таблица Цикл
		Если СтрокаТаблицы.Пометка Тогда
			МассивПрофилейИСЭСФ.Добавить(СтрокаТаблицы.ПрофильИСЭСФ);				
		КонецЕсли;
	КонецЦикла;
	Таблица.Очистить();
	ЗаполнитьТаблицуПрофилейДляСинхронизации();
	Для Каждого СтрокаТаблицы Из Таблица Цикл
		Если МассивПрофилейИСЭСФ.Найти(СтрокаТаблицы.ПрофильИСЭСФ)<>Неопределено Тогда
			СтрокаТаблицы.Пометка = Истина;
		КонецЕсли;
	КонецЦикла;		
КонецПроцедуры

#КонецОбласти
