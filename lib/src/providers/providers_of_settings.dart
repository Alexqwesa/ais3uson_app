import 'dart:ui';

import 'package:ais3uson_app/main.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';

/// Provider of setting - tileType.
///
/// Read/save from/to SharedPreferences, had default preinitialized value.
/// Depend on [locator]<SharedPreferences>.
///
/// {@category Providers}
/// {@category UI Settings}
final tileTypeProvider =
    StateNotifierProvider<_ServiceViewState, String>((ref) {
  return _ServiceViewState();
});

class _ServiceViewState extends StateNotifier<String> {
  _ServiceViewState()
      : super(locator<SharedPreferences>().getString(name) ?? '');

  static const name = 'tileType';

  @override
  set state(String value) {
    super.state = value;
    locator<SharedPreferences>().setString(name, value);
  }
}

/// Provider of setting - hiveArchiveLimit.
///
/// Read/save from/to SharedPreferences, had default preinitialized value.
///
/// Depend on [locator]<SharedPreferences>.
///
/// {@category Providers}
/// {@category UI Settings}
final hiveArchiveLimit =
    StateNotifierProvider<_HiveArchiveLimitState, int>((ref) {
  return _HiveArchiveLimitState();
});

class _HiveArchiveLimitState extends StateNotifier<int> {
  _HiveArchiveLimitState()
      : super(locator<SharedPreferences>().getInt(name) ?? 3000);

  static const name = 'HiveArchiveLimitState';

  @override
  set state(int value) {
    super.state = value;
    locator<SharedPreferences>().setInt(name, value);
  }
}

/// Provider of setting - hiveArchiveLimit.
///
/// Read/save from/to SharedPreferences, had default preinitialized value.
///
/// Depend on [locator]<SharedPreferences>.
///
/// {@category Providers}
/// {@category UI Settings}
final serviceCardMagnifying =
    StateNotifierProvider<_ServiceCardMagnifyState, double>((ref) {
  return _ServiceCardMagnifyState();
});

class _ServiceCardMagnifyState extends StateNotifier<double> {
  _ServiceCardMagnifyState()
      : super(locator<SharedPreferences>().getDouble(name) ?? 1.0);

  static const name = 'serviceCardMagnifying';

  @override
  set state(double value) {
    super.state = value;
    locator<SharedPreferences>().setDouble(name, value);
  }
}

/// Calculate size of ServiceCard based on parentSize and tileType.
///
/// {@category Providers}
/// {@category UI Settings}
final serviceCardSize =
    Provider.family<Size, Tuple2<Size, String>>((ref, tuple) {
  final parentSize = tuple.item1;
  final tileType = tuple.item2;

  final parentWidth = parentSize.width;
  if (tileType == 'tile') {
    final divider =
        (parentWidth - 20) ~/ (400.0 * ref.watch(serviceCardMagnifying));
    var cardWidth = (parentWidth / divider) - 10;
    if (divider == 0) {
      cardWidth = (parentWidth - 10).abs();
    }

    return Size(
      cardWidth * 1.0,
      cardWidth / 4,
    );
  } else if (tileType == 'square') {
    var divider =
        (parentWidth - 20) ~/ (150.0 * ref.watch(serviceCardMagnifying));
    if (parentWidth < (130 * ref.watch(serviceCardMagnifying))) {
      divider = 1;
    } else if (parentWidth < (260 * ref.watch(serviceCardMagnifying))) {
      divider = 2;
    } else {
      divider = divider > 2 ? divider : 3;
    }
    final cardWidth = parentWidth / divider;

    return Size(
      cardWidth,
      cardWidth,
    );
  } else {
    var divider =
        (parentWidth - 20) ~/ (250.0 * ref.watch(serviceCardMagnifying));
    divider = divider > 1 ? divider : 2;
    final cardWidth = parentWidth / divider;

    return Size(
      cardWidth * 1.0,
      cardWidth * 1.2,
    );
  }
});
