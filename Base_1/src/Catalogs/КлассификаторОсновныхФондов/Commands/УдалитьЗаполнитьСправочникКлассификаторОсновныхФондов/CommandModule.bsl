
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОбработкаПрерыванияПользователя();
	
	ТекстСостояние = НСтр("ru='Выполняется заполнение справочника. Это может занять некоторое время. Пожалуйста, подождите.'");

	Состояние(ТекстСостояние);

	ЗаполнитьКлассификатор();
	
	ТекстСообщения = НСтр("ru='Заполнение справочника завершено'");
	
	ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,,,,);

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаСервере
Процедура ЗаполнитьКлассификатор() 
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Справочник.КлассификаторОсновныхФондов.ПФ_MXL_КлассификаторОсновныхФондов");
	Область = Макет.Области["Строки"];
	
	Для Ном = Область.Верх По Область.Низ Цикл
		// возможность прерывания загрузки для пользователя
				
		КодСтроки    	   = СокрЛП(Макет.Область(Ном, 1).Текст);
		НаименованиеСтроки = СокрЛП(Макет.Область(Ном, 2).Текст);
		ЗаписатьЭлементСправочника(КодСтроки, НаименованиеСтроки);				
		
	КонецЦикла;
	
КонецПроцедуры	// ЗаполнитьКлассификатор()

&НаСервере
// Возвращает код родительского элемента
// по классификатору КОФ
Функция ПолучитьКодРодителя(КодЭлемента)
	// получаем значимый код
	ЧисловойКод = Число(СтрЗаменить(КодЭлемента, ".",""));
	Если ЧисловойКод%100000000 = 0 Тогда 			// Х00. 000000  это раздел
		КодРодителя = "";
	ИначеЕсли ЧисловойКод%10000000 = 0 Тогда 		// ХХ0. 000000  это подраздел
		КодРодителя = Лев(КодЭлемента,1) + "00.000000"  ;
	ИначеЕсли ЧисловойКод%1000000 = 0 Тогда 		// ХХХ.000000   это группа
		КодРодителя = Лев(КодЭлемента,2) + "0.000000"  ;
	ИначеЕсли ЧисловойКод%100 = 0 Тогда 			// ХХХ. ХХХХ00 	это класс
		КодРодителя = Лев(КодЭлемента,3) + ".000000"  ;
	Иначе										 	// ХХХ. ХХХХХХ 	это вид
		КодРодителя = Лев(КодЭлемента,8) + "00" ;
	КонецЕсли;	        		
	
	Возврат КодРодителя;	
КонецФункции // ПолучитьКодРодителя(КодЭлемента)

&НаСервере
// Возвращает ссылку на родительский элемент
// справочника "классификаторОсновныхФондов"
Функция ПолучитьЭлементРодитель(КодЭлемента, НаименованиеДочернегоЭлемента);
	
	КодРодителя = ПолучитьКодРодителя(КодЭлемента);
	// для элементов первого уровня родителя нет
	Если НЕ ЗначениеЗаполнено(КодРодителя) ТОгда
		Возврат Справочники.КлассификаторОсновныхФондов.ПустаяСсылка();
	КонецЕсли;	
	
	НайденнаяСсылка =  Справочники.КлассификаторОсновныхФондов.НайтиПоРеквизиту("КодКОФ", КодРодителя);
	Если НайденнаяСсылка.Пустая() Тогда
		// создаем элемент-родитель
		НайденнаяСсылка = ЗаписатьЭлементСправочника(КодРодителя, НаименованиеДочернегоЭлемента);				
	КонецЕсли;	
	
	Возврат НайденнаяСсылка;
КонецФункции //ПолучитьЭлементРодитель(КодЭлемента, НаименованиеДочернегоЭлемента)	

&НаСервере
// Записывает текущиц элемент классификатор с учетом
// иерархии 
Функция ЗаписатьЭлементСправочника(КодЭлемента, НаименованиеЭлемента)	
	НайденнаяСсылка =  Справочники.КлассификаторОсновныхФондов.НайтиПоРеквизиту("КодКОФ", КодЭлемента);
	Если НайденнаяСсылка.Пустая() Тогда
		Объект = Справочники.КлассификаторОсновныхФондов.СоздатьЭлемент();
		Объект.КодКОФ = КодЭлемента;
	Иначе
		Объект = НайденнаяСсылка.ПолучитьОбъект();
	КонецЕсли;	
	
	Объект.Наименование = НаименованиеЭлемента;
	// рекурсивное создание элементов-родителей, в случае, если они не были созданы ранее
	Объект.Родитель = ПолучитьЭлементРодитель(КодЭлемента, НаименованиеЭлемента);
	Попытка
		Объект.Записать();
	Исключение
		
		ТекстСообщения = НСтр("ru='Не удалось записать элемент: " + КодЭлемента + " "+  НаименованиеЭлемента + Символы.ПС + ОписаниеОшибки()+"'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,,,);

	КонецПопытки;
		
	Возврат Объект.Ссылка;
	
КонецФункции // ЗаписатьЭлементСправочника
