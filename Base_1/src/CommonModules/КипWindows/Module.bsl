///////////////////////////////////////////////////////////////////////////////
// СЧЕТЧИКИ ПРОИЗВОДИТЕЛЬНОСТИ

// Сформировать имя счетчика производительности
//
// Параметры:
//  Компьютер - Строка, имя или IP-адрес компьютера с которого будут получаться
//              значения счетчиков производительности. Можно не указывать, если
//              значения получаются со своего компьютера
//  Объект -  Строка, имя физического компонента системы (процессор, диск, ...)
//            или объекта системы (процессы, потоки, ...)
//  Экземпляр - Строка, экземпляр объекта
//  Родитель - Строка, родительский экземпляр объекта
//  Индекс - Строка, номер экземпляра объекта, применимый если несколько
//           экземпляров одного объекта имеют одинаковое имя
//
// Возвращаемое значение:
//  Строка - полное имя счетчика производительности
//
Функция ИмяСчетчика(Объект,
                    Счетчик,
                    Компьютер = "",
                    Экземпляр = "",
                    Родитель = "",
                    Индекс = "") Экспорт
	
	ПолноеИмя = "";
	
	Если Не ПустаяСтрока(Компьютер) Тогда
		ПолноеИмя = "\\" + Компьютер;
	КонецЕсли;
	
	ПолноеИмя = ПолноеИмя + "\" + Объект;
	ЕстьРодитель = Не ПустаяСтрока(Родитель);
	ЕстьЭкземпляр = Не ПустаяСтрока(Экземпляр);
	ЕстьИндекс = Не ПустаяСтрока(Индекс);
	
	Если ЕстьРодитель Или ЕстьЭкземпляр Или ЕстьИндекс Тогда
		ПолноеИмя = ПолноеИмя + "(";
		
		Если ЕстьРодитель Тогда
			ПолноеИмя = ПолноеИмя + Родитель + "/";
		КонецЕсли;
		
		Если ЕстьЭкземпляр Тогда
			ПолноеИмя = ПолноеИмя + Экземпляр;
		КонецЕсли;
		
		Если ЕстьИндекс Тогда
			ПолноеИмя = ПолноеИмя + "#" + Индекс;
		КонецЕсли;
		
		ПолноеИмя = ПолноеИмя + ")";
	КонецЕсли;
	
	ПолноеИмя = ПолноеИмя + "\" + Счетчик;
	Возврат ПолноеИмя;
	
КонецФункции // ИмяСчетчика()

// Получить имя объекта счетчиков SQL Server
//
// Параметры:
//  ИмяСервера - Строка, полное имя сервера СУБД
//  Класс - Строка, класса объекта
//
// Возвращаемое значение:
//  Строка - имя объекта
//
Функция ИмяОбъектаСчетчиковMSSQL(ИмяСервера, Класс) Экспорт
	
	СоставИмени = КипОбщий.РазделитьСтроку(ИмяСервера, "\");
	Имя = ?(СоставИмени.Количество() > 1, "MSSQL$" + СоставИмени[1], "SQLServer");
	Возврат Имя + ":" + Класс;
	
КонецФункции // ИмяОбъектаСчетчиковMSSQL()

// Получить имя сервера из имени сервера СУБД
//
// Параметры:
//  ИмяСервера - Строка, полное имя сервера СУБД
//
// Возвращаемое значение:
//  Строка - имя компьютера, на котором запущен сервер СУБД
//
Функция ИмяСервераMSSQL(ИмяСервера) Экспорт
	
	СоставИмени = КипОбщий.РазделитьСтроку(ИмяСервера, "\");
	Возврат СоставИмени[0];
	
КонецФункции // ИмяОбъектаСчетчиковMSSQL()

// Получить полное имя счетчика количетва ожиданий на блокировках MSSQL
//
// Параметры:
//  ИмяСервера - Строка, полное имя экземпляра сервера СУБД
//
// Возвращаемое значение:
//  Строка - полное наименование показателя
//
Функция ИмяСчетчикаКоличествоОжиданийMSSQL(ПолноеИмяСервера) Экспорт
	
	Объект = ИмяОбъектаСчетчиковMSSQL(ПолноеИмяСервера, "Locks");
	ИмяСервера = ИмяСервераMSSQL(ПолноеИмяСервера);
	Возврат ИмяСчетчика(Объект, "Lock Timeouts (timeout > 0)/sec", ИмяСервера, "_Total");
	
КонецФункции // ИмяСчетчикаКоличествоОжиданийMSSQL()

// Получить полное имя счетчика количетва взаимоблокировок MSSQL
//
// Параметры:
//  ПолноеИмяСервера - Строка, полное имя экземпляра сервера СУБД
//
// Возвращаемое значение:
//  Строка - полное наименование показателя
//
Функция ИмяСчетчикаКоличествоВзаимоблокировокMSSQL(ПолноеИмяСервера) Экспорт
	
	Объект = ИмяОбъектаСчетчиковMSSQL(ПолноеИмяСервера, "Locks");
	ИмяСервера = ИмяСервераMSSQL(ПолноеИмяСервера);
	Возврат ИмяСчетчика(Объект, "Number of Deadlocks/sec", ИмяСервера, "_Total");
	
КонецФункции // ИмяСчетчикаКоличествоВзаимоблокировокMSSQL()
