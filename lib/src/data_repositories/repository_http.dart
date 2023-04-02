import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:ais3uson_app/client_server_api.dart' show WorkerKey;
import 'package:ais3uson_app/global_helpers.dart';
import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/repositories.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:tuple/tuple.dart';

/// Provider of httpData, create families by apiKey and url.
///
/// {@category Providers}
final repositoryHttp = StateNotifierProvider.family<_RepositoryHttp,
    List<Map<String, dynamic>>, Tuple2<WorkerKey, String>>((ref, apiUrl) {
  final notifier = _RepositoryHttp(
    ref: ref,
    workerKey: apiUrl.item1,
    urlAddress: apiUrl.item2,
  );

  return notifier;
});

/// Repository for families of providers [repositoryHttp].
///
/// Read hive on init, [state] is a [http.Response] in json format,
///  save state to [Hive].
///
/// Public methods [getHttpData] and [syncHiveHttp].
///
/// {@category Providers}
class _RepositoryHttp extends StateNotifier<List<Map<String, dynamic>>> {
  _RepositoryHttp({
    required this.workerKey,
    required this.urlAddress,
    required this.ref,
  }) : super([]) {
    log.severe('HttpDataState recreated $urlAddress');
    apiKey = workerKey.apiKey;
  }

  final String urlAddress;
  final WorkerKey workerKey;
  late final String apiKey;
  final Ref ref;

  Map<String, String> get headers => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'api-key': workerKey.apiKey,
      };

  /// Force get new data from http.
  Future<void> getHttpData() async {
    final prevLastUpdate = ref.read(lastHttpUpdate(apiKey + urlAddress));
    ref.read(lastHttpUpdate('$apiKey$urlAddress').notifier).state =
        DateTime.now();
    final url = Uri.parse(urlAddress);
    try {
      //
      // > main - call server
      //
      final client = ref.read<http.Client>(
        httpClientProvider(workerKey.certBase64),
      );
      final response = await client.get(url, headers: headers);
      //
      // > check response
      //
      log.finest('$urlAddress response.statusCode = ${response.statusCode}');
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        // ignore: avoid_dynamic_calls
        final dynamic js = jsonDecode(response.body);
        if (js is List) {
          state = js.whereType<Map<String, dynamic>>().toList(growable: false);
          await _writeHive(response.body);
        }
      } else {
        //
        // > on fail: rollback update date
        //
        ref.read(lastHttpUpdate(apiKey + urlAddress).notifier).state =
            prevLastUpdate; // = lastUpdate.add(Duration(hours: 1.9))
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
    await ref.read(hiveBox(hiveProfiles).future);
    final hive = ref.read(hiveBox(hiveProfiles)).value!;
    // for getting new test data
    // print("=== " + apiKey + url);
    // print("=== " + response.body);
    await hive.put(apiKey + urlAddress, data);
    await hive.put(
      'sync_date_$apiKey$urlAddress',
      ref.read(lastHttpUpdate('$apiKey$urlAddress')),
    );
  }

  Future<String> syncHiveHttp() async {
    if (apiKey == 'none') {
      log.fine('Skip none apiKey sync');

      return 'None';
    }
    final hive = await ref.read(hiveBox(hiveProfiles).future);
    //
    // > check hive update needed
    //
    if (ref.read(lastHttpUpdate('$apiKey$urlAddress')) == nullDate) {
      state = ref.read(_loadMapFromHiveKeyProvider(apiKey + urlAddress));
      ref.read(lastHttpUpdate('$apiKey$urlAddress').notifier).state =
          hive.get('sync_date_$apiKey$urlAddress') as DateTime? ??
              nullDate.add(const Duration(days: 1));
    }

    if (ref
        .read(lastHttpUpdate('$apiKey$urlAddress'))
        .add(const Duration(hours: 2))
        .isBefore(DateTime.now())) {
      await getHttpData();

      return 'updated';
    }

    return 'loaded';
  }
}

/// Provider of httpData, create families by apiKey and url.
final lastHttpUpdate = StateProvider.family<DateTime, String>((ref, apiUrl) {
  return nullDate;
});

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
            // if (host == '80.87.196.11') {
            //   // for debug
            //   return true;
            // }
            log.severe('!!!!Bad certificate');
            // showErrorNotification('Ошибка!неправильный сертификат сервера!');

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

/// Helper, convert String to List of Map<String, dynamic>
final _loadMapFromHiveKeyProvider =
    Provider.family<List<Map<String, dynamic>>, String>((ref, hiveKey) {
  // ignore: avoid_dynamic_calls
  return jsonDecode(
    ref.watch(hiveBox(hiveProfiles)).value?.get(hiveKey) as String? ?? '[]',
  ).whereType<Map<String, dynamic>>().toList() as List<Map<String, dynamic>>;
});
