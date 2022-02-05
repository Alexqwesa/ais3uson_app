import 'package:ais3uson_app/source/app_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'mock_server.dart';

/// Setup full environment for testing.
///
/// Create mocks of: Hive, SharedPreference, httpClient.
Future<void> mySetUpAll() async {
  //
  // > SharedPreference setup
  //
  SharedPreferences.setMockInitialValues({}); //set values here
  //
  // > httpClient setup
  //
  AppData().httpClient = getMockHttpClient();
}
