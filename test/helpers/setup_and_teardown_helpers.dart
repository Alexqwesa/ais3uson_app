import 'package:ais3uson_app/source/app_data.dart';
import 'package:ais3uson_app/source/journal/service_of_journal.dart';
import 'package:ais3uson_app/source/journal/service_state.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_test/hive_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'mock_server.dart';

/// Setup full environment for testing.
///
/// Create mocks of: Hive, SharedPreference, httpClient.
Future<void> mySetUpAll() async {
  //
  // > Hive setup
  //
  await setUpTestHive();
  Hive
    ..registerAdapter(ServiceOfJournalAdapter())
    ..registerAdapter(ServiceStateAdapter());
  final hivData = await Hive.openBox<dynamic>('profiles');
  AppData().hiveData = hivData;
  //
  // > SharedPreference setup
  //
  SharedPreferences.setMockInitialValues({}); //set values here
  AppData.prefs = await SharedPreferences.getInstance();
  //
  // > httpClient setup
  //
  AppData().httpClient = getMockHttpClient();
}
