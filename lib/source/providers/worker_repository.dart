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
import 'package:ais3uson_app/source/from_json/worker_key.dart';
import 'package:ais3uson_app/source/global_helpers.dart';
import 'package:ais3uson_app/source/providers/providers.dart';
import 'package:ais3uson_app/source/providers/worker_keys_and_profiles.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:overlay_support/overlay_support.dart';

/// Provider of httpData, create families by apiKey and url.
final httpDataProvider = StateNotifierProvider.family<HttpDataState,
    List<Map<String, dynamic>>, List<String>>((ref, httpCall) {
  return HttpDataState(
    read: ref.read,
    apiKey: httpCall[0],
    urlAddress: httpCall[1],
  );
});

/// Repository for families of providers [httpDataProvider].
///
/// Read hive on init, [state] is [http.Response], save state to [Hive].
///
/// Public methods [update] and [updateIfNeeded].
/// Public field [lastUpdate].
class HttpDataState extends StateNotifier<List<Map<String, dynamic>>> {
  HttpDataState({
    required this.apiKey,
    required this.urlAddress,
    required this.read,
  }) : super([]) {
    log.severe('HttpDataState recreated $urlAddress');
    _workerKey = read(workerKeys).firstWhereOrNull((e) => e.apiKey == apiKey);
    _asyncInit();
  }

  final String urlAddress;
  final String apiKey;
  // static const hiveName = 'profiles';
  final Reader read;
  late final WorkerKey? _workerKey;
  DateTime lastUpdate = nullDate;

  Map<String, String> get headers => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'api_key': apiKey,
      };

  Future<void> update() async {
    final prevLastUpdate = lastUpdate;
    lastUpdate = DateTime.now();
    final url = Uri.parse(urlAddress);
    try {
      //
      // > main - call server
      //
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
        // rollback update date
        lastUpdate = prevLastUpdate; // = lastUpdate.add(Duration(hours: 1.9))
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
    final hive = await Hive.openBox<dynamic>(hiveProfiles);
    // for getting new test data
    // print("=== " + apiKey + url);
    // print("=== " + response.body);
    lastUpdate = DateTime.now();
    await hive.put(apiKey + urlAddress, data);
    await hive.put('sync_date_$apiKey$urlAddress', lastUpdate);
  }

  Future<void> _asyncInit() async {
    state = await loadFromHiveJsonDecode([hiveProfiles, apiKey + urlAddress]);
    if (lastUpdate == nullDate) {
      final hive = await Hive.openBox<dynamic>(hiveProfiles);
      lastUpdate = hive.get(
        'sync_date_$apiKey$urlAddress',
        defaultValue: nullDate,
      ) as DateTime;
    }
  }

  Future<void> updateIfNeeded() async {
    if (lastUpdate.add(const Duration(hours: 2)).isBefore(DateTime.now())) {
      await update();
    }
  }
}

/// Providers clients of [WorkerProfile].
///
/// It check is update needed, and auto update list.
/// Return List<[ClientProfile]>.
final clientsOfWorker =
    Provider.family<List<ClientProfile>, WorkerProfile>((ref, workerProfile) {
  final apiKey = workerProfile.apiKey;
  final url = '${workerProfile.key.activeServer}/clients';

    ref.watch(httpDataProvider([apiKey, url]).notifier).updateIfNeeded();

    return ref
        .watch(httpDataProvider([apiKey, url]))
        .map<ClientEntry>((json) => ClientEntry.fromJson(json))
        .map((el) => ClientProfile(workerProfile: workerProfile, entry: el))
        .toList(growable: false);
  },
);

/// Providers services of [WorkerProfile].
///
/// It check is update needed, and auto update list.
/// Return List<[ServiceEntry]>.
final servicesOfWorker =
    Provider.family<List<ServiceEntry>, WorkerProfile>((ref, workerProfile) {
  final apiKey = workerProfile.apiKey;
  final url = '${workerProfile.key.activeServer}/services';

  ref.watch(httpDataProvider([apiKey, url]).notifier).updateIfNeeded();

  return ref
      .watch(httpDataProvider([apiKey, url]))
      .map<ServiceEntry>((json) => ServiceEntry.fromJson(json))
      .toList(growable: false);
});

/// Providers services of [WorkerProfile].
///
/// It check is update needed, and auto update list.
/// Return List<[ClientPlan]>.
final planOfWorker =
    Provider.family<List<ClientPlan>, WorkerProfile>((ref, workerProfile) {
  final apiKey = workerProfile.apiKey;
  final url = '${workerProfile.key.activeServer}/planned';

  ref.read(httpDataProvider([apiKey, url]).notifier).updateIfNeeded();

  return ref
      .watch(httpDataProvider([apiKey, url]))
      .map<ClientPlan>((json) => ClientPlan.fromJson(json))
      .toList(growable: false);
});

/// DateTime of last update of [planOfWorker].
final planOfWorkerSyncDate =
    Provider.family<DateTime, WorkerProfile>((ref, workerProfile) {
  final apiKey = workerProfile.apiKey;
  final url = '${workerProfile.key.activeServer}/planned';

  return ref.watch(httpDataProvider([apiKey, url]).notifier).lastUpdate;
});

/// DateTime of last update of [servicesOfWorker].
final servicesOfWorkerSyncDate =
    Provider.family<DateTime, WorkerProfile>((ref, workerProfile) {
  final apiKey = workerProfile.apiKey;
  final url = '${workerProfile.key.activeServer}/services';

  return ref.watch(httpDataProvider([apiKey, url]).notifier).lastUpdate;
});
