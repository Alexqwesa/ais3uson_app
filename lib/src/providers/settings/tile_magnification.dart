import 'package:ais3uson_app/main.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'tile_magnification.g.dart';

/// Provider of setting - Magnification of tiles in list of services.
///
/// Read/save from/to SharedPreferences, had default preinitialized value.
///
/// Depend on [locator]<SharedPreferences>.
///
/// {@category Providers}
/// {@category UI Settings}
// final tileMagnificationProvider =
//     NotifierProvider<TileMagnification, double>(TileMagnification.new);
//
@Riverpod(keepAlive: true)
class TileMagnification extends Notifier<double> {
  static const name = 'serviceCardMagnifying';

  @override
  set state(double value) {
    super.state = value;
    locator<SharedPreferences>().setDouble(name, value);
  }

  @override
  double build() {
    return locator<SharedPreferences>().getDouble(name) ?? 1.0;
  }
}
