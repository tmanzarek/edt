
Процедура ОбработкаПроведения(Отказ, Режим)
	Движения.СуточныйГрафик.Записывать = Истина;
	Движения.СуточныйГрафик.Очистить();
	Для Каждого СтрокаТЧ Из Выполнение Цикл
		Движение = Движения.СуточныйГрафик.Добавить();
		Движение.Период = Дата;
		Движение.Подрядчик = СтрокаТЧ.Подрядчик;
		Движение.Титул = СтрокаТЧ.Титул;
		Движение.ШифрПроекта = СтрокаТЧ.ШифрПроекта;
		Движение.ЛокальнаяСмета = СтрокаТЧ.НомерЛокальнойСметы;
		Движение.СМР = СтрокаТЧ.НаименованиеСМР;
		Движение.ЕдИзм = СтрокаТЧ.ЕдиницаИзмерения;
		Движение.ДатаВыполнения = Дата;
		Движение.ФактОбъёмВыполнения = СтрокаТЧ.Объём;
	КонецЦикла;
КонецПроцедуры
