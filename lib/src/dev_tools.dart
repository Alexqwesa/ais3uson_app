import 'dart:developer' as dev;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_html/flutter_html.dart';
import '../src/global.dart';

/// About page + dev tests
///
/// about and test buttons...
class DevPage extends StatelessWidget {
  const DevPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("О приложении"),
      ),
      body: Center(
        child: Column(children: [
          const Text("Приложение для ввода услуг"),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Назад!'),
          ),
          /*
          Test web worker
          */
          CheckWorkerServer(),
          /*
          Test web worker POST
          */
          CheckWorkerServerPOST(),
        ]),
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
      setState(() {
        _testHTTP = response.body;
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
    var url = Uri.parse(SERVER + ':48080/test');
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
            checkHTTP();
          },
          child: const Text('Передача!'),
        ),
        Flexible(
          child: Html(data: _testHTTP),
        ),
      ],
    );
  }
}
