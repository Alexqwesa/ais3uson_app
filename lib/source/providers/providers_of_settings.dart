import 'dart:ui';

import 'package:ais3uson_app/main.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider of setting - serviceView.
///
/// Read/save from/to SharedPreferences, had default preinitialized value.
/// Depend on [locator]<SharedPreferences>.
///
/// {@category Providers}
final serviceViewProvider =
    StateNotifierProvider<_ServiceViewState, String>((ref) {
  return _ServiceViewState();
});

class _ServiceViewState extends StateNotifier<String> {
  _ServiceViewState()
      : super(locator<SharedPreferences>().getString(name) ?? '');

  static const name = 'serviceView';

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

/// Calculate size of ServiceCard based on parentSize and serviceView.
///
/// {@category Providers}
Size serviceCardSize(Size parentSize, String serviceView) {
  final parentWidth = parentSize.width;
  if (serviceView == 'tile') {
    final divider = (parentWidth - 20) ~/ 400.0;
    var cardWidth = (parentWidth / divider) - 10;
    if (divider == 0) {
      cardWidth = (parentWidth - 10).abs();
    }

    return Size(
      cardWidth * 1.0,
      cardWidth / 4,
    );
  } else if (serviceView == 'square') {
    var divider = (parentWidth - 20) ~/ 150.0;
    if (parentWidth < 130) {
      divider = 1;
    } else if (parentWidth < 260) {
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
    var divider = (parentWidth - 20) ~/ 250.0;
    divider = divider > 1 ? divider : 2;
    final cardWidth = parentWidth / divider;

    return Size(
      cardWidth * 1.0,
      cardWidth * 1.2,
    );
  }
}
