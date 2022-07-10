import 'package:ais3uson_app/journal.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Base provider of [SharedPreferences].
///
/// {@category Base Providers}
final preference = FutureProvider<SharedPreferences>((ref) async {
  return SharedPreferences.getInstance();
});

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
  (ref, boxName) async => Hive.openBox<DateTime>(boxName),
);

/// Base provider of Images.
///
/// {@category Base Providers}
final image = Provider.family<Image, String>(
  (ref, imgSrc) {
    return imgSrc.startsWith('http://') || imgSrc.startsWith('https://')
        ? Image.network(imgSrc)
        : Image.asset('images/$imgSrc');
  },
);
