import 'dart:convert';

import 'package:ais3uson_app/src/data_classes/app_data.dart';
import 'package:ais3uson_app/src/data_classes/from_json/user_key.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dev_tools.dart';
import '../global.dart';
import 'list_fio.dart';
import 'list_profiles.dart';
import 'scan_qr/scan_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AIS 3USON App',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/department': (BuildContext context) => const ListFio(),
        DevPage.routeName: (BuildContext context) => const DevPage(),
      },
      home: MyHomePage(title: 'Список отделений'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
          actions: [
            PopupMenuButton(
              icon: const Icon(Icons.more_vert),
              // onCanceled: () {
              //   setState(() {
              //     _counter = 100;
              //   });
              // },
              enabled: true,
              // onSelected: (value) {
              //   setState(() {
              //     _counter = 10;
              //   });
              // },
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                PopupMenuItem(
                  child: ListTile(
                    leading: const Icon(Icons.add),
                    title: const Text('Сканировать QR код'),
                    onTap: () {
                      Navigator.pop(context, "qr");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const QRViewExample()),
                      );
                    },
                  ),
                ),
                PopupMenuItem(
                  child: ListTile(
                      leading: Icon(Icons.group),
                      title: Text('Добавить тестовое отделение'),
                      onTap: () {
                        // AppData.of(context);
                        Navigator.pop(context, "qr");
                        AppData.instance
                            .addProfile(UserKey.fromJson(jsonDecode(qrData2)));
                        // Provider.of<AppData>(context, listen: false).addProfile(UserKey.fromJson(jsonDecode(qrData2)));
                      }),
                ),
                // const PopupMenuItem(
                //   child: ListTile(
                //     leading: Icon(Icons.backspace),
                //     title: Text('Забыть отделение'),
                //   ),
                // ),
                PopupMenuItem(
                  child: ListTile(
                    leading: const Icon(Icons.adb),
                    title: const Text('О программе'),
                    onTap: () {
                      Navigator.pop(context, "dev");
                      Navigator.pushNamed(context, DevPage.routeName,
                          arguments: "");
                    },
                  ),
                ),
              ],
            ),
          ]),
      body: Center(
        heightFactor: 1.1,
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the screens axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: ListOfProfiles(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const QRViewExample()),
          );
        },
        tooltip: 'Добавить отделение',
        child: const Icon(Icons.add),
      ),
    );
  }
}
