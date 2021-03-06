// Тимур - старт - 25.03.2020

&НаКлиенте
Процедура Обработать(Команда)
	ОбработатьНаСервере();
КонецПроцедуры

&НаСервере
Процедура ОбработатьНаСервере()
	
	ВывестиСообщение("Начало обработки - " + ТекущаяДата());
	ВывестиСообщение("-----------------------------------");
	
	Запрос	= Новый Запрос(ТекстЗапроса());
	
	Запрос.УстановитьПараметр("ДатаНачала",		НачалоДня(Объект.Период.ДатаНачала));
	Запрос.УстановитьПараметр("ДатаОкончания",	КонецДня(Объект.Период.ДатаОкончания));
	
	РезультатыЗапроса			= Запрос.ВыполнитьПакет();
	РезультатЗапросаПоПродажам	= РезультатыЗапроса[0];
	
	Если РезультатЗапросаПоПродажам.Пустой() Тогда
		ВывестиСообщение("В указанном периоде нет продаж служб доставки.");
		Возврат;
	КонецЕсли;
	
	Отбор						= Новый Структура("Дата,Склад,Номенклатура");
	ВыборкаПоДатамПродажи		= РезультатЗапросаПоПродажам.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	ТЗСписания					= РезультатыЗапроса[1].Выгрузить();
	Соответствие				= Новый Соответствие();
	ДляКакихТоваровНужныАналоги	= Новый Массив;
	
	Пока ВыборкаПоДатамПродажи.Следующий() Цикл
		ВыборкаПоСкладам = ВыборкаПоДатамПродажи.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаПоСкладам.Следующий() Цикл
			ВыборкаПоТоварам = ВыборкаПоСкладам.Выбрать();
			Пока ВыборкаПоТоварам.Следующий() Цикл
				
				ЗаполнитьЗначенияСвойств(Отбор, ВыборкаПоТоварам);
				ОсталосьСписать = ВыборкаПоТоварам.Количество;
				
				Номенклатура = ВыборкаПоТоварам.Номенклатура;
				
				ВывестиСообщение("Обрабатываем номенклатуру """ + Номенклатура + """ (надо списать - " + ОсталосьСписать + " шт.):");
				
				СписатьИзТребованияНакладной(ОсталосьСписать, Отбор, ТЗСписания, Соответствие, ДляКакихТоваровНужныАналоги);
				
				Если ОсталосьСписать > 0 Тогда
					
					Номенклатура = ВыборкаПоТоварам.Номенклатура;
					
					Для каждого СтрокаАналога Из Аналоги Цикл
						Если СтрокаАналога.Номенклатура = Номенклатура Тогда
							
							Отбор.Номенклатура = СтрокаАналога.Аналог;
							СписатьИзТребованияНакладной(ОсталосьСписать, Отбор, ТЗСписания, Соответствие, ДляКакихТоваровНужныАналоги);
							
							Если ОсталосьСписать <= 0 Тогда
								Прервать;
							КонецЕсли;
							
						КонецЕсли;
					КонецЦикла;
					
				КонецЕсли;
					
				Если ОсталосьСписать > 0 Тогда
					
					ВывестиСообщение("В требованиях-накладных за дату " + Формат(ВыборкаПоТоварам.Дата, "ДФ=dd.MM.yyyy") +
									" по складу """ + ВыборкаПоТоварам.Склад + """ по товару """ + Номенклатура + """" +
									" недостаточно количества к списанию. Не хватает - " + ОсталосьСписать + "шт.");
					
					Если ДляКакихТоваровНужныАналоги.Найти(Номенклатура) = Неопределено Тогда
						ДляКакихТоваровНужныАналоги.Добавить(Номенклатура);
					КонецЕсли;
					
				КонецЕсли;
				
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	
	Если Объект.ИзменятьДокументыСписания Тогда
		
		ЕстьОшибки	= Ложь;
		
		НачатьТранзакцию();
		
		Для каждого ЭлементСоответствия Из Соответствие Цикл
			ТребованиеНакладнаяОбъект	= ЭлементСоответствия.Значение;
			Попытка
				Если ТребованиеНакладнаяОбъект.Материалы.Количество() Тогда
					ТребованиеНакладнаяОбъект.Записать(РежимЗаписиДокумента.Проведение);
					ВывестиСообщение("Проведен документ " + ТребованиеНакладнаяОбъект);
				Иначе
					ТребованиеНакладнаяОбъект.Прочитать();
					ТребованиеНакладнаяОбъект.УстановитьПометкуУдаления(Истина);
					ВывестиСообщение("Установлена пометка на удаление у документа " + ТребованиеНакладнаяОбъект);
				КонецЕсли;
			Исключение
				ЕстьОшибки			= Истина;
				ВывестиСообщение("Ошибка при проведении документа " + ТребованиеНакладнаяОбъект + ": " + ОписаниеОшибки());
				
				
				ОтменитьТранзакцию();
				Возврат;
				
			КонецПопытки;
		КонецЦикла;
		
		Если ЕстьОшибки Тогда
			ОтменитьТранзакцию();
			ПостфиксСообщения	= " с ошибками";
		Иначе
			ЗафиксироватьТранзакцию();
			ПостфиксСообщения	= "без ошибок";
		КонецЕсли;
		
	ИначеЕсли ДляКакихТоваровНужныАналоги.Количество() Тогда
		ПостфиксСообщения	= " с ошибками";

	ИначеЕсли НЕ ДляКакихТоваровНужныАналоги.Количество() Тогда
		ПостфиксСообщения	= "без ошибок";
	КонецЕсли;
	
	Если ДляКакихТоваровНужныАналоги.Количество() Тогда
		ВывестиСообщение("Для следующих товаров необходимо указать аналоги:");
		Отбор = Новый Структура("Номенклатура");
		Для каждого ЭлементМассива Из ДляКакихТоваровНужныАналоги Цикл
			Отбор.Номенклатура	= ЭлементМассива;
			Если НЕ Аналоги.НайтиСтроки(Отбор).Количество() Тогда
				НоваяСтрока					= Аналоги.Добавить();
				НоваяСтрока.Номенклатура	= ЭлементМассива;
				ВывестиСообщение(ЭлементМассива);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	ВывестиСообщение("-----------------------------------");
	ВывестиСообщение("Обработка завершена " + ПостфиксСообщения + " - " + ТекущаяДата());
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ТекстЗапроса()
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ОтчетОРозничныхПродажахТовары.Ссылка.Склад КАК Склад,
	|	НАЧАЛОПЕРИОДА(ОтчетОРозничныхПродажахТовары.Ссылка.Дата, ДЕНЬ) КАК Дата,
	|	ОтчетОРозничныхПродажахТовары.Номенклатура КАК Номенклатура,
	|	СУММА(ОтчетОРозничныхПродажахТовары.Количество) КАК Количество
	|ИЗ
	|	Документ.ОтчетОРозничныхПродажах.Товары КАК ОтчетОРозничныхПродажахТовары
	|ГДЕ
	|	ОтчетОРозничныхПродажахТовары.Ссылка.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
	|	И ПОДСТРОКА(ОтчетОРозничныхПродажахТовары.Ссылка.Комментарий, 0, 100) ПОДОБНО ""%Код заказа%сумма заказа%""
	|
	|СГРУППИРОВАТЬ ПО
	|	ОтчетОРозничныхПродажахТовары.Ссылка.Склад,
	|	ОтчетОРозничныхПродажахТовары.Номенклатура,
	|	НАЧАЛОПЕРИОДА(ОтчетОРозничныхПродажахТовары.Ссылка.Дата, ДЕНЬ)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата,
	|	Склад,
	|	Номенклатура
	|ИТОГИ
	|	СУММА(Количество)
	|ПО
	|	Дата,
	|	Склад
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТребованиеНакладнаяМатериалы.Ссылка.Склад КАК Склад,
	|	НАЧАЛОПЕРИОДА(ТребованиеНакладнаяМатериалы.Ссылка.Дата, ДЕНЬ) КАК Дата,
	|	ТребованиеНакладнаяМатериалы.Ссылка.Дата КАК ДатаИВремяСписания,
	|	ТребованиеНакладнаяМатериалы.Ссылка КАК ТребованиеНакладная,
	|	ТребованиеНакладнаяМатериалы.НомерСтроки КАК НомерСтроки,
	|	ТребованиеНакладнаяМатериалы.Номенклатура КАК Номенклатура,
	|	ТребованиеНакладнаяМатериалы.Количество КАК Количество
	|ИЗ
	|	Документ.ТребованиеНакладная.Материалы КАК ТребованиеНакладнаяМатериалы
	|ГДЕ
	|	ТребованиеНакладнаяМатериалы.Ссылка.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
	|
	|УПОРЯДОЧИТЬ ПО
	|	Склад,
	|	ДатаИВремяСписания,
	|	ТребованиеНакладная,
	|	НомерСтроки";
	Возврат ТекстЗапроса;
КонецФункции // ТекстЗапроса()

&НаСервереБезКонтекста
Процедура СписатьИзТребованияНакладной(ОсталосьСписать, Отбор, ТЗСписания, Соответствие, ДляКакихТоваровНужныАналоги)
	
	Для каждого СтрокаСписанияТовара Из ТЗСписания.НайтиСтроки(Отбор) Цикл
		
		Если ОсталосьСписать <= 0 Тогда
			Прервать;
		КонецЕсли;
		
		ТребованиеНакладнаяСсылка	= СтрокаСписанияТовара.ТребованиеНакладная;
		ТребованиеНакладнаяОбъект	= НайтиСоответствие(ТребованиеНакладнаяСсылка, Соответствие);
		Если ТребованиеНакладнаяОбъект = Неопределено Тогда
			ТребованиеНакладнаяОбъект = ТребованиеНакладнаяСсылка.ПолучитьОбъект();
			Соответствие.Вставить(ТребованиеНакладнаяСсылка, ТребованиеНакладнаяОбъект);
		КонецЕсли;
		
		Материалы				= ТребованиеНакладнаяОбъект.Материалы;
		НомерСтроки				= 0;
		Номенклатура			= Отбор.Номенклатура;
		СтрокаТЧ				= НайтиСтроку(Материалы, Номенклатура, НомерСтроки);
		Если СтрокаТЧ = Неопределено Тогда
			
			ТекстСообщения = "В требованиях-накладных за дату " + Формат(Отбор.Дата, "ДФ=dd.MM.yyyy") +
			" по складу """ + Отбор.Склад + """ по товару """ + Номенклатура + """" +
			" недостаточно количества к списанию. Не хватает - " + ОсталосьСписать + "шт.";
			
			Если ДляКакихТоваровНужныАналоги.Найти(Номенклатура) = Неопределено Тогда
				ДляКакихТоваровНужныАналоги.Добавить(Номенклатура);
			КонецЕсли;
		Иначе
			КоличествоИзТребования	= СтрокаТЧ.Количество;
			
			Если КоличествоИзТребования <= ОсталосьСписать Тогда
				Материалы.Удалить(СтрокаТЧ);
				ТекстСообщения	= "В документе " + ТребованиеНакладнаяСсылка + " удалена строка № " + НомерСтроки + " с товаром """ + Номенклатура + """ и количеством " + КоличествоИзТребования + " шт.";
				ОсталосьСписать	= ОсталосьСписать - КоличествоИзТребования;
			Иначе
				СтрокаТЧ.Количество	= КоличествоИзТребования - ОсталосьСписать;
				ТекстСообщения		= "В документе " + ТребованиеНакладнаяСсылка + " в строке № " + НомерСтроки + " с товаром """ + Номенклатура + """ уменьшено количество на " + ОсталосьСписать + " шт.";
				ОсталосьСписать		= 0;
			КонецЕсли;
		КонецЕсли;
		
		ВывестиСообщение(ТекстСообщения);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция НайтиСоответствие(Ключ, Соответствие)
	Для каждого ЭлементСоответствия Из Соответствие Цикл
		Если ЭлементСоответствия.Ключ = Ключ Тогда
			Результат	= ЭлементСоответствия.Значение;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	Возврат Результат;
КонецФункции // НайтиСоответствие()

&НаСервереБезКонтекста
Функция НайтиСтроку(Материалы, Номенклатура, НомерСтроки)
	Для каждого СтрокаТЧ Из Материалы Цикл
		Если СтрокаТЧ.Номенклатура = Номенклатура Тогда
			Результат	= СтрокаТЧ;
			НомерСтроки	= СтрокаТЧ.НомерСтроки;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	Возврат Результат;
КонецФункции // НайтиСтроку()

&НаСервереБезКонтекста
Процедура ВывестиСообщение(ТекстСообщения)
	Сообщение			= Новый СообщениеПользователю;
	Сообщение.Текст		= ТекстСообщения;
	Сообщение.Сообщить();
КонецПроцедуры // ВывестиСообщение()

// финиш - 25.03.2020
