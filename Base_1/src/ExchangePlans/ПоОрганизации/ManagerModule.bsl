#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

// Заполняет настройки, влияющие на использование плана обмена.
// 
// Параметры:
//  Настройки - Структура - настройки плана обмена по умолчанию, см. ОбменДаннымиСервер.НастройкиПланаОбменаПоУмолчанию,
//                          описание возвращаемого значения функции.
//
Процедура ПриПолученииНастроек(НастройкиПланаОбмена) Экспорт
	
	НастройкиПланаОбмена.ПланОбменаИспользуетсяВМоделиСервиса = Ложь;
	
	НастройкиПланаОбмена.НазначениеПланаОбмена = "РИБСФильтром";
	
	НастройкиПланаОбмена.Алгоритмы.ПриПолученииОписанияВариантаНастройки = Истина;
	НастройкиПланаОбмена.Алгоритмы.ОписаниеОграниченийПередачиДанных     = Истина;

КонецПроцедуры

// Заполняет набор параметров, определяющих вариант настройки обмена.
// 
// Параметры:
//  ОписаниеВарианта       - Структура - набор варианта настройки по умолчанию,
//                                       см. ОбменДаннымиСервер.ОписаниеВариантаНастройкиОбменаПоУмолчанию,
//                                       описание возвращаемого значения.
//  ИдентификаторНастройки - Строка    - идентификатор варианта настройки обмена.
//  ПараметрыКонтекста     - Структура - см. ОбменДаннымиСервер.ПараметрыКонтекстаПолученияОписанияВариантаНастройки,
//                                       описание возвращаемого значения функции.
//
Процедура ПриПолученииОписанияВариантаНастройки(ОписаниеВарианта, ИдентификаторНастройки, ПараметрыКонтекста) Экспорт
	
	КраткаяИнформацияПоОбмену = НСтр("ru = 'Распределенная информационная база представляет собой иерархическую структуру, состоящую из отдельных информационных 
	|баз системы «1С:Предприятие» — узлов распределенной информационной базы, между которыми организована синхронизация 
	|конфигурации и данных. Главной особенностью распределенных информационных баз является передача изменений 
	|конфигурации в подчиненные узлы.
	|Необходимо указать ограничения миграции данных по организациям.'");
	КраткаяИнформацияПоОбмену = СтрЗаменить(КраткаяИнформацияПоОбмену, Символы.ПС, "");
	
	ОписаниеВарианта.КраткаяИнформацияПоОбмену   = КраткаяИнформацияПоОбмену;
	ОписаниеВарианта.ПодробнаяИнформацияПоОбмену = "ПланОбмена.ПоОрганизации.Форма.ПодробнаяИнформация";;
	
	ОписаниеВарианта.ИспользуемыеТранспортыСообщенийОбмена = ОбменДаннымиСервер.ВсеТранспортыСообщенийОбменаКонфигурации();
	
	ОписаниеВарианта.ИмяФайлаНастроекДляПриемника = НСтр("ru = 'Настройки обмена распределенной информационной базы'");
	
	ОписаниеВарианта.ЗаголовокКомандыДляСозданияНовогоОбменаДанными = НСтр("ru = 'По организации (Распределенная информационная база с фильтром по организации)'");
	
	ОписаниеВарианта.ИмяФормыСозданияНачальногоОбраза = "ОбщаяФорма.СозданиеНачальногоОбразаСФайлами";
	
	// Отборы
	
	СтруктураТабличнойЧастиОрганизации = Новый Структура;
	СтруктураТабличнойЧастиОрганизации.Вставить("Организация", Новый Массив);
	
	СтруктураНастроек = Новый Структура;
	СтруктураНастроек.Вставить("Организации",СтруктураТабличнойЧастиОрганизации);
	
	ОписаниеВарианта.Отборы = СтруктураНастроек;
	
КонецПроцедуры

// Позволяет переопределить настройки плана обмена, заданные по умолчанию.
// Значения настроек по умолчанию см. в ОбменДаннымиСервер.НастройкиПланаОбменаПоУмолчанию.
// 
// Параметры:
//	Настройки - Структура - Содержит настройки по умолчанию.
//
Процедура ОпределитьНастройки(Настройки, ИдентификаторНастройки) Экспорт

КонецПроцедуры

// Возвращает структуру значений по умолчению для узла;
// Структура настроек повторяет состав реквизитов шапки плана обмена;
// Для реквизитов шапки используются аналогичные по ключу и значению элементы структуры.
// 
// Параметры:
//  Нет.
// 
// Возвращаемое значение:
//  СтруктураНастроек - Структура - структура значений по умолчанию на узле плана обмена
// 
Функция ЗначенияПоУмолчаниюНаУзле(ВерсияКорреспондента, ИмяФорм, ИдентификаторНастройки) Экспорт
	
	Возврат Новый Структура;
	
КонецФункции

// Возвращает структуру значений по умолчению для узла базы корреспондента;
// Структура настроек повторяет состав реквизитов шапки плана обмена базы корреспондента;
// Для реквизитов шапки используются аналогичные по ключу и значению элементы структуры.
// 
// Параметры:
//  Нет.
// 
// Возвращаемое значение:
//  СтруктураНастроек - Структура - структура значений по умолчанию на узле плана обмена базы корреспондента
//
Функция ЗначенияПоУмолчаниюНаУзлеБазыКорреспондента(ВерсияКорреспондента, ИмяФормы, ИдентификаторНастройки) Экспорт
	
	Возврат Новый Структура;
	
КонецФункции

// Возвращает имя файла настроек по умолчанию;
// В этот файл будут выгружены настройки обмена для приемника;
// Это значение должно быть одинаковым в плане обмена источника и приемника.
// 
// Параметры:
//  Нет.
// 
// Возвращаемое значение:
//  Строка, 255 - имя файла по умолчанию для выгрузки настроек обмена данными
//
Функция ИмяФайлаНастроекДляПриемника() Экспорт
	
	Возврат НСтр("ru = 'Настройки обмена распределенной информационной базы'");
	
КонецФункции

// Возвращает массив используемых транспортов сообщений для этого плана обмена
//
// 1. Например, если план обмена поддерживает только два транспорта сообщений FILE и FTP,
// то тело функции следует определить следующим образом:
//
//	Результат = Новый Массив;
//	Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FILE);
//	Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FTP);
//	Возврат Результат;
//
// 2. Например, если план обмена поддерживает все транспорты сообщений, определенных в конфигурации,
// то тело функции следует определить следующим образом:
//
//	Возврат ОбменДаннымиСервер.ВсеТранспортыСообщенийОбменаКонфигурации();
//
// Возвращаемое значение:
//  Массив - массив содержит значения перечисления ВидыТранспортаСообщенийОбмена
//
Функция ИспользуемыеТранспортыСообщенийОбмена() Экспорт
	
	Возврат ОбменДаннымиСервер.ВсеТранспортыСообщенийОбменаКонфигурации();
	
КонецФункции

// Возвращает пользовательскую форму для создания начального образа базы.
// Эта форма будет открыта после завершения настройки обмена с помощью помощника.
//
// Возвращаемое значение:
//  Строка, Неогранич - имя формы
//
// Например:
//	Возврат "ПланОбмена.ОбменВРаспределеннойИнформационнойБазе.Форма.ФормаСозданияНачальногоОбраза";
//
Функция ИмяФормыСозданияНачальногоОбраза() Экспорт
	
	Возврат "ОбщаяФорма.СозданиеНачальногоОбразаСФайлами";
	
КонецФункции

// Определяет, будет ли использоваться помощник для создания новых узлов плана обмена.
//
// Возвращаемое значение:
//  Булево - признак использования помощника.
//
Функция ИспользоватьПомощникСозданияОбменаДанными() Экспорт
	
	Возврат Истина;
	
КонецФункции

// Возвращает структуру отборов на узле плана обмена с установленными значениями по умолчанию;
// Структура настроек повторяет состав реквизитов шапки и табличных частей плана обмена;
// Для реквизитов шапки используются аналогичные по ключу и значению элементы структуры,
// а для табличных частей используются структуры,
// содержащие массивы значений полей табличных частей плана обмена.
// 
// Параметры:
//  Нет.
// 
// Возвращаемое значение:
//  СтруктураНастроек - Структура - структура отборов на узле плана обмена
// 
Функция НастройкаОтборовНаУзле(ВерсияКорреспондента, ИмяФормы, ИдентификаторНастройки) Экспорт
	
	СтруктураТабличнойЧастиОрганизации = Новый Структура;
	СтруктураТабличнойЧастиОрганизации.Вставить("Организация", Новый Массив);
	
	СтруктураНастроек = Новый Структура;
	СтруктураНастроек.Вставить("Организации",СтруктураТабличнойЧастиОрганизации);
	
	Возврат СтруктураНастроек;
	
КонецФункции

// Возвращает структуру отборов на узле плана обмена базы корреспондента с установленными значениями по умолчанию;
// Структура настроек повторяет состав реквизитов шапки и табличных частей плана обмена базы корреспондента;
// Для реквизитов шапки используются аналогичные по ключу и значению элементы структуры,
// а для табличных частей используются структуры,
// содержащие массивы значений полей табличных частей плана обмена.
// 
// Параметры:
//  Нет.
// 
// Возвращаемое значение:
//  СтруктураНастроек - Структура - структура отборов на узле плана обмена базы корреспондента
// 
Функция НастройкаОтборовНаУзлеБазыКорреспондента(ВерсияКорреспондента, ИмяФормы, ИдентификаторНастройки) Экспорт
	
	Возврат Новый Структура;
	
КонецФункции

Функция ОписаниеЗначениеПоУмолчанию() Экспорт 
	
	Возврат ".";
	
КонецФункции

// Возвращает строку описания значений по умолчанию для базы корреспондента, которая отображается пользователю;
// Прикладной разработчик на основе установленных значений по умолчанию на узле базы корреспондента должен сформировать строку описания 
// удобную для восприятия пользователем.
// 
// Параметры:
//  ЗначенияПоУмолчаниюНаУзле - Структура - структура значений по умолчанию на узле плана обмена базы корреспондента,
//                                       полученная при помощи функции ЗначенияПоУмолчаниюНаУзлеБазыКорреспондента().
// 
// Возвращаемое значение:
//  Строка, Неогранич. - строка описания для пользователя значений по умолчанию
//
Функция ОписаниеЗначенийПоУмолчаниюБазыКорреспондента(ЗначенияПоУмолчаниюНаУзле, ВерсияКорреспондента, ИдентификаторНастройки) Экспорт
	
	Возврат "";
	
КонецФункции

// Возвращает строку описания ограничений миграции данных для базы корреспондента, которая отображается пользователю;
// Прикладной разработчик на основе установленных отборов на узле базы корреспондента должен сформировать строку описания ограничений 
// удобную для восприятия пользователем.
// 
// Параметры:
//  НастройкаОтборовНаУзле - Структура - структура отборов на узле плана обмена базы корреспондента,
//                                       полученная при помощи функции НастройкаОтборовНаУзлеБазыКорреспондента().
// 
// Возвращаемое значение:
//  Строка, Неогранич. - строка описания ограничений миграции данных для пользователя
//
Функция ОписаниеОграниченийПередачиДанныхБазыКорреспондента(НастройкаОтборовНаУзле, ВерсияКорреспондента, ИдентификаторНастройки) Экспорт
	
	Возврат "";
	
КонецФункции

// Возвращает строку описания ограничений миграции данных для пользователя;
// Прикладной разработчик на основе установленных отборов на узле должен сформировать строку описания ограничений 
// удобную для восприятия пользователем.
// 
// Параметры:
//  НастройкаОтборовНаУзле - Структура - структура отборов на узле плана обмена,
//                                       полученная при помощи функции НастройкаОтборовНаУзле().
// 
// Возвращаемое значение:
//  Строка, Неогранич. - строка описания ограничений миграции данных для пользователя
//
Функция ОписаниеОграниченийПередачиДанных(НастройкаОтборовНаУзле, ВерсияКорреспондента, ИдентификаторНастройки) Экспорт
	
	Если НастройкаОтборовНаУзле.Организации.Организация.Количество() > 0 Тогда 
		СтрокаПредставленияОтбора = СтрСоединить(НастройкаОтборовНаУзле.Организации.Организация, "; ");
		НСтрока = НСтр("ru = 'Только по организациям: %1'");
		ОграничениеОтборПоОрганизациям = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтрока, СтрокаПредставленияОтбора);
		Возврат ОграничениеОтборПоОрганизациям;
	Иначе
		Возврат "";
	КонецЕсли;
	
КонецФункции

// Возвращает версию подсистемы обмена данными
// Для вновь создаваемых планов обмена функция должна
// возвращать значение Перечисления.ВерсииПодсистемыОбменаДанными.Версия30
//
// Возвращаемое значение:
//  ПеречислениеСсылка.ВерсииПодсистемыОбменаДанными
//
Функция ВерсияОбменаДанными() Экспорт
	
	Возврат Перечисления.ВерсииПодсистемыОбменаДанными.Версия30;
	
КонецФункции

// Возвращает строку описания значений по умолчанию для пользователя;
// Прикладной разработчик на основе установленных значений по умолчанию на узле должен сформировать строку описания 
// удобную для восприятия пользователем.
// 
// Параметры:
//  ЗначенияПоУмолчаниюНаУзле - Структура - структура значений по умолчанию на узле плана обмена,
//                                       полученная при помощи функции ЗначенияПоУмолчаниюНаУзле().
// 
// Возвращаемое значение:
//  Строка, Неогранич. - строка описания для пользователя значений по умолчанию
//
Функция ОписаниеЗначенийПоУмолчанию(ЗначенияПоУмолчаниюНаУзле, ВерсияКорреспондента, ИдентификаторНастройки) Экспорт
	
	Возврат "";
	
КонецФункции

// Определяет использование механизма регистрации объектов
//
// Возвращаемое значение:
// Тип: Булево. Истина – механизм регистрации объектов необходимо использовать для текущего плана обмена;
// Ложь – механизм регистрации объектов использовать не требуется.
//
Функция ИспользоватьМеханизмРегистрацииОбъектов() Экспорт
	
	Возврат Истина;
	
КонецФункции

Функция ПланОбменаИспользуетсяВМоделиСервиса() Экспорт
	
	Возврат Ложь;
	
КонецФункции

// Возвращает признак того, что план обмена поддерживает обмен данными с корреспондентом, работающим в модели сервиса.
// Если признак установлен, то становится возможным создать обмен данными когда эта информационная база
// работает в локальном режиме, а корреспондент в модели сервиса.
//
Функция КорреспондентВМоделиСервиса() Экспорт
	
	Возврат Ложь;
	
КонецФункции

Функция ПояснениеДляНастройкиПараметровУчета() Экспорт
	
	Возврат "";
	
КонецФункции

Функция ПояснениеДляНастройкиПараметровУчетаБазыКорреспондента(ВерсияКорреспондента) Экспорт
	
	Возврат "";
	
КонецФункции

Функция ОбщиеДанныеУзлов(ВерсияКорреспондента, ИмяФормы) Экспорт
	
	Возврат "";
	
КонецФункции

Процедура ОбработчикПроверкиПараметровУчета(Отказ, Получатель, Сообщение) Экспорт
	
	
	
КонецПроцедуры

//Возвращает строку с кратким описанием обмена данными
//
Функция КраткаяИнформацияПоОбмену(ИдентификаторНастройки) Экспорт
	
	ПоясняющийТекст = НСтр("ru = 'Распределенная информационная база представляет собой иерархическую структуру, состоящую из отдельных информационных 
	|баз системы «1С:Предприятие» — узлов распределенной информационной базы, между которыми организована синхронизация 
	|конфигурации и данных. Главной особенностью распределенных информационных баз является передача изменений 
	|конфигурации в подчиненные узлы.
	|Необходимо указать ограничения миграции данных по организациям.'");
	
	Возврат ПоясняющийТекст;
	
КонецФункции

//Возвращает ссылку на веб-страницу или полный путь к форме внутри конфигурации строкой
//
Функция ПодробнаяИнформацияПоОбмену(ИдентификаторНастройки) Экспорт

	Возврат "ПланОбмена.ПоОрганизации.Форма.ПодробнаяИнформация";

КонецФункции

////////////////////////////////////////////////////////////////////////////////
//Дополнение к функционалу БСП

//Возвращает режим запуска, в случае интерактивного инициирования синхронизации
//Возвращаемые значения АвтоматическаяСинхронизация Или ИнтерактивнаяСинхронизация
//На основании этих значений запускается либо помощник интерактивного обмена, либо автообмен
Функция РежимЗапускаСинхронизацииДанных(УзелИнформационнойБазы) Экспорт
	//Пример типового возврата
	Возврат "";
КонецФункции

//Возвращает сценарий работы помощника интерактивного сопостовления
//НеОтправлять, ИнтерактивнаяСинхронизацияДокументов, ИнтерактивнаяСинхронизацияСправочников либо пустую строку
Функция ИнициализироватьСценарийРаботыПомощникаИнтерактивногоОбмена(УзелИнформационнойБазы) Экспорт
	//Пример типового возврата
	Возврат "";
КонецФункции

//Возвращает значения ограничений объектов узла плана обмена для интерактивной регистрации к обмену
//Структура: ВсеДокументы, ВсеСправочники, ДетальныйОтбор
//Детальный отбор либо неопределено, либо массив объектов метаданных входящих в состав узла (Указывается полное имя метаданных)
Функция ДобавитьГруппыОграничений(УзелИнформационнойБазы) Экспорт
	//Пример типового возврата
	Возврат Новый Структура("ВсеДокументы, ВсеСправочники, ДетальныйОтбор", Ложь, Ложь, Неопределено);
КонецФункции

// Обработчик события при подключении к корреспонденту.
// Событие возникает при успешном подключении к корреспонденту и получении версии конфигурации корреспондента
// при настройке обмена с использованием помощника через прямое подключение
// или при подключении к корреспонденту через Интернет.
// В обработчике можно проанализировать версию корреспондента и,
// если настройка обмена не поддерживается с корреспондентом указанной версии, то вызвать исключение.
//
//  Параметры:
// ВерсияКорреспондента (только чтение) – Строка – версия конфигурации корреспондента, например, "2.1.5.1".
//
Процедура ПриПодключенииККорреспонденту(ВерсияКорреспондента) Экспорт
	
КонецПроцедуры

// Обработчик события при отправке данных узла-отправителя.
// Событие возникает при отправке данных узла-отправителя из текущей базы в корреспондент,
// до помещения данных узла в сообщения обмена.
// В обработчике можно изменить отправляемые данные или вовсе отказаться от отправки данных узла.
//
//  Параметры:
// Отправитель – ПланОбменаОбъект – узел плана обмена, от имени которого выполняется отправка данных.
// Игнорировать – Булево – признак отказа от выгрузки данных узла.
//                         Если в обработчике установить значение этого параметра в Истина,
//                         то отправка данных узла выполнена не будет. Значение по умолчанию – Ложь.
//
Процедура ПриОтправкеДанныхОтправителя(Отправитель, Игнорировать) Экспорт
	
КонецПроцедуры

// Обработчик события при получении данных узла-отправителя.
// Событие возникает при получении данных узла-отправителя,
// когда данные узла прочитаны из сообщения обмена, но не записаны в информационную базу.
// В обработчике можно изменить полученные данные или вовсе отказаться от получения данных узла.
//
//  Параметры:
// Отправитель – ПланОбменаОбъект – узел плана обмена, от имени которого выполняется получение данных.
// Игнорировать – Булево – признак отказа от получения данных узла.
//                         Если в обработчике установить значение этого параметра в Истина,
//                         то получение данных узла выполнена не будет. Значение по умолчанию – Ложь.
//
Процедура ПриПолученииДанныхОтправителя(Отправитель, Игнорировать) Экспорт
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
//Обновление информационной базы

Процедура ЗарегистрироватьОбъектыПодсистемыСвойства() Экспорт
	
	Если НЕ ОбщегоНазначенияПовтИсп.РазделениеВключено()
		И ПланыОбмена.ГлавныйУзел() = Неопределено Тогда
		
		ЗапросИзмеренияРегистра = Новый Запрос;
		ЗапросИзмеренияРегистра.Текст = 
			"ВЫБРАТЬ
			|	ДополнительныеСведения.Объект КАК Объект,
			|	ДополнительныеСведения.Свойство КАК Свойство,
			|	ДополнительныеСведения.Значение КАК Значение
			|ИЗ
			|	РегистрСведений.ДополнительныеСведения КАК ДополнительныеСведения
			|ГДЕ
			|	ВЫБОР
			|		КОГДА ДополнительныеСведения.Объект ССЫЛКА Справочник.Организации ТОГДА ДополнительныеСведения.Объект В (&Организации)
			|		КОГДА ДополнительныеСведения.Объект.Организация ССЫЛКА Справочник.Организации ТОГДА ДополнительныеСведения.Объект.Организация В (&Организации)
			|		ИНАЧЕ ИСТИНА
			|	КОНЕЦ
			|	И
			|	ВЫБОР
			|		КОГДА ДополнительныеСведения.Значение ССЫЛКА Справочник.Организации ТОГДА ДополнительныеСведения.Значение В (&Организации)
			|		КОГДА ДополнительныеСведения.Значение.Организация ССЫЛКА Справочник.Организации ТОГДА ДополнительныеСведения.Значение.Организация В (&Организации)
			|		ИНАЧЕ ИСТИНА
			|	КОНЕЦ";				
		
		Запрос = Новый Запрос();
		Запрос.Параметры.Вставить("ЭтотУзел", ПланыОбмена.ПоОрганизации.ЭтотУзел());
		Запрос.Текст =
			"ВЫБРАТЬ
			|	ПоОрганизации.Ссылка КАК Ссылка,
			|	ПоОрганизацииОрганизации.Организация КАК Организация
			|ИЗ
			|	ПланОбмена.ПоОрганизации КАК ПоОрганизации
			|		ЛЕВОЕ СОЕДИНЕНИЕ ПланОбмена.ПоОрганизации.Организации КАК ПоОрганизацииОрганизации
			|		ПО (ПоОрганизации.Ссылка = ПоОрганизацииОрганизации.Ссылка)
			|ГДЕ
			|	ПоОрганизации.Ссылка <> &ЭтотУзел
			|ИТОГИ ПО
			|	Ссылка";

		Результат = Запрос.Выполнить();
		Если Результат.Пустой() Тогда
			Возврат;
		КонецЕсли;
		
		МассивУзлов = Новый Массив;
		ДеревоУзлов = Результат.Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкам);
		Для Каждого СтрокаДерева Из ДеревоУзлов.Строки Цикл
			МассивУзлов.Добавить(СтрокаДерева.Ссылка);
		КонецЦикла;
		
		Попытка
			
			ПланыОбмена.ЗарегистрироватьИзменения(МассивУзлов, Метаданные.Константы.ИспользоватьДополнительныеРеквизитыИСведения);
			
			ПланыОбмена.ЗарегистрироватьИзменения(МассивУзлов, Метаданные.Справочники.ЗначенияСвойствОбъектов);
			ПланыОбмена.ЗарегистрироватьИзменения(МассивУзлов, Метаданные.Справочники.ЗначенияСвойствОбъектовИерархия);
			ПланыОбмена.ЗарегистрироватьИзменения(МассивУзлов, Метаданные.Справочники.НаборыДополнительныхРеквизитовИСведений);
			
			ПланыОбмена.ЗарегистрироватьИзменения(МассивУзлов, Метаданные.ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения);
			
		Исключение
			
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			ПодробноеПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке);
			
			Комментарий = НСтр(
				"ru = 'При регистрации объектов плана обмена ""По организации"" произошла ошибка:
				|%1'");
			Комментарий = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Комментарий, ПодробноеПредставлениеОшибки);
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Обновление ИБ. Регистрация объектов плана обмена ""По организации""'"),
				УровеньЖурналаРегистрации.Ошибка, , , Комментарий);
			
		КонецПопытки;
		
		НаборЗаписейРегистра = РегистрыСведений.ДополнительныеСведения.СоздатьНаборЗаписей();
		
		ВыборкаУзлов = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаУзлов.Следующий() Цикл
			
			ВыборкаОрганизаций = ВыборкаУзлов.Выбрать();
			МассивОрганизаций = Новый Массив;
			Пока ВыборкаОрганизаций.Следующий() Цикл
				Если НЕ ЗначениеЗаполнено(ВыборкаОрганизаций.Организация) Тогда
					Продолжить;
				КонецЕсли;
				МассивОрганизаций.Добавить(ВыборкаОрганизаций.Организация);
			КонецЦикла;
			
			Если МассивОрганизаций.Количество() > 0 Тогда
				
				ЗапросИзмеренияРегистра.УстановитьПараметр("Организации", МассивОрганизаций);
				РезультатЗапроса = ЗапросИзмеренияРегистра.Выполнить();
				
				ВыборкаИзмерения = РезультатЗапроса.Выбрать();
				
				Пока ВыборкаИзмерения.Следующий() Цикл
					
					НаборЗаписейРегистра.Отбор.Объект.Установить(ВыборкаИзмерения.Объект);
					НаборЗаписейРегистра.Отбор.Свойство.Установить(ВыборкаИзмерения.Свойство);
					НаборЗаписейРегистра.Прочитать();
					
					Попытка
						ПланыОбмена.ЗарегистрироватьИзменения(ВыборкаУзлов.Ссылка, НаборЗаписейРегистра);
					Исключение
						ИнформацияОбОшибке = ИнформацияОбОшибке();
						ПодробноеПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке);
						
						Комментарий = НСтр(
							"ru = 'При регистрации объектов для плана обмена ""По организации"" произошла ошибка:
							|%1'");
						Комментарий = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Комментарий, ПодробноеПредставлениеОшибки);
						ЗаписьЖурналаРегистрации(НСтр("ru = 'Обновление ИБ. Регистрация объектов плана обмена ""По организации""'"),
							УровеньЖурналаРегистрации.Ошибка, , , Комментарий);
					КонецПопытки;
						
					Если НЕ ПланыОбмена.ИзменениеЗарегистрировано(ВыборкаУзлов.Ссылка, ВыборкаИзмерения.Объект) Тогда
						
						Попытка
							ПланыОбмена.ЗарегистрироватьИзменения(ВыборкаУзлов.Ссылка, ВыборкаИзмерения.Объект);
						Исключение
							ИнформацияОбОшибке = ИнформацияОбОшибке();
							ПодробноеПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке);
							
							Комментарий = НСтр(
								"ru = 'При регистрации объектов для плана обмена ""По организации"" произошла ошибка:
								|%1'");
							Комментарий = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Комментарий, ПодробноеПредставлениеОшибки);
							ЗаписьЖурналаРегистрации(НСтр("ru = 'Обновление ИБ. Регистрация объектов плана обмена ""По организации""'"),
								УровеньЖурналаРегистрации.Ошибка, , , Комментарий);
						КонецПопытки;
							
					КонецЕсли;
					
				КонецЦикла;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецЕсли