import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/src/l10n/localization_provider.dart';
import 'package:ais3uson_app/ui_root.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// This is main MaterialApp widget.
///
/// It set up:
/// - theme [appThemeProvider],
/// - navigation routes [routerProvider],
/// - localization,
/// - initial location.
///
/// {@category UI Root}
class AppRoot extends ConsumerWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      routerConfig: ref.watch(
        routerProvider(
          locator<SharedPreferences>().getString(AppRouteObserver.name) ?? '/',
        ),
      ),
      //
      // > l10n
      //
      locale: ref.watch(appLocaleProvider).locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      title: 'AIS 3USON App',
      //
      // > theme
      //
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ref.watch(appThemeProvider),

      debugShowCheckedModeBanner: false,
    );
  }
}
