import 'package:ais3uson_app/src/generated/l10n.dart';
import 'package:ais3uson_app/ui_root.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Hive in memory
Future<void> setUpTestHive() async {
  // final tempDir = await getTempDir();
  Hive.init(null, backendPreference: HiveStorageBackendPreference.memory);
}

/// Deletes the temporary [Hive].
Future<void> tearDownTestHive() async {
  await Hive.deleteFromDisk();
}

// ignore: avoid-returning-widgets
MaterialApp localizedMaterialApp(
  Widget? widget,
  ProviderContainer ref, {
  String? initialRoute,
  // Map<String, WidgetBuilder>? routes,
}) {
  // final routes = <String, Widget Function(BuildContext)>{
  //   '/journal': (context) => const ArchiveServicesOfClientScreen(),
  //   '/add_department': (context) => const AddDepartmentScreen(),
  //   '/client_services': (context) => ProviderScope(overrides: [
  //         currentClient.overrideWithValue(
  //             ref.read(departmentsProvider).first.clients.first)
  //       ], child: const ListOfClientServicesScreen()),
  //   '/settings': /*    */ (context) => const SettingsScreen(),
  //   '/department': /*  */ (context) => ListOfClientsScreen(
  //         workerProfile: ref.read(departmentsProvider).first,
  //       ),
  //   '/scan_qr': /*     */ (context) => const QRScanScreen(),
  //   '/dev': /*         */ (context) => const DevScreen(),
  //   '/delete_department': (context) => const DeleteDepartmentScreen(),
  //   '/': /*            */ (context) => const HomeScreen(),
  // };

  if (initialRoute == null) {
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
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
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
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
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
