import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:ais3uson_app/generated/l10n.dart';
import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/source/data_classes/client_profile.dart';
import 'package:ais3uson_app/source/data_classes/worker_profile.dart';
import 'package:ais3uson_app/source/from_json/client_entry.dart';
import 'package:ais3uson_app/source/from_json/client_plan.dart';
import 'package:ais3uson_app/source/from_json/service_entry.dart';
import 'package:ais3uson_app/source/global_helpers.dart';
import 'package:ais3uson_app/source/providers/providers.dart';
import 'package:ais3uson_app/source/providers/worker_keys_and_profiles.dart';
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
final httpDataProvider = StateNotifierProvider.family<HttpDataState,
    List<Map<String, dynamic>>, Tuple2<String, String>>((ref, apiUrl) {
  final notifier = HttpDataState(
    read: ref.read,
    apiKey: apiUrl.item1,
    urlAddress: apiUrl.item2,
  );

  return notifier;
  // return ref.watch(futureHttpDataProvider(notifier)).when(
  //       data: (state) => notifier,
  //       error: (err, stack) => notifier,
  //       loading: () => notifier,
  //     );
});

/// Repository for families of providers [httpDataProvider].
///
/// Read hive on init, [state] is [http.Response], save state to [Hive].
///
/// Public methods [getHttpData] and [syncHiveHttp].
/// Public field [lastUpdate].
class HttpDataState extends StateNotifier<List<Map<String, dynamic>>> {
  HttpDataState({
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

  Future<void> getHttpData() async {
    final prevLastUpdate = read(lastUpdate(apiKey + urlAddress));
    read(lastUpdate('$apiKey$urlAddress').notifier).state = DateTime.now();
    final url = Uri.parse(urlAddress);
    try {
      //
      // > main - call server
      //
      final _workerKey =
          read(workerKeys).firstWhereOrNull((e) => e.apiKey == apiKey);
      final client =
          read<http.Client>(httpClientProvider(_workerKey?.certificate));
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
        read(lastUpdate(apiKey + urlAddress).notifier).state =
            prevLastUpdate; // = lastUpdate.add(Duration(hours: 1.9))
      }
      //
      // > just error handling
      //
    } on FormatException {
      log.severe(' Wrong json format - FormatException');
      showSimpleNotification(
        const Text('Ошибка: был получен неправильный ответ от сервера!'),
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
      read(lastUpdate('$apiKey$urlAddress')),
    );
  }

  Future<String> syncHiveHttp() async {
    final hive = await read(hiveBox(hiveProfiles).future);
    //
    // > check hive update needed
    //
    if (read(lastUpdate('$apiKey$urlAddress')) == nullDate) {
      state = read(loadMapFromHiveKeyProvider(apiKey + urlAddress));
      read(lastUpdate('$apiKey$urlAddress').notifier).state =
          hive.get('sync_date_$apiKey$urlAddress') as DateTime? ??
              nullDate.add(const Duration(days: 1));
    }

    if (read(lastUpdate('$apiKey$urlAddress'))
        .add(const Duration(hours: 2))
        .isBefore(DateTime.now())) {
      await getHttpData();

      return 'updated';
    }

    return 'loaded';
  }
}

/// Providers clients of [WorkerProfile].
///
/// It check is update needed, and auto update list.
/// Return List<[ClientProfile]>.
final clientsOfWorker = Provider.family<List<ClientProfile>, WorkerProfile>(
  (ref, wp) {
    () async {
      await ref
          .watch(httpDataProvider(Tuple2(wp.apiKey, wp.urlClients)).notifier)
          .syncHiveHttp();
    }();

    return ref
        .watch(httpDataProvider(Tuple2(wp.apiKey, wp.urlClients)))
        .map<ClientEntry>((json) => ClientEntry.fromJson(json))
        .map((el) => ClientProfile(workerProfile: wp, entry: el))
        .toList(growable: false);
  },
);

/// Providers services of [WorkerProfile].
///
/// It check is update needed, and auto update list.
/// Return List<[ServiceEntry]>.
final servicesOfWorker =
    Provider.family<List<ServiceEntry>, WorkerProfile>((ref, wp) {
  // ref.watch(httpDataProvider(Tuple2(apiKey, urlAddress)).notifier)
  // .updateIfNeeded();

  return ref
      .watch(httpDataProvider(Tuple2(wp.apiKey, wp.urlServices)))
      .map<ServiceEntry>((json) => ServiceEntry.fromJson(json))
      .toList(growable: false);
});

/// Providers services of [WorkerProfile].
///
/// It check is update needed, and auto update list.
/// Return List<[ClientPlan]>.
final planOfWorker =
    Provider.family<List<ClientPlan>, WorkerProfile>((ref, wp) {
  // ref.read(httpDataProvider(Tuple2(apiKey, urlAddress)).notifier)
  // .updateIfNeeded();

  return ref
      .watch(httpDataProvider(Tuple2(wp.apiKey, wp.urlPlan)))
      .map<ClientPlan>((json) => ClientPlan.fromJson(json))
      .toList(growable: false);
});

/// Provider of httpData, create families by apiKey and url.
final lastUpdate = StateProvider.family<DateTime, String>((ref, apiUrl) {
  return nullDate;
});

/// DateTime of last update of [planOfWorker].
final planOfWorkerSyncDate =
    Provider.family<DateTime, WorkerProfile>((ref, wp) {
  return ref.watch(lastUpdate(wp.apiKey + wp.urlPlan));
});

/// DateTime of last update of [servicesOfWorker].
final servicesOfWorkerSyncDate =
    Provider.family<DateTime, WorkerProfile>((ref, wp) {
  return ref.watch(lastUpdate(wp.apiKey + wp.urlServices));
});
