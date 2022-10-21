#Область ПрограммныйИнтерфейс

// Проверяет принадлежность сеанса информационной базы конкретной области данных.
//
// Параметры:
//  НомерОбластиДанных - Число(7,0,+) - номер области данных,
//  КлючОбластиДанных - Строка - ключ области данных,
//  НомерСеанса - Число - номер сеанса информационной базы, принадлежность которого к области
//    данных проверяется.
//  ИнформацияОбОшибке - ОбъектXDTO {http://www.1c.ru/SaaS/ServiceCommon}ErrorDescription -
//   описание ошибки для передачи через web-сервис.
//
Функция ПроверитьПринадлежностьСеансаОбластиДанных(НомерОбластиДанных, КлючОбластиДанных, НомерСеанса, ИнформацияОбОшибке)
	
	Попытка
		
		Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
			
			Если ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
				
				ВызватьИсключение НСтр("ru = 'Операция не может быть вызвана в сеансе, который запущен с указанием разделителей. Проверьте правильность публикации веб-сервиса!'");
				
			Иначе
				
				РаботаВМоделиСервиса.УстановитьРазделениеСеанса(Истина, НомерОбластиДанных);
				
				Если КлючОбластиДанных <> Константы.КлючОбластиДанных.Получить() Тогда
					ВызватьИсключение НСтр("ru = 'Некорректный ключ области данных!'");
				КонецЕсли;
				
				УстановитьБезопасныйРежимРазделенияДанных(Метаданные.ОбщиеРеквизиты.ОбластьДанныхОсновныеДанные.Имя, Истина);
				
				Возврат УдаленноеАдминистрированиеБТССлужебный.ПроверитьПринадлежностьСеансаТекущейОбластиДанных(НомерСеанса);
				
			КонецЕсли;
			
		Иначе
			ВызватьИсключение НСтр("ru = 'Операция не может быть выполнена для информационной базы, в которой отключено разделение по областям данных!'");
		КонецЕсли;
		
	Исключение
		
		ИнформацияОбОшибке = ТехнологияСервиса.ПолучитьОписаниеОшибкиWebСервиса(ИнформацияОбОшибке());
		
	КонецПопытки;
	
КонецФункции

// Возвращает требуемые для корректной работы ИБ разрешения на использование
//  внешних ресурсов. Вызывается при первоначальном включении профилей безопасности
//  из менеджера сервиса.
//
// Параметры:
//  ИнформацияОбОшибке - ОбъектXDTO {http://www.1c.ru/SaaS/ServiceCommon}ErrorDescription -
//   описание ошибки для передачи через web-сервис.
//
// Возвращаемое значение - ОбъектXDTO {http://www.1c.ru/1cFresh/Application/Permissions/Management/a.b.c.d}PermissionsRequestsList -
//  сериализация запросов разрешений на использование внешних ресурсов.
//
Функция ПолучитьТребуемыеРазрешенияНаИспользованиеВнешнихРесурсов(ИнформацияОбОшибке)
	
	Попытка
		
		
		
	Исключение
		
		ИнформацияОбОшибке = ТехнологияСервиса.ПолучитьОписаниеОшибкиWebСервиса(ИнформацияОбОшибке());
		
	КонецПопытки;
	
КонецФункции

// Возвращает запросы разрешений на использование внешних ресурсов.
//
// Параметры:
//  НаборЗапросов - УникальныйИдентификатор - набор запросов на использование внешних ресурсов.
//  ИнформацияОбОшибке - ОбъектXDTO {http://www.1c.ru/SaaS/ServiceCommon}ErrorDescription -
//   описание ошибки для передачи через web-сервис.
//
// Возвращаемое значение - ОбъектXDTO {http://www.1c.ru/1cFresh/Application/Permissions/Management/a.b.c.d}PermissionsRequestsList -
//  сериализация запросов разрешений на использование внешних ресурсов.
//
Функция ПолучитьЗапросыРазрешений(ИдентификаторПакета, ИнформацияОбОшибке)
	
	Попытка
		
		
		
	Исключение
		
		ИнформацияОбОшибке = ТехнологияСервиса.ПолучитьОписаниеОшибкиWebСервиса(ИнформацияОбОшибке());
		
	КонецПопытки;
	
КонецФункции

#КонецОбласти
