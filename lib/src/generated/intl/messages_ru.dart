// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ru locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ru';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "about": MessageLookupByLibrary.simpleMessage("О прилжонии"),
        "add": MessageLookupByLibrary.simpleMessage("Добавить!"),
        "addDep": MessageLookupByLibrary.simpleMessage("Добавить отделение"),
        "addDepFromText": MessageLookupByLibrary.simpleMessage(
            "Добавить отделение из строки текста"),
        "archive": MessageLookupByLibrary.simpleMessage("Архив ввода услуг"),
        "archiveAt": MessageLookupByLibrary.simpleMessage("Архив на: "),
        "areYouSureToDelete": MessageLookupByLibrary.simpleMessage(
            "Вы уверены что хотите удалить отделение: "),
        "authorizePlease": MessageLookupByLibrary.simpleMessage(
            "Пожалуйста, авторизируйтесь \n(отсканируйте QR код) \n (Или добавьте тестовое отделение)"),
        "awaitResults":
            MessageLookupByLibrary.simpleMessage("Ожидание данных..."),
        "cantAddDepBadFormat": MessageLookupByLibrary.simpleMessage(
            "Не удалось добавить отделение. Возможно неправильный формат строки."),
        "cantAddDepDuplicate": MessageLookupByLibrary.simpleMessage(
            "Не удалось добавить отделение. Возможно оно уже есть в списке."),
        "clear": MessageLookupByLibrary.simpleMessage("Очистить"),
        "dark": MessageLookupByLibrary.simpleMessage("Темная"),
        "data": MessageLookupByLibrary.simpleMessage("Данные: "),
        "deleteDep": MessageLookupByLibrary.simpleMessage("Удалить отделение"),
        "depList": MessageLookupByLibrary.simpleMessage("Список отделений"),
        "detailed": MessageLookupByLibrary.simpleMessage("Подбробно"),
        "developer": MessageLookupByLibrary.simpleMessage(
            "Разработчик: Савин Александр Викторович aka Alexqwesa"),
        "emptyDepList":
            MessageLookupByLibrary.simpleMessage("Список отделений пуст!"),
        "emptyListOfPeople": MessageLookupByLibrary.simpleMessage(
            "Список получателей услуг пуст, \n\n попросите заведующего отделением добавить людей в ваш список обслуживаемых \n\n затем обновите список"),
        "error": MessageLookupByLibrary.simpleMessage("Ошибка"),
        "errorDepSave": MessageLookupByLibrary.simpleMessage(
            "Ошибка: не удалось сохранить профиль отделения!"),
        "errorFormat": MessageLookupByLibrary.simpleMessage(
            "Ошибка: был получен неправильный ответ от сервера!"),
        "errorSave": MessageLookupByLibrary.simpleMessage(
            "Ошибка: не удалось сохранить запись журнала, \n  проверьте сводобное место на устройстве, \n проверьте права доступа на запись"),
        "errorService": MessageLookupByLibrary.simpleMessage(
            "Ошибка: не удается найти указанный сервис "),
        "errorWrongCertificate": MessageLookupByLibrary.simpleMessage(
            "Ошибка! Не удалось добавить сертификат отделения!"),
        "exportLastMonth":
            MessageLookupByLibrary.simpleMessage("Экспорт предыдущего месяца"),
        "exportLastWeek":
            MessageLookupByLibrary.simpleMessage("Экспорт предыдущей недели"),
        "exportThisMonth":
            MessageLookupByLibrary.simpleMessage("Экспорт этого месяца"),
        "exportThisWeek":
            MessageLookupByLibrary.simpleMessage("Экспорт этой недели"),
        "fileSavedTo":
            MessageLookupByLibrary.simpleMessage("Файл сохранен в: "),
        "flashLight": MessageLookupByLibrary.simpleMessage("Вспышка"),
        "httpAccessError":
            MessageLookupByLibrary.simpleMessage("Ошибка доступа к серверу!"),
        "internetError": MessageLookupByLibrary.simpleMessage(
            "Ошибка: нет соединения с интернетом!"),
        "light": MessageLookupByLibrary.simpleMessage("Светлая"),
        "list": MessageLookupByLibrary.simpleMessage("Список"),
        "listOfServicesByDays":
            MessageLookupByLibrary.simpleMessage("Список услуг по дням"),
        "loading": MessageLookupByLibrary.simpleMessage("Загрузка..."),
        "orTestDepList": MessageLookupByLibrary.simpleMessage(
            "Либо добавьте тестовое отделение из списка ниже:"),
        "putDepText": MessageLookupByLibrary.simpleMessage(
            "Вставте код отделение в виде текста..."),
        "putDepTextField": MessageLookupByLibrary.simpleMessage(
            "Вставте текст-код отделение сюда..."),
        "putDepTextFieldHint": MessageLookupByLibrary.simpleMessage(
            "Вставьте текст qr-кода отделения здесь, это резервный способ добавления отделения, например для тех у кого не работает камера на телефоне... \n рекомендуемый способ - сканировать QR код!"),
        "scanQrCode": MessageLookupByLibrary.simpleMessage(
            "Сканировать QR код отделения"),
        "searchQR": MessageLookupByLibrary.simpleMessage(
            "Выполняется поиск QR-кода..."),
        "selectDepForDelete": MessageLookupByLibrary.simpleMessage(
            "Выберите отделение для удаления..."),
        "serverError": MessageLookupByLibrary.simpleMessage("Ошибка сервера!"),
        "settings": MessageLookupByLibrary.simpleMessage("Настройки"),
        "shortAboutApp": MessageLookupByLibrary.simpleMessage(
            "Приложение для учета услуг АИС ТриУСОН"),
        "small": MessageLookupByLibrary.simpleMessage("Значки"),
        "sslError": MessageLookupByLibrary.simpleMessage(
            "Ошибка защищенного соединения!"),
        "testConnection": MessageLookupByLibrary.simpleMessage("Соединение!"),
        "theme": MessageLookupByLibrary.simpleMessage("Тема:")
      };
}
