import 'package:ais3uson_app/main.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider of setting - tileType (for tiles in list of services).
///
/// Read/save from/to SharedPreferences, had default preinitialized value.
/// Depend on [locator]<SharedPreferences>.
///
/// {@category Providers}
/// {@category UI Settings}
final tileType = StateNotifierProvider<_TileType, String>((ref) {
  return _TileType();
});

class _TileType extends StateNotifier<String> {
  _TileType() : super(locator<SharedPreferences>().getString(name) ?? '');

  static const name = 'tileType';

  @override
  set state(String value) {
    super.state = value;
    locator<SharedPreferences>().setString(name, value);
  }
}
