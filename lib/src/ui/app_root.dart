import 'package:ais3uson_app/ui_root.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locale_switcher/locale_switcher.dart';

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
  final String lastRouteOrRoot;

  const AppRoot({required this.lastRouteOrRoot, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LocaleManager(
      child: MaterialApp.router(
        routerConfig: ref.watch(routerProvider(lastRouteOrRoot)),
        //
        // > l10n
        //
        locale: LocaleManager.locale.value,
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
      ),
    );
  }
}
