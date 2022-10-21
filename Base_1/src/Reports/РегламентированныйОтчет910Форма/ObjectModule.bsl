Функция ТаблицаФормОтчета() Экспорт
	
	ОписаниеТиповСтрока = Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(254));
	
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("Дата"));
	ОписаниеТиповДата = Новый ОписаниеТипов(МассивТипов, , Новый КвалификаторыДаты(ЧастиДаты.Дата));
	
	ТаблицаФормОтчета = Новый ТаблицаЗначений;
	ТаблицаФормОтчета.Колонки.Добавить("ФормаОтчета",        ОписаниеТиповСтрока);
	ТаблицаФормОтчета.Колонки.Добавить("ОписаниеОтчета",     ОписаниеТиповСтрока, "Утверждена",  20);
	ТаблицаФормОтчета.Колонки.Добавить("ДатаНачалоДействия", ОписаниеТиповДата,   "Действует с", 5);
	ТаблицаФормОтчета.Колонки.Добавить("ДатаКонецДействия",  ОписаниеТиповДата,   "         по", 5);
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "Форма9102007Кв3";
	НоваяФорма.ОписаниеОтчета     = "Упрощенная декларация для субъектов малого бизнеса. Форма адаптирована к версии ЭФНО 1.6.1.41 от 13.02.2009г.";
	НоваяФорма.ДатаНачалоДействия = '20070101';
	НоваяФорма.ДатаКонецДействия  = '20081231';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "Форма9102009Кв1";
	НоваяФорма.ОписаниеОтчета     = "Упрощенная декларация для субъектов малого бизнеса. Форма имеет возможность выгрузки в ИС СОНО 3.119.56, версия ФНО: 910.00.v8.r10 от 29.07.2009 г.";
	НоваяФорма.ДатаНачалоДействия = '20090101';
	НоваяФорма.ДатаКонецДействия  = '20091231';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "Форма9102010Кв1";
	НоваяФорма.ОписаниеОтчета     = "Упрощенная декларация для субъектов малого бизнеса. Версия шаблона ФНО для ИС СОНО: 910.00.v10.r55 от 02.04.2010 г.";
	НоваяФорма.ДатаНачалоДействия = '20100101';
	НоваяФорма.ДатаКонецДействия  = '20101231';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "Форма9102011Кв1";                                                                             
	НоваяФорма.ОписаниеОтчета     = "Упрощенная декларация для субъектов малого бизнеса. Версия шаблона ФНО для ИС СОНО: 910.00.v11.r66 от 21.02.2011 г.";
	НоваяФорма.ДатаНачалоДействия = '20110101';
	НоваяФорма.ДатаКонецДействия  = '20111231';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "Форма9102012Кв1";                                                                             
	НоваяФорма.ОписаниеОтчета     = "Упрощенная декларация для субъектов малого бизнеса. Версия шаблона ФНО для ИС СОНО: 910.00.v12.r71";
	НоваяФорма.ДатаНачалоДействия = '20120101';
	НоваяФорма.ДатаКонецДействия  = '20121231';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "Форма9102013Кв1";                                                                             
	НоваяФорма.ОписаниеОтчета     = "Упрощенная декларация для субъектов малого бизнеса. Версия шаблона ФНО для ИС СОНО: 910.00.v13.r75";
	НоваяФорма.ДатаНачалоДействия = '20130101';
	НоваяФорма.ДатаКонецДействия  = '20131231';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "Форма9102014Кв1";
	НоваяФорма.ОписаниеОтчета     = "Упрощенная декларация для субъектов малого бизнеса. Версия шаблона ФНО для ИС СОНО: 910.00.v14.r79";
	НоваяФорма.ДатаНачалоДействия = '20140101';
	НоваяФорма.ДатаКонецДействия  = '20141231';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "Форма9102015Кв1";
	НоваяФорма.ОписаниеОтчета     = "Упрощенная декларация для субъектов малого бизнеса. Версия шаблона ФНО для ИС СОНО: 910.00.v15.r81";
	НоваяФорма.ДатаНачалоДействия = '20150101';
	НоваяФорма.ДатаКонецДействия  = '20150630';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "Форма9102015Кв3";
	НоваяФорма.ОписаниеОтчета     = "Упрощенная декларация для субъектов малого бизнеса. Версия шаблона ФНО для ИС СОНО: 910.00.v16.r82";
	НоваяФорма.ДатаНачалоДействия = '20150701';
	НоваяФорма.ДатаКонецДействия  = '20151231';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "Форма9102016Кв2";
	НоваяФорма.ОписаниеОтчета     = "Упрощенная декларация для субъектов малого бизнеса. Версия шаблона ФНО для ИС СОНО: 910.00.v17.r83";
	НоваяФорма.ДатаНачалоДействия = '20160101';
	НоваяФорма.ДатаКонецДействия  = '20161231';

	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "Форма9102017Кв1";
	НоваяФорма.ОписаниеОтчета     = "Упрощенная декларация для субъектов малого бизнеса. Версия шаблона ФНО для ИС СОНО: 910.00.v17.r84";
	НоваяФорма.ДатаНачалоДействия = '20170101';
	НоваяФорма.ДатаКонецДействия  = '20170630';

	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "Форма9102017Кв2";
	НоваяФорма.ОписаниеОтчета     = "Упрощенная декларация для субъектов малого бизнеса. Версия шаблона ФНО для ИС СОНО: 910.00.v18.r85";
	НоваяФорма.ДатаНачалоДействия = '20170701';
	НоваяФорма.ДатаКонецДействия  = '20171231';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "Форма9102018Кв1";
	НоваяФорма.ОписаниеОтчета     = "Упрощенная декларация для субъектов малого бизнеса. Версия шаблона ФНО для ИС СОНО: 910.00.v20.r87";
	НоваяФорма.ДатаНачалоДействия = '20180101';
	НоваяФорма.ДатаКонецДействия  = '20181231';

	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "Форма9102019Кв1";
	НоваяФорма.ОписаниеОтчета     = "Упрощенная декларация для субъектов малого бизнеса. Версия шаблона ФНО для ИС СОНО: 910.00.v20.r89";
	НоваяФорма.ДатаНачалоДействия = '20190101';
	НоваяФорма.ДатаКонецДействия  = '20190630';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "Форма9102019Кв2";
	НоваяФорма.ОписаниеОтчета     = "Упрощенная декларация для субъектов малого бизнеса. Версия шаблона ФНО для ИС СОНО: 910.00.v22.r103";
	НоваяФорма.ДатаНачалоДействия = '20190701';
	НоваяФорма.ДатаКонецДействия  = '20191231';

	//НоваяФорма = ТаблицаФормОтчета.Добавить();
	//НоваяФорма.ФормаОтчета        = "Форма9102020Кв1";
	//НоваяФорма.ОписаниеОтчета     = "Упрощенная декларация для субъектов малого бизнеса. Версия шаблона ФНО для ИС СОНО: 910.00.v22.r103";
	//НоваяФорма.ДатаНачалоДействия = '20200101';
	//НоваяФорма.ДатаКонецДействия  = РегламентированнаяОтчетностьКлиентСервер.ПустоеЗначениеТипа(Тип("Дата"));

	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "Форма9102020Кв2";
	НоваяФорма.ОписаниеОтчета     = "Упрощенная декларация для субъектов малого бизнеса. Версия шаблона ФНО для ИС СОНО: 910.00.v24.r105 от 11.01.2021 г.";
	НоваяФорма.ДатаНачалоДействия = '20200101';
	НоваяФорма.ДатаКонецДействия  = '20201231';

	//НоваяФорма = ТаблицаФормОтчета.Добавить();
	//НоваяФорма.ФормаОтчета        = "Форма9102021Кв1";
	//НоваяФорма.ОписаниеОтчета     = "Упрощенная декларация для субъектов малого бизнеса. Версия шаблона ФНО для ИС СОНО: 910.00.v25.r113 от 21.01.2022 г.";
	//НоваяФорма.ДатаНачалоДействия = '20210101';
	//НоваяФорма.ДатаКонецДействия  = РегламентированнаяОтчетностьКлиентСервер.ПустоеЗначениеТипа(Тип("Дата"));

	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "Форма9102022Кв1";
	НоваяФорма.ОписаниеОтчета     = "Упрощенная декларация для субъектов малого бизнеса. Версия шаблона ФНО для ИС СОНО: 910.00.v26.r115 от 30.06.2022 г.";
	НоваяФорма.ДатаНачалоДействия = '20210101';
	НоваяФорма.ДатаКонецДействия  = РегламентированнаяОтчетностьКлиентСервер.ПустоеЗначениеТипа(Тип("Дата"));
	
	Возврат ТаблицаФормОтчета;
	
КонецФункции

