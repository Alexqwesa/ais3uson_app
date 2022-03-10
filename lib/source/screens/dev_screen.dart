import 'dart:developer' as dev;

import 'package:ais3uson_app/generated/l10n.dart';
import 'package:ais3uson_app/source/app_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;

/// About page + tests
class DevScreen extends StatelessWidget {
  const DevScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).about),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      S.of(context).shortAboutApp,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline2,
                    ),
                  ),
                  Text(
                    'Разработчик: Савин Александр Викторович aka Alexqwesa',
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  const Divider(),
                  Html(
                    data: '''
                    <div>
                        <p dir="auto">Изображения в папке images получены с сервиса <a href="http://www.flaticon.com" rel="nofollow">www.flaticon.com</a>, в
                            соответствии требованиями сервиса, размещены ссылки:</p>

                          Some Icons in folder <em>images</em> made by authors: <a href="http://www.freepik.com" rel="nofollow">Freepik</a>
                            , <a href="http://www.flaticon.com/authors/smashicons" rel="nofollow">Smashicons</a>
                        , <a href="https://www.flaticon.com/authors/dinosoftlabs" rel="nofollow">DinosoftLabs</a>
                        , <a href="https://www.flaticon.com/authors/zafdesign" rel="nofollow">zafdesign</a>
                        , <a href="https://www.flaticon.com/authors/GOWI" rel="nofollow">GOWI</a>
                        , <a href="https://www.flaticon.com/authors/Konkapp" rel="nofollow">Konkapp</a>
                        , <a href="https://www.flaticon.com/authors/photo3idea_studio" rel="nofollow">photo3idea_studio</a>
                        , <a href="https://www.flaticon.com/authors/monkik" rel="nofollow">monkik</a>
                        , <a href="https://www.flaticon.com/authors/Payungkead" rel="nofollow">Payungkead</a>
                        , <a href="https://www.flaticon.com/authors/Eucalyp" rel="nofollow">Eucalyp</a>
                        , <a href="https://www.flaticon.com/authors/kosonicon" rel="nofollow">kosonicon</a>
                        , <a href="https://www.flaticon.com/authors/wanicon" rel="nofollow">wanicon</a>
                        from <a href="http://www.flaticon.com" rel="nofollow">www.flaticon.com</a>

                        These images belongs to its owners, I
                        am <a href="https://web.archive.org/web/20211109140855/https://support.flaticon.com/hc/en-us/articles/207248209" rel="nofollow">allowed to use them</a>
                        in this project by permission of service <a href="http://www.flaticon.com" rel="nofollow">www.flaticon.com</a>.
                  </div>
                  ''',
                  ),

                  const Divider(),
                  //
                  // > Get stat
                  //
                  const CheckWorkerServer(),
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
  Future<http.Response>? _httpFuture;
  Future<http.Response>? _httpsFuture;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ElevatedButton(
          onPressed: checkHTTP,
          child: Text(S.of(context).testConnection),
        ),
        if (_httpFuture != null)
        Column(
          children: [
            const Text('Http Response:'),
            FutureBuilder(
              future: _httpFuture,
              builder: buildHttpFuture,
            ),
          ],
        ),
        if (_httpsFuture != null)
        Column(
          children: [
            const Text('Https Response:'),
            FutureBuilder(
              future: _httpsFuture,
              builder: buildHttpFuture,
            ),
          ],
        ),
      ],
    );
  }

  /// Get statistic from server, check both http and https.
  Future<void> checkHTTP() async {
    try {
      //
      // > http
      //
      var url = Uri.parse(
        'http://${AppData().profiles.first.key.activeHost}:${AppData().profiles.first.key.activePort}/stat',
      );
      _httpFuture = http.get(url);
      //
      // > https
      //
      url = Uri.parse(
        'https://${AppData().profiles.first.key.activeHost}:${AppData().profiles.first.key.activePort}/stat',
      );
      _httpsFuture = http.get(url);
      setState(() {
        _httpFuture = _httpFuture; // stub
      });
      await _httpsFuture;
      await _httpFuture;
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      dev.log(e
          .toString()); // this is handled exception but android studio thinks it unhandled! bug?
    }
  }

  /// Function for FutureBuilder
  // ignore:long-method
  Widget buildHttpFuture(
    BuildContext context,
    AsyncSnapshot<http.Response> snapshot,
  ) {
    List<Widget> children;
    if (snapshot.hasData) {
      children = <Widget>[
        // FractionallySizedBox(
        //   widthFactor: 1,
        //   child:
        Card(
          child: Column(
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Html(
                  data: snapshot.data?.body,
                  shrinkWrap: true,
                ),
              ),
            ],
          ),
          // ),
        ),
      ];
    } else if (snapshot.hasError) {
      children = <Widget>[
        Card(
          child: Column(
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              ),
            ],
          ),
        ),
      ];
    } else if (snapshot.connectionState == ConnectionState.none) {
      children = [];
    } else {
      children = const <Widget>[
        SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(),
        ),
        Padding(
          padding: EdgeInsets.only(top: 16),
          child: Text('Awaiting result...'),
        ),
      ];
    }

    return Center(
      child: Column(
        children: children,
      ),
    );
  }
}
