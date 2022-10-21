////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаСервереБезКонтекста
Функция НайтиРодителя(КодРодителя)
	
	Возврат ПланыСчетов.Налоговый.НайтиПоКоду(КодРодителя);
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьЗапрещенныеСчета()
	
	ЗапрещенныеСчета = Новый Массив;
	ЗапрещенныеСчета.Добавить(ПланыСчетов.Налоговый.РасходыПоКурсовойРазнице);
	ЗапрещенныеСчета.Добавить(ПланыСчетов.Налоговый.ДоходОтКурсовойРазницы);
	ЗапрещенныеСчета.Добавить(ПланыСчетов.Налоговый.ПоступлениеИВыбытиеИмуществаРаботУслугПрав);

	//по расчету заработной платы
	ЗапрещенныеСчета.Добавить(ПланыСчетов.Налоговый.ВзаиморасчетыСРаботниками); // 3350Н (Н460)
	ЗапрещенныеСчета.Добавить(ПланыСчетов.Налоговый.ОбязательстваПоСоциальномуСтрахованию); // 3211Н
	ЗапрещенныеСчета.Добавить(ПланыСчетов.Налоговый.ОбязательстваПоВзносамОСМС); // 3212Н
	ЗапрещенныеСчета.Добавить(ПланыСчетов.Налоговый.ОбязательстваПоОтчислениямОСМС); // 3213Н
	ЗапрещенныеСчета.Добавить(ПланыСчетов.Налоговый.ОбязательстваПоПенсионнымОтчислениям);  // 3220Н
	
	Возврат Новый ФиксированныйМассив(ЗапрещенныеСчета);
	
КонецФункции

&НаКлиенте
Процедура ПредупреждениеОНевозможностиИзмененияСоставаВидовСубконто(Отказ)
	
	ПоказатьПредупреждение(, НСтр("ru = 'Состав видов субконто на этом счете определяется настройкой параметров учета.'"));
	Отказ = Истина;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЭтоЗапрещенныйСчет(Счет)

	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("Ссылка"          , Счет);
	Запрос.УстановитьПараметр("СписокСчетов"    , ПолучитьЗапрещенныеСчета());	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Налоговый.Ссылка КАК Ссылка
	|ИЗ
	|	ПланСчетов.Налоговый КАК Налоговый
	|ГДЕ
	|	Налоговый.Ссылка = &Ссылка
	|	И Налоговый.Ссылка В ИЕРАРХИИ(&СписокСчетов)";
	
	ЗапрещенныйСчет = НЕ Запрос.Выполнить().Пустой();
	
	Возврат ЗапрещенныйСчет;

КонецФункции // ЭтоЗапрещенныйСчет()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗапрещенныйСчет      = ЭтоЗапрещенныйСчет(Объект.Ссылка);

	Элементы.ВидыСубконтоДобавить.Доступность = НЕ ЗапрещенныйСчет;
	Элементы.ВидыСубконтоИзменить.Доступность = НЕ ЗапрещенныйСчет;
	Элементы.ВидыСубконтоУдалить.Доступность  = НЕ ЗапрещенныйСчет;
	Элементы.ВидыСубконтоПереместитьВверх.Доступность 	= НЕ ЗапрещенныйСчет;
	Элементы.ВидыСубконтоПереместитьВниз.Доступность 	= НЕ ЗапрещенныйСчет;
	Элементы.Количественный.Доступность					= НЕ ЗапрещенныйСчет И НЕ Объект.Предопределенный;
	Элементы.Забалансовый.Доступность					= НЕ ЗапрещенныйСчет И НЕ Объект.Предопределенный;
	
	Кнопка = Элементы.ВидыСубконто.КонтекстноеМеню.ПодчиненныеЭлементы.Найти("ВидыСубконтоКонтекстноеМенюДобавить");
	Если Кнопка <> Неопределено Тогда
		Кнопка.Доступность = НЕ ЗапрещенныйСчет;
	КонецЕсли;
	Кнопка = Элементы.ВидыСубконто.КонтекстноеМеню.ПодчиненныеЭлементы.Найти("ВидыСубконтоКонтекстноеМенюИзменить");
	Если Кнопка <> Неопределено Тогда
		Кнопка.Доступность = НЕ ЗапрещенныйСчет;
	КонецЕсли;
	Кнопка = Элементы.ВидыСубконто.КонтекстноеМеню.ПодчиненныеЭлементы.Найти("ВидыСубконтоКонтекстноеМенюУдалить");
	Если Кнопка <> Неопределено Тогда
		Кнопка.Доступность = НЕ ЗапрещенныйСчет;
	КонецЕсли;
	
	Элементы.Родитель.ТолькоПросмотр 	= Объект.Предопределенный;
	Элементы.Вид.ТолькоПросмотр 		= Объект.Предопределенный;
	
	Элементы.ВидыСубконтоКоличественный.Видимость = Объект.Количественный;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ШАПКИ

&НаКлиенте
Процедура КодПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Возврат;
	КонецЕсли;
	
	// Если задан субсчет, то в его коде должна быть точка
	Код      = Объект.Код;
	Родитель = Объект.Родитель;
	
	Если Найти(Код, ".") > 0 Тогда
		
		//Найдем код родителя, для этого найдем последнюю точку в коде счета
		ПозицияТочки = СтрДлина(Код);
		
		Пока Сред(Код, ПозицияТочки, 1) <> "." Цикл
			
			ПозицияТочки = ПозицияТочки - 1;
			
		КонецЦикла;
		
		КодРодителя    = Лев(Код, ПозицияТочки - 1);
		РодительПоКоду = НайтиРодителя(КодРодителя);
		
		Если НЕ ЗначениеЗаполнено(РодительПоКоду) Тогда
			
			ПоказатьПредупреждение(, СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'План счетов не содержит счета с кодом %1'"), КодРодителя));
			
		ИначеЕсли РодительПоКоду <> Объект.Ссылка Тогда
			
			СвойстваТекущегоРодителя = ПроцедурыБухгалтерскогоУчетаВызовСервераПовтИсп.ПолучитьСвойстваСчета(Объект.Родитель);
			
			Объект.Родитель       = РодительПоКоду;
			Объект.Вид            = СвойстваТекущегоРодителя.Вид;
			Объект.Забалансовый   = СвойстваТекущегоРодителя.Забалансовый;
			Объект.Количественный = СвойстваТекущегоРодителя.Количественный;
					
			Элементы.ВидыСубконтоКоличественный.Видимость = Объект.Количественный;
			
		КонецЕсли;
		
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура КоличественныйПриИзменении(Элемент)
	
	//Элементы.ВидыСубконтоКоличественный.Видимость = Объект.Количественный;
	
	ПредупреждениеОбИзмененииПризнакаУчета("Количественный", "ВидыСубконтоКоличественный");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗабалансовыйПриИзменении(Элемент)
	
	ПредупреждениеОбИзмененииПризнакаУчета("Забалансовый");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ВИДЫ СУБКОНТО

&НаКлиенте
Процедура ВидыСубконтоПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если ЗапрещенныйСчет Тогда
		ПредупреждениеОНевозможностиИзмененияСоставаВидовСубконто(Отказ);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидыСубконтоПередНачаломИзменения(Элемент, Отказ)
	
	Если ЗапрещенныйСчет Тогда
		ПредупреждениеОНевозможностиИзмененияСоставаВидовСубконто(Отказ);
	КонецЕсли;
	
	Если Элемент.ТекущиеДанные.Предопределенное Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидыСубконтоПередУдалением(Элемент, Отказ)
	
	Если ЗапрещенныйСчет Тогда
		ПредупреждениеОНевозможностиИзмененияСоставаВидовСубконто(Отказ);
	КонецЕсли;
	
	Если Элемент.ТекущиеДанные.Предопределенное Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидыСубконтоПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		Элемент.ТекущиеДанные.Суммовой       = Истина;
		Элемент.ТекущиеДанные.Количественный = Истина;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ПредупреждениеОбИзмененииПризнакаУчета(ПризнакУчета, ЭлементФормы = "")
	
	ПараметрыВопроса = Новый Структура("ПризнакУчета, ЭлементФормы", ПризнакУчета, ЭлементФормы);
	
	ТекстВопроса = НСтр(
		"ru = 'Изменение признаков учета может привести к потере данных.
		|Продолжить?'");
	
	ПризнакУчетаИзменениеЗавершение = Новый ОписаниеОповещения("ПризнакУчетаИзменениеЗавершение", ЭтаФорма, ПараметрыВопроса);
	ПоказатьВопрос(ПризнакУчетаИзменениеЗавершение, ТекстВопроса, РежимДиалогаВопрос.ОКОтмена,, КодВозвратаДиалога.Отмена);
	
КонецПроцедуры

&НаКлиенте
Процедура ПризнакУчетаИзменениеЗавершение(РезультатВопроса, ПараметрыВопроса) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Отмена Тогда
		Объект[ПараметрыВопроса.ПризнакУчета] = НЕ Объект[ПараметрыВопроса.ПризнакУчета];
	КонецЕсли;
	
	Если ПараметрыВопроса.ЭлементФормы <> "" Тогда
		Элементы[ПараметрыВопроса.ЭлементФормы].Видимость = Объект[ПараметрыВопроса.ПризнакУчета];
	КонецЕсли;
	
КонецПроцедуры
