import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/source/data_classes/client_profile.dart';
import 'package:ais3uson_app/source/providers/worker_keys_and_profiles.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Should always return last client [ClientProfile].
///
/// If can't find last client - return first client from first profile.
/// This is readonly provider, but you can change it values via [lastApiKey] and
/// [lastClientId] providers.
///
/// {@category Providers}
final lastClient = Provider((ref) {
  final id = ref.watch(lastClientId);
  final apiKey = ref.watch(lastApiKey);

  try {
    return ref
        .watch(workerProfiles)
        .firstWhere((element) => element.apiKey == apiKey)
        .clients
        .firstWhere((e) => e.contractId == id);
    // ignore: avoid_catches_without_on_clauses
  } catch (e) {
    log.severe('lastClient requested but provider failed');

    return ref.watch(workerProfiles).first.clients.first;
  }
});

final lastWorkerProfile = Provider((ref) {
  return ref
      .watch(workerProfiles)
      .firstWhere((element) => element.apiKey == ref.watch(lastApiKey));
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
  static const name = 'last_api_key';

  @override
  set state(String value) {
    super.state = value;
    locator<SharedPreferences>().setString(name, value);
  }

  LastApiKeyState() : super(locator<SharedPreferences>().getString(name) ?? '');
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
  static const name = 'last_client_id';

  @override
  set state(int value) {
    super.state = value;
    locator<SharedPreferences>().setInt(name, value);
  }

  LastClientIdState() : super(locator<SharedPreferences>().getInt(name) ?? 0);
}
