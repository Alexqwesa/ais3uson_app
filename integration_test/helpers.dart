import 'package:ais3uson_app/api_classes.dart';
import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/src/stubs_for_testing/default_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<WorkerKey> openAndAddDepartment(WidgetTester tester) async {
  final wKey = testWorkerKey();
  await runMain();
  await tester.pumpAndSettle();
  // Verify start screen
  expect(find.text(tr().authorizePlease), findsOneWidget);
  // open drawer
  final appBarMenuIcon = find.descendant(
    of: find.byType(AppBar),
    matching: find.widgetWithIcon(IconButton, Icons.menu),
  );
  await tester.tap(appBarMenuIcon);
  await tester.pumpAndSettle();
  // click add department
  final addDep = find.text(tr().addDepFromText);
  expect(addDep, findsOneWidget);
  await tester.tap(addDep);
  await tester.pumpAndSettle();
  // add department screen here
  final addDepButton = find.text(wKey.dep);
  await tester.tap(addDepButton);
  await tester.pumpAndSettle();
  // return to main screen
  expect(find.text(tr().authorizePlease), findsNothing);
  expect(find.text(wKey.dep), findsOneWidget);
  return wKey;
}

// Future<void> setupSomePreferences(String name, String value) async {
//   SharedPreferences.setMockInitialValues({name: value});
//   final preferences = await SharedPreferences.getInstance();
//   // TODO this should not be necessary
//   // reported issue: https://github.com/flutter/flutter/issues/28837
//   await preferences.setString(name, value);
// }
