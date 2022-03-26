import 'dart:io';

import 'package:ais3uson_app/generated/l10n.dart';
import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/source/global_helpers.dart';
import 'package:ais3uson_app/source/providers/dates_in_archive.dart';
import 'package:ais3uson_app/source/providers/providers.dart';
import 'package:ais3uson_app/source/screens/add_department_screen.dart';
import 'package:ais3uson_app/source/screens/clients_screen.dart';
import 'package:ais3uson_app/source/screens/delete_department_screen.dart';
import 'package:ais3uson_app/source/screens/dev_screen.dart';
import 'package:ais3uson_app/source/screens/home_screen.dart';
import 'package:ais3uson_app/source/screens/qr_scan_sreen.dart';
import 'package:ais3uson_app/source/screens/service_related/client_services_list_screen.dart';
import 'package:ais3uson_app/source/screens/service_related/confirmation_for_list_of_services.dart';
import 'package:ais3uson_app/source/screens/settings_screen.dart';
import 'package:ais3uson_app/themes_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Root widget of whole app.
///
/// {@category Root}
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
/// {@category Root}
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
                        ref.read(isArchive.notifier).update((state) => !state);
                      },
                      icon: const Icon(Icons.cancel_outlined),
                    ),
                    Text(
                      '${locator<S>().archiveAt} ${ref.watch(archiveDate) == null ? "" : standardFormat.format(ref.watch(archiveDate)!)}',
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
                          await archiveOnWithDatePicker(context, ref);
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
                      (ref.watch(isArchive)
                          ? kToolbarHeight // locator<AppData>().windowTopPadding * 2
                          : 0),
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
}

/// Activate archive mode([isArchive]) only if [datesInArchive] not empty.
///
/// It also show date picker if [archiveDate] is null.
Future<void> archiveOnWithDatePicker(
  BuildContext context,
  WidgetRef ref,
) async {
  final archiveDates = await ref.read(datesInArchive.future);

  // ignore: use_if_null_to_convert_nulls_to_bools
  if (archiveDates?.isEmpty != false) {
    ref.read(isArchive.notifier).state = false;

    return;
  }
  ref.read(archiveDate.notifier).state = await showDatePicker(
    context: context,
    selectableDayPredicate: archiveDates!.contains,
    initialDate: archiveDates.last,
    lastDate: archiveDates.last,
    firstDate: archiveDates.first,
  );
  ref.read(isArchive.notifier).state = true;
}

/// This is main MaterialApp widget.
///
/// Only theme [standardTheme] and navigation routes here.
/// home: [HomePage].
///
/// {@category Root}
class MainMaterialApp extends ConsumerWidget {
  const MainMaterialApp({
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
      initialRoute: '/',
      routes: {
        '/client_journal': (context) => const ConfirmationForListOfServices(),
        '/add_department': (context) => AddDepartmentScreen(),
        '/client_services': (context) => const ClientServicesListScreen(),
        '/settings': /*    */ (context) => const SettingsScreen(),
        '/department': /*  */ (context) => const ClientScreen(),
        '/scan_qr': /*     */ (context) => const QRScanScreen(),
        '/dev': /*         */ (context) => const DevScreen(),
        '/delete_department': (context) => const DeleteDepartmentScreen(),
        '/': /*            */ (context) => HomePage(
              title: S.of(context).depList,
            ),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
