// ignore_for_file: always_use_package_imports, avoid_annotating_with_dynamic

import 'dart:developer' as dev;

import 'package:ais3uson_app/source/app_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;

/// About page + dev tests
///
/// about and test buttons...
class DevScreen extends StatelessWidget {
  const DevScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('О приложении'),
      ),
      body: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height,
        ),
        child: Center(
          child: SizedBox(
            child: Center(
              child: Column(
                children: const [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Мобльное приложение для ввода услуг АИС "ТриУСОН" ',
                      textScaleFactor: 1.5,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Text(
                    'Разработчик: Савин Александр Викторович',
                  ),
                  //
                  // > Get stat
                  //
                  CheckWorkerServer(),
                  // Expanded(child: ListOfAllServices()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Test web worker
///
/// get status data from Web worker
class CheckWorkerServer extends StatefulWidget {
  const CheckWorkerServer({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CheckWorkerServer();
  }
}

class _CheckWorkerServer extends State<CheckWorkerServer> {
  String _testHTTP = '';

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        ElevatedButton(
          onPressed: checkHTTP,
          child: const Text('Соединение!'),
        ),
        Flexible(
          child: Html(data: _testHTTP),
        ),
      ],
    );
  }

  Future<void> checkHTTP() async {
    final url = Uri.parse(
      'http://${AppData().profiles.first.key.host}:${AppData().profiles.first.key.port}/stat',
    );
    try {
      await http.get(url).then((response) {
        if (response.statusCode == 200) {
          setState(() {
            _testHTTP = response.body;
          });
        }
      }).catchError((dynamic e) {
        setState(() {
          _testHTTP = e.toString();
          dev.log(e.toString());
        });
      }).whenComplete(() => dev.log(_testHTTP));
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      dev.log('Error $e');
    }
  }
}
