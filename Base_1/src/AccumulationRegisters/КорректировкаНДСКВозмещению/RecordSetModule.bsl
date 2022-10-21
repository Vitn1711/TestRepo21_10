#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Перем мПериод          Экспорт; // Период движений
Перем мТаблицаДвижений Экспорт; // Таблица движений

Процедура ДобавитьДвижение() Экспорт
	
	мТаблицаДвижений.ЗаполнитьЗначения( мПериод, "Период");
	мТаблицаДвижений.ЗаполнитьЗначения( Истина,  "Активность");

	ОбщегоНазначенияБК.ВыполнитьДвижениеПоРегистру(ЭтотОбъект);
	
КонецПроцедуры // ДобавитьДвижение()
	
#КонецЕсли
