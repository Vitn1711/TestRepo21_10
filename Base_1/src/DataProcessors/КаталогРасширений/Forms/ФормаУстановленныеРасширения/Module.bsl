
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТекущийПользователь = Пользователи.ТекущийПользователь();
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ОчередьРасширенийДляОповещений.Пользователь КАК Пользователь,
	               |	ОчередьРасширенийДляОповещений.ИдентификаторРасширения КАК ИдентификаторРасширения,
	               |	ОчередьРасширенийДляОповещений.Состояние КАК Состояние
	               |ИЗ
	               |	РегистрСведений.ОчередьРасширенийДляОповещений КАК ОчередьРасширенийДляОповещений
	               |ГДЕ
	               |	ОчередьРасширенийДляОповещений.Состояние В (ЗНАЧЕНИЕ(Перечисление.СостоянияРасширений.Установлено), ЗНАЧЕНИЕ(Перечисление.СостоянияРасширений.Удалено))
	               |	И ОчередьРасширенийДляОповещений.Пользователь = &Пользователь";
	
	Запрос.УстановитьПараметр("Пользователь", ТекущийПользователь);
	
	УстановитьПривилегированныйРежим(Истина);
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.Состояние = Перечисления.СостоянияРасширений.Установлено Тогда
			Расширение = Справочники.ПоставляемыеРасширения.ПолучитьСсылку(Выборка.ИдентификаторРасширения);
			УстановленныеРасширения.Добавить(Расширение);
		КонецЕсли;
		
		НаборЗаписей = РегистрыСведений.ОчередьРасширенийДляОповещений.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Пользователь.Установить(ТекущийПользователь);
		НаборЗаписей.Отбор.ИдентификаторРасширения.Установить(Выборка.ИдентификаторРасширения);
		НаборЗаписей.Записать(Истина);
		
	КонецЦикла;
	
	Если УстановленныеРасширения.Количество() = 0 Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура УстановленныеРасширенияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Расширение = УстановленныеРасширения.НайтиПоИдентификатору(ВыбраннаяСтрока).Значение;
	ИдентификаторВерсии = ПолучитьИдентификаторВерсииРасширения(Расширение);
	
	КаталогРасширенийКлиент.ОткрытьФормуВерсииРасширения(ИдентификаторВерсии, Строка(Расширение), ЭтотОбъект); 
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ПолучитьИдентификаторВерсииРасширения(Знач Расширение)
	
	Возврат Строка(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Расширение, "ИдентификаторВерсии"));
	
КонецФункции

#КонецОбласти










