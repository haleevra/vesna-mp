////////////////////////////////////////////////////////////////////////////////
// Обновление информационной базы конфигурации.
// Библиотека Интернет-поддержи (БИП).
// ОбщийМодуль.ОбновлениеИнформационнойБазыБИП.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Сведения о библиотеке (или конфигурации).
//

// Заполняет основные сведения о библиотеке или основной конфигурации.
// Библиотека, имя которой имя совпадает с именем конфигурации в метаданных, определяется как основная конфигурация.
// 
// Параметры:
//  Описание - Структура - сведения о библиотеке:
//
//   * Имя                 - Строка - имя библиотеки, например, "СтандартныеПодсистемы".
//   * Версия              - Строка - версия в формате из 4-х цифр, например, "2.1.3.1".
//
//   * ТребуемыеПодсистемы - Массив - имена других библиотек (Строка), от которых зависит данная библиотека.
//                                    Обработчики обновления таких библиотек должны быть вызваны ранее
//                                    обработчиков обновления данной библиотеки.
//                                    При циклических зависимостях или, напротив, отсутствии каких-либо зависимостей,
//                                    порядок вызова обработчиков обновления определяется порядком добавления модулей
//                                    в процедуре ПриДобавленииПодсистем общего модуля
//                                    ПодсистемыКонфигурацииПереопределяемый.
//   * РежимВыполненияОтложенныхОбработчиков - Строка - "Последовательно" - отложенные обработчики обновления выполняются
//                                    последовательно в интервале от номера версии информационной базы до номера
//                                    версии конфигурации включительно или "Параллельно" - отложенный обработчик после
//                                    обработки первой порции данных передает управление следующему обработчику, а после
//                                    выполнения последнего обработчика цикл повторяется заново.
//
Процедура ПриДобавленииПодсистемы(Описание) Экспорт

	Описание.Имя    = "ИнтернетПоддержкаПользователей";
	Описание.Версия = ИнтернетПоддержкаПользователейКлиентСервер.ВерсияБиблиотеки();

	// Требуется библиотека стандартных подсистем.
	Описание.ТребуемыеПодсистемы.Добавить("СтандартныеПодсистемы");

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики обновления информационной базы.

// Добавляет в список процедуры-обработчики обновления данных ИБ
// для всех поддерживаемых версий библиотеки или конфигурации.
// Вызывается перед началом обновления данных ИБ для построения плана обновления.
//
// Параметры:
//	Обработчики - ТаблицаЗначений - описание полей, см. в процедуре
//		ОбновлениеИнформационнойБазы.НоваяТаблицаОбработчиковОбновления().
//
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт

	// БазоваяФункциональностьБИП
	ИнтернетПоддержкаПользователей.ПриДобавленииОбработчиковОбновления(Обработчики);
	// Конец БазоваяФункциональностьБИП

	// Новости
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.Новости") Тогда
		МодульОбработкаНовостей = ОбщегоНазначения.ОбщийМодуль("ОбработкаНовостей");
		МодульОбработкаНовостей.ПриДобавленииОбработчиковОбновления(Обработчики);
	КонецЕсли;
	// Конец Новости

	// ОблачныйАрхив
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.ОблачныйАрхив") Тогда
		МодульОблачныйАрхивПовтИсп = ОбщегоНазначения.ОбщийМодуль("ОблачныйАрхивПовтИсп");
		// Обновление имеет смысл запускать только когда возможна работа с облачным архивом (Windows, файловая база).
		Если МодульОблачныйАрхивПовтИсп.ВозможнаРаботаСОблачнымАрхивом() Тогда
			МодульОблачныйАрхив = ОбщегоНазначения.ОбщийМодуль("ОблачныйАрхив");
			МодульОблачныйАрхив.ПриДобавленииОбработчиковОбновления(Обработчики);
		КонецЕсли;
	КонецЕсли;
	// Конец ОблачныйАрхив

	// ПолучениеОбновленийПрограммы
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.ПолучениеОбновленийПрограммы") Тогда
		МодульПолучениеОбновленийПрограммы = ОбщегоНазначения.ОбщийМодуль("ПолучениеОбновленийПрограммы");
		МодульПолучениеОбновленийПрограммы.ПриДобавленииОбработчиковОбновления(Обработчики);
	КонецЕсли;
	// Конец ПолучениеОбновленийПрограммы

	// СПАРКРиски
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.СПАРКРиски") Тогда
		МодульСПАРКРиски = ОбщегоНазначения.ОбщийМодуль("СПАРКРиски");
		МодульСПАРКРиски.ПриДобавленииОбработчиковОбновления(Обработчики);
	КонецЕсли;
	// Конец СПАРКРиски
	
	// РаботаСКонтрагентами
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.РаботаСКонтрагентами") Тогда
		МодульРаботаСКонтрагентами = ОбщегоНазначения.ОбщийМодуль("РаботаСКонтрагентами");
		МодульРаботаСКонтрагентами.ПриДобавленииОбработчиковОбновления(Обработчики);
	КонецЕсли;
	// Конец РаботаСКонтрагентами
	
КонецПроцедуры

// Вызывается перед обработчиками обновления данных ИБ.
//
Процедура ПередОбновлениемИнформационнойБазы() Экспорт
	
	
	
КонецПроцедуры

// Вызывается после завершения обновления данных ИБ.
// 
// Параметры:
//   ПредыдущаяВерсияИБ - Строка - версия до обновления. "0.0.0.0" для "пустой" ИБ.
//   ТекущаяВерсияИБ - Строка - версия после обновления.
//   ВыполненныеОбработчики - ДеревоЗначений - список выполненных процедур-обработчиков обновления,
//                                             сгруппированных по номеру версии.
//   ВыводитьОписаниеОбновлений - Булево - если установить Истина, то будет выведена форма
//                                с описанием обновлений. По умолчанию, Истина.
//                                Возвращаемое значение.
//   МонопольныйРежим           - Булево - Истина, если обновление выполнялось в монопольном режиме.
//
Процедура ПослеОбновленияИнформационнойБазы(Знач ПредыдущаяВерсияИБ, Знач ТекущаяВерсияИБ,
		Знач ВыполненныеОбработчики, ВыводитьОписаниеОбновлений, МонопольныйРежим) Экспорт
	
	
	
КонецПроцедуры

// Вызывается при подготовке табличного документа с описанием изменений системы.
//
// Параметры:
//   Макет - ТабличныйДокумент - описание обновлений.
//
// См. также общий макет ОписаниеИзмененийСистемы.
//
Процедура ПриПодготовкеМакетаОписанияОбновлений(Знач Макет) Экспорт
	
	
	
КонецПроцедуры

// Позволяет переопределить режим обновления данных информационной базы.
// Для использования в редких (нештатных) случаях перехода, не предусмотренных в
// стандартной процедуре определения режима обновления.
//
// Параметры:
//   РежимОбновленияДанных - Строка - в обработчике можно присвоить одно из значений:
//              "НачальноеЗаполнение"     - если это первый запуск пустой базы (области данных);
//              "ОбновлениеВерсии"        - если выполняется первый запуск после обновление конфигурации базы данных;
//              "ПереходСДругойПрограммы" - если выполняется первый запуск после обновление конфигурации базы данных, 
//                                          в которой изменилось имя основной конфигурации.
//
//   СтандартнаяОбработка  - Булево - если присвоить Ложь, то стандартная процедура
//                                    определения режима обновления не выполняется, 
//                                    а используется значение РежимОбновленияДанных.
//
Процедура ПриОпределенииРежимаОбновленияДанных(РежимОбновленияДанных, СтандартнаяОбработка) Экспорт
	
	
	
КонецПроцедуры

// Добавляет в список процедуры-обработчики перехода с другой программы (с другим именем конфигурации).
// Например, для перехода между разными, но родственными конфигурациями: базовая -> проф -> корп.
// Вызывается перед началом обновления данных ИБ.
//
// Параметры:
//	Обработчики - ТаблицаЗначений - с колонками:
//		* ПредыдущееИмяКонфигурации - Строка - имя конфигурации, с которой выполняется переход;
//			или "*", если нужно выполнять при переходе с любой конфигурации.
//		* Процедура - Строка - полное имя процедуры-обработчика перехода с программы ПредыдущееИмяКонфигурации. 
//			Например, "ОбновлениеИнформационнойБазыУПП.ЗаполнитьУчетнуюПолитику"
//			Обязательно должна быть экспортной.
//
// Пример:
//	Обработчик = Обработчики.Добавить();
//	Обработчик.ПредыдущееИмяКонфигурации  = "УправлениеТорговлей";
//	Обработчик.Процедура                  = "ОбновлениеИнформационнойБазыУПП.ЗаполнитьУчетнуюПолитику";
//
Процедура ПриДобавленииОбработчиковПереходаСДругойПрограммы(Обработчики) Экспорт
	
	
	
КонецПроцедуры

// Вызывается после выполнения всех процедур-обработчиков перехода с другой программы (с другим именем конфигурации),
// и до начала выполнения обновления данных ИБ.
//
// Параметры:
//  ПредыдущееИмяКонфигурации    - Строка - имя конфигурации до перехода.
//  ПредыдущаяВерсияКонфигурации - Строка - имя предыдущей конфигурации (до перехода).
//  Параметры                    - Структура - 
//    * ВыполнитьОбновлениеСВерсии   - Булево - по умолчанию Истина. Если установить Ложь, 
//        то будут выполнена только обязательные обработчики обновления (с версией "*").
//    * ВерсияКонфигурации           - Строка - номер версии после перехода. 
//        По умолчанию, равен значению версии конфигурации в свойствах метаданных.
//        Для того чтобы выполнить, например, все обработчики обновления с версии ПредыдущаяВерсияКонфигурации, 
//        следует установить значение параметра в ПредыдущаяВерсияКонфигурации.
//        Для того чтобы выполнить вообще все обработчики обновления, установить значение "0.0.0.1".
//    * ОчиститьСведенияОПредыдущейКонфигурации - Булево - по умолчанию Истина. 
//        Для случаев когда предыдущая конфигурация совпадает по имени с подсистемой текущей конфигурации, следует указать Ложь.
//
Процедура ПриЗавершенииПереходаСДругойПрограммы(Знач ПредыдущееИмяКонфигурации, 
	Знач ПредыдущаяВерсияКонфигурации, Параметры) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти
