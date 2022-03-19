// ignore_for_file: always_use_package_imports

import 'package:ais3uson_app/generated/l10n.dart';
import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/source/app_data.dart';
import 'package:ais3uson_app/source/data_classes/worker_profile.dart';
import 'package:ais3uson_app/source/screens/list_profiles.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

/// Show screen with main menu and with list of [WorkerProfile].
///
/// {@category WorkerProfiles}
class HomePage extends StatefulWidget {
  final String title;

  const HomePage({required this.title, Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    locator<AppData>().standardTheme.addListener(_standardListener);
    locator<AppData>().addListener(_standardListener);
  }

  @override
  void dispose() {
    locator<AppData>().removeListener(_standardListener);
    locator<AppData>().standardTheme.removeListener(_standardListener);

    return super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //
      // > drawer
      //
      drawer: locator<AppData>().isArchive
          ? null
          : Drawer(
              child: ListView(
                controller: ScrollController(),
                children: [
                  //
                  // > logo
                  //
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width / 4,
                        ),
                        child: SizedBox.square(
                          child: Image.asset('assets/ais-3uson-logo.png'),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      S.of(context).shortAboutApp,
                      style: Theme.of(context).textTheme.headline5,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  //
                  // > menu list
                  //
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.group_add),
                    title: Text(
                      S.of(context).addDepFromText,
                    ),
                    onTap: () {
                      Navigator.pop(
                        context,
                        'qr',
                      );
                      Navigator.pushNamed(
                        context,
                        '/add_department',
                        arguments: '',
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.add,
                      color: Colors.green,
                    ),
                    title: Text(S.of(context).scanQrCode),
                    onTap: () {
                      Navigator.pop(context, 'qr');
                      Navigator.pushNamed(
                        context,
                        '/scan_qr',
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.delete),
                    title: Text(S.of(context).deleteDep),
                    onTap: () {
                      Navigator.pop(context, 'delete_department');
                      Navigator.pushNamed(
                        context,
                        '/delete_department',
                        arguments: '',
                      );
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.archive),
                    title: Text(S.of(context).archive),
                    onTap: () {
                      locator<AppData>().isArchive =
                          !locator<AppData>().isArchive;
                      Navigator.pop(context, 'archive');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: Text(S.of(context).settings),
                    onTap: () {
                      Navigator.pop(context, 'settings');
                      Navigator.pushNamed(
                        context,
                        '/settings',
                        arguments: '',
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.adb),
                    title: Text(S.of(context).about),
                    onTap: () {
                      Navigator.pop(context, 'dev');
                      Navigator.pushNamed(
                        context,
                        '/dev',
                        arguments: '',
                      );
                    },
                  ),
                  const Divider(),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          S.of(context).theme,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                      ToggleSwitch(
                        minWidth: 145.0,
                        minHeight: 34,
                        cornerRadius: 83.0,
                        activeBgColors: [
                          [Theme.of(context).primaryColor],
                          [Theme.of(context).primaryColor],
                        ],
                        activeFgColor: Colors.white,
                        inactiveBgColor: const Color(0xffECEFF1),
                        inactiveFgColor: Colors.black,
                        initialLabelIndex:
                            locator<AppData>().standardTheme.themeIndex,
                        totalSwitches: 2,
                        labels: [S.of(context).light, S.of(context).dark],
                        radiusStyle: true,
                        onToggle: (index) {
                          locator<AppData>().standardTheme.changeIndex(index!);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
      //
      // appBar
      //
      appBar: AppBar(
        title: Text(widget.title),
      ),
      //
      // > body
      //
      body: Center(
        heightFactor: 1.1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Expanded(
              child: ListOfProfiles(),
            ),
          ],
        ),
      ),
      //
      // > scan qr button
      //
      floatingActionButton: locator<AppData>().isArchive
          ? null
          : FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/scan_qr',
                );
              },
              tooltip: S.of(context).scanQrCode,
              child: const Icon(Icons.add),
            ),
    );
  }

  void _standardListener() {
    setState(() {
      return;
    });
  }
}
