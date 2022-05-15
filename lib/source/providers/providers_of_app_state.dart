import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/source/data_models/client_profile.dart';
import 'package:ais3uson_app/source/data_models/client_service.dart';
import 'package:ais3uson_app/source/data_models/worker_profile.dart';
import 'package:ais3uson_app/source/providers/controller_of_worker_profiles_list.dart';
import 'package:ais3uson_app/source/providers/repository_of_client.dart';
import 'package:ais3uson_app/source/providers/repository_of_worker.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Should always return last used service [ClientService].
///
/// If can't find last client - return first client from first profile.
/// This is readonly provider, but you can change it values via [lastApiKey] and
/// [lastClientId] and [lastClientServiceId] providers.
///
/// {@category Providers}
final lastClientService = Provider<ClientService>((ref) {
  final id = ref.watch(lastClientServiceId);

  try {
    return ref
        .watch(servicesOfClient(ref.watch(lastClient)))
        .firstWhere((e) => e.servId == id);
    // ignore: avoid_catches_without_on_clauses
  } catch (e) {
    log.severe('lastClientService requested but provider failed');

    return ref.watch(servicesOfClient(ref.watch(lastClient))).first;
  }
});

/// Should always return last used client [ClientProfile].
///
/// If can't find last client - return first client from first profile.
/// This is readonly provider, but you can change it values via [lastApiKey] and
/// [lastClientId] providers.
///
/// {@category Providers}
final lastClient = Provider<ClientProfile>((ref) {
  final id = ref.watch(lastClientId);

  try {
    return ref
        .watch(clientsOfWorker(ref.watch(lastWorkerProfile)))
        .firstWhere((e) => e.contractId == id);
    // ignore: avoid_catches_without_on_clauses
  } catch (e) {
    log.severe('lastClient requested but provider failed');

    return ref.watch(clientsOfWorker(ref.watch(lastWorkerProfile))).first;
    //
    // return ref.watch(clientsOfWorker(ref.watch(lastWorkerProfile))).isNotEmpty
    //     ? ref.watch(clientsOfWorker(ref.watch(lastWorkerProfile))).first
    //     : ClientProfile(
    //         workerProfile: ref.watch(lastWorkerProfile),
    //         entry: const ClientEntry(
    //           dhw_id: 0,
    //           client_id: 0,
    //           client: 'Error',
    //           contract_id: 0,
    //           dep_id: 0,
    //         ));
  }
});

/// Should always return last used worker [WorkerProfile].
///
/// If can't find last, return first profile.
/// This is readonly provider, but you can change it values via [lastApiKey].
///
/// {@category Providers}
final lastWorkerProfile = Provider((ref) {
  try {
    return ref
        .watch(workerProfiles)
        .firstWhere((element) => element.apiKey == ref.watch(lastApiKey));
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
final lastApiKey = StateNotifierProvider<LastApiKeyState, String>((ref) {
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
final lastClientId = StateNotifierProvider<LastClientIdState, int>((ref) {
  return LastClientIdState();
});

class LastClientIdState extends StateNotifier<int> {
  LastClientIdState() : super(locator<SharedPreferences>().getInt(name) ?? 0);

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
final lastClientServiceId =
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
final isArchive = StateProvider<bool>((ref) {
  return false;
});

/// Provider of setting - archiveDate. Inited with null, doesn't save its value.
///
/// {@category Providers}
final archiveDate = StateProvider<DateTime?>((ref) {
  return null;
});
