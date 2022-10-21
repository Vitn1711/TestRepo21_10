#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	ЗаполнитьТаблицуАктуализации();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ЭтаФорма.КлючУникальности = Источник И Параметр <> Неопределено Тогда
		
		Если ИмяСобытия = "АктуализацияТНВЭД_ПроверятьОповещенияФоновогоЗадания" Тогда
			
			РезультатРаботыЗадания = Параметр;
			
			Если РезультатРаботыЗадания.ЗаданиеВыполнено Тогда
				
				АдресСообщенияПользователю = ЭСФВызовСервера.СообщенияФоновогоЗадания(РезультатРаботыЗадания.ИдентификаторЗадания);
				СообщенияПользователю = ПолучитьИзВременногоХранилища(АдресСообщенияПользователю);
				Если СообщенияПользователю <> Неопределено Тогда
					Для каждого СообщениеФоновогоЗадания Из СообщенияПользователю Цикл
						СообщениеФоновогоЗадания.Сообщить();
					КонецЦикла;
				КонецЕсли;
				
				Оповестить("АктуализацияТНВЭД_Выполнена", Параметр, ЭтаФорма.КлючУникальности);
			Иначе
			
				ПараметрыДлительнойОперации = Новый Структура;
				ПараметрыДлительнойОперации.Вставить("ИдентификаторЗадания");
				ПараметрыДлительнойОперации.Вставить("ВыводитьОкноОжидания", Истина);
				ПараметрыДлительнойОперации.Вставить("АдресРезультата", РезультатРаботыЗадания.АдресХранилища);
				ПараметрыДлительнойОперации.Вставить("ВыводитьСообщения", Истина);
				
				Если РезультатРаботыЗадания.Свойство("ТекстСообщения") Тогда
					ПараметрыДлительнойОперации.Вставить("ТекстСообщения", РезультатРаботыЗадания.ТекстСообщения);
				КонецЕсли;
				
				ПараметрыДлительнойОперации.ИдентификаторЗадания = РезультатРаботыЗадания.ИдентификаторЗадания;
				
				ОписаниеОповещения = Новый ОписаниеОповещения("ОповеститьОЗавершениияДлительнойОперации_АктуализацияТНВЭД", ЭтотОбъект, ЭтаФорма);
				
				ОткрытьФорму("Обработка.ОбменЭСФ.Форма.ДлительнаяОперация", ПараметрыДлительнойОперации, ЭтаФорма,,,, ОписаниеОповещения);
				
			КонецЕсли;
			
		ИначеЕсли ИмяСобытия = "АктуализацияТНВЭД_Выполнена" Тогда
			
			ЗаполнитьТаблицуАктуализацииИзХранилища(Параметр.АдресХранилища);
			
			Если ТаблицаАктуализации.Количество() > 0 Тогда
				
				Сообщить("Актуализация кодов ТН ВЭД проведена не для всех элементов номенклатуры!", СтатусСообщения.Внимание);
				
			КонецЕсли;
			
		ИначеЕсли ИмяСобытия = "ЗаполнениеТаблицыАктуализацииТНВЭД_ПроверятьОповещенияФоновогоЗадания" Тогда
			
			РезультатРаботыЗадания = Параметр;
			
			Если РезультатРаботыЗадания.ЗаданиеВыполнено Тогда
				
				АдресСообщенияПользователю = ЭСФВызовСервера.СообщенияФоновогоЗадания(РезультатРаботыЗадания.ИдентификаторЗадания);
				СообщенияПользователю = ПолучитьИзВременногоХранилища(АдресСообщенияПользователю);
				Если СообщенияПользователю <> Неопределено Тогда
					Для каждого СообщениеФоновогоЗадания Из СообщенияПользователю Цикл
						СообщениеФоновогоЗадания.Сообщить();
					КонецЦикла;
				КонецЕсли;
				
				Оповестить("ЗаполнениеТаблицыАктуализацииТНВЭД_Выполнена", Параметр, ЭтаФорма.КлючУникальности);
			Иначе
			
				ПараметрыДлительнойОперации = Новый Структура;
				ПараметрыДлительнойОперации.Вставить("ИдентификаторЗадания");
				ПараметрыДлительнойОперации.Вставить("ВыводитьОкноОжидания", Истина);
				ПараметрыДлительнойОперации.Вставить("АдресРезультата", РезультатРаботыЗадания.АдресХранилища);
				ПараметрыДлительнойОперации.Вставить("ВыводитьСообщения", Истина);
				
				Если РезультатРаботыЗадания.Свойство("ТекстСообщения") Тогда
					ПараметрыДлительнойОперации.Вставить("ТекстСообщения", РезультатРаботыЗадания.ТекстСообщения);
				КонецЕсли;
				
				ПараметрыДлительнойОперации.ИдентификаторЗадания = РезультатРаботыЗадания.ИдентификаторЗадания;
				
				ОписаниеОповещения = Новый ОписаниеОповещения("ОповеститьОЗавершениияДлительнойОперации_ЗаполнениеТаблицыАктуализацииТНВЭД", ЭтотОбъект, ЭтаФорма);
				
				ОткрытьФорму("Обработка.ОбменЭСФ.Форма.ДлительнаяОперация", ПараметрыДлительнойОперации, ЭтаФорма,,,, ОписаниеОповещения);
				
			КонецЕсли;
			
		ИначеЕсли ИмяСобытия = "ЗаполнениеТаблицыАктуализацииТНВЭД_Выполнена" Тогда
			
			ЗаполнитьТаблицуАктуализацииИзХранилища(Параметр.АдресХранилища);
			
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Актуализировать(Команда)
	
	ПараметрыВыполнения = ЭСФКлиентСерверПереопределяемый.ПараметрыВыполненияВФоне();
	
	Результат = АктуализироватьВФоне(ПараметрыВыполнения);						
	
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		Результат.Вставить("ТекстСообщения", НСтр("ru = 'Актуализация кодов ТН ВЭД номенклатуры.'"));
	КонецЕсли;
	
	ЭСФКлиент.ОповеститьФормы("АктуализацияТНВЭД_ПроверятьОповещенияФоновогоЗадания", Результат, КлючУникальности);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияРезервнаяКопияНажатие(Элемент)
	
	ОткрытьФорму("Обработка.РезервноеКопированиеИБ.Форма", Неопределено);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийДереваНоменклатуры

&НаКлиенте
Процедура ДеревоПриАктивизацииСтроки(Элемент)
	
	Если Элемент.ТекущиеДанные = Неопределено Или Элемент.ТекущиеДанные.Ссылка.Пустая() Тогда
		
		Элементы.ТаблицаАктуализации.ОтборСтрок = Неопределено;
		
	Иначе
		
		Элементы.ТаблицаАктуализации.ОтборСтрок = Новый ФиксированнаяСтруктура("Родитель", Элемент.ТекущиеДанные.Ссылка);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыАктуализации

&НаКлиенте
Процедура ОбновитьТаблицу(Команда)
	
	Если Вопрос("Значения колонки ""Новый код ТН ВЭД"" будут перезаполнены. Продолжить?", РежимДиалогаВопрос.ДаНет, , , ) = КодВозвратаДиалога.Да Тогда
		ЗаполнитьТаблицуАктуализации();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПометки(Команда)
	УправлениеПометками(Истина);
КонецПроцедуры

&НаКлиенте
Процедура СнятьПометки(Команда)
	УправлениеПометками(Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ИнвертироватьПометки(Команда)
	УправлениеПометками();
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаАктуализацииНоменклатураГСВСНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаАктуализацииНоменклатураНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗаполнитьТаблицуАктуализации()

	ПараметрыВыполнения = ЭСФКлиентСерверПереопределяемый.ПараметрыВыполненияВФоне();
	
	Результат = ЗаполнитьТаблицуАктуализацииВФоне(ПараметрыВыполнения);						
	
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		Результат.Вставить("ТекстСообщения", НСтр("ru = 'Заполнение таблицы актуализации кодов ТН ВЭД.'"));
	КонецЕсли;
	
	ЭСФКлиент.ОповеститьФормы("ЗаполнениеТаблицыАктуализацииТНВЭД_ПроверятьОповещенияФоновогоЗадания", Результат, КлючУникальности);
	
КонецПроцедуры

&НаСервере
Функция АктуализироватьВФоне(ПараметрыВыполнения)
	
	КлючФоновогоЗадания = Новый УникальныйИдентификатор;		
	
	ПараметрыВыполнения.КлючФоновогоЗадания = КлючФоновогоЗадания;
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Актуализация кодов ТН ВЭД номенклатуры'");
			    
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("ТаблицаАктуализации", ТаблицаАктуализации.Выгрузить(, "Номенклатура, ТекущийКодТНВЭД, НовыйКодТНВЭД, НоменклатураГСВС, Пометка, Родитель"));  
	ПараметрыПроцедуры.Вставить("КлючФоновогоЗадания", КлючФоновогоЗадания);
	
	Возврат ЭСФСерверПереопределяемый.ВыполнитьВФоне("ЭСФСерверПереопределяемый.АктуализироватьКодыТНВЭДВФоне", ПараметрыПроцедуры, ПараметрыВыполнения);
	
КонецФункции

&НаСервере
Функция ЗаполнитьТаблицуАктуализацииВФоне(ПараметрыВыполнения)
	
	КлючФоновогоЗадания = Новый УникальныйИдентификатор;		
	
	ПараметрыВыполнения.КлючФоновогоЗадания = КлючФоновогоЗадания;
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Заполнение таблицы актуализации кодов ТН ВЭД'");
			    
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("ДатаАктуальности", ТекущаяДатаСеанса());
	ПараметрыПроцедуры.Вставить("КлючФоновогоЗадания", КлючФоновогоЗадания);
	
	Возврат ЭСФСерверПереопределяемый.ВыполнитьВФоне("ЭСФСерверПереопределяемый.ПолучитьСписокНоменклатурыДляАктуализации", ПараметрыПроцедуры, ПараметрыВыполнения);
	
КонецФункции

&НаКлиенте
Процедура ОповеститьОЗавершениияДлительнойОперации_АктуализацияТНВЭД(Результат, Источник) Экспорт

	Оповестить("АктуализацияТНВЭД_Выполнена", Результат, Источник.КлючУникальности);
	
КонецПроцедуры

&НаКлиенте
Процедура ОповеститьОЗавершениияДлительнойОперации_ЗаполнениеТаблицыАктуализацииТНВЭД(Результат, Источник) Экспорт

	Оповестить("ЗаполнениеТаблицыАктуализацииТНВЭД_Выполнена", Результат, Источник.КлючУникальности);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуАктуализацииИзХранилища(Знач АдресХранилища)
	ТаблицаАктуализации.Загрузить(ПолучитьИзВременногоХранилища(АдресХранилища));
КонецПроцедуры	

&НаКлиенте
Процедура УправлениеПометками(Значение = Неопределено)
	Для Каждого ТекСтрока Из ТаблицаАктуализации Цикл
		ТекСтрока.Пометка = ?(Значение = Неопределено, Не ТекСтрока.Пометка, Значение);
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

