// ignore_for_file: sort_constructors_first

import 'package:ais3uson_app/source/journal/service_of_journal.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final preference = FutureProvider<SharedPreferences>((ref) async {
  return SharedPreferences.getInstance();
});

final hiveBox = FutureProvider.family<Box<dynamic>, String>((ref, boxName) {
  return Hive.openBox<dynamic>(boxName);
});

final hiveStringBox =
    FutureProvider.family<Box<String>, String>((ref, boxName) {
  return Hive.openBox<String>(boxName);
});

final hiveJournalBox =
    FutureProvider.family<Box<ServiceOfJournal>, String>((ref, boxName) {
  return Hive.openBox<ServiceOfJournal>(boxName);
});

final hiveDateTimeBox = FutureProvider.family<Box<DateTime>, String>(
  (ref, boxName) async => Hive.openBox<DateTime>(boxName),
);
