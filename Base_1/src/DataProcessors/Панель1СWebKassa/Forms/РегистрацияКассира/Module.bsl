
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ Параметры.Свойство("КассыККМ")
		ИЛИ НЕ Параметры.Свойство("Организация") Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Организация = Параметры.Организация;
	
	ТаблицаКасс = ИнтеграцияWebKassaВызовСервера.МассивВТаблицуЗначений(Параметры.КассыККМ);
	
	КассыККМ.Загрузить(ТаблицаКасс);
	ЗаполнитьСвязанныеКассыККМ();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьРегистрациюКассира(Команда)
	
	ОчиститьСообщения();
	
	Если НЕ ПроверитьЗаполнениеДанных() Тогда
		Возврат;
	КонецЕсли;
	
	Кассы = Новый Массив;
	Для Каждого СтрокаКассаККМ Из КассыККМ Цикл
		Если СтрокаКассаККМ.Выбрать = Истина Тогда
			Кассы.Добавить(СтрокаКассаККМ.СерийныйНомер);
		КонецЕсли;
	КонецЦикла;
	ВходныеПараметры = Новый Структура;
	ВходныеПараметры.Вставить("Организация",  Организация);
	ВходныеПараметры.Вставить("ФИО",          ФИО);
	ВходныеПараметры.Вставить("НомерТелефона","+"+НомерТелефона);
	ВходныеПараметры.Вставить("Логин",        Email);
	ВходныеПараметры.Вставить("Пароль",       Пароль);
	ВходныеПараметры.Вставить("ПереченьКасс", Кассы);
	
	ПараметрыПодключения = Новый Структура;
	ОповещениеПриЗавершении = Новый ОписаниеОповещения("ВыполнитьРегистрациюКассира_Завершение", ЭтотОбъект, ВходныеПараметры);
	ИнтеграцияWebKassaКлиент.НачатьРегистрациюКассира(ОповещениеПриЗавершении, ВходныеПараметры, ПараметрыПодключения);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВсеКассы(Команда)
	Для Каждого СтрокаКассаККМ Из КассыККМ Цикл
		СтрокаКассаККМ.Выбрать = Истина;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьВсеКассы(Команда)
	Для Каждого СтрокаКассаККМ Из КассыККМ Цикл
		СтрокаКассаККМ.Выбрать = Ложь;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьСвязанныеКассыККМ()
	
	ТаблицаКасс = РеквизитФормыВЗначение("КассыККМ");
	МассивСерийныхНомеров = ТаблицаКасс.ВыгрузитьКолонку("СерийныйНомер");
	СоответствиеКассККМСерийнымНомерам = ИнтеграцияWebKassaВызовСервера.СоответствиеКассККМСерийнымНомерам(МассивСерийныхНомеров);
	
	Для Каждого СтрокаКассы Из ТаблицаКасс Цикл
		СписокКассККМ = СоответствиеКассККМСерийнымНомерам[СтрокаКассы.СерийныйНомер];
		Если СписокКассККМ <> Неопределено Тогда
			СтрокаКассы.СвязанныеКассыККМ.ЗагрузитьЗначения(СписокКассККМ);
			СтрокаКассы.ПредставлениеКассыККМ = СтрСоединить(СписокКассККМ, ",");
		КонецЕсли;
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(ТаблицаКасс, "КассыККМ");
	
КонецПроцедуры

&НаКлиенте
Функция ПроверитьЗаполнениеДанных()
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	КоличествоКасс = 0;
	Для Каждого СтрокаКассаККМ Из КассыККМ Цикл
		Если СтрокаКассаККМ.Выбрать = Истина Тогда
			КоличествоКасс = КоличествоКасс + 1;
		КонецЕсли;
	КонецЦикла;
	
	Если КоличествоКасс = 0 Тогда
		ТекстОшибки = НСтр("ru = 'Необходимо выбрать хотя бы одну кассу ККМ!'");
		ИнтеграцияWebKassaКлиентПереопределяемый.СообщитьПользователю(ТекстОшибки, , "Ошибка заполнения");
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Процедура ВыполнитьРегистрациюКассира_Завершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат.РезультатВыполнения Тогда
		Если ДобавитьПользователяВНастройкуИнтеграции(ДополнительныеПараметры.Организация, ДополнительныеПараметры.Логин) Тогда
			ШаблонСообщения = НСтр("ru = 'Регистрация прошла успешно.'");
		Иначе
			ШаблонСообщения = НСтр("ru = 'При регистрации кассира произошла ошибка.
				|(Подробности см. в Журнале регистрации).'");
		КонецЕсли;
		ИнтеграцияWebKassaКлиентПереопределяемый.СообщитьПользователю(ШаблонСообщения);
		ТолькоПросмотр = Истина;
		Модифицированность = Ложь;
		Элементы.ВыполнитьРегистрациюКассира.Видимость = Ложь;
		Элементы.ФормаЗакрыть.КнопкаПоУмолчанию = Истина;
		Элементы.ФормаЗакрыть.Заголовок = НСтр("ru = 'Закрыть'");
	Иначе
		Если Результат.ВыходныеПараметры[0] = 999 Тогда
			ТекстСообщения = НСтр("ru = 'При регистрации кассира произошла ошибка.
										|Дополнительное описание: %ДополнительноеОписание%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДополнительноеОписание%", Результат.ВыходныеПараметры[1]);
			ИнтеграцияWebKassaКлиентПереопределяемый.СообщитьПользователю(ТекстСообщения);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ДобавитьПользователяВНастройкуИнтеграции(Организация, Пользователь)
	Возврат Справочники.НастройкиИнтеграцииWebKassa.ДобавитьПользователяВНастройкуИнтеграции(Организация, Пользователь);
КонецФункции

&НаКлиенте
Процедура КассыККМВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя = "КассыККМПредставлениеКассыККМ" Тогда
		ТекущиеДанные = Элементы.КассыККМ.ТекущиеДанные;
		ОткрытьФорму("Обработка.Панель1СWebKassa.Форма.ПросмотрСпискаКасс",
			Новый Структура("СписокКасс", ТекущиеДанные.СвязанныеКассыККМ));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
