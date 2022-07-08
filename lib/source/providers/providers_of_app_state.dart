import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/source/client_server_api/client_entry.dart';
import 'package:ais3uson_app/source/data_models/client_profile.dart';
import 'package:ais3uson_app/source/data_models/client_service.dart';
import 'package:ais3uson_app/source/data_models/client_service_at.dart';
import 'package:ais3uson_app/source/data_models/worker_profile.dart';
import 'package:ais3uson_app/source/global_helpers.dart';
import 'package:ais3uson_app/source/providers/controller_of_worker_profiles_list.dart';
import 'package:ais3uson_app/source/providers/repository_of_client.dart';
import 'package:ais3uson_app/source/providers/repository_of_worker.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Controller of App states, last used:
/// - worker,
/// - client,
/// - service,
/// - service at date.
///
/// {@category Providers}
final lastUsed = Provider<_LastUsed>((ref) {
  return _LastUsed(ref);
});

class _LastUsed {
  _LastUsed(this.ref);

  final ProviderRef ref;

  ClientServiceAt get serviceAt => ClientServiceAt(
        clientService: ref.read(_lastClientService),
        date: ref.read(_lastServiceAt),
      );

  ClientService get service => ref.read(_lastClientService);

  ClientProfile get client => ref.read(_lastClient);

  WorkerProfile get worker => ref.read(_lastWorkerProfile);

  set serviceAt(ClientServiceAt value) {
    ref.read(_lastServiceAt.notifier).state = value.dateOnly;
    ref.read(_lastClientServiceId.notifier).state = value.servId;
    ref.read(_lastClientId.notifier).state = value.contractId;
    ref.read(_lastApiKey.notifier).state = value.workerProfile.apiKey;
  }

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
        .watch(servicesOfClient(ref.watch(_lastClient)))
        .firstWhere((e) => e.servId == id);
    // ignore: avoid_catches_without_on_clauses
  } catch (e) {
    log.severe('lastClientService requested but provider failed');

    return ref.watch(servicesOfClient(ref.watch(_lastClient))).first;
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
        .watch(clientsOfWorker(ref.watch(_lastWorkerProfile)))
        .firstWhere((e) => e.contractId == id);
    // ignore: avoid_catches_without_on_clauses
  } catch (e) {
    log.severe('lastClient requested but provider failed');
    try {
      return ref.watch(clientsOfWorker(ref.watch(_lastWorkerProfile))).first;
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      log.severe('lastClient requested but provider failed twice');

      return ClientProfile(
        workerProfile: ref.watch(_lastWorkerProfile),
        entry: const ClientEntry(
          contract_id: 0,
          dep_id: 0,
          client_id: 0,
          dhw_id: 0,
          comment: 'Error Client',
        ),
      );
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

    return ref.watch(workerProfiles).first;
  }
});

/// Provider of setting - lastApiKey.
///
/// Read/save from/to SharedPreferences, had default preinitialized value.
/// Depend on [locator]<SharedPreferences>.
///
/// {@category Providers}
final _lastApiKey = StateNotifierProvider<LastApiKeyState, String>((ref) {
  return LastApiKeyState();
});

class LastApiKeyState extends StateNotifier<String> {
  LastApiKeyState() : super(locator<SharedPreferences>().getString(name) ?? '');

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

/// Archive view or usual view of App.
///
/// Provider of setting - isArchive. Inited with false, doesn't save its value.
///
/// {@category Providers}
// Todo: only use archiveDate?
final isArchive = StateNotifierProvider<_ArchiveState, bool>((ref) {
  return _ArchiveState(ref.read);
});

class _ArchiveState extends StateNotifier<bool> {
  _ArchiveState(this.read) : super(false);

  final Reader read;

  @override
  set state(bool value) {
    super.state = value;
    if (!value) {
      read(archiveDate.notifier).state = null;
    }
  }
}

/// Provider of setting - archiveDate. Inited with null, doesn't save its value.
///
/// {@category Providers}
final archiveDate = StateProvider<DateTime?>((ref) {
  return null;
});

/// Provider of setting - date of LastService
///
/// {@category Providers}
final _lastServiceAt = StateProvider<DateTime?>((ref) {
  return DateTime.now().dateOnly();
});
