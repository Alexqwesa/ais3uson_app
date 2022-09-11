import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:ais3uson_app/data_models.dart';
import 'package:ais3uson_app/global_helpers.dart';
import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:overlay_support/overlay_support.dart';
import 'package:tuple/tuple.dart';

/// Provider of httpData, create families by apiKey and url.
///
/// {@category Providers}
final httpDataProvider = StateNotifierProvider.family<_HttpDataState,
    List<Map<String, dynamic>>, Tuple2<String, String>>((ref, apiUrl) {
  final notifier = _HttpDataState(
    read: ref.read,
    apiKey: apiUrl.item1,
    urlAddress: apiUrl.item2,
  );

  return notifier;
});

/// Repository for families of providers [httpDataProvider].
///
/// Read hive on init, [state] is a [http.Response] in json format,
///  save state to [Hive].
///
/// Public methods [getHttpData] and [syncHiveHttp].
/// Public field [_lastUpdate].
///
/// {@category Providers}
class _HttpDataState extends StateNotifier<List<Map<String, dynamic>>> {
  _HttpDataState({
    required this.apiKey,
    required this.urlAddress,
    required this.read,
  }) : super([]) {
    log.severe('HttpDataState recreated $urlAddress');
  }

  final String urlAddress;
  final String apiKey;
  final Reader read;

  Map<String, String> get headers => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'api_key': apiKey,
      };

  /// Force get new data from http.
  Future<void> getHttpData() async {
    final prevLastUpdate = read(_lastUpdate(apiKey + urlAddress));
    read(_lastUpdate('$apiKey$urlAddress').notifier).state = DateTime.now();
    final url = Uri.parse(urlAddress);
    try {
      //
      // > main - call server
      //
      final workerProfile =
          read(workerProfiles).firstWhere((e) => e.apiKey == apiKey);
      final client = read<http.Client>(
        httpClientProvider(workerProfile.key.certBase64),
      );
      final response = await client.get(url, headers: headers);
      //
      // > check response
      //
      log.finest('$urlAddress response.statusCode = ${response.statusCode}');
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        // ignore: avoid_dynamic_calls
        state = jsonDecode(response.body)
            .whereType<Map<String, dynamic>>()
            .toList(growable: false) as List<Map<String, dynamic>>;
        await _writeHive(response.body);
      } else {
        //
        // > on fail: rollback update date
        //
        read(_lastUpdate(apiKey + urlAddress).notifier).state =
            prevLastUpdate; // = lastUpdate.add(Duration(hours: 1.9))
      }
      //
      // > just error handling
      //
    } on FormatException {
      log.severe(' Wrong json format - FormatException');
      showSimpleNotification(
        Text(tr().errorFormat),
        background: Colors.red[300],
        position: NotificationPosition.bottom,
      );
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
    await read(hiveBox(hiveProfiles).future);
    final hive = read(hiveBox(hiveProfiles)).value!;
    // for getting new test data
    // print("=== " + apiKey + url);
    // print("=== " + response.body);
    await hive.put(apiKey + urlAddress, data);
    await hive.put(
      'sync_date_$apiKey$urlAddress',
      read(_lastUpdate('$apiKey$urlAddress')),
    );
  }

  Future<String> syncHiveHttp() async {
    if (apiKey == 'none') {
      log.fine('Skip none apiKey sync');

      return 'None';
    }
    final hive = await read(hiveBox(hiveProfiles).future);
    //
    // > check hive update needed
    //
    if (read(_lastUpdate('$apiKey$urlAddress')) == nullDate) {
      state = read(_loadMapFromHiveKeyProvider(apiKey + urlAddress));
      read(_lastUpdate('$apiKey$urlAddress').notifier).state =
          hive.get('sync_date_$apiKey$urlAddress') as DateTime? ??
              nullDate.add(const Duration(days: 1));
    }

    if (read(_lastUpdate('$apiKey$urlAddress'))
        .add(const Duration(hours: 2))
        .isBefore(DateTime.now())) {
      await getHttpData();

      return 'updated';
    }

    return 'loaded';
  }
}

/// DateTime of last update of [planOfWorker].
///
/// {@category Providers}
final planOfWorkerSyncDate =
    Provider.family<DateTime, WorkerProfile>((ref, wp) {
  return ref.watch(_lastUpdate(wp.apiKey + wp.urlPlan));
});

/// DateTime of last update of [servicesOfWorker].
///
/// {@category Providers}
final servicesOfWorkerSyncDate =
    Provider.family<DateTime, WorkerProfile>((ref, wp) {
  return ref.watch(_lastUpdate(wp.apiKey + wp.urlServices));
});

/// Provider of httpData, create families by apiKey and url.
final _lastUpdate = StateProvider.family<DateTime, String>((ref, apiUrl) {
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
