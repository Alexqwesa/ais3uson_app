import 'package:ais3uson_app/journal.dart';
import 'package:ais3uson_app/main.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider of setting - hiveArchiveLimit (amount of stored entries for [Journal]).
///
/// Read/save from/to SharedPreferences, had default preinitialized value.
///
/// Depend on [locator]<SharedPreferences>.
///
/// {@category Providers}
/// {@category UI Settings}
final hiveArchiveSize =
    StateNotifierProvider<_HiveArchiveSize, int>((ref) {
  return _HiveArchiveSize();
});

class _HiveArchiveSize extends StateNotifier<int> {
  _HiveArchiveSize()
      : super(locator<SharedPreferences>().getInt(name) ?? 3000);

  static const name = 'HiveArchiveLimitState';

  @override
  set state(int value) {
    super.state = value;
    locator<SharedPreferences>().setInt(name, value);
  }
}
