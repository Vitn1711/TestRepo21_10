
// Конвертирует двоичные данные в Base64
// 
// Параметры:
// 	ДвоичныеДанные - ДвоичныеДанные - Двоичные данные
// Возвращаемое значение:
// 	Строка - Строка в Base64
Функция ДвоичныеДанныеBase64(ДвоичныеДанные) Экспорт
	
	Base64 = Base64Строка(ДвоичныеДанные);
	Base64 = СтрЗаменить(Base64, Символы.ПС, "");
	Base64 = СтрЗаменить(Base64, Символы.ВК, "");
	
	Возврат Base64;
	
КонецФункции

// Возвращает перечень маркируемой продукции, оборот которой фиксируется в ИС МП.
//
// Параметры:
//  ВключатьТабачнуюПродукцию - Булево - Признак включения табачной продукции
//  ВключатьМолочнуюПродукциюВЕТИС - Булево - Признак включения молочной продукции подконтрольной ВетИС
//
// Возвращаемое значение:
//   Массив Из ПеречислениеСсылка.ВидыПродукцииИСМПТК - список видов маркируемой продукции ИСМП.
//
Функция ВидыПродукцииИСМП() Экспорт
	
	//БМ_ИСМПТ НА_РАЗВИТИЕ	Товарные группы
	ВидыПродукцииИСМПТКМП = Новый Массив();
	ВидыПродукцииИСМПТКМП.Добавить(ПредопределенноеЗначение("Перечисление.ВидыПродукцииИСМПТК.Обувная"));
	ВидыПродукцииИСМПТКМП.Добавить(ПредопределенноеЗначение("Перечисление.ВидыПродукцииИСМПТК.Табачная"));
	ВидыПродукцииИСМПТКМП.Добавить(ПредопределенноеЗначение("Перечисление.ВидыПродукцииИСМПТК.МолочнаяПродукция"));
	ВидыПродукцииИСМПТКМП.Добавить(ПредопределенноеЗначение("Перечисление.ВидыПродукцииИСМПТК.ЛегкаяПромышленность"));
	ВидыПродукцииИСМПТКМП.Добавить(ПредопределенноеЗначение("Перечисление.ВидыПродукцииИСМПТК.ЛекарственныеПрепараты"));
		
	Возврат ВидыПродукцииИСМПТКМП;
	
КонецФункции

// Возвращает признак принадлежности переданного в параметре вида продукции к виду продукции ИС МП.
//
// Параметры:
//  ВидПродукции - ПеречислениеСсылка.ВидыПродукцииИСМПТК - Вид продукции для анализа
//  ВключатьТабачнуюПродукцию - Булево - Признак включения табачной продукции
//  ВключатьМолочнуюПродукцию - Булево - Признак вкючения молочной продукции
// Возвращаемое значение:
//  Булево - Принадлежность к виду продукции ИСМП.
//
Функция ЭтоПродукцияИСМП(ВидПродукции) Экспорт
	
	ВидыПродукцииИСМПТКМП = ВидыПродукцииИСМП();
	
	Возврат ВидыПродукцииИСМПТКМП.Найти(ВидПродукции) <> Неопределено;

КонецФункции

//Определяет является ли тип упаковки логистической или групповой товарной упаковкой.
//
//Параметры:
//  ТипУпаковки - ПеречислениеСсылка.ТипыУпаковокИСМП - тип упаковки
//Возвращаемое значение:
//   Булево - Истина, если тип упаковки относится к логистической или товарной.
Функция ЭтоУпаковка(ТипУпаковки) Экспорт
	
	Возврат ТипУпаковки = ПредопределенноеЗначение("Перечисление.ТипыУпаковокИСМПТК.МонотоварнаяУпаковка")
		Или ТипУпаковки = ПредопределенноеЗначение("Перечисление.ТипыУпаковокИСМПТК.МультитоварнаяУпаковка");
	
КонецФункции
