import 'package:ais3uson_app/journal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Base provider of hive [Box], type [dynamic].
///
/// {@category Base Providers}
final hiveBox = FutureProvider.family<Box<dynamic>, String>((ref, boxName) {
  return Hive.openBox<dynamic>(boxName);
});

/// Base provider of hive [Box], type [ServiceOfJournal].
///
/// {@category Base Providers}
final hiveJournalBox =
    FutureProvider.family<Box<ServiceOfJournal>, String>((ref, boxName) {
  return Hive.openBox<ServiceOfJournal>(boxName);
});

/// Base provider of hive [Box], type [DateTime].
///
/// {@category Base Providers}
final hiveDateTimeBox = FutureProvider.family<Box<DateTime>, String>(
  (ref, boxName) async => Hive.openBox<DateTime>('$boxName-DateTime'),
);
