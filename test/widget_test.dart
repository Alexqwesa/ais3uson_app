// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/ui_departments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/setup_and_teardown_helpers.dart';

void main() {
  // final locator = GetIt.instance;
  tearDownAll(() async {
    await tearDownTestHive();
  });
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await init();
  });
  setUp(() async {
    // set SharedPreferences values
    SharedPreferences.setMockInitialValues({});
    // Hive setup
    await setUpTestHive();
  });
  tearDown(() async {
    await tearDownTestHive();
  });
  testWidgets('listOfProfiles shows empty message', (tester) async {
    // Init , WidgetTester tester
    const widget = ListOfDepartments(
      key: ValueKey(111),
    );
    await tester.pumpWidget(
      ProviderScope(
        child: localizedMaterialApp(
          widget,
          ProviderContainer(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey(111)), findsOneWidget);
    // Check empty
    expect(
      find.textContaining(tr().authorizePlease.substring(0, 10)),
      findsOneWidget,
    );
    expect(find.text('Тестовое отделение 48080'), findsNothing);
    expect(find.text('Тестовое отделение'), findsNothing);
    // Add department
  });
}
