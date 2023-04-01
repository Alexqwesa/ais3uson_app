import 'package:ais3uson_app/main.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider of setting - tileMagnification (for tiles in list of services).
///
/// Read/save from/to SharedPreferences, had default preinitialized value.
///
/// Depend on [locator]<SharedPreferences>.
///
/// {@category Providers}
/// {@category UI Settings}
final tileMagnification =
    StateNotifierProvider<_TileMagnification, double>((ref) {
  return _TileMagnification();
});

class _TileMagnification extends StateNotifier<double> {
  _TileMagnification()
      : super(locator<SharedPreferences>().getDouble(name) ?? 1.0);

  static const name = 'serviceCardMagnifying';

  @override
  set state(double value) {
    super.state = value;
    locator<SharedPreferences>().setDouble(name, value);
  }
}
