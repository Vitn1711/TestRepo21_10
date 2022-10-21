////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СНТСерверПереопределяемый.СНТФормаСпискаИВыбораПриСозданииНаСервере(ЭтаФорма);

	ЭСФКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ФормаЭСФИСФ", "Видимость", Ложь);
	
	УстановитьВидимостьКнопокИзмененияСтатуса();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = СНТКлиентСервер.ИмяСобытияЗаписьСНТ() Тогда
		Элементы.Список.Обновить();
	ИначеЕсли ИмяСобытия = "СНТ_ПроверятьОповещенияФоновогоЗадания"
		И ЭтаФорма.КлючУникальности = Источник Тогда
		
		СНТКлиентПереопределяемый.ОбработкаОповещенияСНТ_ПроверятьОповещенияФоновогоЗадания(ЭтаФорма, Параметр);
		Элементы.Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)	
	УстановитьБыстрыйОтбор("Организация", Организация);
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	УстановитьБыстрыйОтбор("Контрагент", Контрагент);
КонецПроцедуры

&НаКлиенте
Процедура СостояниеПриИзменении(Элемент)
	УстановитьБыстрыйОтбор("Состояние", Состояние);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	УстановитьВидимостьКнопокИзмененияСтатуса();
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура УстановитьБыстрыйОтбор(ВидЭлемента, ЗначениеЭлемента)
	
	ЭСФКлиентСерверПереопределяемый.ИзменитьЭлементОтбораСписка(Список, ВидЭлемента, ЗначениеЭлемента, ЗначениеЗаполнено(ЗначениеЭлемента));
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьКнопокИзмененияСтатуса()
	
	Если Элементы.Список.ВыделенныеСтроки.Количество() > 0 Тогда		
		
		ПервыйВыделенныйСНТ = Элементы.Список.ВыделенныеСтроки[0];
		СоответвствиеСтатусов = СНТСервер.РазрешенныеДействияПоСтатусамСНТ(ПервыйВыделенныйСНТ.Направление,, ПервыйВыделенныйСНТ);
		УстановитьВидимостьКнопки(СоответвствиеСтатусов, "СписокДокументСНТПодтвердить", ПервыйВыделенныйСНТ, СНТКлиентСервер.ДействиеПодтверждение());
		УстановитьВидимостьКнопки(СоответвствиеСтатусов, "СписокДокументСНТОтклонить", ПервыйВыделенныйСНТ, СНТКлиентСервер.ДействиеОтклонение());
		
	Иначе
		
		СНТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СписокДокументСНТПодтвердить",  "Видимость", Ложь);
		СНТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СписокДокументСНТОтклонить",  "Видимость", Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция УстановитьВидимостьКнопки(СоответвствиеСтатусов, НазваниеКнопки, ПервыйВыделенныйСНТ, Действие) 
	
	ВидимостьКнопки = СоответвствиеСтатусов[Действие][ПервыйВыделенныйСНТ.Статус];
	Если ВидимостьКнопки <> Неопределено Тогда
		СНТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, НазваниеКнопки, "Видимость", ВидимостьКнопки);
	Иначе
		СНТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СписокДокументСНТОтозвать", "Видимость", Истина);
		ТекстСообщения = НСтр("ru='Тех. ошибка! Для действия %1 и статуса СНТ %2 не указано соответствие для отображение кнопки'");
		ЭСФКлиентСерверПереопределяемый.ПодставитьПараметрыВСтроку(ТекстСообщения, СНТКлиентСервер.ДействиеОтзыв(), ПервыйВыделенныйСНТ.Статус);
		ЭСФКлиентСерверПереопределяемый.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
		
КонецФункции

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды


