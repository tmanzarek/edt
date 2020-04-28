// Тимур - старт - 22.01.2020

#Область ПрограммныйИнтерфейс

Функция СведенияОВнешнейОбработке() Экспорт
	ПараметрыРегистрации	= Новый Структура;
	ПараметрыРегистрации.Вставить("Вид",				"ДополнительнаяОбработка"); //может быть - ЗаполнениеОбъекта, ДополнительныйОтчет, СозданиеСвязанныхОбъектов... 
	ПараметрыРегистрации.Вставить("Наименование",		"Загрузка цен и продаж служб доставки"); //имя под которым обработка будет зарегестрирована в справочнике внешних обработок
	ПараметрыРегистрации.Вставить("Версия",				"1.02");
	ПараметрыРегистрации.Вставить("БезопасныйРежим",	Ложь);
	ПараметрыРегистрации.Вставить("Информация",			"Загрузка цен и продаж служб доставки");//так будет выглядеть описание печ.формы для пользователя
	ТаблицаКоманд			= ПолучитьТаблицуКоманд();
	ДобавитьКоманду(ТаблицаКоманд,				"Загрузка цен и продаж служб доставки", "тЗагрузкаЦенПродаж", "ОткрытиеФормы");
	ПараметрыРегистрации.Вставить("Команды",	ТаблицаКоманд);
	Возврат ПараметрыРегистрации;
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

//Процедура, которая подготавливает структуру таблицы команд
Функция ПолучитьТаблицуКоманд()
	// Создадим пустую таблицу команд и колонки в ней
	Команды = Новый ТаблицаЗначений;
	// Как будет выглядеть описание печатной формы для пользователя
	Команды.Колонки.Добавить("Представление",	Новый ОписаниеТипов("Строка"));
	// Имя нашего макета, что бы могли отличить вызванную команду в обработке печати
	Команды.Колонки.Добавить("Идентификатор",	Новый ОписаниеТипов("Строка"));
	// Тут задается, как должна вызваться команда обработки
	// Возможные варианты:
	// - ОткрытиеФормы - в этом случае в колонке идентификатор должно быть указано имя формы, которое должна будет открыть система
	// - ВызовКлиентскогоМетода - вызвать клиентскую экспортную процедуру из модуля формы обработки
	// - ВызовСерверногоМетода - вызвать серверную экспортную процедуру из модуля объекта обработки
	Команды.Колонки.Добавить("Использование",			Новый ОписаниеТипов("Строка"));
	// Следующий параметр указывает, необходимо ли показывать оповещение при начале и завершению работы обработки. Не имеет смысла при открытии формы
	Команды.Колонки.Добавить("ПоказыватьОповещение",	Новый ОписаниеТипов("Булево"));
	// Для печатной формы должен содержать строку ПечатьMXL
	Команды.Колонки.Добавить("Модификатор",				Новый ОписаниеТипов("Строка"));
	Возврат Команды;
КонецФункции

//Создает в таблице команд новую строку
Функция ДобавитьКоманду(ТаблицаКоманд, Представление, Идентификатор, Использование, ПоказыватьОповещение = Ложь, Модификатор = "")
	НоваяКоманда						= ТаблицаКоманд.Добавить();
	НоваяКоманда.Представление			= Представление;
	НоваяКоманда.Идентификатор			= Идентификатор;
	НоваяКоманда.Использование			= Использование;
	НоваяКоманда.ПоказыватьОповещение	= ПоказыватьОповещение;
	НоваяКоманда.Модификатор			= Модификатор;
КонецФункции

#КонецОбласти

// финиш - 22.01.2020
