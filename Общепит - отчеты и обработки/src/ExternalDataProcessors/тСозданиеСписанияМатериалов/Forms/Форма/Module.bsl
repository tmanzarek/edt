// Тимур - старт - 15.04.2020

&НаСервереБезКонтекста
Процедура ЗаполнитьНаСервере(ДокументСписания)
	
	ДокументСписанияОбъект = ДокументСписания.ПолучитьОбъект();
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ХозрасчетныйОстатки.Счет КАК Счет,
	|	ВЫРАЗИТЬ(ХозрасчетныйОстатки.Субконто1 КАК Справочник.Номенклатура) КАК Номенклатура,
	|	ВЫРАЗИТЬ(ХозрасчетныйОстатки.Субконто1 КАК Справочник.Номенклатура).НоменклатурнаяГруппа КАК НоменклатурнаяГруппа,
	|	ВЫРАЗИТЬ(ХозрасчетныйОстатки.Субконто1 КАК Справочник.Номенклатура).ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	1 КАК Коэффициент,
	|	ХозрасчетныйОстатки.КоличествоОстатокДт КАК Количество
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.Остатки(&Дата, Счет = &Счет,, Субконто3 = &Склад) КАК ХозрасчетныйОстатки
	|ГДЕ
	|	ХозрасчетныйОстатки.КоличествоОстатокДт > 0
	|УПОРЯДОЧИТЬ ПО
	|	ВЫРАЗИТЬ(ХозрасчетныйОстатки.Субконто1 КАК Справочник.Номенклатура).Наименование,
	|	Количество");
	
	Запрос.УстановитьПараметр("Дата",	КонецМесяца(ДокументСписания.Дата));
	Запрос.УстановитьПараметр("Склад",	ДокументСписания.Склад);
	Запрос.УстановитьПараметр("Счет",	ПланыСчетов.Хозрасчетный.ИнвентарьИХозяйственныеПринадлежности);
	
	ДокументСписанияОбъект.Материалы.Загрузить(Запрос.Выполнить().Выгрузить());
	
	ДокументСписанияОбъект.Комментарий = "" + ТекущаяДата() + " - Документ заполнен обработкой";
	
	Попытка
		ДокументСписанияОбъект.Записать(РежимЗаписиДокумента[?(ДокументСписанияОбъект.Проведен, "Проведение", "Запись")]);
	Исключение
		Сообщение		= Новый СообщениеПользователю;
		Сообщение.Текст	= "Ошибка записи документа " + ДокументСписанияОбъект + ": " + ОписаниеОшибки();
		Сообщение.Сообщить();
		Возврат;
	КонецПопытки;
	
	Сообщение		= Новый СообщениеПользователю;
	Сообщение.Текст	= "Документ " + ДокументСписанияОбъект + " успешно заполнен.";
	Сообщение.Сообщить();
	
КонецПроцедуры

&НаКлиенте
Процедура Заполнить(Команда)
	ЗаполнитьНаСервере(Объект.ДокументСписания);
КонецПроцедуры

// финиш - 15.04.2020


