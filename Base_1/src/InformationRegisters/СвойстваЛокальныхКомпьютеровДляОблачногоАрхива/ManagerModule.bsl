///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2018, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает список доступных значений для поля "ТипОС".
// ТипОС совпадает с типами платформы из СистемнаяИнформация, хотя имеет другой смысл (относится к операционной системе).
//
// Возвращаемое значение:
//   Массив - список доступных значений.
//
Функция ПолучитьЗначенияДопустимыхТиповОС() Экспорт

	Результат = Новый Массив;

	Результат.Добавить("Linux_x86");
	Результат.Добавить("Linux_x86_64");
	Результат.Добавить("MacOS_x86");
	Результат.Добавить("MacOS_x86_64");
	Результат.Добавить("Windows_x86");
	Результат.Добавить("Windows_x86_64");

	Возврат Результат;

КонецФункции

#КонецОбласти

#КонецЕсли