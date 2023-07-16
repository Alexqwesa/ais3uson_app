import 'dart:convert';

import 'package:ais3uson_app/api_classes.dart';
import 'package:ais3uson_app/dynamic_data_models.dart';
import 'package:ais3uson_app/global_helpers.dart';
import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _stubKey = WorkerKey.fromJson(
  jsonDecode(stubJsonWorkerKey) as Map<String, dynamic>,
);
final stubWorker = WorkerProfile(_stubKey, ProviderContainer());
final stubClient = ClientProfile(
  workerProfile: stubWorker,
  entry: const ClientEntry(
    contract_id: 0,
    dep_id: 0,
    client_id: 0,
    dhw_id: 0,
    comment: 'Error Client',
  ),
);

/// Controller of App states, last used:
/// - worker,
/// - client,
/// - service.
///
/// {@category Providers}
/// {@category App State}
final lastUsed = Provider<_ProviderOfAPPState>((ref) {
  // todo: test it
  ref
    ..watch(_lastClientService)
    ..watch(_lastClient)
    ..watch(_lastWorkerProfile);

  return _ProviderOfAPPState(ref);
});

class _ProviderOfAPPState {
  _ProviderOfAPPState(this.ref);

  final Ref ref;

  ClientService get service => ref.watch(_lastClientService);

  ClientProfile get client => ref.watch(_lastClient);

  WorkerProfile get worker => ref.watch(_lastWorkerProfile);

  set service(ClientService value) {
    ref.read(_lastClientServiceId.notifier).state = value.servId;
    ref.read(_lastClientId.notifier).state = value.contractId;
    ref.read(_lastApiKey.notifier).state = value.workerProfile.apiKey;
  }

  set client(ClientProfile value) {
    ref.read(_lastClientId.notifier).state = value.contractId;
    ref.read(_lastApiKey.notifier).state = value.workerProfile.apiKey;
  }

  set worker(WorkerProfile value) =>
      ref.read(_lastApiKey.notifier).state = value.apiKey;
}

/// Provider of setting - archiveDate. Inited with null, doesn't save its value.
///
/// {@category Providers}
/// {@category App State}
final archiveDate = StateProvider<DateTime?>((ref) {
  return null;
});

/// Archive view or usual view of App.
///
/// Provider of setting - isArchive. Inited with false, doesn't save its value.
///
/// {@category Providers}
/// {@category App State}
// Todo: only use archiveDate?
final isArchive = StateNotifierProvider<_ArchiveState, bool>((ref) {
  return _ArchiveState(ref);
});

class _ArchiveState extends StateNotifier<bool> {
  _ArchiveState(this.ref) : super(false);

  final Ref ref;

  @override
  set state(bool value) {
    super.state = value;
    if (!value) {
      ref.read(archiveDate.notifier).state = null;
    }
  }
}

/// Should always return last used service [ClientService].
///
/// If can't find last client - return first client from first profile.
/// This is readonly provider, but you can change it values via [_lastApiKey] and
/// [_lastClientId] and [_lastClientServiceId] providers.
///
/// {@category Providers}
final _lastClientService = Provider<ClientService>((ref) {
  final id = ref.watch(_lastClientServiceId);

  try {
    return ref
        .watch(ref.watch(_lastClient).servicesOf)
        .firstWhere((e) => e.servId == id);
    // ignore: avoid_catches_without_on_clauses
  } catch (e) {
    log.severe('lastClientService requested but provider failed');
    try {
      return ref.watch(ref.watch(_lastClient).servicesOf).first;

      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      log.severe('lastClientService requested but provider failed');

      return ClientService(
        workerProfile: ref.watch(_lastWorkerProfile),
        service: const ServiceEntry(serv_text: '', id: 0),
        planned:
            const ClientPlan(filled: 0, planned: 0, serv_id: 0, contract_id: 0),
      );
    }
  }
});

/// Should always return last used client [ClientProfile].
///
/// If can't find last client - return first client from first profile.
/// This is readonly provider, but you can change it values via [_lastApiKey] and
/// [_lastClientId] providers.
///
/// {@category Providers}
final _lastClient = Provider<ClientProfile>((ref) {
  final id = ref.watch(_lastClientId);

  try {
    return ref
        .watch(ref.watch(_lastWorkerProfile).clientsOf)
        .firstWhere((e) => e.contractId == id);
    // ignore: avoid_catches_without_on_clauses
  } catch (e) {
    log.severe('lastClient requested but provider failed');
    try {
      return ref.watch(ref.watch(_lastWorkerProfile).clientsOf).first;
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      log.severe('lastClient requested but provider failed twice');

      return stubClient;
    }
  }
});

/// Should always return last used worker [WorkerProfile].
///
/// If can't find last, return first profile.
/// This is readonly provider, but you can change it values via [_lastApiKey].
///
/// {@category Providers}
final _lastWorkerProfile = Provider((ref) {
  try {
    return ref
        .watch(workerProfiles)
        .firstWhere((element) => element.apiKey == ref.watch(_lastApiKey));
    // ignore: avoid_catches_without_on_clauses
  } catch (e) {
    log.severe('lastWorkerProfile requested but provider failed');
    try {
      return ref.watch(workerProfiles).first;
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      log.severe('lastWorkerProfile requested but it did not exist');

      return stubWorker;
    }
  }
});

/// Provider of setting - lastApiKey.
///
/// Read/save from/to SharedPreferences, had default preinitialized value.
/// Depend on [locator]<SharedPreferences>.
///
/// {@category Providers}
final _lastApiKey = StateNotifierProvider<_LastApiKeyState, String>((ref) {
  return _LastApiKeyState();
});

class _LastApiKeyState extends StateNotifier<String> {
  _LastApiKeyState()
      : super(locator<SharedPreferences>().getString(name) ?? '');

  static const name = 'last_api_key';

  @override
  set state(String value) {
    super.state = value;
    locator<SharedPreferences>().setString(name, value);
  }
}

/// Provider of setting - lastClientId.
///
/// Read/save from/to SharedPreferences, had default preinitialized value.
/// Depend on [locator]<SharedPreferences>.
///
/// {@category Providers}
final _lastClientId = StateNotifierProvider<_LastClientIdState, int>((ref) {
  return _LastClientIdState();
});

class _LastClientIdState extends StateNotifier<int> {
  _LastClientIdState() : super(locator<SharedPreferences>().getInt(name) ?? 0);

  static const name = 'last_client_id';

  @override
  set state(int value) {
    super.state = value;
    locator<SharedPreferences>().setInt(name, value);
  }
}

/// Provider of setting - lastClientService.
///
/// Read/save from/to SharedPreferences, had default preinitialized value.
/// Depend on [locator]<SharedPreferences>.
///
/// {@category Providers}
final _lastClientServiceId =
    StateNotifierProvider<_LastClientServiceIdState, int>((ref) {
  return _LastClientServiceIdState();
});

class _LastClientServiceIdState extends StateNotifier<int> {
  _LastClientServiceIdState()
      : super(locator<SharedPreferences>().getInt(name) ?? 0);

  static const name = 'last_client_service';

  @override
  set state(int value) {
    super.state = value;
    locator<SharedPreferences>().setInt(name, value);
  }
}
