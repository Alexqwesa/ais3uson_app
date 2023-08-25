import 'package:ais3uson_app/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Base provider of [SharedPreferences].
///
/// {@category Base Providers}
final preferences = Provider<SharedPreferences>((ref) {
  return locator<SharedPreferences>();
});
