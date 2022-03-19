import 'package:ais3uson_app/generated/l10n.dart';
import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/source/app_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'mock_server.dart';

/// Setup full environment for testing.
///
/// Create mocks of: Hive, SharedPreference, httpClient.
Future<void> mySetUpAll() async {
  //
  // > SharedPreference setup
  //
  SharedPreferences.setMockInitialValues({}); //set values here
  //
  // > httpClient setup
  //
  locator<AppData>().httpClient = getMockHttpClient();
}

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
