
&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

&НаКлиенте
Перем УИДЗамера;

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьЗначенияСвойств(Отчет, Параметры);
	
	Если НЕ ЗначениеЗаполнено(Отчет.НачалоПериода) Тогда
		Отчет.НачалоПериода = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Отчет.КонецПериода) Тогда
		Отчет.КонецПериода  = КонецДня(ОбщегоНазначения.ТекущаяДатаПользователя());
	КонецЕсли;
	
	ПоддержкаРаботыСоСтруктурнымиПодразделениями = ПолучитьФункциональнуюОпцию("ПоддержкаРаботыСоСтруктурнымиПодразделениями");
	УчетПоВсемОрганизациям = ПользователиБКВызовСервераПовтИсп.ПолучитьЗначениеПоУмолчанию(ПользователиКлиентСервер.ТекущийПользователь(), "УчетПоВсемОрганизациям");
	
	Если НЕ ЗначениеЗаполнено(Отчет.Организация) Тогда
		Отчет.Организация = Справочники.Организации.ОрганизацияПоУмолчанию();
	КонецЕсли;
	
	//+++ ИспользоватьНесколькоКассОрганизации
	РеквизитыОрганизацииСсылка = ПроверкаРеквизитовОрганизации.СтрокаСообщенияНеЗаполненаКассаВОтчете();
	
	Если ЗначениеЗаполнено(Отчет.Организация) И Не ЗначениеЗаполнено(Отчет.Касса) Тогда
		ИспользоватьНесколькоКасс = Справочники.Кассы.ИспользуетсяНесколькоКасс(Отчет.Организация);
		Если Не ИспользоватьНесколькоКасс Тогда
			//Если у организации отключена ФО ИспользоватьНесколькоКассОрганизации и есть касса, подставляем ее, скрываем поле.
			Элементы.Касса.Видимость = Ложь;
			Отчет.Касса = ПолучитьКассуПоУмолчаниюПриОтключеннойФО();
		Иначе
			//Если ФО по организации включена, подставляем по умолчанию основную кассу, если она не назначена - оставляем поле на выбор пользователя.
			Отчет.Касса = Отчет.Организация.ОсновнаяКасса;
		КонецЕсли;
	КонецЕсли;
	//+++ ИспользоватьНесколькоКассОрганизации	
			
	Если НЕ Отчет.ПечататьВкладнойЛист И НЕ Отчет.ПечататьОтчетКассира Тогда
		Отчет.ПечататьВкладнойЛист = Истина;
	КонецЕсли;
	
	НомераДокументовПоПараметрамУчета = Истина;
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
		
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	БухгалтерскиеОтчетыКлиент.ПриОткрытии(ЭтаФорма, Отказ);
	
	Элементы.Организация.ТолькоПросмотр = НЕ УчетПоВсемОрганизациям;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	ВариантМодифицирован                    = Ложь;
	ПользовательскиеНастройкиМодифицированы = НЕ Отчет.РежимРасшифровки;
	БухгалтерскиеОтчетыКлиент.ПередЗакрытием(ЭтаФорма, Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;	
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОтменитьВыполнениеЗадания();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСохраненииПользовательскихНастроекНаСервере(Настройки)
	
	БухгалтерскиеОтчетыВызовСервера.ПриСохраненииПользовательскихНастроекНаСервере(ЭтаФорма, Настройки);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(Настройки)
	
	Если НЕ Отчет.РежимРасшифровки Тогда
		БухгалтерскиеОтчетыВызовСервера.ПриЗагрузкеПользовательскихНастроекНаСервере(ЭтаФорма, Настройки);
	КонецЕсли;
	
	//+++ ИспользоватьНесколькоКассОрганизации
	РеквизитыОрганизацииСсылка = ПроверкаРеквизитовОрганизации.СтрокаСообщенияНеЗаполненаКассаВОтчете();
	
	Если Значениезаполнено(Отчет.Организация) Тогда
		ИспользоватьНесколькоКасс = Справочники.Кассы.ИспользуетсяНесколькоКасс(Отчет.Организация);
		Если Не ИспользоватьНесколькоКасс Тогда
			//Если у организации отключена ФО ИспользоватьНесколькоКассОрганизации и есть касса, подставляем ее, скрываем поле.
			Элементы.Касса.Видимость = Ложь;
			Отчет.Касса = ПолучитьКассуПоУмолчаниюПриОтключеннойФО();
		Иначе
			//Если ФО по организации включена, подставляем по умолчанию основную кассу, если она не назначена - оставляем поле на выбор пользователя.
			Если НЕ ЗначениеЗаполнено(Отчет.Касса) Тогда
				Отчет.Касса = Отчет.Организация.ОсновнаяКасса;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	ОтобразитьПредупреждениеОЗаполненииРеквизитовКассы();
	//+++ ИспользоватьНесколькоКассОрганизации
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	БухгалтерскиеОтчетыКлиент.ОтправитьОтчетыПоПочтеОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_Организации" Тогда
		//+++ ИспользоватьНесколькоКассОрганизации
		Если Источник = Отчет.Организация Тогда
			ОбработатьИзмененияВОрганизацииНаСервере();
			Модифицированность = Истина;
		КонецЕсли;
		//--- ИспользоватьНесколькоКассОрганизации
	КонецЕсли;

КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура НачалоПериодаПриИзменении(Элемент)
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КонецПериодаПриИзменении(Элемент)
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Отчет.Организация) Тогда
		
		ОрганизацияПриИзмененииНаСервере();
		
		Если ИспользоватьНесколькоКасс Тогда
			Элементы.Касса.Видимость = Истина;
			ЗаполнитьКассуНаСервере();
		Иначе
			Элементы.Касса.Видимость = Ложь;
			Отчет.Касса = ПолучитьКассуПоУмолчаниюПриОтключеннойФО();
		КонецЕсли;
		
		ОтобразитьПредупреждениеОЗаполненииРеквизитовКассы();
		
	Иначе
		Отчет.Касса = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	ЭтаФорма.ИспользоватьНесколькоКасс = Справочники.Кассы.ИспользуетсяНесколькоКасс(Отчет.Организация);
	
КонецПроцедуры

&НаКлиенте
Процедура ПечататьВкладнойЛистПриИзменении(Элемент)
	
	Если Не Отчет.ПечататьВкладнойЛист и Не Отчет.ПечататьОтчетКассира Тогда
		Отчет.ПечататьОтчетКассира = Истина;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПечататьОтчетКассираПриИзменении(Элемент)
	
	Если Не Отчет.ПечататьВкладнойЛист и Не Отчет.ПечататьОтчетКассира Тогда
		Отчет.ПечататьВкладнойЛист = Истина;
	КонецЕсли;  	
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбораЛистаПриИзменении(Элемент)
	
	ПоказатьВыбранныйЛист();
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ПОЛЯ ТАБЛИЧНОГО ДОКУМЕНТА

&НаКлиенте
Процедура РезультатПриАктивизацииОбласти(Элемент)
	
	Если ТипЗнч(Результат.ВыделенныеОбласти) = Тип("ВыделенныеОбластиТабличногоДокумента") Тогда
		ИнтервалОжидания = ?(ПолучитьСкоростьКлиентскогоСоединения() = СкоростьКлиентскогоСоединения.Низкая, 1, 0.2);
		ПодключитьОбработчикОжидания("Подключаемый_РезультатПриАктивизацииОбластиПодключаемый", ИнтервалОжидания, Истина);
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ВыбратьПериод(Команда)
	
	ПараметрыВыбора = Новый Структура("НачалоПериода,КонецПериода", Отчет.НачалоПериода, Отчет.КонецПериода);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьПериодЗавершение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериода", ПараметрыВыбора, Элементы.ВыбратьПериод, , , , ОписаниеОповещения);

КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьНастройки(Команда)
	
	Элементы.Сформировать.КнопкаПоУмолчанию = Истина;
	ПодключитьОбработчикОжидания("Подключаемый_ЗакрытьНастройки", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьНастройки(Команда)
	
	Элементы.ПрименитьНастройки.КнопкаПоУмолчанию = Истина;
	Элементы.РазделыОтчета.ТекущаяСтраница = Элементы.НастройкиОтчета;
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьОтчет(Команда)
	
	ОчиститьСообщения();
	
	ОтключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания");
	
	УИДЗамера = ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Ложь, "Отчет ""кассовая книга"" (формирование)");
	
	РезультатВыполнения = СформироватьОтчетНаСервере();
	Если Не РезультатВыполнения.ЗаданиеВыполнено Тогда
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "ФормированиеОтчета");
	Иначе
		ЗафиксироватьДлительностьКлючевойОперации();
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("Подключаемый_ЗакрытьНастройки", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьПоЭлектроннойПочте(Команда)

	ПоказатьДиалогОтправкиПоЭлектроннойПочте();
	
КонецПроцедуры

&НаКлиенте
Процедура РеквизитыОрганизацииСсылкаОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	//+++ ИспользоватьНесколькоКассОрганизации
	ПроверкаРеквизитовОрганизацииКлиент.РеквизитыОрганизацииСсылкаОбработкаНавигационнойСсылки(отчет.Организация, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
	//--- ИспользоватьНесколькоКассОрганизации
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ВыбратьПериодЗавершение(РезультатВыбора, ДопПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ЗаполнитьЗначенияСвойств(Отчет, РезультатВыбора, "НачалоПериода,КонецПериода");
	
	ОбновитьТекстЗаголовка(ЭтаФорма); 
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьТекстЗаголовка(Форма)
	
	Отчет = Форма.Отчет;
	
	ЗаголовокОтчета = НСтр("ru = 'Кассовая книга %1'");
	ЗаголовокОтчета = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		ЗаголовокОтчета, БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(Отчет.НачалоПериода, Отчет.КонецПериода));

	Форма.Заголовок = ЗаголовокОтчета;

КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаСервере
Процедура ОтменитьВыполнениеЗадания()
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
КонецПроцедуры

&НаСервере
Процедура ВычислитьСуммуВыделенныхЯчеекТабличногоДокументаВКонтекстеНаСервере()
	
	ПолеСумма = БухгалтерскиеОтчетыВызовСервера.ВычислитьСуммуВыделенныхЯчеекТабличногоДокумента(
		Результат, КэшВыделеннойОбласти);
	
КонецПроцедуры

&НаСервере
Функция СформироватьОтчетНаСервере() Экспорт
	
	Если НЕ ПроверитьЗаполнение() Тогда 
		Возврат Новый Структура("ЗаданиеВыполнено", Истина);
	КонецЕсли;
	
	ИдентификаторЗадания = Неопределено;
	ИБФайловая = ОбщегоНазначения.ИнформационнаяБазаФайловая();
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	
	ПараметрыОтчета = ПодготовитьПараметрыОтчета();
	
	Если ИБФайловая Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		Отчеты.КассоваяКнига.СформироватьОтчет(ПараметрыОтчета, АдресХранилища);
		РезультатВыполнения = Новый Структура("ЗаданиеВыполнено", Истина);
	Иначе
		РезультатВыполнения = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор, 
			"Отчеты.КассоваяКнига.СформироватьОтчет",
			ПараметрыОтчета, 
			БухгалтерскиеОтчетыКлиентСервер.ПолучитьНаименованиеЗаданияВыполненияОтчета(ЭтаФорма));
		
		АдресХранилища       = РезультатВыполнения.АдресХранилища;
		ИдентификаторЗадания = РезультатВыполнения.ИдентификаторЗадания;
	КонецЕсли;
	
	Если РезультатВыполнения.ЗаданиеВыполнено Тогда
		ЗагрузитьПодготовленныеДанные();
	КонецЕсли;
	
	Элементы.Сформировать.КнопкаПоУмолчанию = Истина;
	
	Возврат РезультатВыполнения;
	
КонецФункции

&НаСервере
Функция ПодготовитьПараметрыОтчета()
	
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("Организация"                 , Отчет.Организация);
	ПараметрыОтчета.Вставить("Касса"                       , Отчет.Касса);
	ПараметрыОтчета.Вставить("НачалоПериода"               , Отчет.НачалоПериода);
	ПараметрыОтчета.Вставить("КонецПериода"                , Отчет.КонецПериода);
	ПараметрыОтчета.Вставить("ВыводитьОснования"           , Отчет.ВыводитьОснования);
	ПараметрыОтчета.Вставить("ВыводитьНазваниеКассы"       , Отчет.ВыводитьНазваниеКассы);
	ПараметрыОтчета.Вставить("ПересчитатьНомера"           , Отчет.ПересчитатьНомера);
	ПараметрыОтчета.Вставить("ПечататьВкладнойЛист"        , Отчет.ПечататьВкладнойЛист);
	ПараметрыОтчета.Вставить("ПечататьОтчетКассира"        , Отчет.ПечататьОтчетКассира);
	ПараметрыОтчета.Вставить("ПечататьТитульныйЛист"       , Отчет.ПечататьТитульныйЛист);
	ПараметрыОтчета.Вставить("РазбиватьЛистыПоДням"        , Отчет.РазбиватьЛистыПоДням);
	ПараметрыОтчета.Вставить("СортироватьПоВиду"           , Отчет.СортироватьПоВиду);
	ПараметрыОтчета.Вставить("СортироватьПоНомеру"         , Отчет.СортироватьПоНомеру);
	ПараметрыОтчета.Вставить("НомераДокументовПоПараметрамУчета", Отчет.НомераДокументовПоПараметрамУчета);
	ПараметрыОтчета.Вставить("РежимРасшифровки"            , Отчет.РежимРасшифровки);
	ПараметрыОтчета.Вставить("СписокСформированныхЛистов"  , Отчет.СписокСформированныхЛистов);
	ПараметрыОтчета.Вставить("ИдентификаторОтчета"         , БухгалтерскиеОтчетыКлиентСервер.ПолучитьИдентификаторОбъекта(ЭтаФорма));
	
	Возврат ПараметрыОтчета;
	
КонецФункции

&НаСервере
Процедура ЗагрузитьПодготовленныеДанные()

	ВозвращаемыеПараметры = ПолучитьИзВременногоХранилища(АдресХранилища);
	Отчет.СписокСформированныхЛистов = ВозвращаемыеПараметры;
	
	Элементы.СписокВыбораЛиста.СписокВыбора.Очистить();
	Если Отчет.СписокСформированныхЛистов.Количество() > 0 Тогда
		Для каждого Лист Из Отчет.СписокСформированныхЛистов Цикл
			Элементы.СписокВыбораЛиста.СписокВыбора.Добавить(Лист.Представление);
		КонецЦикла;
		
		СписокВыбораЛиста = Отчет.СписокСформированныхЛистов.Получить(0).Представление;
		Элементы.СписокВыбораЛиста.Видимость = Истина;
		
	КонецЕсли;
	
	ПоказатьВыбранныйЛист();
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РезультатПриАктивизацииОбластиПодключаемый()
	
	НеобходимоВычислятьНаСервере = Ложь;
	БухгалтерскиеОтчетыКлиент.ВычислитьСуммуВыделенныхЯчеекТабличногоДокумента(
		ПолеСумма, Результат, КэшВыделеннойОбласти, НеобходимоВычислятьНаСервере);
	
	Если НеобходимоВычислятьНаСервере Тогда
		ВычислитьСуммуВыделенныхЯчеекТабличногоДокументаВКонтекстеНаСервере();
	КонецЕсли;
	
	ОтключитьОбработчикОжидания("Подключаемый_РезультатПриАктивизацииОбластиПодключаемый");
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ЗакрытьНастройки()
	
	Элементы.РазделыОтчета.ТекущаяСтраница = Элементы.Отчет;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Попытка
		Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда 

			ЗагрузитьПодготовленныеДанные();
			ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
		    ЗафиксироватьДлительностьКлючевойОперации();
		Иначе
			ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			ПодключитьОбработчикОжидания(
				"Подключаемый_ПроверитьВыполнениеЗадания", 
				ПараметрыОбработчикаОжидания.ТекущийИнтервал, 
				Истина);
		КонецЕсли;
	Исключение
		УИДЗамера = Неопределено;
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьКассуНаСервере()

	Отчет.Касса = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Отчет.Организация, "ОсновнаяКасса");
	
КонецПроцедуры

&НаСервере
Процедура ПоказатьВыбранныйЛист()
	
	Результат.Очистить();
	Результат.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_КассоваяКнига";
	
	ИндексСформированногоЛиста = ПолучитьИндексСформированногоЛиста(СписокВыбораЛиста, Отчет.СписокСформированныхЛистов);
	
	Если ИндексСформированногоЛиста <> Неопределено Тогда
		СформированныйЛист = Отчет.СписокСформированныхЛистов.Получить(ИндексСформированногоЛиста).Значение;
		Результат.Вывести(СформированныйЛист);
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьИндексСформированногоЛиста(ИмяЛиста, СписокСформированныхЛистов)
	
	Если ИмяЛиста = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Для каждого Лист Из СписокСформированныхЛистов Цикл
		Если Лист.Представление = ИмяЛиста Тогда
			Возврат СписокСформированныхЛистов.Индекс(Лист);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

&НаКлиенте
Процедура ПоказатьДиалогОтправкиПоЭлектроннойПочте()
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ОтправитьОтчетыПоПочтеНастройкаУчетнойЗаписиПредложена", БухгалтерскиеОтчетыКлиент, ЭтотОбъект);

	РаботаСПочтовымиСообщениямиКлиент.ПроверитьНаличиеУчетнойЗаписиДляОтправкиПочты(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗафиксироватьДлительностьКлючевойОперации()
	
	ОценкаПроизводительностиКлиент.ЗавершитьЗамерВремени(УИДЗамера);
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьИзмененияВОрганизацииНаСервере()
	
	//+++ ИспользоватьНесколькоКассОрганизации
	ИспользоватьНесколькоКасс = Справочники.Кассы.ИспользуетсяНесколькоКасс(Отчет.Организация);
		
	Если НЕ ИспользоватьНесколькоКасс И Не ЗначениеЗаполнено(Отчет.Касса) Тогда
		Отчет.Касса = Справочники.Кассы.ПолучитьКассуПоУмолчаниюПриОтключеннойОпцииИспользоватьНесколькоКасс(Отчет.Организация);
	ИначеЕсли ИспользоватьНесколькоКасс Тогда
		Отчет.Касса = Отчет.Организация.ОсновнаяКасса;
		Элементы.Касса.Видимость = Истина;
	КонецЕсли;
	
	ОтобразитьПредупреждениеОЗаполненииРеквизитовКассы();
	//--- ИспользоватьНесколькоКассОрганизации

КонецПроцедуры

&НаСервере
Процедура ОтобразитьПредупреждениеОЗаполненииРеквизитовКассы()
	
	ПроверкаРеквизитовОрганизации.ОтобразитьПредупреждениеОЗаполненииРеквизитовКассыВОтчете(ЭтотОбъект, Отчет);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьКассуПоУмолчаниюПриОтключеннойФО()
	
	Возврат Справочники.Кассы.ПолучитьКассуПоУмолчаниюПриОтключеннойОпцииИспользоватьНесколькоКасс(Отчет.Организация);
	
КонецФункции