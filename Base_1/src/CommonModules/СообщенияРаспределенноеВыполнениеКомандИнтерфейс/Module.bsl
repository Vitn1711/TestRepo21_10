////////////////////////////////////////////////////////////////////////////////
// РаспределенноеВыполнениеКомандИнтерфейс: описание программного интерфейса
// подсистемы РаспределенноеВыполнениеКоманд. Используется в обмене сообщениями.
////////////////////////////////////////////////////////////////////////////////

// Экспортные процедуры и функции для вызова из других подсистем
// 
#Область ПрограммныйИнтерфейс

// Возвращает номер текущей версии программного интерфейса.
//
// Возвращаемое значение:
//   Строка   - Номер версии интерфейса
//
Функция Версия() Экспорт

	Возврат СообщенияРаспределенноеВыполнениеКомандОбработчикСообщения_1_0_2_1.Версия();

КонецФункции // Версия() 

// Возвращает пространство имен текущей (используемой вызывающим кодом) версии интерфейса сообщений.
//
// Возвращаемое значение:
//   Строка   - Пространство имен интерфейса
//
Функция Пакет() Экспорт

	Возврат СообщенияРаспределенноеВыполнениеКомандОбработчикСообщения_1_0_2_1.Пакет();
	
КонецФункции // Пакет() 

// Возвращает название программного интерфейса сообщений.
//
// Возвращаемое значение:
//   Строка   - Имя интерфейса
//
Функция ПрограммныйИнтерфейс() Экспорт

	Возврат "RemoteProcedureCall";

КонецФункции // ПрограммныйИнтерфейс() 

// Возвращает тип сообщения RemoteCall
// http://www.1c.ru/1cFresh/Automation/RemoteProcedureCall/v{x}/RemoteCall
//
// Параметры:
//	Пакет - Строка - Пространство имен (если не указан, используется текущий) 
//
Функция ТипПрямойВызов(Пакет = Неопределено) Экспорт

	Возврат СоздатьТипСообщения("RemoteCall", Пакет);	

КонецФункции // ТипПрямойВызов() 

// Возвращает тип сообщения CallBack
// http://www.1c.ru/1cFresh/Automation/RemoteProcedureCall/v{x}/CallBack
//
// Параметры:
//	Пакет - Строка - Пространство имен (если не указан, используется текущий) 
//
Функция ТипОбратныйВызов(Пакет = Неопределено) Экспорт

	Возврат СоздатьТипСообщения("CallBack", Пакет);	

КонецФункции // ТипОбратныйВызов()

// Возвращает тип сообщения FileTransferRequest
// http://www.1c.ru/1cFresh/Automation/RemoteProcedureCall/v{x}/FileTransferRequest
//
// Параметры:
//	Пакет - Строка - Пространство имен (если не указан, используется текущий) 
//
Функция ТипПередачаФайлаЗапрос(Пакет = Неопределено) Экспорт

	Возврат СоздатьТипСообщения("FileTransferRequest", Пакет);	

КонецФункции // ТипОбратныйВызов()

// Возвращает тип сообщения FileTransferResponse
// http://www.1c.ru/1cFresh/Automation/RemoteProcedureCall/v{x}/FileTransferResponse
//
// Параметры:
//	Пакет - Строка - Пространство имен (если не указан, используется текущий) 
//
Функция ТипПередачаФайлаОтвет(Пакет = Неопределено) Экспорт

	Возврат СоздатьТипСообщения("FileTransferResponse", Пакет);	

КонецФункции // ТипОбратныйВызов()

// Выполняет регистрацию обработчиков сообщений в качестве обработчиков каналов обмена сообщениями.
//
// Параметры:
//	МассивОбработчиков - Массив - Обработчики каналов. 
//
Процедура ОбработчикиКаналовСообщений(МассивОбработчиков) Экспорт
	
	МассивОбработчиков.Добавить(СообщенияРаспределенноеВыполнениеКомандОбработчикСообщения_1_0_1_1);
	МассивОбработчиков.Добавить(СообщенияРаспределенноеВыполнениеКомандОбработчикСообщения_1_0_2_1);
	
КонецПроцедуры

// Выполняет регистрацию обработчиков трансляции сообщений.
//
// Параметры:
//	МассивОбработчиков - Массив - Обработчики каналов.
//
Процедура ОбработчикиТрансляцииСообщений(МассивОбработчиков) Экспорт

	МассивОбработчиков.Добавить(СообщенияРаспределенноеВыполнениеКомандОбработчикТрансляции_1_0_2_1);
	
КонецПроцедуры

#КонецОбласти  

// Служебные и вспомогательные процедуры и функции, для вызова только из самого модуля
// 
#Область СлужебныеФункции

// Возвращает тип XDTO-пакета по его имени
//
// Параметры:
//	Пакет - Строка - Пространство имен (если не указан, используется текущий) 
//	ИмяТипа - Строка - Необходимый тип 
//
// Возвращаемое значение:
//   ТипОбъектаXDTO	- сформированный тип
//
Функция СоздатьТипСообщения(ИмяТипа, Пакет = Неопределено)

	Возврат ФабрикаXDTO.Тип(?(Пакет = Неопределено, Пакет(), Пакет), ИмяТипа);

КонецФункции // СоздатьТипСообщения()

#КонецОбласти  