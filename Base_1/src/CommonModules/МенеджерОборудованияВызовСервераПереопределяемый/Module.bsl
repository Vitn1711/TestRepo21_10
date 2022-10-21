
#Область ПрограммныйИнтерфейс

#Область Основные

// Возвращает список доступных типов оборудования.
// 
// Возвращаемое значение:
//   Массив - Массив доступных типов подключаемого оборудования в конфигурации.
//
Функция ПолучитьДоступныеТипыОборудования() Экспорт
	
	СписокОборудования = Новый Массив;
	
	// Сканеры штрихкода
	СписокОборудования.Добавить(Перечисления.ТипыПодключаемогоОборудования.СканерШтрихкода);
	// Конец Сканеры штрихкода
	
	// Фискальные регистраторы
	СписокОборудования.Добавить(Перечисления.ТипыПодключаемогоОборудования.ФискальныйРегистратор);
	// Конец Фискальные регистраторы.

	// Принтеры чеков
	СписокОборудования.Добавить(Перечисления.ТипыПодключаемогоОборудования.ПринтерЧеков);
	// Конец принтеры чеков.
	
	// Терминалы сбора данных
	СписокОборудования.Добавить(Перечисления.ТипыПодключаемогоОборудования.ТерминалСбораДанных);
	// Конец Терминалы сбора данных.

	// Эквайринговые терминалы
	СписокОборудования.Добавить(Перечисления.ТипыПодключаемогоОборудования.ЭквайринговыйТерминал);
	// Конец Эквайринговые терминалы.
		
	Возврат СписокОборудования;
	
КонецФункции

// Возвращает флаг возможности добавления новых драйверов в справочник драйверов.
// 
// Возвращаемое значение:
//   Булево - В случае разрешение добавления новых драйверов возвращает Истина.
//
Функция ВозможностьДобавленияНовыхДрайверов() Экспорт
	
	Возврат Истина;
	
КонецФункции

// Возвращает флаг возможности использовать подключаемое оборудование.
// 
// Возвращаемое значение:
//   Булево - В случае разрешение использовать подключаемое оборудование.
//
Функция ИспользоватьПодключаемоеОборудование() Экспорт
	
	Возврат Истина;
	
КонецФункции

// Возвращает признак возможности обращения к разделенным данным из текущего сеанса.
//  
// Возвращаемое значение:
//  Булево - В случае вызова в неразделенной конфигурации возвращает Истина.
//
Функция ДоступноИспользованиеРазделенныхДанных() Экспорт
	
	Возврат ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных();
	
КонецФункции

// Обновление библиотеки в целевой конфигурации.
//                                   
Процедура ОбновлениеБиблиотеки() Экспорт
	
	ОбновитьПоставляемыеДрайвера();
	ОбновитьУстановленныеДрайвера();
	
КонецПроцедуры

// Обновить поставляемые драйверы в составе конфигурации.
//                                   
Процедура ОбновитьПоставляемыеДрайвера() Экспорт
	
	// Сканеры штрихкода
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикСканкодСканерыШтрихкода, "AddIn.ScancodeScanner", , Истина, , Истина);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикАтолСканерыШтрихкода, "AddIn.Scaner45", , Истина, , Истина);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.Обработчик1ССканерыШтрихкода, "AddIn.Scanner", "Драйвер1ССканерШтрихкода", Ложь, "8.1.9.1");
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.Обработчик1ССканерыШтрихкодаNative, "AddIn.InputDevice", "Драйвер1СУстройстваВводаNative", Ложь, "9.0.8.7");
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикГексагонСканерыШтрихкода, "AddIn.ProtonScanner", "ДрайверГексагонСканерШтрихкода", Ложь);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикАтолСканерыШтрихкода8X, "AddIn.ATOL_Scaners_1CInt", "ДрайверАТОЛУстройстваВвода8X", Ложь);
	// Конец Сканеры штрихкода
	
	
	// Фискальные регистраторы
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.Обработчик1СФискальныйРегистраторЭмулятор, "AddIn.EmulatorFP1C", , Истина,, Истина);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.Обработчик1СРарусФискальныеРегистраторыФеликс, "AddIn.fr_feliksRMK1c82", "Драйвер1СРарусФискальныеРегистраторыФеликс", Ложь, , Истина);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.Обработчик1СРарусФискальныеРегистраторыМебиус, "AddIn.fr_moebius1c82", "Драйвер1СРарусФискальныеРегистраторыМебиус", Ложь, , Истина);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикАтолФискальныеРегистраторы, "AddIn.ATOL_KKM_1C", , Истина, , Истина);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикАтолФискальныеРегистраторыУниверсальный, "AddIn.ATOL_KKM_1C", , Истина, , Истина);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикАтолФискальныеРегистраторы8X, "AddIn.ATOL_KKM_1C82", "ДрайверАТОЛФискальныеРегистраторы8X", Ложь,,Истина);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикВерсияТФискальныеРегистраторы, "AddIn.KSBFR1K1C", , Истина, ,Истина);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикККСФискальныеРегистраторы, "AddIn.SparkTF", "ДрайверККСФискальныеРегистраторы", Ложь,,Истина);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикШтрихМФискальныеРегистраторы, "AddIn.DrvFR1C", , Истина, , Истина);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикШтрихМФискальныеРегистраторыУниверсальный, "AddIn.SMDrvFR1C", "ДрайверШтрихМФискальныеРегистраторы", Ложь,,Истина);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикОРИОНФискальныеРегистраторы, "AddIn.OrionFR_1C8", , Истина, ,Истина);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикКристаллСервисФискальныеРегистраторыPirit, "AddIn.PiritK", "ДрайверКристаллСервисФискальныеРегистраторыPirit", Ложь, , Истина);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикДримкасФискальныеРегистраторыVikiPrint, "AddIn.VikiP", "ДрайверДримкасФискальныеРегистраторыVikiPrint", Ложь, , Истина);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикИскраФискальныеРегистраторыПрим, "AddIn.IskraFR", "ДрайверИскраФискальныеРегистраторыПрим", Ложь, , Истина);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикWebkassaФискальныеРегистраторы);
	// Конец Фискальные регистраторы.
	
	
	// Принтеры чеков
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.Обработчик1СПринтерЧеков, "AddIn.ReceiptPrinterNative", "Драйвер1СПринтерЧеков", Ложь, "3.1.4.6");
	// Конец Принтеры чеков.
	
		
	// Терминалы сбора данных
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикАтолТерминалыСбораДанных, "AddIn.PDX45", , Истина, , Истина);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикГексагонТерминалыСбораДанных, "AddIn.ProtonTSD", "ДрайверГексагонТСД", Ложь, "8.4.2");
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикСканкодТерминалыСбораДанных, "AddIn.CipherLab", , Истина, ,Истина);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикСканситиТерминалыСбораДанных, "AddIn.iPOSoft_DT", , Истина, ,Истина);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикКлеверенсТерминалыСбораДанных, "AddIn.Cleverence.TO_TSD", "ДрайверКлеверенсТСД", Ложь);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикШтрихМТерминалыСбораДанных, "AddIn.Terminals", , Истина, ,Истина);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикАтолТерминалыСбораДанныхMobileLogistics, "AddIn.PDX1C_Int", "ДрайверАТОЛТСДMobileLogistics", Ложь);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикСканкодТерминалыСбораДанныхNative, "AddIn.CipherLab8", "ДрайверСканкодТерминалыСбораДанныхNative", Ложь, "1.0.0.9", Истина);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикRightScanТерминалыСбораДанных, "AddIn.RSExchange", "ДрайверRightScanТерминалыСбораДанных", Ложь, "1.11");
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикСканситиТерминалСбораДанныхCitySoftBusiness, "AddIn.CitySoftBusinessDriver", "ДрайверСканситиТерминалСбораДанныхCitySoftBusiness", Ложь, "4.0.12.747");
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикСканкодТерминалыСбораДанныхCipherLab8G2, "AddIn.CipherLab8G2", "ДрайверСканкодТерминалыСбораДанныхCipherLab8G2", Ложь, "2.0.0.20");
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикСканситиТерминалСбораДанныхCitySoftLite, "AddIn.CitySoftLiteEquipmentDriver", "ДрайверСканситиТерминалСбораДанныхCitySoftLite", Ложь, "5.8.3.260");
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикСканситиТерминалСбораДанныхCitySoftStandart, "AddIn.CitySoftStandartDriver", "ДрайверСканситиТерминалСбораДанныхCitySoftStandart", Ложь, "4.5.0.881");
	// Конец Терминалы сбора данных.
	
	// Эквайринговые терминалы
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикИНПАСЭквайринговыеТерминалыSmart, "AddIn.a_inpas1c82", , Ложь, , Истина);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикИНПАСЭквайринговыеТерминалыUNIPOS, "AddIn.a_inpasDC1c83", "ДрайверИНПАСЭквайринговыеТерминалыUNIPOS", Ложь, "1.1.1.2");
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикTRPOSЭквайринговыеТерминалы, "AddIn.a_trpos1c82", "ДрайверTRPOSЭквайринговыеТерминалы", Ложь, "1.0.0.34");
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикСБРФЭквайринговыеТерминалы, "AddIn.SBRFCOMObject|AddIn.SBRFCOMExtension", , Истина, , Истина);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикUCSEFTPOSЭквайринговыеТерминалы, "AddIn.UCS_EFTPOS", "ДрайверUCSEFTPOSЭквайринговыеТерминалы", Ложь, "1.0.9.8");
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикГАЗПРОМБАНКЭквайринговыеТерминалы, "AddIn.GPBEMVGateNativeAPI1C", "ДрайверГАЗПРОМБАНКЭквайринговыеТерминалы", Ложь, "1.0.3.5");
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикARCUS2ЭквайринговыеТерминалыIngenico, "AddIn.IngenicoDriver1C", "ДрайверARCUS2ЭквайринговыеТерминалыIngenico", Ложь, "1.0.0.2");
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикIboxProПоддержкаMPosЭквайринга, "AddIn.iboxPro", "ДрайверIboxProПоддержкаMPosЭквайринга", Ложь, "1.2.4");
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикШтрихМПлатежныйТерминалYarus, "AddIn.ShtrihPayMan1C", "ДрайверШтрихМПлатежныйТерминалYarus", Ложь);
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.Обработчик1СЭквайринговыеТерминалыСбербанк, "AddIn.SberAcquiringTerminal", "Драйвер1СЭквайринговыеТерминалыСбербанк", Ложь, "1.0.2.2");
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикMPos2canЭквайринг, "AddIn.mPos2can", "ДрайверMPos2canЭквайринг", Ложь, "1.5.9");
	Справочники.ДрайверыОборудования.ЗаполнитьПредопределенныйЭлемент(Перечисления.ОбработчикиДрайверовПодключаемогоОборудования.ОбработчикSKAM1CЭквайринговыеСистемы, "AddIn.skam", "ДрайверSKAM1CЭквайринговыеСистемы", Ложь, "1.0.3");
	// Конец Эквайринговые терминалы.
		
		
КонецПроцедуры

// Обновить установленные драйвера.
//
Процедура ОбновитьУстановленныеДрайвера() Экспорт
	
	// ККТ с передачей данных ОФД
	МенеджерОборудованияВызовСервера.ОбновитьУстановленныеДрайвера(Перечисления.ТипыПодключаемогоОборудования.ККТ);
	// Конец ККТ с передачей данных ОФД.
	
	// Принтеры чеков
	МенеджерОборудованияВызовСервера.ОбновитьУстановленныеДрайвера(Перечисления.ТипыПодключаемогоОборудования.ПринтерЭтикеток);
	// Конец Принтеры чеков.
	
	// Сканеры штрихкода
	МенеджерОборудованияВызовСервера.ОбновитьУстановленныеДрайвера(Перечисления.ТипыПодключаемогоОборудования.СканерШтрихкода);
	// Конец Сканеры штрихкода
	
КонецПроцедуры

// Возвращает флаг возможности использовать драйверов снятых с поддержки.
// 
// Возвращаемое значение:
//   Булево - В случае возможность использовать снятых с поддержки драйверов возвращает Истина.
//
Функция ВозможностьИспользоватьСнятыхСПоддержкиДрайверов() Экспорт
	
	Возврат Истина;
	
КонецФункции

// Переопределяемая процедура для подсистемы управление доступом СтандартныеПодсистемы
// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
//
Процедура ПриЗаполненииОграниченияДоступа(Менеджер, Ограничение) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область РаботаСЭлементомФормы

// Дополнительные переопределяемые действия с элементом формы 
// служит для учета специфики визуального отображения в зависимости от типа клиента.
//
Процедура ПодготовитьЭлементУправления(ЭлементУправления, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область ПроцедурыОбновленияБПОМеждуВерсиями

#КонецОбласти

#Область ОборудованиеККТ

// Процедура заполняет реквизиты организации для регистрации ФН.
//
Процедура ЗаполнитьРеквизитыОрганизацииДляРегистрацииФН(Организация, ПараметрыРегистрации) Экспорт
	
КонецПроцедуры

// Переопределяет формируемый шаблон чека.
//
Функция СформироватьШаблонЧека(ОбщиеПараметры, ДополнительныйТекст, СтандартнаяОбработка, ТипОборудования = "") Экспорт

КонецФункции

#КонецОбласти


#Область РаботаСФормойЭкземпляраОборудования

// Дополнительные переопределяемые действия с управляемой формой в Экземпляре оборудования
// при событии "ПриСозданииНаСервере".
//
Процедура ЭкземплярОборудованияПриСозданииНаСервере(Объект, ЭтаФорма, Отказ, Параметры, СтандартнаяОбработка) Экспорт

КонецПроцедуры

// Дополнительные переопределяемые действия с управляемой формой в Экземпляре оборудования
// при событии "ПриЧтенииНаСервере".
//
Процедура ЭкземплярОборудованияПриЧтенииНаСервере(ТекущийОбъект, ЭтаФорма) Экспорт

КонецПроцедуры

// Дополнительные переопределяемые действия с управляемой формой в Экземпляре оборудования
// при событии "ПередЗаписьюНаСервере".
//
Процедура ЭкземплярОборудованияПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи) Экспорт

КонецПроцедуры

// Дополнительные переопределяемые действия с управляемой формой в Экземпляре оборудования
// при событии "ПриЗаписиНаСервере".
//
Процедура ЭкземплярОборудованияПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи) Экспорт

КонецПроцедуры

// Дополнительные переопределяемые действия с управляемой формой в Экземпляре оборудования
// при событии "ПослеЗаписиНаСервере".
//
Процедура ЭкземплярОборудованияПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи) Экспорт

КонецПроцедуры

// Дополнительные переопределяемые действия с управляемой формой в Экземпляре оборудования
// при событии "ОбработкаПроверкиЗаполненияНаСервере".
//
Процедура ЭкземплярОборудованияОбработкаПроверкиЗаполненияНаСервере(Объект, ЭтаФорма, Отказ, ПроверяемыеРеквизиты) Экспорт

КонецПроцедуры

#КонецОбласти

#Область РаботаСФормойЭкземпляраФискальныеОперации

// Дополнительные переопределяемые действия с управляемой формой в Экземпляре Фискальные операции
// при событии "ПриСозданииНаСервере".
//
Процедура ЭкземплярФискальныеОперацииПриСозданииНаСервере(Запись, ЭтаФорма, Отказ, Параметры, СтандартнаяОбработка) Экспорт

КонецПроцедуры

#КонецОбласти

#Область РаботаСФормойСписокаФискальныеОперации

// Дополнительные переопределяемые действия с управляемой формой в Список Фискальные операции
// при событии "ПриСозданииНаСервере".
//
Процедура СписокФискальныеОперацииПриСозданииНаСервере(ЭтаФорма, Отказ, Параметры, СтандартнаяОбработка) Экспорт

КонецПроцедуры

#КонецОбласти

#КонецОбласти
