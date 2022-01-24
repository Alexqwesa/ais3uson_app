import 'package:ais3uson_app/source/app_data.dart';
import 'package:ais3uson_app/source/screens/delete_department_screen.dart';
import 'package:ais3uson_app/source/screens/dev_screen.dart';
import 'package:ais3uson_app/source/screens/fio_screen.dart';
import 'package:ais3uson_app/source/screens/home_screen.dart';
import 'package:ais3uson_app/source/screens/scan_qr/qr_scan_sreen.dart';
import 'package:ais3uson_app/source/screens/service_related/client_services_list_screen.dart';
import 'package:ais3uson_app/themes_data.dart';
import 'package:flutter/material.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
        '/department': /*  */ (context) => const FioScreen(),
        '/scan_qr': /*     */ (context) => const QRScanScreen(),
        '/dev': /*         */ (context) => const DevScreen(),
        '/fio_services': /**/ (context) => ClientServicesListScreen(),
        '/delete_department': (context) => const DeleteDepartmentScreen(),
        '/': /*            */ (context) => const HomePage(
              title: 'Список отделений',
            ),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
