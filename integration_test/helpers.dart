import 'dart:convert';

import 'package:ais3uson_app/api_classes.dart';
import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/src/stubs_for_testing/demo_worker_data.dart';
import 'package:ais3uson_app/ui_service_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<WorkerKey> openAndAddDepartment(WidgetTester tester) async {
  final wKey = demoWorkerKey();
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

Future<(WorkerKey, List<Map<String, dynamic>>, List<Map<String, dynamic>>)>
    openServicesOfFirstClient(WidgetTester tester) async {
  final wKey = await openDepartment(tester);

  final clientsData = (jsonDecode(SERVER_DATA_CLIENTS) as List)
      .whereType<Map<String, dynamic>>()
      .toList();

  final servicesData = (jsonDecode(SERVER_DATA_SERVICES) as List)
      .whereType<Map<String, dynamic>>()
      .toList();
  // before load
  // expect(find.text(tr().emptyListOfPeople), findsOneWidget);
  // await tester.pump(const Duration(seconds: 1));

  //
  // > open first
  //
  final firstClient = find.text(clientsData[0]['contract']! as String);
  expect(firstClient, findsOneWidget);
  await tester.tap(firstClient);
  await tester.pumpAndSettle();
  //
  // > it contains services
  //
  expect(find.text('Итого:'), findsOneWidget);
  expect(find.byType(ServiceCard), findsWidgets);
  expect(find.text(tr().noServicesForClient), findsNothing);

  return (wKey, clientsData, servicesData);
}

Future<WorkerKey> openDepartment(WidgetTester tester) async {
  final wKey = demoWorkerKey();
  await runMain();
  await tester.pumpAndSettle();
  // open clients
  final depButton = find.text(wKey.dep);
  await tester.tap(depButton);
  await tester.pumpAndSettle();

  return wKey;
}
