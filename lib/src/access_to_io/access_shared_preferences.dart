import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Base provider of [SharedPreferences].
///
/// {@category Base Providers}
final preference = FutureProvider<SharedPreferences>((ref) async {
  return SharedPreferences.getInstance();
});
