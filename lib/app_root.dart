import 'package:ais3uson_app/source/app_data.dart';
import 'package:ais3uson_app/source/screens/delete_department_screen.dart';
import 'package:ais3uson_app/source/screens/dev_screen.dart';
import 'package:ais3uson_app/source/screens/fio_screen.dart';
import 'package:ais3uson_app/source/screens/home_screen.dart';
import 'package:ais3uson_app/source/screens/scan_qr/qr_scan_sreen.dart';
import 'package:ais3uson_app/source/screens/service_related/fio_services_screen.dart';
import 'package:ais3uson_app/themes_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Root widget of whole app
///
/// Only theme and navigation routes here.
/// home: [HomePage]
class AppRoot extends StatelessWidget {
  const AppRoot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AIS 3USON App',
      //
      // > theme
      //
      theme:  StandardTheme.dark(),
      //
      // > routes
      //
      initialRoute: '/',
      routes: {
        '/department': /*  */ (context) => const FioScreen(),
        '/scan_qr': /*     */ (context) => const QRScanScreen(),
        '/dev': /*         */ (context) => const DevScreen(),
        '/fio_services': /**/ (context) => FioServicesScreen(),
        '/delete_department': (context) => const DeleteDepartmentScreen(),
        '/': /*            */ (context) => const HomePage(
              title: 'Список отделений',
            ),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
