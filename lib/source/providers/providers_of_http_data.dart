import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:typed_data';

import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/source/data_classes/worker_profile.dart';
import 'package:ais3uson_app/source/global_helpers.dart';
import 'package:ais3uson_app/source/providers/providers.dart';
import 'package:ais3uson_app/source/providers/providers_of_lists_of_workers.dart';
import 'package:ais3uson_app/source/providers/repository_of_worker.dart';
import 'package:ais3uson_app/src/generated/l10n.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:overlay_support/overlay_support.dart';
import 'package:tuple/tuple.dart';

// final futureHttpDataProvider =
//     FutureProvider.family<String, HttpDataState>((ref, notifier) async {
//   return notifier.syncHiveHttp();
// });

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
      final _workerProfile =
          read(workerProfiles).firstWhereOrNull((e) => e.apiKey == apiKey);
      final client = read<http.Client>(
        httpClientProvider(_workerProfile?.key.certificate),
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
            .toList() as List<Map<String, dynamic>>;
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
        Text(locator<S>().errorFormat),
        background: Colors.red[300],
        position: NotificationPosition.bottom,
      );
    } on HandshakeException {
      showErrorNotification(locator<S>().sslError);
      log.severe('Server HandshakeException error $url ');
    } on http.ClientException {
      showErrorNotification(locator<S>().serverError);
      log.severe('Server error  $url  ');
    } on SocketException {
      showErrorNotification(locator<S>().internetError);
      log.warning('No internet connection $url ');
    } on HttpException {
      showErrorNotification(locator<S>().httpAccessError);
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
    Provider.family<http.Client, Uint8List?>((ref, certificate) {
  var client = http.Client();

  if (certificate != null) {
    try {
      if (certificate.isNotEmpty) {
        final context = SecurityContext()
          ..setTrustedCertificatesBytes(certificate);
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
      showErrorNotification(locator<S>().errorWrongCertificate);
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
