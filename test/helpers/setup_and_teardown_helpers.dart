import 'package:ais3uson_app/access_to_io.dart';
import 'package:ais3uson_app/global_helpers.dart';
import 'package:ais3uson_app/src/stubs_for_testing/default_data.dart';
import 'package:ais3uson_app/ui_root.dart';
import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

import 'fake_path_provider_platform.dart';

/// Hive in memory
Future<void> setUpTestHive() async {
  // final tempDir = await getTempDir();
  Hive.init(
    // tempDir.path,
    uuid.v4(),
    backendPreference: HiveStorageBackendPreference.memory,
  );
  await Hive.openBox(hiveHttpCache);
}

/// Deletes the temporary [Hive].
Future<void> tearDownTestHive() async {
  for (final apiKey in [wKeysData2().apiKey, testWorkerKey().apiKey]) {
    try {
      if (Hive.box('journal_$apiKey').isOpen) {
        await Hive.box('journal_$apiKey').clear();
      }
      // ignore: avoid_catches_without_on_clauses, empty_catches
    } catch (e) {}
  }
  // await Hive.close();  // ?
  await Hive.deleteFromDisk();
}

// ignore: avoid-returning-widgets
MaterialApp localizedMaterialApp(
  Widget? widget,
  ProviderContainer ref, {
  String? initialRoute,
  // Map<String, WidgetBuilder>? routes,
}) {
  if (initialRoute == null) {
    return MaterialApp(
      //
      // > l10n
      //
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      //
      // > routes
      //
      home: widget,
      // initialRoute: initialRoute,
      // routes: routes,
    );
  } else {
    return MaterialApp.router(
      //
      // > l10n
      //
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      //
      // > routes
      //

      routerConfig: ref.read(routerProvider(initialRoute)),
    );
  }
}

extension PumpApp on WidgetTester {
  Future<void> pumpRealRouterApp(
    String initialRoute,
    Widget Function(Widget child) builder, {
    required ProviderContainer ref,
  }) {
    // Logic to initialize my StateManagement with the
    // value of isConnected
    // ...

    return pumpWidget(
      builder(
        MaterialApp.router(
          //
          // > l10n
          //
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          //
          // > routes
          //

          routerConfig: ref.read(routerProvider(initialRoute)),

          // routeInformationParser:
          //     ref.read(routerProvider(location)).routeInformationParser,
          // routerDelegate: ref.read(routerProvider(location)).routerDelegate,
        ),
      ),
    );
  }
}
