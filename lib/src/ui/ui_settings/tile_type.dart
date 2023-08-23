import 'package:ais3uson_app/main.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'tile_type.g.dart';

/// Provider of setting - Type of tiles in list of services.
///
/// Read/save from/to SharedPreferences, had default preinitialized value.
/// Depend on [locator]<SharedPreferences>.
///
/// {@category Providers}
/// {@category UI Settings}
// final tileTypeProvider = StateNotifierProvider<_TileType, String>((ref) {
//   return _TileType();
// });
@Riverpod(keepAlive: true)
class TileType extends _$TileType {
  TileType() : super();

  static const name = 'tileType';

  @override
  set state(String value) {
    super.state = value;
    locator<SharedPreferences>().setString(name, value);
  }

  @override
  String build() {
    return locator<SharedPreferences>().getString(name) ?? '';
  }
}
