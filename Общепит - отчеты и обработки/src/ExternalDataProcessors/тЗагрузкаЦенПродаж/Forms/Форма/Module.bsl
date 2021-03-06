// Тимур - старт - 29.01.2020

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ЧтоЗагружаем = "СигмаЧеки";
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ПутьНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка				= Ложь;
	Диалог								= Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	Диалог.Заголовок					= "Укажите файл для загрузки:";
	Диалог.Фильтр						= "Текстовый файл с разделителями файлы (*.csv)|*.csv";
	Диалог.ПроверятьСуществованиеФайла	= Истина;
	Диалог.ПолноеИмяФайла				= Путь;
	Если Диалог.Выбрать() Тогда
		Путь = Диалог.ПолноеИмяФайла;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПутьОткрытие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ЗапуститьПриложение(Путь);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Загрузить(Команда)
	Если ПустаяСтрока(ЧтоЗагружаем) ИЛИ ПустаяСтрока(Путь) Тогда
		Сообщение		= Новый СообщениеПользователю;
		Сообщение.Текст	= "Не заполнены объязательные поля ""Что заполняем"" или ""Путь""!";
		Сообщение.Сообщить();
	Иначе
		ЗагрузитьНаСервере(ЧтоЗагружаем, Путь);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОсновныеПроцедурыИФункцииЗагрузки

&НаСервереБезКонтекста
Процедура ЗагрузитьНаСервере(ЧтоЗагружаем, Путь)
	
	Перем Колонки;
	
	ТЗ = СоздатьТЗ(Колонки, ЧтоЗагружаем);
	ПрочитатьФайл(Путь, ТЗ, Колонки, ЧтоЗагружаем = "delivery club");
	ОбработатьТЗ(ТЗ, ЧтоЗагружаем);
	ЗагрузитьВДокументы(ТЗ, ЧтоЗагружаем);
	
КонецПроцедуры // ЗагрузитьНаСервере()

&НаСервереБезКонтекста
Функция СоздатьТЗ(Колонки, ВидЗагрузки)
	
	ТЗ		= Новый ТаблицаЗначений;
	Колонки	= ТЗ.Колонки;
	
	Если ВидЗагрузки = "Цены"  Тогда
		Колонки.Добавить("Наименование");
		Колонки.Добавить("Артикул");
		Колонки.Добавить("ЕдиницаИзмерения");
		Колонки.Добавить("Штрихкод");
		Колонки.Добавить("Категория");
		Колонки.Добавить("СтавкаНДС");
		Колонки.Добавить("Цена");
	ИначеЕсли ВидЗагрузки = "СигмаЧеки" Тогда
		Колонки.Добавить("Дата");
		Колонки.Добавить("Время");
		Колонки.Добавить("НомерЧека");
		Колонки.Добавить("НазваниеРесторана");
		Колонки.Добавить("КодТовара");
		Колонки.Добавить("ТипОперации");
		Колонки.Добавить("СпособОплаты");
		Колонки.Добавить("ПризнакСпособаРасчетов");
		Колонки.Добавить("НаименованиеТовара");
		Колонки.Добавить("Модификатор");
		Колонки.Добавить("Категория");
		Колонки.Добавить("Цех");
		Колонки.Добавить("ЕдиницаИзмерения");
		Колонки.Добавить("Количество");
		Колонки.Добавить("Цена");
		Колонки.Добавить("Сумма");
		Колонки.Добавить("Скидка");
		Колонки.Добавить("ТипКартыЛояльности");
		Колонки.Добавить("НомерКартыЛояльности");
		Колонки.Добавить("Комментарий");
		Колонки.Добавить("Кассир");
	ИначеЕсли ВидЗагрузки = "delivery club" Тогда
		Колонки.Добавить("КодЗаказа");
		Колонки.Добавить("КодРесторана");
		Колонки.Добавить("НазваниеРесторана");
		Колонки.Добавить("АдресКлиента");
		Колонки.Добавить("ТелефонКлиента");
		Колонки.Добавить("СуммаБезСкидки");
		Колонки.Добавить("Скидка");
		Колонки.Добавить("Стоимость");
		Колонки.Добавить("СтоимостьТары");
		Колонки.Добавить("СтоимостьДоставки");
		Колонки.Добавить("СервисныйСборРесторана");
		Колонки.Добавить("КурьерПлатит");
		Колонки.Добавить("СпособОплаты");
		Колонки.Добавить("Позиции");
		Колонки.Добавить("ПозицииЗаказа");
		Колонки.Добавить("ДатаДоставки");
		Колонки.Добавить("ОжидаемоеВремяДоставки");
		Колонки.Добавить("ТипДоставки");
		Колонки.Добавить("Статус");
		Колонки.Добавить("ПричинаОтмены");
	Иначе // Яндекс.Еда
		Колонки.Добавить("НазваниеРесторана");
		Колонки.Добавить("ДатаДоставки");
		Колонки.Добавить("КодЗаказа");
		Колонки.Добавить("Стоимость");
		Колонки.Добавить("Скидка");
		Колонки.Добавить("СпособОплаты");
		Колонки.Добавить("Блюда");
		Колонки.Добавить("Статус");
		Колонки.Добавить("БудетОплачен");
	КонецЕсли;
	
	Возврат ТЗ;
	
КонецФункции // СоздатьТЗ()

&НаСервереБезКонтекста
Процедура ПрочитатьФайл(ПутьКФайлу, ТЗ, Колонки, ДеливериКлаб)
	
	Текст = Новый ЧтениеТекста(ПутьКФайлу);
	
	// Деливери клаб:
	//	строка № 1 - служебная информация
	//	строка № 2 - заголовки полей
	//	строка № 3 - первая строка с данными
	// Чеки,Цены,Яндекс.Еда:
	//	строка № 1 - заголовки полей
	//	строка № 2 - первая строка с данными
	Для Счетчик = 1 По ?(ДеливериКлаб, 3, 2) Цикл
		СтрокаТекста = Текст.ПрочитатьСтроку();
	КонецЦикла;
	
	Пока СтрокаТекста <> Неопределено Цикл
		НоваяСтрокаТЗ = ТЗ.Добавить();
		Для каждого Колонка Из Колонки Цикл
			ПозицияРазделителя = Найти(СтрокаТекста, ";");
			ИмяКолонки = Колонка.Имя;
			Если ПозицияРазделителя Тогда
				ЗначениеПоля = Лев(СтрокаТекста, ПозицияРазделителя - 1);
				Если ИмяКолонки = "Позиции" Тогда
					// только для Деливери клаб
					СтрокаТекста			= ПреобразоватьСтрокуТекста(СтрокаТекста, ЗначениеПоля);
				КонецЕсли;
				НоваяСтрокаТЗ[ИмяКолонки]	= СокрЛП(ЗначениеПоля);
				СтрокаТекста				= Сред(СтрокаТекста, ПозицияРазделителя + 1);
			Иначе
				НоваяСтрокаТЗ[ИмяКолонки]	= СокрЛП(СтрокаТекста);
			КонецЕсли;
		КонецЦикла;
		СтрокаТекста = Текст.ПрочитатьСтроку();
	КонецЦикла;
	
	Текст.Закрыть();
	
КонецПроцедуры // ПрочитатьФайл()

&НаСервереБезКонтекста
Процедура ОбработатьТЗ(ТЗ, ВидЗагрузки)
	Если ВидЗагрузки = "Цены"  Тогда
		НоменклатурныеГруппыМенеджер = Справочники.НоменклатурныеГруппы;
		БезНДС	= Перечисления.СтавкиНДС.БезНДС;
		Штука	= Справочники.КлассификаторЕдиницИзмерения.НайтиПоКоду("796");
		Для каждого СтрокаТЗ Из ТЗ Цикл
			СтрокаТЗ.ЕдиницаИзмерения	= Штука;
			СтрокаТЗ.Категория			= НайтиСоздатьНомеклатурнуюГруппу(СтрокаТЗ.Категория, НоменклатурныеГруппыМенеджер);
			СтрокаТЗ.СтавкаНДС			= БезНДС;
			СтрокаТЗ.Цена				= Число(СтрокаТЗ.Цена);
		КонецЦикла;
	ИначеЕсли ВидЗагрузки = "СигмаЧеки" Тогда
		ПользователиМенеджер			= Справочники.Пользователи;
		НоменклатурныеГруппыМенеджер	= Справочники.НоменклатурныеГруппы;
		Штука							= Справочники.КлассификаторЕдиницИзмерения.НайтиПоКоду("796");
		Для каждого СтрокаТЗ Из ТЗ Цикл
			СтрокаТЗ.Дата				= СтрокуВДату(СтрокаТЗ.Дата, Истина, СтрокаТЗ.Время);
			СтрокаТЗ.Категория			= НайтиСоздатьНомеклатурнуюГруппу(СтрокаТЗ.Категория, НоменклатурныеГруппыМенеджер);
			СтрокаТЗ.ЕдиницаИзмерения	= Штука;
			СтрокаТЗ.Количество			= Число(СтрокаТЗ.Количество);
			СтрокаТЗ.Цена				= Число(СтрокаТЗ.Цена);
			СтрокаТЗ.Сумма				= Число(СтрокаТЗ.Сумма);
			СтрокаТЗ.Скидка				= Число(СтрокаТЗ.Скидка);
			СтрокаТЗ.Кассир				= НайтиСоздатьПользователя(СтрокаТЗ.Кассир, ПользователиМенеджер);
		КонецЦикла;
	ИначеЕсли ВидЗагрузки = "delivery club" Тогда
		Для каждого СтрокаТЗ Из ТЗ Цикл
			СтрокаТЗ.АдресКлиента			= СтрЗаменить(СтрокаТЗ.АдресКлиента, """", "");
			СтрокаТЗ.КурьерПлатит			= Число(СтрокаТЗ.КурьерПлатит);
			СтрокаТЗ.НазваниеРесторана		= СтрЗаменить(СтрокаТЗ.НазваниеРесторана, """", "");
			СтрокаТЗ.ДатаДоставки			= СтрокуВДату(СтрокаТЗ.ДатаДоставки, Истина);
			СтрокаТЗ.Позиции				= Число(СтрокаТЗ.Позиции);
			СтрокаТЗ.СервисныйСборРесторана	= Число(СтрокаТЗ.СервисныйСборРесторана);
			СтрокаТЗ.Скидка					= Число(СтрокаТЗ.Скидка);
			СтрокаТЗ.СпособОплаты			= СтрЗаменить(СтрокаТЗ.СпособОплаты, """", "");
			СтрокаТЗ.Стоимость				= Число(СтрокаТЗ.Стоимость);
			СтрокаТЗ.СтоимостьДоставки		= Число(СтрокаТЗ.СтоимостьДоставки);
			СтрокаТЗ.СтоимостьТары			= Число(СтрокаТЗ.СтоимостьТары);
			СтрокаТЗ.СуммаБезСкидки			= Число(СтрокаТЗ.СуммаБезСкидки);
			СтрокаТЗ.ТелефонКлиента			= СтрЗаменить(СтрокаТЗ.ТелефонКлиента, """", "");
		КонецЦикла;
	Иначе // Яндекс.Еда
		Для каждого СтрокаТЗ Из ТЗ Цикл
			СтрокаТЗ.ДатаДоставки	= СтрокуВДату(СтрокаТЗ.ДатаДоставки, Ложь);
			СтрокаТЗ.Стоимость		= Число(СтрокаТЗ.Стоимость);
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры // ОбработатьТЗ()

&НаСервереБезКонтекста
Процедура ЗагрузитьВДокументы(ТЗ, ВидЗагрузки)
	Если ВидЗагрузки = "Цены" Тогда
		ЗагрузитьЦены(ТЗ);
	ИначеЕсли ВидЗагрузки = "СигмаЧеки" Тогда
		ЗагрузитьЧеки(ТЗ, ВидЗагрузки);
	Иначе
		ЗагрузитьПродажи(ТЗ, ВидЗагрузки);
	КонецЕсли;
КонецПроцедуры // ЗагрузитьВДокументы()

&НаСервереБезКонтекста
Процедура ЗагрузитьЦены(ТЗ)
	Документ							= Документы.УстановкаЦенНоменклатуры.СоздатьДокумент();
	Документ.Дата						= ТекущаяДата();
	Документ.ТипЦен						= Справочники.ТипыЦенНоменклатуры.РозничнаяЦена;
	Документ.НеПроводитьНулевыеЗначения	= Истина;
	Документ.Комментарий				= "Создан с помощью обработки загрузки " + ТекущаяДата();
	Документ.Информация					= "Розничная цена";
	Документ.Ответственный				= ПараметрыСеанса.ТекущийПользователь;
	Документ.УстановитьНовыйНомер();
	
	ОбщиеСвойстваТовара	= Новый Структура("Валюта,Коэффициент", Константы.ВалютаРегламентированногоУчета.Получить(), 1);
	
	НоменклатураМенеджер	= Справочники.Номенклатура;
	Товары					= Документ.Товары;
	
	Всего						= ТЗ.Количество();
	СписокНезагруженныхТоваров	= "";
	СчетчикНезагруженныхЦен		= 0;
	СчетчикЗагруженныхЦен		= 0;
	Счетчик						= 0;
	
	Для каждого СтрокаТЗ Из ТЗ Цикл
		
		Счетчик				= Счетчик + 1;
		НаименованиеТовара	= СтрокаТЗ.Наименование;
		Номенклатура		= ПолучитьНоменклатуру(НаименованиеТовара, НоменклатураМенеджер, Ложь);
		
		Если НЕ Номенклатура.Пустая() Тогда
			НоваяСтрокаТЧ				= Товары.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрокаТЧ, ОбщиеСвойстваТовара);
			ЗаполнитьЗначенияСвойств(НоваяСтрокаТЧ, СтрокаТЗ);
			НоваяСтрокаТЧ.Номенклатура	= Номенклатура;
			Если Номенклатура.НоменклатурнаяГруппа.Пустая() Тогда
				НоменклатураОбъект						= Номенклатура.ПолучитьОбъект();
				НоменклатураОбъект.НоменклатурнаяГруппа	= СтрокаТЗ.Категория;
				НоменклатураОбъект.Записать();
			КонецЕсли;
			СчетчикЗагруженныхЦен		= СчетчикЗагруженныхЦен + 1;
		Иначе
			СчетчикНезагруженныхЦен		= СчетчикНезагруженныхЦен + 1;
			СписокНезагруженныхТоваров	= СписокНезагруженныхТоваров + НаименованиеТовара + "    ";
		КонецЕсли;
	КонецЦикла;
	
	Если Товары.Количество() Тогда
		ДокументУспешноПроведен		= Истина;
		Попытка
			Документ.Записать(РежимЗаписиДокумента.Запись);
			Документ.Записать(РежимЗаписиДокумента.Проведение);
		Исключение
			ДокументУспешноПроведен	= Ложь;
			Сообщить("Ошибка при создании документа " + Документ + ": " + ОписаниеОшибки(), СтатусСообщения.Важное);
		КонецПопытки;
	КонецЕсли;
	
	Если ДокументУспешноПроведен Тогда
		Сообщить("Обработано строк: " + Число(Счетчик + 1) + " из " + Число(Всего + 1) + ", загружено цен: " + СчетчикЗагруженныхЦен + ", не загружено цен: " + СчетчикНезагруженныхЦен, СтатусСообщения.Информация);
		Если СчетчикНезагруженныхЦен Тогда
			Сообщить("------------------------------", СтатусСообщения.Важное);
			Сообщить("Список товаров с незагруженными ценами: " + СокрЛП(СписокНезагруженныхТоваров), СтатусСообщения.Важное);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры // ЗагрузитьЦены()

&НаСервереБезКонтекста
Процедура ЗагрузитьЧеки(ТЗ, ВидЗагрузки)
	ТЗЧеки = ТЗ.Скопировать();
	ТЗЧеки.Свернуть("НомерЧека,Дата,ТипОперации,НазваниеРесторана,Кассир");
	ТЗЧеки.Сортировать("Дата");
	
	НоменклатураМенеджер			= Справочники.Номенклатура;
	СкладыМенеджер					= Справочники.Склады;
	РозничнаяПродажаМенеджер		= Документы.РозничнаяПродажа;
	ВидыОперацийМенеджер			= Перечисления.ВидыОперацийРозничнаяПродажа;
	БезНДС							= Перечисления.СтавкиНДС.БезНДС;
	ВидОплаты						= Справочники.ВидыОплатОрганизаций.НайтиПоНаименованию("Платежная карта");
	Отбор							= Новый Структура("Дата,НомерЧека");
	НазванияТочекПродаж				= ПолучитьНазванияТочекПродаж(ВидЗагрузки);
	
	ОбщиеСвойстваДокумента		= Новый Структура("Организация,ТипЦен,ДокументБезНДС,ВалютаДокумента,КурсДокумента,КратностьДокумента,СчетКасса",
		Справочники.Организации.ОрганизацияПоУмолчанию(), Справочники.ТипыЦенНоменклатуры.РозничнаяЦена, Истина, Константы.ВалютаРегламентированногоУчета.Получить(),
		1, 1, ПланыСчетов.Хозрасчетный.КассаОрганизации);
		
	Всего						= ТЗ.Количество();
	СписокНезагруженныхЧеков	= "";
	СчетчикНезагруженныхЧеков	= 0;
	СчетчикЗагруженныхЧеков		= 0;
	СчетчикЗагруженныхПродаж	= 0;
	Счетчик						= 0;
	
	Для каждого СтрокаТЗЧеки Из ТЗЧеки Цикл
		
		НомерЧека					= СтрокаТЗЧеки.НомерЧека;
		Документ					= НайтиСоздатьРозничнуюПродажу(НомерЧека, СтрокаТЗЧеки.Дата, РозничнаяПродажаМенеджер);
		ЗаполнитьЗначенияСвойств(Документ, ОбщиеСвойстваДокумента);
		Документ.Дата				= СтрокаТЗЧеки.Дата;
		Документ.ВидОперации		= ВидыОперацийМенеджер[?(СтрокаТЗЧеки.ТипОперации = "Приход", "Продажа", "Возврат")];
		Документ.Склад				= СкладыМенеджер.НайтиПоНаименованию(НазванияТочекПродаж[СтрокаТЗЧеки.НазваниеРесторана]);
		Документ.Ответственный		= СтрокаТЗЧеки.Кассир;
		Документ.Комментарий		= "№ чека - " + НомерЧека;
		
		Если ПустаяСтрока(Документ.Номер) Тогда
			Документ.УстановитьНовыйНомер();
		КонецЕсли;
		
		Товары				= Документ.Товары;
		БезналичнаяСумма	= 0;
		
		Товары.Очистить();
		
		ЗаполнитьЗначенияСвойств(Отбор, СтрокаТЗЧеки);
		Для каждого СтрокаЧека Из ТЗ.НайтиСтроки(Отбор) Цикл
			Счетчик				= Счетчик + 1;
			НаименованиеТовара	= СтрокаЧека.НаименованиеТовара;
			Номенклатура	= ПолучитьНоменклатуру(НаименованиеТовара, НоменклатураМенеджер, Ложь);
			Если НЕ Номенклатура.Пустая() Тогда
				НоваяСтрокаТЧ				= Товары.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрокаТЧ, СтрокаЧека, "Количество,Цена,Сумма");
				НоваяСтрокаТЧ.СтавкаНДС		= БезНДС;
				НоваяСтрокаТЧ.Номенклатура	= Номенклатура;
				Комментарий					= СтрокаЧека.Комментарий;
				Если НЕ ПустаяСтрока(Комментарий) Тогда
					Документ.Комментарий	= Документ.Комментарий + "; № стр. " + Формат(НоваяСтрокаТЧ.НомерСтроки, "ЧГ=") + ": " + Комментарий;
				КонецЕсли;
				Если Номенклатура.НоменклатурнаяГруппа.Пустая() Тогда
					НоменклатураОбъект						= Номенклатура.ПолучитьОбъект();
					НоменклатураОбъект.НоменклатурнаяГруппа	= СтрокаЧека.Категория;
					НоменклатураОбъект.Записать();
				КонецЕсли;
				СчетчикЗагруженныхПродаж	= СчетчикЗагруженныхПродаж + 1;
				
				Если СтрокаЧека.СпособОплаты = "Безналичный" Тогда
					БезналичнаяСумма = БезналичнаяСумма + СтрокаЧека.Сумма;
				КонецЕсли;
			Иначе
				Сообщить("ОШИБКА: В чеке № " + НомерЧека + " не найден товар """ + НаименованиеТовара + """", СтатусСообщения.Важное);
			КонецЕсли;
			
		КонецЦикла;
		
		Если БезналичнаяСумма  Тогда
			ТЧОплата					= Документ.Оплата;
			ТЧОплата.Очистить();
			СтрокаОплаты				= ТЧОплата.Добавить();
			СтрокаОплаты.ВидОплаты		= ВидОплаты;
			СтрокаОплаты.Сумма			= БезналичнаяСумма;
		КонецЕсли;
		
		Документ.СуммаДокумента = Товары.Итог("Сумма");
		
		Попытка
			Документ.Записать(РежимЗаписиДокумента.Запись);
			Если Документ.ПометкаУдаления Тогда
				Документ.УстановитьПометкуУдаления(Ложь);
			КонецЕсли;
			СчетчикЗагруженныхЧеков = СчетчикЗагруженныхЧеков + 1;
		Исключение
			Сообщить("Ошибка при создании документа " + Документ + ": " + ОписаниеОшибки(), СтатусСообщения.Важное);
			СчетчикНезагруженныхЧеков	= СчетчикНезагруженныхЧеков + 1;
			СписокНезагруженныхЧеков	= СписокНезагруженныхЧеков + НомерЧека + "  ";
		КонецПопытки;
		
	КонецЦикла;
	
	КоличествоСлужебныхСтрок = 1;
	Сообщить("Обработано строк: " + Число(Счетчик + КоличествоСлужебныхСтрок) + " из " + Число(Всего + КоличествоСлужебныхСтрок) + ", загружено продаж: " + СчетчикЗагруженныхПродаж + ", загружено чеков: " + СчетчикЗагруженныхЧеков + ", не загружено чеков: " + СчетчикНезагруженныхЧеков, СтатусСообщения.Информация);
	Если СчетчикНезагруженныхЧеков Тогда
		Сообщить("------------------------------", СтатусСообщения.Важное);
		Сообщить("Список незагруженных чеков: " + СокрЛП(СписокНезагруженныхЧеков), СтатусСообщения.Важное);
	КонецЕсли;
	
КонецПроцедуры // ЗагрузитьЧеки()

&НаСервереБезКонтекста
Процедура ЗагрузитьПродажи(ТЗ, ВидЗагрузки)
	// На каждый заказ создается отдельный документ
	ТЗ.Сортировать("ДатаДоставки");
	
	ДеливериКлаб					= ВидЗагрузки = "delivery club";
	ХозрасчетныйМенеджер			= ПланыСчетов.Хозрасчетный;
	НоменклатураМенеджер			= Справочники.Номенклатура;
	СкладыМенеджер					= Справочники.Склады;
	ОбщепитКассыККММенеджер			= Справочники.ОбщепитКассыККМ;
	ОтчетОРозничныхПродажахМенеджер	= Документы.ОтчетОРозничныхПродажах;
	ВидОплаты						= Справочники.ВидыОплатОрганизаций.НайтиПоНаименованию(?(ДеливериКлаб, "Деливери клаб", "Яндекс.Еда"));
	БезНДС							= Перечисления.СтавкиНДС.БезНДС;
	
	НазванияТочекПродаж				= ПолучитьНазванияТочекПродаж(ВидЗагрузки);
	
	ОбщиеСвойстваДокумента		= Новый Структура("ВидОперации,Организация,СчетКасса,СтатьяДвиженияДенежныхСредств,ВалютаДокумента,КурсДокумента,КратностьДокумента,СуммаВключаетНДС,Ответственный",
		Перечисления.ВидыОперацийОтчетОРозничныхПродажах.ОтчетККМОПродажах, Справочники.Организации.ОрганизацияПоУмолчанию(), ХозрасчетныйМенеджер.КассаОрганизации, Справочники.СтатьиДвиженияДенежныхСредств.РозничнаяВыручка,
		Константы.ВалютаРегламентированногоУчета.Получить(), 1, 1, Ложь, ПараметрыСеанса.ТекущийПользователь);
	ОбщиеСвойстваСтрокиТЧТовары	= Новый Структура("СтавкаНДС,СчетУчета,СчетДоходов,СчетУчетаНДСПоРеализации,СчетРасходов,Коэффициент",
		БезНДС, ХозрасчетныйМенеджер.ТоварыНаСкладах,ХозрасчетныйМенеджер.ВыручкаНеЕНВД, ХозрасчетныйМенеджер.Продажи_НДС,ХозрасчетныйМенеджер.СебестоимостьПродажНеЕНВД, 1);
		
	Параметры					= Новый Структура("Дата,Организация,ДеятельностьНаПатенте,Склад,ТипЦен,ВалютаДокумента,КурсВзаиморасчетов,КратностьВзаиморасчетов,СуммаВключаетНДС,СтавкаНДС");
	Параметры.СтавкаНДС			= БезНДС;
	
	Всего						= ТЗ.Количество();
	СписокНезагруженныхЗаказов	= "";
	СчетчикНезагруженныхЗаказов	= 0;
	СчетчикЗагруженныхЗаказов	= 0;
	Счетчик						= 0;
	
	Для каждого СтрокаТЗ Из ТЗ Цикл
		
		Счетчик	= Счетчик + 1;
		
		Статус	= СтрокаТЗ.Статус;
		Если ДеливериКлаб И Статус <> "Доставлен" ИЛИ НЕ ДеливериКлаб И Статус = "Отклонен" Тогда
			СчетчикНезагруженныхЗаказов	= СчетчикНезагруженныхЗаказов + 1;
			СписокНезагруженныхЗаказов	= СписокНезагруженныхЗаказов + СтрокаТЗ.КодЗаказа + "  ";
			Продолжить;
		КонецЕсли;
		
		КодЗаказа	= СтрокаТЗ.КодЗаказа;
		
		Документ	= НайтиСоздатьДокументПродажи(КодЗаказа, ОтчетОРозничныхПродажахМенеджер, ДеливериКлаб);
		ЗаполнитьЗначенияСвойств(Документ, ОбщиеСвойстваДокумента);
		
		Документ.Дата				= СтрокаТЗ.ДатаДоставки;
		НазваниеТочкиПродаж			= НазванияТочекПродаж[СтрокаТЗ.НазваниеРесторана];
		Документ.Склад				= СкладыМенеджер.НайтиПоНаименованию(НазваниеТочкиПродаж);
		Документ.ОбщепитКассаККМ	= ОбщепитКассыККММенеджер.НайтиПоНаименованию(НазваниеТочкиПродаж);
		СтоимостьЗаказа				= СтрокаТЗ.Стоимость;
		Документ.Комментарий		= "Код заказа - " + КодЗаказа + "; сумма заказа - " + Формат(СтоимостьЗаказа, "ЧДЦ=2") + " руб." + ?(ДеливериКлаб, "; адрес доставки - " + СтрокаТЗ.АдресКлиента, "");
		
		Если ПустаяСтрока(Документ.Номер) Тогда
			Документ.УстановитьНовыйНомер();
		КонецЕсли;
		
		Товары						= Документ.Товары;
		Товары.Очистить();
		
		ЗаполнитьЗначенияСвойств(Параметры, Документ);
		ЗаполнитьТовары(Документ, Товары, ДеливериКлаб, ?(ДеливериКлаб, СтрокаТЗ.ПозицииЗаказа, СтрокаТЗ.Блюда), Параметры, ОбщиеСвойстваСтрокиТЧТовары, НоменклатураМенеджер);
		Документ.СуммаДокумента	= Товары.Итог("Сумма");
		
		ТЧОплата					= Документ.Оплата;
		ТЧОплата.Очистить();
		СтрокаОплаты				= ТЧОплата.Добавить();
		СтрокаОплаты.ВидОплаты		= ВидОплаты;
		СтрокаОплаты.СуммаОплаты	= СтоимостьЗаказа;
		
		Попытка
			Документ.Записать(РежимЗаписиДокумента.Запись);
			СчетчикЗагруженныхЗаказов = СчетчикЗагруженныхЗаказов + 1;
			Документ.Записать(РежимЗаписиДокумента.Проведение);
		Исключение
			Сообщить("Ошибка при создании документа " + Документ + ": " + ОписаниеОшибки(), СтатусСообщения.Важное);
		КонецПопытки;
	КонецЦикла;
	КоличествоСлужебныхСтрок = ?(ДеливериКлаб, 2, 1);
	Сообщить("Обработано строк: " + Число(Счетчик + КоличествоСлужебныхСтрок) + " из " + Число(Всего + КоличествоСлужебныхСтрок) + ", создано документов: " + СчетчикЗагруженныхЗаказов + ", не загружено заказов: " + СчетчикНезагруженныхЗаказов, СтатусСообщения.Информация);
	Если СчетчикНезагруженныхЗаказов Тогда
		Сообщить("------------------------------", СтатусСообщения.Важное);
		Сообщить("Список незагруженных заказов: " + СокрЛП(СписокНезагруженныхЗаказов), СтатусСообщения.Важное);
	КонецЕсли;
КонецПроцедуры // ЗагрузитьПродажи()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ПреобразоватьСтрокуТекста(Знач СтрокаТекста, ЗначениеПоляПозиции)
	ПозицияНачалаПоляПозицииЗаказа		= СтрДлина(ЗначениеПоляПозиции) + 3;
	ПозицияОкончанияПоляПозицииЗаказа	= Найти(Сред(СтрокаТекста, ПозицияНачалаПоляПозицииЗаказа), """");
	ЗначениеПоляПозицииЗаказа			= Сред(СтрокаТекста, ПозицияНачалаПоляПозицииЗаказа, ПозицияОкончанияПоляПозицииЗаказа - ПозицияНачалаПоляПозицииЗаказа + 3);
	ЗначениеПоляПозицииЗаказа			= СтрЗаменить(ЗначениеПоляПозицииЗаказа, ";", "$");
	Возврат ЗначениеПоляПозиции + ";" + ЗначениеПоляПозицииЗаказа + Сред(СтрокаТекста, ПозицияОкончанияПоляПозицииЗаказа + 4);
КонецФункции // ПреобразоватьСтрокуТекста()

&НаСервереБезКонтекста
Функция НайтиСоздатьНомеклатурнуюГруппу(Наименование, НоменклатурныеГруппыМенеджер)
	НоменклатурнаяГруппа							= НоменклатурныеГруппыМенеджер.НайтиПоНаименованию(Наименование);
	Если НоменклатурнаяГруппа.Пустая() Тогда
		НоменклатурнаяГруппаОбъект					= НоменклатурныеГруппыМенеджер.СоздатьЭлемент();
		НоменклатурнаяГруппаОбъект.Наименование		= Наименование;
		НоменклатурнаяГруппаОбъект.ВидСтавкиНДС		= Перечисления.ВидыСтавокНДС.БезНДС;
		НоменклатурнаяГруппаОбъект.ЕдиницаИзмерения	= Справочники.КлассификаторЕдиницИзмерения.НайтиПоКоду("796");
		НоменклатурнаяГруппаОбъект.СпособУчетаНДС	= Перечисления.СпособыУчетаНДС.Списывается;
		НоменклатурнаяГруппаОбъект.Записать();
		НоменклатурнаяГруппа						= НоменклатурнаяГруппаОбъект.Ссылка;
	КонецЕсли;
	Возврат НоменклатурнаяГруппа;
КонецФункции // НайтиСоздатьНомеклатурнуюГруппу()

&НаСервереБезКонтекста
Функция НайтиСоздатьПользователя(Наименование, ПользователиМенеджер)
	Пользователь						= ПользователиМенеджер.НайтиПоНаименованию(Наименование);
	Если Пользователь.Пустая() Тогда
		ПользовательОбъект				= ПользователиМенеджер.СоздатьЭлемент();
		ПользовательОбъект.Наименование	= Наименование;
		ПользовательОбъект.Записать();
		Пользователь					= ПользовательОбъект.Ссылка;
	КонецЕсли;
	Возврат Пользователь;
КонецФункции // НайтиСоздатьПользователя()

&НаСервереБезКонтекста
Функция СтрокуВДату(Строка, ВПолеДатаВремениНет, Время = Неопределено)
	
	Дата = ?(ВПолеДатаВремениНет,
		Дата(Число(Прав(Строка, 4)), Число(Сред(Строка, 4, 2)), Число(Лев(Строка, 2))),
		Дата(Число(Лев(Строка, 4)), Число(Сред(Строка, 6, 2)), Число(Сред(Строка, 9, 2)), Число(Сред(Строка, 12, 2)), Число(Прав(Строка, 2)), 0));
		
	Если Время <> Неопределено Тогда
		Дата = Дата + 60 * (60 * Число(Лев(Время, 2)) + Число(Прав(Время, 2)));
	КонецЕсли;
		
	Возврат Дата;
КонецФункции // СтрокуВДату()

&НаСервереБезКонтекста
Функция ПолучитьНазванияТочекПродаж(ВидЗагрузки)
	Соответствие = Новый Соответствие;
	Если ВидЗагрузки = "delivery club" Тогда
		Соответствие.Вставить("Чебурекми (Уфа, 50-летия Октября, 19А)",			"Дом печати");
		Соответствие.Вставить("Чебурекми (Уфа, улица Мубарякова, 10/1)",		"Школа МВД");
	ИначеЕсли ВидЗагрузки = "СигмаЧеки" тогда
		Соответствие.Вставить("ЧебурекМи Уфа, ул.50-летия Октября, 19А",		"Дом печати");
		Соответствие.Вставить("ЧебурекМи Уфа, ул. Мубарякова 10/1",				"Школа МВД");
	Иначе
		Соответствие.Вставить("Чебурекми (Уфа, улица 50-летия Октября, 19А)",	"Дом печати");
		Соответствие.Вставить("Чебурекми (Уфа, улица Мубарякова, 10/1)",		"Школа МВД");
	КонецЕсли;
	Возврат Соответствие;
КонецФункции // ПолучитьНазванияТочекПродаж()

&НаСервереБезКонтекста
Функция НайтиСоздатьРозничнуюПродажу(НомерЧека, Дата, РозничнаяПродажаМенеджер)
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	РозничнаяПродажа.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.РозничнаяПродажа КАК РозничнаяПродажа
	|ГДЕ
	|	ПОДСТРОКА(РозничнаяПродажа.Комментарий, 10, " + СтрДлина(НомерЧека) + ") = &НомерЧека
	|	И РозничнаяПродажа.Дата МЕЖДУ НАЧАЛОПЕРИОДА(&Дата, ДЕНЬ) И КОНЕЦПЕРИОДА(&Дата, ДЕНЬ)");
	Запрос.УстановитьПараметр("НомерЧека",	НомерЧека);
	Запрос.УстановитьПараметр("Дата",		Дата);
	РезультатЗапроса	= Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Документ		= РозничнаяПродажаМенеджер.СоздатьДокумент();
	Иначе
		Выборка			= РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		Документ		= Выборка.Ссылка.ПолучитьОбъект();
	КонецЕсли;
	Возврат Документ;
КонецФункции // НайтиСоздатьРозничнуюПродажу()

&НаСервереБезКонтекста
Функция НайтиСоздатьДокументПродажи(КодЗаказа, ОтчетОРозничныхПродажахМенеджер, ДеливериКлаб)
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ОтчетОРозничныхПродажах.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ОтчетОРозничныхПродажах КАК ОтчетОРозничныхПродажах
	|ГДЕ
	|	ПОДСТРОКА(ОтчетОРозничныхПродажах.Комментарий, 14, " + ?(ДеливериКлаб, "12", "13") + ") = &КодЗаказа");
	Запрос.УстановитьПараметр("КодЗаказа", КодЗаказа);
	РезультатЗапроса	= Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Документ		= ОтчетОРозничныхПродажахМенеджер.СоздатьДокумент();
	Иначе
		Выборка			= РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		Документ		= Выборка.Ссылка.ПолучитьОбъект();
	КонецЕсли;
	Возврат Документ;
КонецФункции // НайтиСоздатьДокументПродажи()

&НаСервереБезКонтекста
Процедура ЗаполнитьТовары(Документ, Товары, ДеливериКлаб, Знач ПозицииЗаказа, Параметры, ОбщиеСвойстваСтрокиТЧТовары, НоменклатураМенеджер)
	
	Разделитель = ?(ДеливериКлаб, "$", ",");
	
	ПозицияРазделителя = Найти(ПозицииЗаказа, Разделитель);
	Пока ПозицияРазделителя Цикл
		ОписаниеТовара				= СокрЛП(Лев(ПозицииЗаказа, ПозицияРазделителя - 1));
		ПозицияПробела				= Найти(ПозицииЗаказа, " ");
		
		НоваяСтрокаТЧ				= Товары.Добавить();
		НоваяСтрокаТЧ.Количество	= Число(Лев(ОписаниеТовара, ПозицияПробела - 1));
		НоваяСтрокаТЧ.Номенклатура	= ПолучитьНоменклатуру(Сред(ОписаниеТовара,ПозицияПробела + 1), НоменклатураМенеджер, Истина);
		
		СведенияОНоменклатуре		= БухгалтерскийУчетПереопределяемый.ПолучитьСведенияОНоменклатуре(НоваяСтрокаТЧ.Номенклатура, Параметры, Ложь);
		Если СведенияОНоменклатуре <> Неопределено Тогда
			НоваяСтрокаТЧ.Цена				= СведенияОНоменклатуре.ЦенаВРознице;
			НоваяСтрокаТЧ.ЕдиницаИзмерения	= СведенияОНоменклатуре.ЕдиницаИзмерения;
		КонецЕсли;
		
		ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуТабЧасти(НоваяСтрокаТЧ);
		
		ЗаполнитьЗначенияСвойств(НоваяСтрокаТЧ, ОбщиеСвойстваСтрокиТЧТовары);
		
		ПозицииЗаказа				= СокрЛП(Сред(ПозицииЗаказа, ПозицияРазделителя + 1));
		ПозицияРазделителя			= Найти(ПозицииЗаказа, Разделитель);
	КонецЦикла;
КонецПроцедуры // ЗаполнитьТовары()

&НаСервереБезКонтекста
Функция ПолучитьНоменклатуру(Знач ОписаниеТовара, НоменклатураМенеджер, ИспользоватьСложныйПоиск)
	ОписаниеТовара = СокрЛП(ОписаниеТовара);
	НоменклатураМенеджер = Справочники.Номенклатура;
	Результат = НоменклатураМенеджер.НайтиПоНаименованию(ОписаниеТовара);
	Если Результат.Пустая() И ИспользоватьСложныйПоиск Тогда
		Для Счетчик = -(СтрДлина(ОписаниеТовара) - 1) По 0 Цикл
			Символ = Сред(ОписаниеТовара, -Счетчик, 1);
			Если СтрНайти("0123456789",Символ) Тогда
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если Счетчик <> 0 Тогда
			Пока Счетчик <> 0 И СтрНайти("0123456789",Символ) Цикл
				Счетчик = Счетчик + 1;
				Символ = Сред(ОписаниеТовара, -Счетчик, 1);
			КонецЦикла;
			Если Счетчик <> 0 Тогда
				Результат = НоменклатураМенеджер.НайтиПоНаименованию(СокрЛП(Лев(ОписаниеТовара, -Счетчик)));
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	Возврат Результат;
КонецФункции // ПолучитьНоменклатуру()

#КонецОбласти

// финиш - 29.01.2020
