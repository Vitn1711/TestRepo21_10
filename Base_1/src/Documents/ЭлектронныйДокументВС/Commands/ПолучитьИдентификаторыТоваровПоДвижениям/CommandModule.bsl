
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗапускатьФоновоеЗадание", ЭСФКлиентСерверПереопределяемый.ИспользоватьФоновуюОтправкуЭСФ());
	ПараметрыФормы.Вставить("РежимЗапуска", "ПолучениеИДТоваров");
	
	ОткрытьФорму("Обработка.ОбменЭСФ.Форма.СинхронизацияСВС", ПараметрыФормы, , "ФормаПолученияИД");

КонецПроцедуры
