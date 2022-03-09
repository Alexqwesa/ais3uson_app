// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:ais3uson_app/generated/l10n.dart';
import 'package:ais3uson_app/source/app_data.dart';
import 'package:ais3uson_app/source/screens/list_profiles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_test/hive_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:singleton/singleton.dart';

import 'helpers/mock_server.dart';
import 'helpers/setup_and_teardown_helpers.dart';

final locator = GetIt.instance;

void main() {
  tearDownAll(() async {
    Singleton.resetAllForTest();
    await tearDownTestHive();
  });
  setUpAll(() async {
    locator.registerLazySingleton<S>(() => S());
  });
  setUp(() async {
    // Cleanup
    Singleton.resetAllForTest();
    // set SharedPreferences values
    SharedPreferences.setMockInitialValues({});
    // Hive setup
    await setUpTestHive();
    // init AppData
    await AppData().postInit();
    // httpClient setup
    AppData().httpClient = getMockHttpClient();
  });
  tearDown(() async {
    await AppData().asyncDispose();
    AppData().dispose();
    Singleton.resetAllForTest();
    await tearDownTestHive();
  });
  testWidgets('listOfProfiles shows empty message', (tester) async {
    // Init , WidgetTester tester
    const listOfProfiles = ListOfProfiles(
      key: ValueKey(111),
    );
    await tester.pumpWidget(
      localizedMaterialApp(
        listOfProfiles,
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey(111)), findsOneWidget);
    // Check empty
    expect(find.textContaining(locator<S>().authorizePlease.substring(0,10)), findsOneWidget);
    expect(find.text('Тестовое отделение 48080'), findsNothing);
    expect(find.text('Тестовое отделение'), findsNothing);
    // Add department
  });
}
