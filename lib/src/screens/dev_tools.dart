import 'dart:convert';
import 'dart:developer' as dev;

import 'package:ais3uson_app/src/data_classes/app_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;

import '../global.dart';
import 'list_all_services.dart';

/// About page + dev tests
///
/// about and test buttons...
class DevPage extends StatelessWidget {
  const DevPage({Key? key}) : super(key: key);
  static const routeName = '/dev';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("О приложении"),
      ),
      body: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height,
        ),
        child: Center(
          child: SizedBox(
            child: Center(
              child: Column(children: const [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Мобльное приложение для ввода услуг АИС "ТриУСОН" ',
                    textScaleFactor: 1.5,
                    textAlign: TextAlign.center,
                  ),
                ),
                // ElevatedButton(
                //   onPressed: () {
                //     Navigator.pop(context);
                //   },
                //   child: const Text('Назад!'),
                // ),
                /*
                Test web worker
                */
                CheckWorkerServer(),
                /*
                Test web worker POST
                */
                CheckWorkerServerPOST(),
                Expanded(child: ListOfAllServices()),
              ]),
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
  // const _CheckWorkerServer({Key? key}) : super(key: key){
  // }

  String _testHTTP = "";

  void checkHTTP() async {
    var url = Uri.parse(SERVER + ':48080/stat');
    http.get(url).then((response) {
      if (response.statusCode == 200) {
        setState(() {
          _testHTTP = response.body;
        });
      }
    }).catchError((e) {
      setState(() {
        _testHTTP = "${e.toString()}";
        dev.log(e);
      });
    }).whenComplete(() => dev.log(_testHTTP));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        ElevatedButton(
          onPressed: () {
            checkHTTP();
          },
          child: const Text('Соединение!'),
        ),
        Flexible(
          child: Html(data: _testHTTP),
        ),
      ],
    );
  }
}

/// Test web worker POST
///
/// get POST data from Web worker
class CheckWorkerServerPOST extends StatefulWidget {
  const CheckWorkerServerPOST({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CheckWorkerServerPOST();
  }
}

class _CheckWorkerServerPOST extends State<CheckWorkerServerPOST> {
  String _testHTTP = "";
  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };
  String body = qrData;

  void checkHTTP() async {
    var url = Uri.parse(SERVER + ':48080/planned');
    http.post(url, headers: headers, body: body).then((response) {
      setState(() {
        _testHTTP = jsonDecode(response.body).toString();
      });
    }).catchError((e) {
      setState(() {
        _testHTTP = "$e";
      });
    }).whenComplete(() => dev.log(_testHTTP));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        ElevatedButton(
          onPressed: () {
            // checkHTTP();
            AppData.instance.syncHive();
          },
          child: const Text('Обновить!'),
        ),
        Flexible(
          child: Html(data: _testHTTP),
        ),
      ],
    );
  }
}
