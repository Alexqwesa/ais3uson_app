import 'dart:io';

import 'package:ais3uson_app/source/app_data.dart';
import 'package:ais3uson_app/source/global_helpers.dart';
import 'package:ais3uson_app/source/screens/add_department_screen.dart';
import 'package:ais3uson_app/source/screens/client_screen.dart';
import 'package:ais3uson_app/source/screens/delete_department_screen.dart';
import 'package:ais3uson_app/source/screens/dev_screen.dart';
import 'package:ais3uson_app/source/screens/home_screen.dart';
import 'package:ais3uson_app/source/screens/scan_qr/qr_scan_sreen.dart';
import 'package:ais3uson_app/source/screens/service_related/client_services_list_screen.dart';
import 'package:ais3uson_app/themes_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Root widget of whole app.
///
/// Only theme [StandardTheme] and navigation routes here.
/// home: [HomePage].
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
    AppData.instance.standardTheme.addListener(() {
      setState(() {
        return;
      });
    });
    AppData.instance.addListener(() {
      setState(() {
        return;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
                      'Архив на: ${standardFormat.format(AppData.instance.archiveDate)}',
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
                          final lastDate =
                              DateTime.now().add(const Duration(days: -1));
                          AppData.instance.archiveDate = await showDatePicker(
                            context: context,
                            initialDate: AppData.instance.archiveDate,
                            firstDate: DateTime(
                              AppData.instance.archiveDate.day - 365,
                            ),
                            lastDate: lastDate,
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
              child: MaterialApp(
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
                  '/department': /*  */ (context) => const ClientScreen(),
                  '/scan_qr': /*     */ (context) => const QRScanScreen(),
                  '/dev': /*         */ (context) => const DevScreen(),
                  '/delete_department': (context) =>
                      const DeleteDepartmentScreen(),
                  '/': /*            */ (context) => const HomePage(
                        title: 'Список отделений',
                      ),
                },
                debugShowCheckedModeBanner: false,
              ),
            );
          },
        ),
      ),
    );
  }
}
