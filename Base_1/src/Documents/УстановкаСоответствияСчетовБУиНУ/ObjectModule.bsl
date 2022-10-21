
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипДанныхЗаполнения = Тип("Структура") Тогда 
		Если ДанныеЗаполнения.Свойство("Автор") Тогда
			ДанныеЗаполнения.Удалить("Автор");
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;

	ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект, ОбщегоНазначенияБКВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета(), , , , ДанныеЗаполнения);

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	ЗаполнениеДокументов.ЗаполнитьШапкуДокумента(ЭтотОбъект, ОбщегоНазначенияБКВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета(),,, ОбъектКопирования.Ссылка);
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Отказ = СуществуютЗаписиНаДатуДокумента(); 
	
	ДополнительныеСвойства.Вставить("ВыполненаПроверкаЗаполнения", Истина);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение 
		И НЕ ДополнительныеСвойства.Свойство("ВыполненаПроверкаЗаполнения") 
		ИЛИ (ДополнительныеСвойства.Свойство("ВыполненаПроверкаЗаполнения") И НЕ ДополнительныеСвойства.ВыполненаПроверкаЗаполнения) Тогда 
		
		Отказ = НЕ ПроверитьЗаполнение();
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА
	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыПроведения = Документы.УстановкаСоответствияСчетовБУиНУ.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// ФОРМИРОВАНИЕ ДВИЖЕНИЙ
	Документы.УстановкаСоответствияСчетовБУиНУ.СформироватьДвиженияУстановкаСоответствияСчетовБУиНУ(ПараметрыПроведения.ТаблицаСоответствия,
		ПараметрыПроведения.ТаблицаРеквизитов, Движения, Отказ);
		
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция СуществуютЗаписиНаДатуДокумента()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;

	Запрос.УстановитьПараметр("ДатаСреза", Дата);
	Запрос.УстановитьПараметр("Ссылка",    Ссылка);
	
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	Регистратор
	|ИЗ
	|	РегистрСведений.СоответствиеСчетовБУиНУ.СрезПоследних(&ДатаСреза, Регистратор <> &Ссылка) КАК СоответствиеСчетовБУиНУСрезПоследних
	|ГДЕ
	|	СоответствиеСчетовБУиНУСрезПоследних.Период = НАЧАЛОПЕРИОДА(&ДатаСреза, ДЕНЬ)";
				
	РезультатЗапроса = Запрос.Выполнить();
		
	Если НЕ РезультатЗапроса.Пустой() Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'На дату %1 уже существует документ «Установка соответствия счетов БУ и НУ».'"),
			Формат(Дата,"ДФ=dd.MM.yyyy"));
		
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий(); 		
		
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, Выборка.Регистратор);	
		Возврат Истина;		
	КонецЕсли;	
	
	Возврат Ложь;
	
Конецфункции

#КонецЕсли

//////////////////////////////////////////////////////////////////////////////////
//// ОБРАБОТЧИКИ СОБЫТИЙ

//Процедура ОбработкаПроведения(Отказ, Режим)
//	СтруктураПолейШапки = Новый Структура;
//	СтруктураПолейШапки.Вставить("Организация");
//	
//	// Проверка ручной корректировки
//	Если ОбщегоНазначения.РучнаяКорректировкаОбработкаПроведения(РучнаяКорректировка,Отказ,"",ЭтотОбъект) Тогда
//		Возврат
//	КонецЕсли;
//	

//	ОбщегоНазначения.ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, СтруктураПолейШапки, Отказ, ОбщегоНазначения.ПредставлениеДокументаПриПроведении(Ссылка));
//	
//	Для Каждого ТекСтрокаСоответствиеСчетовБУиНУ Из СоответствиеСчетовБУиНУ Цикл
//		Движение = Движения.СоответствиеСчетовБУиНУ.Добавить();
//		Движение.Период 	= Дата;
//		Движение.СчетБУ 	= ТекСтрокаСоответствиеСчетовБУиНУ.СчетБУ;
//		Движение.СчетКоррБУ = ТекСтрокаСоответствиеСчетовБУиНУ.СчетКоррБУ;
//		
//		Движение.СубконтоБУ1 = ?(НЕ ЗначениеЗаполнено(ТекСтрокаСоответствиеСчетовБУиНУ.СубконтоБУ1), Неопределено, ТекСтрокаСоответствиеСчетовБУиНУ.СубконтоБУ1);
//		Движение.СубконтоБУ2 = ?(НЕ ЗначениеЗаполнено(ТекСтрокаСоответствиеСчетовБУиНУ.СубконтоБУ2), Неопределено, ТекСтрокаСоответствиеСчетовБУиНУ.СубконтоБУ2);
//		Движение.СубконтоБУ3 = ?(НЕ ЗначениеЗаполнено(ТекСтрокаСоответствиеСчетовБУиНУ.СубконтоБУ3), Неопределено, ТекСтрокаСоответствиеСчетовБУиНУ.СубконтоБУ3);
//		
//		Движение.ВидЗатратНУ = ?(НЕ ЗначениеЗаполнено(ТекСтрокаСоответствиеСчетовБУиНУ.ВидЗатратНУ), Неопределено, ТекСтрокаСоответствиеСчетовБУиНУ.ВидЗатратНУ);
//		
//		Движение.СчетНУ = ТекСтрокаСоответствиеСчетовБУиНУ.СчетНУ;
//		
//		Движение.СубконтоНУ1 = ?(НЕ ЗначениеЗаполнено(ТекСтрокаСоответствиеСчетовБУиНУ.СубконтоНУ1), Неопределено, ТекСтрокаСоответствиеСчетовБУиНУ.СубконтоНУ1);
//		Движение.СубконтоНУ2 = ?(НЕ ЗначениеЗаполнено(ТекСтрокаСоответствиеСчетовБУиНУ.СубконтоНУ2), Неопределено, ТекСтрокаСоответствиеСчетовБУиНУ.СубконтоНУ2);
//		Движение.СубконтоНУ3 = ?(НЕ ЗначениеЗаполнено(ТекСтрокаСоответствиеСчетовБУиНУ.СубконтоНУ3), Неопределено, ТекСтрокаСоответствиеСчетовБУиНУ.СубконтоНУ3);
//		
//		Движение.Учитывается = ТекСтрокаСоответствиеСчетовБУиНУ.Учитывается;
//		Движение.Комментарий = ТекСтрокаСоответствиеСчетовБУиНУ.Комментарий;
//		Движение.РеквизитПредставление = "";
//	КонецЦикла;
//	
//	Попытка	
//		Движения.СоответствиеСчетовБУиНУ.Записать();	
//	Исключение
//		Сообщить("На дату "+ Формат(Дата,"ДФ=dd.MM.yyyy") +" уже существует документ «Установка соответствия счетов БУ и НУ».", СтатусСообщения.Важное);
//		Отказ = Истина;
//	КонецПопытки;
//	
//КонецПроцедуры
