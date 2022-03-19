// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:ais3uson_app/generated/l10n.dart';
import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/source/app_data.dart';
import 'package:ais3uson_app/source/screens/clients_screen.dart';
import 'package:ais3uson_app/source/screens/list_profiles.dart';
import 'package:ais3uson_app/source/screens/service_related/client_services_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_test/hive_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data_classes_test.dart';
import 'helpers/mock_server.dart';
import 'helpers/setup_and_teardown_helpers.dart';

final locator = GetIt.instance;

void main() {
  setUpAll(() async {
    await init();
  });
  setUp(() async {
    // set SharedPreferences values
    SharedPreferences.setMockInitialValues({});
    // Hive setup
    await setUpTestHive();
    // init AppData
    await locator<AppData>().postInit();
    // httpClient setup
    locator<AppData>().httpClient = getMockHttpClient();
    // add profile
    // await locator<AppData>().addProfileFromKey(wKeysData2());
  });
  tearDown(() async {
    await locator.resetLazySingleton<AppData>();
    await tearDownTestHive();
  });

  testWidgets('it show list of worker profiles', (tester) async {
    await tester.runAsync<bool>(() async {
      return locator<AppData>().addProfileFromKey(wKeysData2());
    });
    expect(locator<AppData>().profiles.first.key.name, wKeysData2().name);
    const listOfProfiles = ListOfProfiles();
    await tester.pumpWidget(
      localizedMaterialApp(
        listOfProfiles,
      ),
    );
    await tester.pumpAndSettle();
    // Check
    expect(find.text(wKeysData2().name), findsOneWidget);
    expect(find.textContaining(locator<S>().authorizePlease), findsNothing);
  });
  testWidgets('it show list of clients profiles', (tester) async {
    await tester.runAsync<bool>(() async {
      return locator<AppData>().addProfileFromKey(wKeysData2());
    });
    const listOf = ClientScreen();
    await tester.pumpWidget(
      localizedMaterialApp(listOf),
    );
    await tester.pumpAndSettle();
    // Check
    expect(
      find.text(locator<AppData>().profiles.first.clients.first.contract),
      findsOneWidget,
    );
    expect(find.textContaining(locator<S>().emptyListOfPeople), findsNothing);
  });
  testWidgets('it show list of services', (tester) async {
    await tester.runAsync<bool>(() async {
      return locator<AppData>().addProfileFromKey(wKeysData2());
    });
    final servicesScreen = ClientServicesListScreen(
      clientProfile: locator<AppData>().profiles.first.clients.first,
    );
    await tester.pumpWidget(
      MaterialApp(
        home: servicesScreen,
      ),
    );
    await tester.pumpAndSettle();
    // Check
    expect(find.text('Покупка продуктов питания'), findsOneWidget);
    expect(find.textContaining('Список положенных услуг пуст,'), findsNothing);
  });
}
