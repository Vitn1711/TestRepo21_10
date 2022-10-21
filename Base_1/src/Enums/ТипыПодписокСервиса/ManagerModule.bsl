#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает значение перечисления по имени значения свойства программного интерфейса сервиса.
//
// Параметры:
//  ИмяЗначения - Строка - имя значения свойства.
// 
// Возвращаемое значение:
//   ПеречислениеСсылка.ТипыПодписокСервиса - значение перечисления.
//
Функция ЗначениеПоИмени(ИмяЗначения) Экспорт
    
    Если ИмяЗначения = "basic" Тогда
        Возврат ПредопределенноеЗначение("Перечисление.ТипыПодписокСервиса.Основная");
    ИначеЕсли ИмяЗначения = "prolonging" Тогда
        Возврат ПредопределенноеЗначение("Перечисление.ТипыПодписокСервиса.Продлевающая");
    ИначеЕсли ИмяЗначения = "extending" Тогда
        Возврат ПредопределенноеЗначение("Перечисление.ТипыПодписокСервиса.Расширяющая");
    Иначе
        Возврат ПредопределенноеЗначение("Перечисление.ТипыПодписокСервиса.ПустаяСсылка");
    КонецЕсли; 
    
КонецФункции

#КонецОбласти

#КонецЕсли