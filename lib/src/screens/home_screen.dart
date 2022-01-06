// ignore_for_file: always_use_package_imports

import 'dart:convert';

import 'package:ais3uson_app/src/data_classes/app_data.dart';
import 'package:ais3uson_app/src/data_classes/from_json/worker_key.dart';
import 'package:ais3uson_app/src/global.dart';
import 'package:ais3uson_app/src/screens/dev_screen.dart';
import 'package:ais3uson_app/src/screens/list_profiles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({required this.title, Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //
      // > drawer
      //
      drawer: Drawer(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
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
              const Center(
                child: Text(
                  'Мобльное приложение для ввода услуг АИС "ТриУСОН" ',
                  textScaleFactor: 1.5,
                  textAlign: TextAlign.center,
                ),
              ),
              //
              // > menu list
              //
              Expanded(
                child: ListView(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.add),
                      title: const Text('Сканировать QR код'),
                      onTap: () {
                        Navigator.pop(context, 'qr');
                        Navigator.pushNamed(
                          context,
                          '/scan_qr',
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.group),
                      title: const Text('Добавить тестовое отделение'),
                      onTap: () {
                        // AppData.of(context);
                        Navigator.pop(context, 'qr');
                        AppData.instance.addProfileFromUKey(
                          WorkerKey.fromJson(jsonDecode(qrData2)),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.delete),
                      title: const Text('Удалить отделение'),
                      onTap: () {
                        Navigator.pop(context, 'delete_department');
                        Navigator.pushNamed(
                          context,
                          '/delete_department',
                          arguments: '',
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.adb),
                      title: const Text('О программе'),
                      onTap: () {
                        Navigator.pop(context, 'dev');
                        Navigator.pushNamed(
                          context,
                          DevScreen.routeName,
                          arguments: '',
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            '/scan_qr',
          );
        },
        tooltip: 'Добавить отделение',
        child: const Icon(Icons.add),
      ),
    );
  }
}
