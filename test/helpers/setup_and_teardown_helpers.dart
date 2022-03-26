import 'package:ais3uson_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// ignore: avoid-returning-widgets
MaterialApp localizedMaterialApp(Widget widget) {
  return MaterialApp(
    //
    // > l10n
    //
    localizationsDelegates: const [
      S.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: S.delegate.supportedLocales,
    home: widget,
  );
}
