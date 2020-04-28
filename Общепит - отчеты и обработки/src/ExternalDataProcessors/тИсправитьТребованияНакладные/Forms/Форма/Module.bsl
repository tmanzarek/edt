// Тимур - старт - 15.04.2020

&НаСервереБезКонтекста
Процедура ИсправитьДокументыНаСервере(ДатаНачала, ДатаОкончания, Ответственный)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ТребованиеНакладная.Ссылка КАК Ссылка,
	|	ТребованиеНакладная.Представление КАК Представление
	|ИЗ
	|	Документ.ТребованиеНакладная КАК ТребованиеНакладная
	|ГДЕ
	|	ТребованиеНакладная.Ответственный = &Ответственный
	|	И ТребованиеНакладная.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТребованиеНакладная.Дата,
	|	ТребованиеНакладная.Номер");
	
	Запрос.УстановитьПараметр("ДатаНачала",		НачалоДня(ДатаНачала));
	Запрос.УстановитьПараметр("ДатаОкончания",	КонецДня(ДатаОкончания));
	Запрос.УстановитьПараметр("Ответственный",	Ответственный);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Товар					= Перечисления.ОбщепитВидыНоменклатуры.Товар;
	Блюдо					= Перечисления.ОбщепитВидыНоменклатуры.Блюдо;
	ТехническийИнгредиент	= Перечисления.ОбщепитВидыНоменклатуры.ТехнологическийОтход;
	Материал				= Перечисления.ОбщепитВидыНоменклатуры.Материал;
	
	ПланСчетовМенеджер		= ПланыСчетов.Хозрасчетный;
	Счет43					= ПланСчетовМенеджер.ГотоваяПродукция;
	Счет41_01				= ПланСчетовМенеджер.ТоварыНаСкладах;
	Счет10_01				= ПланСчетовМенеджер.СырьеИМатериалы;
	Счет10_09				= ПланСчетовМенеджер.ИнвентарьИХозяйственныеПринадлежности;
	
	НоменклатураМенеджер	= Справочники.Номенклатура;
	Шоколадки				= НоменклатураМенеджер.НайтиПоКоду("00-00000062");
	ХолодныеНапитки			= НоменклатураМенеджер.НайтиПоКоду("00-00000054");
	
	Пока Выборка.Следующий() Цикл
		
		ДокументОбъект = Выборка.Ссылка.ПолучитьОбъект();
		
		Для каждого СтрокаТЧ Из ДокументОбъект.Материалы Цикл
			
			Номенклатура	= СтрокаТЧ.Номенклатура;
			ВидНоменклатуры	= Номенклатура.ОбщепитВидНоменклатуры;
			Родитель		= Номенклатура.Родитель;
			
			Если ВидНоменклатуры = Блюдо Тогда
				СтрокаТЧ.Счет = Счет43;
			ИначеЕсли ВидНоменклатуры = ТехническийИнгредиент Тогда
				СтрокаТЧ.Счет = Счет10_01;
			ИначеЕсли ВидНоменклатуры = Материал Тогда
				СтрокаТЧ.Счет = Счет10_09;
			ИначеЕсли ВидНоменклатуры = Товар Тогда
				Если Родитель = Шоколадки Тогда
					СтрокаТЧ.Счет = Счет41_01;
				ИначеЕсли Родитель = ХолодныеНапитки Тогда
					СтрокаТЧ.Счет = Счет41_01;
				Иначе
					СтрокаТЧ.Счет = Счет10_01;
				КонецЕсли;
			КонецЕсли;
			
		КонецЦикла;
		
		Попытка
			ДокументОбъект.Записать(РежимЗаписиДокумента[?(ДокументОбъект.Проведен, "Проведение", "Запись")]);
		Исключение
			Сообщение		= Новый СообщениеПользователю;
			Сообщение.Текст	= "Ошибка записи документа " + Выборка.Представление + ": " + ОписаниеОшибки();
			Сообщение.Сообщить();
		КонецПопытки;
		
	КонецЦикла;
	
	Сообщение		= Новый СообщениеПользователю;
	Сообщение.Текст	= "Обработка документов завершена.";
	Сообщение.Сообщить();
	
КонецПроцедуры

&НаКлиенте
Процедура ИсправитьДокументы(Команда)
	ИсправитьДокументыНаСервере(Объект.ДатаНачала, Объект.ДатаОкончания, Объект.Ответственный);
КонецПроцедуры

// финиш - 15.04.2020
