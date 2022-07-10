import 'dart:io';

import 'package:ais3uson_app/global_helpers.dart';
import 'package:ais3uson_app/journal.dart';
import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:ais3uson_app/src/generated/l10n.dart';
import 'package:ais3uson_app/src/ui/app_route_observer.dart';
import 'package:ais3uson_app/ui_departments.dart';
import 'package:ais3uson_app/ui_root.dart';
import 'package:ais3uson_app/ui_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Root widget of whole app.
///
/// Switch between [ArchiveMaterialApp] and [MainMaterialApp]
///
/// {@category UI Root}
class AppRoot extends ConsumerWidget {
  const AppRoot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(isArchive)
        ? const ArchiveMaterialApp()
        : const MainMaterialApp();
  }
}

/// Show Archive AppBar then app in archive mode.
///
/// {@category UI Root}
class ArchiveMaterialApp extends ConsumerWidget {
  const ArchiveMaterialApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: ref.watch(isArchive)
            ? AppBar(
                title: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        ref.read(isArchive.notifier).state = false;
                      },
                      icon: const Icon(Icons.cancel_outlined),
                    ),
                    Text(
                      '${tr().archiveAt} '
                      // ignore: lines_longer_than_80_chars
                      '${ref.watch(archiveDate) == null ? '' : standardFormat.format(ref.watch(archiveDate)!)}',
                    ),
                  ],
                ),
                backgroundColor: Colors.yellow[700],
                actions: [
                  Builder(
                    builder: (context) {
                      return IconButton(
                        icon: const Icon(Icons.date_range),
                        onPressed: () async {
                          await setArchiveOnWithDatePicker(context, ref);
                        },
                      );
                    },
                  ),
                ],
              )
            : null,
        body: Builder(
          builder: (context) {
            return OverflowBox(
              alignment: Alignment.bottomCenter,
              // this code is only for platforms with status bar (android)
              maxHeight: !kIsWeb && !Platform.isAndroid
                  ? null
                  : MediaQuery.of(context).size.height -
                      (ref.watch(isArchive) ? kToolbarHeight : 0),
              //
              // > main MaterialApp
              //
              child: const MainMaterialApp(),
            );
          },
        ),
      ),
    );
  }

  /// Activate archive mode([isArchive]) only if [datesInArchiveController].dates
  /// not empty.
  ///
  /// It also show date picker to set [archiveDate].
  static Future<void> setArchiveOnWithDatePicker(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final archiveDates = await ref.read(datesInArchiveController).datesInited();

    if (archiveDates.isEmpty) {
      ref.read(isArchive.notifier).state = false;

      return;
    }
    ref.read(archiveDate.notifier).state = await showDatePicker(
      context: context,
      selectableDayPredicate: archiveDates.contains,
      initialDate: archiveDates.last,
      lastDate: archiveDates.last,
      firstDate: archiveDates.first,
    );
    ref.read(isArchive.notifier).state = true;
  }
}

/// This is main MaterialApp widget.
///
/// Only theme [standardTheme] and navigation routes here.
/// home: [HomeScreen].
///
/// {@category UI Root}
class MainMaterialApp extends ConsumerWidget {
  const MainMaterialApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      title: 'AIS 3USON App',
      //
      // > theme
      //
      theme: StandardThemeState.light(),
      darkTheme: StandardThemeState.dark(),
      themeMode: ref.watch(standardTheme),
      //
      // > routes
      //
      navigatorObservers: <NavigatorObserver>[
        AppRouteObserver(), // this will listen all changes
      ],
      initialRoute: locator<SharedPreferences>().getString('last_route') ?? '/',
      routes: {
        '/client_journal': (context) => const ArchiveServicesOfClientScreen(),
        '/add_department': (context) => const AddDepartmentScreen(),
        '/client_services': (context) => const ListOfClientServicesScreen(),
        '/service': /*     */ (context) => const ClientServiceScreen(),
        '/settings': /*    */ (context) => const SettingsScreen(),
        '/department': /*  */ (context) => const ClientScreen(),
        '/scan_qr': /*     */ (context) => const QRScanScreen(),
        '/dev': /*         */ (context) => const DevScreen(),
        '/delete_department': (context) => const DeleteDepartmentScreen(),
        '/': /*            */ (context) => const HomeScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
