// Тимур - старт - 19.03.2020
&НаСервереБезКонтекста
Процедура ДозаполнитьНаСервере(ДатаНачала, ДатаОкончания)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ИнвентаризацияТоваровНаСкладе.Ссылка КАК Ссылка,
	|	ИнвентаризацияТоваровНаСкладе.Представление КАК Представление
	|ИЗ
	|	Документ.ИнвентаризацияТоваровНаСкладе КАК ИнвентаризацияТоваровНаСкладе
	|ГДЕ
	|	ИнвентаризацияТоваровНаСкладе.Дата >= &ДатаНачала
	|	И ИнвентаризацияТоваровНаСкладе.Дата <= &ДатаОкончания");
	
	Запрос.УстановитьПараметр("ДатаНачала",		НачалоДня(ДатаНачала));
	Запрос.УстановитьПараметр("ДатаОкончания",	КонецДня(ДатаОкончания));
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Штука				= Справочники.КлассификаторЕдиницИзмерения.НайтиПоКоду("870");
	СтатьяПрочиеДоходы	= Справочники.ПрочиеДоходыИРасходы.ВнереализационныеДоходыПоИнвентаризации;
	Отбор				= Новый Структура("Количество,КоличествоУчет", 0, 0);
	
	Пока Выборка.Следующий() Цикл
		
		ДокументОбъект	= Выборка.Ссылка.ПолучитьОбъект();
		
		Товары			= ДокументОбъект.Товары;
		
		Для каждого СтрокаТЧ Из Товары Цикл
			
			СтрокаТЧ.ЕдиницаИзмерения	= Штука;
			СтрокаТЧ.Коэффициент		= 1;
			
		КонецЦикла;
		
		ДокументОбъект.СтатьяПрочихДоходовРасходов	= СтатьяПрочиеДоходы;
		
		Для каждого СтрокаТЧ Из Товары.НайтиСтроки(Отбор) Цикл
			Товары.Удалить(СтрокаТЧ);
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
Процедура Дозаполнить(Команда)
	ДозаполнитьНаСервере(Объект.ДатаНачала, Объект.ДатаОкончания);
КонецПроцедуры

// финиш - 19.03.2020
