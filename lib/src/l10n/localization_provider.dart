import 'package:ais3uson_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

export 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'localization_provider.g.dart';

extension AppLocalizationsExt on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

// extension AppLocalizationsLoader on AppLocalizations {
Future<AppLocalizations> loadDefaultLocale() async {
  const delegate = AppLocalizations.delegate;
  final locale = WidgetsBinding.instance.platformDispatcher.locale;
  if (delegate.isSupported(locale)) {
    return delegate.load(locale);
  }
  return delegate.load(const Locale('en'));
}
// }

/// Provider of [AppLocalizations] for current locale.
@Riverpod(keepAlive: true)
class AppLocale extends _$AppLocale {
  static late final _LocaleObserver __observer;

  //
  // static final Finalizer<_LocaleObserver> _finalizer =
  //     Finalizer((observer) => WidgetsBinding.instance.removeObserver(observer));

  _LocaleObserver _initSystemLocaleObserver() {
    try {
      return __observer;
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      //on LateError  LateInitializationError

      __observer = _LocaleObserver(onChanged: (_) {
        ref.invalidate(appLocaleProvider);
      });
      WidgetsBinding.instance.addObserver(
        __observer,
      ); // todo: use only for system-locale
      // _finalizer.attach(this, __observer, detach: this);

      return __observer;
    }
  }

  @override
  LocaleState build() {
    //
    // > listen to system locale
    //
    _initSystemLocaleObserver();
    //
    // > sync get_it translations provider (for strings outside of BuildContext/ref)
    //
    ref.listenSelf((previous, next) async {
      if (locator.currentScopeName == 'new-locale') {
        await locator.popScopesTill('new-locale');
      }
      locator
        ..pushNewScope(scopeName: 'new-locale')
        ..registerLazySingleton<AppLocalizations>(() => next.locale.tr);
      // tr = locator<AppLocalizations>;
    });

    final locale = locator<SharedPreferences>().getString('AppLocale') ??
        LocaleState.systemLocale;

    return LocaleState(locale);
  }

  @override
  set state(LocaleState value) {
    super.state = value;

    const delegate = AppLocalizations.delegate;
    if (delegate.isSupported(value.locale) ||
        value.langCode == LocaleState.systemLocale ||
        value.langCode == '') {
      locator<SharedPreferences>().setString('AppLocale', value.langCode);
    }
  }
}

class LocaleState {
  String langCode;
  late final Locale locale;

  static String systemLocale = 'system_locale';

  AppLocalizations get tr => lookupAppLocalizations(locale);

  LocaleState(this.langCode) {
    const delegate = AppLocalizations.delegate;
    final binding = WidgetsBinding.instance;

    if (langCode == systemLocale || langCode == '') {
      locale = binding.platformDispatcher.locale;
    } else {
      locale = Locale(langCode);
    }

    if (!delegate.isSupported(locale)) {
      langCode = 'system_locale';
      locale = AppLocalizations.supportedLocales.first;
    }

    delegate.load(locale);
  }
}

extension LocaleWithDelegate on Locale {
  /// Get class with translation strings for this locale.
  AppLocalizations get tr => lookupAppLocalizations(this);
}

/// Observer used to notify the caller when the locale changes.
class _LocaleObserver extends WidgetsBindingObserver {
  final void Function(List<Locale>? locales) onChanged;

  _LocaleObserver({required this.onChanged});

  @override
  void didChangeLocales(List<Locale>? locales) {
    onChanged(locales);
  }
}
