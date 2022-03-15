import 'dart:io';

import 'package:ais3uson_app/generated/l10n.dart';
import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/source/app_data.dart';
import 'package:ais3uson_app/source/global_helpers.dart';
import 'package:ais3uson_app/source/screens/add_department_screen.dart';
import 'package:ais3uson_app/source/screens/clients_screen.dart';
import 'package:ais3uson_app/source/screens/delete_department_screen.dart';
import 'package:ais3uson_app/source/screens/dev_screen.dart';
import 'package:ais3uson_app/source/screens/home_screen.dart';
import 'package:ais3uson_app/source/screens/qr_scan_sreen.dart';
import 'package:ais3uson_app/source/screens/service_related/client_services_list_screen.dart';
import 'package:ais3uson_app/source/screens/settings_screen.dart';
import 'package:ais3uson_app/themes_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

/// Root widget of whole app.
///
/// {@category Root}
class AppRoot extends StatefulWidget {
  const AppRoot({Key? key}) : super(key: key);

  @override
  _AppRootState createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  @override
  void initState() {
    super.initState();
    AppData.instance.addListener(_standardListener);
  }

  @override
  void dispose() {
    AppData.instance.removeListener(_standardListener);

    return super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppData.instance.isArchive
        ? const ArchiveMaterialApp()
        : const MainMaterialApp();
  }

  void _standardListener() {
    setState(() {
      return;
    });
  }
}

/// Show Archive AppBar then app in archive mode.
///
/// {@category Root}
class ArchiveMaterialApp extends StatelessWidget {
  const ArchiveMaterialApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        appBar: AppData.instance.isArchive
            ? AppBar(
                title: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        AppData.instance.isArchive =
                            !AppData.instance.isArchive;
                      },
                      icon: const Icon(Icons.cancel_outlined),
                    ),
                    Text(
                      '${locator<S>().archiveAt} ${standardFormat.format(AppData.instance.archiveDate)}',
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
                          final datesInArchive = AppData.instance.datesInArchive
                              .toList(growable: true);
                          AppData.instance.archiveDate = await showDatePicker(
                            context: context,
                            selectableDayPredicate: datesInArchive.contains,
                            initialDate: datesInArchive.last,
                            lastDate: datesInArchive.last,
                            firstDate: datesInArchive.first,
                          );
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
                      (AppData.instance.isArchive
                          ? kToolbarHeight // AppData.instance.windowTopPadding * 2
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

/// This is main MaterialApp widget.
///
/// Only theme [StandardTheme] and navigation routes here.
/// home: [HomePage].
///
/// {@category Root}
class MainMaterialApp extends StatelessWidget {
  const MainMaterialApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: AppData.instance.standardTheme,
      child: Consumer<StandardTheme>(
        builder: (context, data, child) {
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
            theme: StandardTheme.light(),
            darkTheme: StandardTheme.dark(),
            themeMode: AppData.instance.standardTheme.current(),
            //
            // > routes
            //
            initialRoute: '/',
            routes: {
              '/add_department': (context) => AddDepartmentScreen(),
              '/client_services': (context) => ClientServicesListScreen(),
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
        },
      ),
    );
  }
}
