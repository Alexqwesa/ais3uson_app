import 'package:ais3uson_app/source/screens/delete_department_screen.dart';
import 'package:ais3uson_app/source/screens/dev_screen.dart';
import 'package:ais3uson_app/source/screens/fio_screen.dart';
import 'package:ais3uson_app/source/screens/fio_services_screen.dart';
import 'package:ais3uson_app/source/screens/home_screen.dart';
import 'package:ais3uson_app/source/screens/scan_qr/qr_scan_sreen.dart';
import 'package:flutter/material.dart';

/// [AppRoot]
///
/// Root widget of whole app
class AppRoot extends StatelessWidget {
  const AppRoot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AIS 3USON App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(title: 'Список отделений'),
        '/department': (context) => const FioScreen(),
        '/scan_qr': (context) => const QRScanScreen(),
        DevScreen.routeName: (context) => const DevScreen(),
        '/fio_services': (context) => FioServicesScreen(),
        '/delete_department': (context) => const DeleteDepartmentScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
