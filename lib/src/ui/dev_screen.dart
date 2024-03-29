import 'dart:developer' as dev;

import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:ais3uson_app/src/api_classes/worker_key.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

/// Provider of responses to a test http and https connections.
final _httpFuture = StateProvider.family<Future<http.Response>?, bool>(
  (ref, ssl) => null,
);

/// About page + tests
class DevScreen extends StatelessWidget {
  const DevScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr().about,
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      tr().shortAboutApp,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ),
                  Text(
                    tr().developer,
                    style: Theme.of(context).textTheme.displaySmall,
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
class CheckWorkerServer extends ConsumerWidget {
  CheckWorkerServer({super.key}) {
    // ref.read(_httpFuture(false).notifier) = null;
    // ref.read(_httpFuture(true).notifier) = null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wKeys = ref.watch(workerKeysProvider).keys;
    if (wKeys.isEmpty) {
      return const Text('Please add Department or test Department!');
    }

    final host = wKeys.first.activeHost;
    final port = wKeys.first.activePort;

    return Column(
      children: <Widget>[
        ElevatedButton(
          onPressed: () => checkHTTP(ref, wKeys.first),
          child: Text(
            tr().testConnection,
          ),
        ),
        if (ref.watch(_httpFuture(false)) != null)
          Column(
            children: [
              Text('Http Response to http://$host:$port/stat:'),
              FutureBuilder(
                future: ref.watch(_httpFuture(false)),
                builder: buildHttpFuture,
              ),
            ],
          ),
        if (ref.watch(_httpFuture(true)) != null)
          Column(
            children: [
              Text('Https Response to https://$host:$port/stat:'),
              FutureBuilder(
                future: ref.watch(_httpFuture(true)),
                builder: buildHttpFuture,
              ),
            ],
          ),
      ],
    );
  }

  /// Get statistic from server, check both http and https.
  Future<void> checkHTTP(WidgetRef ref, WorkerKey wKey) async {
    try {
      //
      // > http
      //
      final host = wKey.activeHost;
      final port = wKey.activePort;
      var url = Uri.parse(
        'http://$host:$port/stat',
      );
      ref.watch(_httpFuture(false).notifier).state = http.get(url);
      //
      // > https
      //
      url = Uri.parse(
        'https://$host:$port/stat',
      );
      ref.watch(_httpFuture(true).notifier).state = http.get(url);
      //
      // > wait
      //
      await Future.wait([
        ref.watch(_httpFuture(true)),
        ref.watch(_httpFuture(false))
      ] as Iterable<Future>);
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      dev.log(e.toString());
    }
  }

  /// Function for FutureBuilder
  // ignore:long-method
  Widget buildHttpFuture(
    BuildContext _,
    AsyncSnapshot<http.Response> snapshot,
  ) {
    final List<Widget> children;

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
      children = <Widget>[
        const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text(tr().awaitResults),
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
