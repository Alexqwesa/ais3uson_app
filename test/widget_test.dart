// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:ais3uson_app/source/app_data.dart';
import 'package:ais3uson_app/source/screens/list_profiles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_test/hive_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:singleton/singleton.dart';

import 'data_classes_test.dart';
import 'helpers/mock_server.dart';

void main() {
  tearDownAll(() async {
    Singleton.resetAllForTest();
    await tearDownTestHive();
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
  testWidgets('listOfProfiles smoke test', (tester) async {
    // Init , WidgetTester tester
    const listOfProfiles = ListOfProfiles(
      key: ValueKey(111),
    );
    await tester.pumpWidget(
      const MaterialApp(
        home: listOfProfiles,
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey(111)), findsOneWidget);
    // Check empty
    expect(find.textContaining('отсканируйте QR код'), findsOneWidget);
    expect(find.text('Тестовое отделение 48080'), findsNothing);
    expect(find.text('Тестовое отделение'), findsNothing);
    // Add department
  });
  testWidgets('listOfProfiles smoke test part 2', (tester) async {
    // only runAsync can work with async code (like file IO)
    final wKey = wKeysData2();
    await tester.runAsync<bool>(() {
      return AppData.instance.addProfileFromKey(wKey);
    });
    const listOfProfiles = ListOfProfiles();
    await tester.pumpWidget(
      const MaterialApp(
        home: listOfProfiles,
      ),
    );
    await tester.pumpAndSettle();
    // Check
    expect(find.text(wKey.name), findsOneWidget);
    expect(find.textContaining('отсканируйте QR код'), findsNothing);
    await tester.pumpAndSettle();
  });
}
