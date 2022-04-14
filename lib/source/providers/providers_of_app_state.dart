import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/source/data_classes/client_profile.dart';
import 'package:ais3uson_app/source/data_classes/worker_profile.dart';
import 'package:ais3uson_app/source/providers/providers_of_lists_of_workers.dart';
import 'package:ais3uson_app/source/providers/repository_of_worker.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

/// Archive view or usual view of App.
///
/// Provider of setting - isArchive. Inited with false, doesn't save its value.
///
/// {@category Providers}
final isArchive = StateProvider<bool>((ref) {
  return false;
});
