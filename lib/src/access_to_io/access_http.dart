import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:ais3uson_app/access_to_io.dart';
import 'package:ais3uson_app/api_classes.dart';
import 'package:ais3uson_app/dynamic_data_models.dart';
import 'package:ais3uson_app/global_helpers.dart';
import 'package:ais3uson_app/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tuple/tuple.dart';

part 'access_http.g.dart';

/// Name of hiveBox with worker profiles
const hiveHttpCache = 'http_cache';

/// Provider of httpData, create families by apiKey and url.
///
/// {@category Providers}
//Todo: delete it
@riverpod
Http repositoryHttp(Ref ref, Tuple2<WorkerKey, String> apiUrl) {
  return ref.read(httpProvider(
    apiUrl.item1.apiKey,
    apiUrl.item2.substring(apiUrl.item2.indexOf('/')),
  ).notifier);
}

/// Repository for families of providers [repositoryHttp].
///
/// Read hive on init, [state] is a [http.Response] in json format,
///  save state to [Hive].
///
/// Public methods [getHttpData] and [syncHiveHttp].
///
/// {@category Providers}
@Riverpod(keepAlive: false)
class Http extends _$Http {
  static String hiveName = hiveHttpCache;

  DateTime get updatedAt {
    return ref.watch(hiveBox(hiveName)).when(
        data: (hive) {
          return hive.get('sync_date_$apiKey$urlAddress') as DateTime? ??
              nullDate;
        },
        error: (o, e) => nullDate,
        loading: () => nullDate);
  }

  @override
  List<Map<String, dynamic>> build(String apiKey, String path) {
    log.fine('HttpDataState recreated $urlAddress');
    // unawaited(syncHiveHttp());

    return ref.watch(hiveBox(hiveName)).when(
        data: (hive) {
          final hiveKey = apiKey + urlAddress;
          final data = jsonDecode(hive.get(hiveKey) as String? ?? '[]') as List;
          return data.whereType<Map<String, dynamic>>().toList();
        },
        error: (o, e) => [],
        loading: () => []);
  }

  // ignore: strict_raw_type
  Future<Box> future() async => ref.watch(hiveBox(hiveName).future);

  Worker get worker => ref.read(workerByApiProvider(apiKey));

  String get urlAddress => worker.key.activeServer + path;

  Map<String, String> get headers => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'api-key': apiKey,
      };

  /// Force get new data from http.
  Future<void> getHttpData() async {
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
          await _writeHive(response.body); // filter out empty data
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
  }

  Future<void> _writeHive(String data) async {
    final hive = await future();
    // ref.watch(hiveBox(hiveName)).whenData((hive) async { // didn't work in tests
      // for getting new test data
      // print("=== " + apiKey + url);
      // print("=== " + response.body);
      await hive.put(apiKey + urlAddress, data);
      await hive.put('sync_date_$apiKey$urlAddress', DateTime.now());
    // });
  }

  Future<String> syncHiveHttp() async {
    if (apiKey == 'none') {
      log.severe('None apiKey sync');
      return 'error';
    }
    //
    // > check hive update needed
    //
    if (updatedAt.isBefore(DateTime.now().add(const Duration(hours: -2)))) {
      await getHttpData();

      return 'updated';
    }

    return 'loaded';
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
