import 'package:ais3uson_app/source/journal/service_of_journal.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Base provider of [SharedPreferences].
final preference = FutureProvider<SharedPreferences>((ref) async {
  return SharedPreferences.getInstance();
});

/// Base provider of hive [Box], type [dynamic].
final hiveBox = FutureProvider.family<Box<dynamic>, String>((ref, boxName) {
  return Hive.openBox<dynamic>(boxName);
});

/// Base provider of hive [Box], type [ServiceOfJournal].
final hiveJournalBox =
    FutureProvider.family<Box<ServiceOfJournal>, String>((ref, boxName) {
  return Hive.openBox<ServiceOfJournal>(boxName);
});

/// Base provider of hive [Box], type [DateTime].
final hiveDateTimeBox = FutureProvider.family<Box<DateTime>, String>(
  (ref, boxName) async => Hive.openBox<DateTime>(boxName),
);
