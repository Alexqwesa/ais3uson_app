// ignore_for_file: cascade_invocations

import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:ais3uson_app/access_to_io.dart';
import 'package:ais3uson_app/dynamic_data_models.dart';
import 'package:ais3uson_app/global_helpers.dart';
import 'package:ais3uson_app/main.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:synchronized/synchronized.dart';

part 'access_http.g.dart';

/// Name of hiveBox with worker profiles
const hiveHttpCache = 'http_cache';

/// Make http requests, and cache them in [hiveBox] ([hiveHttpCache])].
///
/// Require [hiveBox(hiveHttpCache)] to be awaited before start of app!
///
/// Read hive on init, [state] is a List from json [http.Response] ,
///  save state to [Hive].
/// {@category Providers}
@Riverpod(keepAlive: true)
class Http extends _$Http {
  static String hiveName = hiveHttpCache;
  final _lock = Lock();

  @override
  List<Map<String, dynamic>> build(String apiKey, String path) {
    log.fine('HttpDataState recreated $apiKey$path');
    final hive = future();

    // return ref.watch(hiveBox(hiveName)).when(
    //     data: (hive) {
    updateIfOld();
    final hiveKey = apiKey + path;
    final data = jsonDecode(hive.get(hiveKey) as String? ?? '[]') as List;
    return data.whereType<Map<String, dynamic>>().toList();
    //       },
    //       error: (o, e) => [],
    //       loading: () => []);
  }

  DateTime get updatedAt {
    return ref.watch(hiveBox(hiveName)).when(
        data: (hive) {
          return hive.get('sync_date_$apiKey$path') as DateTime? ?? nullDate;
        },
        error: (o, e) => nullDate,
        loading: () => nullDate);
  }

  // ignore: strict_raw_type
  Box future() => ref.watch(hiveBox(hiveName)).requireValue;

  Worker get worker => ref.read(workerByApiProvider(apiKey));

  String get urlAddress => worker.key.activeServer + path;

  Map<String, String> get headers => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'api-key': apiKey,
      };

  /// Force get new data from http.
  Future<void> update() async {
    await _lock.synchronized(() async {
      // await future();
      final url = Uri.parse(urlAddress);
      try {
        //
        // > main - call server
        //
        final client = ref.read<http.Client>(
          httpClientProvider(worker.key.certBase64),
        );
        final response = await client.get(url, headers: headers);
        //
        // > check response
        //
        log.finest('$urlAddress response.statusCode = ${response.statusCode}');
        if (response.statusCode == 200 && response.body.isNotEmpty) {
          // ignore: avoid_dynamic_calls
          final dynamic js = jsonDecode(response.body);
          if (js is List && js.isNotEmpty) {
            _writeHive(response.body);
            state = js
                .whereType<Map<String, dynamic>>()
                .where((e) => e.isNotEmpty)
                .toList(growable: false);
          }
        }
        //
        // > just error handling
        //
      } on FormatException {
        log.severe(' Wrong json format - FormatException');
        showErrorNotification(tr().errorFormat);
      } on HandshakeException {
        showErrorNotification(tr().sslError);
        log.severe('Server HandshakeException error $url ');
      } on http.ClientException {
        showErrorNotification(tr().serverError);
        log.severe('Server error  $url  ');
      } on SocketException {
        showErrorNotification(tr().internetError);
        log.warning('No internet connection $url ');
      } on HttpException {
        showErrorNotification(tr().httpAccessError);
        log.severe('Server access error $url ');
      } finally {
        log.fine('sync ended $url ');
      }
    });
  }

  void _writeHive(String data) {
    final hive = future();
    // ref.watch(hiveBox(hiveName)).whenData((hive) async { // didn't work in tests
    // for getting new test data
    // print("=== " + apiKey + url);
    // print("=== " + response.body);
    hive.put(apiKey + path, data);
    hive.put('sync_date_$apiKey$path', DateTime.now());
    // });
  }

  // break tests if async
  String updateIfOld() {
    // return  _lock.synchronized(() async {
    if (apiKey == 'none') {
      log.severe('None apiKey sync');
      return 'error';
    }
    //
    // > check hive update needed
    //
    // final hive = await future();
    if (updatedAt.isBefore(DateTime.now().add(const Duration(hours: -2)))) {
      final hive = future();
      hive.put('sync_date_$apiKey$path',
          DateTime.now().add(const Duration(hours: -1, minutes: -59)));
      update();

      return 'updated';
    }

    return 'loaded';
    // });
  }
}

/// Provider of httpClient (with certificate if not null).
///
/// {@category Providers}
final httpClientProvider =
    Provider.family<http.Client, String>((ref, certificate) {
  var client = http.Client();

  if (certificate.isNotEmpty) {
    final cert = const Base64Decoder().convert(certificate);
    try {
      if (cert.isNotEmpty) {
        final context = SecurityContext()..setTrustedCertificatesBytes(cert);
        client = (HttpClient(context: context)
          ..badCertificateCallback = (cert, host, port) {
            // if (host == 'localhost') {
            //   // for debug
            //   return true;
            // }
            log.severe('!!!!Bad certificate');
            // showErrorNotification(tr().errorWrongCertificate);

            return false;
          }) as http.Client;
      }
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      log.severe('!!!!Bad certificate');
      showErrorNotification(tr().errorWrongCertificate);
    }
  }

  return client;
});
