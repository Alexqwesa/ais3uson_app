// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Приложение для учета услуг АИС ТриУСОН`
  String get shortAboutApp {
    return Intl.message(
      'Приложение для учета услуг АИС ТриУСОН',
      name: 'shortAboutApp',
      desc: '',
      args: [],
    );
  }

  /// `Добавить отделение из строки текста`
  String get addDepFromText {
    return Intl.message(
      'Добавить отделение из строки текста',
      name: 'addDepFromText',
      desc: '',
      args: [],
    );
  }

  /// `Сканировать QR код отделения`
  String get scanQrCode {
    return Intl.message(
      'Сканировать QR код отделения',
      name: 'scanQrCode',
      desc: '',
      args: [],
    );
  }

  /// `Удаление отделения`
  String get deleteDep {
    return Intl.message(
      'Удаление отделения',
      name: 'deleteDep',
      desc: '',
      args: [],
    );
  }

  /// `О прилжонии`
  String get about {
    return Intl.message(
      'О прилжонии',
      name: 'about',
      desc: '',
      args: [],
    );
  }

  /// `Настройки`
  String get settings {
    return Intl.message(
      'Настройки',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Тема:`
  String get theme {
    return Intl.message(
      'Тема:',
      name: 'theme',
      desc: '',
      args: [],
    );
  }

  /// `Светлая`
  String get light {
    return Intl.message(
      'Светлая',
      name: 'light',
      desc: '',
      args: [],
    );
  }

  /// `Темная`
  String get dark {
    return Intl.message(
      'Темная',
      name: 'dark',
      desc: '',
      args: [],
    );
  }

  /// `Архив ввода услуг`
  String get archive {
    return Intl.message(
      'Архив ввода услуг',
      name: 'archive',
      desc: '',
      args: [],
    );
  }

  /// `Список отделений`
  String get depList {
    return Intl.message(
      'Список отделений',
      name: 'depList',
      desc: '',
      args: [],
    );
  }

  /// `Выполняется поиск QR-кода...`
  String get searchQR {
    return Intl.message(
      'Выполняется поиск QR-кода...',
      name: 'searchQR',
      desc: '',
      args: [],
    );
  }

  /// `Данные: `
  String get data {
    return Intl.message(
      'Данные: ',
      name: 'data',
      desc: '',
      args: [],
    );
  }

  /// `Вспышка`
  String get flashLight {
    return Intl.message(
      'Вспышка',
      name: 'flashLight',
      desc: '',
      args: [],
    );
  }

  /// `Загрузка...`
  String get loading {
    return Intl.message(
      'Загрузка...',
      name: 'loading',
      desc: '',
      args: [],
    );
  }

  /// `Добавить!`
  String get add {
    return Intl.message(
      'Добавить!',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `Соединение!`
  String get testConnection {
    return Intl.message(
      'Соединение!',
      name: 'testConnection',
      desc: '',
      args: [],
    );
  }

  /// `Список отделений пуст!`
  String get emptyDepList {
    return Intl.message(
      'Список отделений пуст!',
      name: 'emptyDepList',
      desc: '',
      args: [],
    );
  }

  /// `Выберите отделение для удаления...`
  String get selectDepForDelete {
    return Intl.message(
      'Выберите отделение для удаления...',
      name: 'selectDepForDelete',
      desc: '',
      args: [],
    );
  }

  /// `Вы уверены что хотите удалить отделение: `
  String get areYouSureToDelete {
    return Intl.message(
      'Вы уверены что хотите удалить отделение: ',
      name: 'areYouSureToDelete',
      desc: '',
      args: [],
    );
  }

  /// `Ошибка`
  String get error {
    return Intl.message(
      'Ошибка',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `Ошибка защищенного соединения!`
  String get sslError {
    return Intl.message(
      'Ошибка защищенного соединения!',
      name: 'sslError',
      desc: '',
      args: [],
    );
  }

  /// `Ошибка сервера!`
  String get serverError {
    return Intl.message(
      'Ошибка сервера!',
      name: 'serverError',
      desc: '',
      args: [],
    );
  }

  /// `Ошибка: нет соединения с интернетом!`
  String get internetError {
    return Intl.message(
      'Ошибка: нет соединения с интернетом!',
      name: 'internetError',
      desc: '',
      args: [],
    );
  }

  /// `Ошибка доступа к серверу!`
  String get httpAccessError {
    return Intl.message(
      'Ошибка доступа к серверу!',
      name: 'httpAccessError',
      desc: '',
      args: [],
    );
  }

  /// `Очистить`
  String get clear {
    return Intl.message(
      'Очистить',
      name: 'clear',
      desc: '',
      args: [],
    );
  }

  /// `Добавить отделение`
  String get addDep {
    return Intl.message(
      'Добавить отделение',
      name: 'addDep',
      desc: '',
      args: [],
    );
  }

  /// `Вставте код отделение в виде текста...`
  String get putDepText {
    return Intl.message(
      'Вставте код отделение в виде текста...',
      name: 'putDepText',
      desc: '',
      args: [],
    );
  }

  /// `Вставте текст-код отделение сюда...`
  String get putDepTextField {
    return Intl.message(
      'Вставте текст-код отделение сюда...',
      name: 'putDepTextField',
      desc: '',
      args: [],
    );
  }

  /// `Либо добавьте тестовое отделение из списка ниже:`
  String get orTestDepList {
    return Intl.message(
      'Либо добавьте тестовое отделение из списка ниже:',
      name: 'orTestDepList',
      desc: '',
      args: [],
    );
  }

  /// `Не удалось добавить отделение. Возможно оно уже есть в списке.`
  String get cantAddDepDuplicate {
    return Intl.message(
      'Не удалось добавить отделение. Возможно оно уже есть в списке.',
      name: 'cantAddDepDuplicate',
      desc: '',
      args: [],
    );
  }

  /// `Не удалось добавить отделение. Возможно неправильный формат строки.`
  String get cantAddDepBadFormat {
    return Intl.message(
      'Не удалось добавить отделение. Возможно неправильный формат строки.',
      name: 'cantAddDepBadFormat',
      desc: '',
      args: [],
    );
  }

  /// `Вставьте текст qr-кода отделения здесь, это резервный способ добавления отделения, например для тех у кого не работает камера на телефоне... \n рекомендуемый способ - сканировать QR код!`
  String get putDepTextFieldHint {
    return Intl.message(
      'Вставьте текст qr-кода отделения здесь, это резервный способ добавления отделения, например для тех у кого не работает камера на телефоне... \n рекомендуемый способ - сканировать QR код!',
      name: 'putDepTextFieldHint',
      desc: '',
      args: [],
    );
  }

  /// `Пожалуйста, авторизируйтесь \n(отсканируйте QR код) \n (Или добавьте тестовое отделение)`
  String get authorizePlease {
    return Intl.message(
      'Пожалуйста, авторизируйтесь \n(отсканируйте QR код) \n (Или добавьте тестовое отделение)',
      name: 'authorizePlease',
      desc: '',
      args: [],
    );
  }

  /// `Список получателей услуг пуст, \n\n попросите заведующего отделением добавить людей в ваш список обслуживаемых \n\n затем обновите список`
  String get emptyListOfPeople {
    return Intl.message(
      'Список получателей услуг пуст, \n\n попросите заведующего отделением добавить людей в ваш список обслуживаемых \n\n затем обновите список',
      name: 'emptyListOfPeople',
      desc: '',
      args: [],
    );
  }

  /// `Подбробно`
  String get detailed {
    return Intl.message(
      'Подбробно',
      name: 'detailed',
      desc: '',
      args: [],
    );
  }

  /// `Список`
  String get list {
    return Intl.message(
      'Список',
      name: 'list',
      desc: '',
      args: [],
    );
  }

  /// `Значки`
  String get small {
    return Intl.message(
      'Значки',
      name: 'small',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'ru'),
      Locale.fromSubtags(languageCode: 'de'),
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
