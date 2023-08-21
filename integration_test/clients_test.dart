import 'dart:convert';

import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:ais3uson_app/src/generated/l10n.dart';
import 'package:ais3uson_app/src/stubs_for_testing/default_data.dart';
import 'package:ais3uson_app/src/stubs_for_testing/worker_keys_data.dart';
import 'package:ais3uson_app/ui_service_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../test/helpers/setup_and_teardown_helpers.dart';
import 'helpers.dart';

Future<void> main() async {
  // enableFlutterDriverExtension();

  setUpAll(() async {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    await initAndSetCertificate();
  });
  setUp(() async {
    // set SharedPreferences values
    SharedPreferences.setMockInitialValues(
        {Departments.name: '[$qrData2WithLocalCache]'});
    //
    // > locator
    //
    await locator.reset();
    final sharedPreferences = await SharedPreferences.getInstance();
    locator
      ..registerLazySingleton<S>(S.new)
      ..registerLazySingleton<SharedPreferences>(() => sharedPreferences);
    // Hive setup
    await setUpTestHive();
  });
  tearDown(() async {
    await tearDownTestHive();
  });

  testWidgets('it open Clients', (tester) async {
    // final wKey =
    await openDepartment(tester);

    final clientsData = (jsonDecode(SERVER_DATA_CLIENTS) as List)
        .whereType<Map<String, dynamic>>();
    // before load
    // expect(find.text(tr().emptyListOfPeople), findsOneWidget);
    // await tester.pump(const Duration(seconds: 1));
    expect(find.text(clientsData.first['client']! as String), findsNWidgets(2));
    expect(find.text(clientsData.first['contract']! as String), findsOneWidget);

    expect(find.text(tr().emptyListOfPeople), findsNothing);
  });

  testWidgets('it open Services of Client', (tester) async {
    final (_, clientsData, _) =
        await openServicesOfFirstClient(tester);
    //
    // > go back
    //
    final appBarMenuIcon = find.descendant(
      of: find.byType(AppBar),
      matching: find.widgetWithIcon(IconButton, Icons.arrow_back),
    );
    await tester.tap(appBarMenuIcon);
    await tester.pumpAndSettle();
    //
    // > open Second Client
    //
    final secondClient = find.text(clientsData[1]['contract']! as String);
    expect(secondClient, findsOneWidget);
    await tester.tap(secondClient);
    await tester.pumpAndSettle();
    expect(find.text(tr().noServicesForClient), findsOneWidget);
    //
    // > scroll to last element
    //
    // final lastService = servicesData
    //     .whereType<Map<String,dynamic>>()
    //     .where((element) => element['id'] == 885)
    //     .first;
    // await tester.scrollUntilVisible(
    //     find.textContaining(RegExp(
    //         (lastService['serv_text'] as String).substring(0, 18))),
    //     70.0);
    // expect(find.byType(ServiceCard), findsNWidgets(39));

    expect(find.text(tr().noServicesForClient), findsOneWidget);
  });

  testWidgets('it add Services', (tester) async {
    // final (wKey, clientsData, servicesData) =
        await openServicesOfFirstClient(tester);

    final serviceText = find.text('Итого:');
    //
    // > add service
    //
    final service =
        find.ancestor(of: serviceText, matching: find.byType(ServiceCard));
    final state =
        find.descendant(of: service, matching: find.byType(ServiceCardState));
    expect(
      find.descendant(of: state, matching: find.text('1')),
      findsNothing,
    );
    await tester.tap(serviceText); //warnIfMissed
    await tester.pumpAndSettle();
    expect(
      find.descendant(of: state, matching: find.text('1')),
      findsOneWidget,
    );

    expect(find.text(tr().noServicesForClient), findsNothing);
  });
}
