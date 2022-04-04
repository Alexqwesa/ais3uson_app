// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:ais3uson_app/generated/l10n.dart';
import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/source/providers/app_state.dart';
import 'package:ais3uson_app/source/providers/providers.dart';
import 'package:ais3uson_app/source/providers/worker_keys_and_profiles.dart';
import 'package:ais3uson_app/source/screens/clients_screen.dart';
import 'package:ais3uson_app/source/screens/list_profiles.dart';
import 'package:ais3uson_app/source/screens/service_related/client_services_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_test/hive_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data_classes_test.dart';
import 'helpers/mock_server.dart';
import 'helpers/setup_and_teardown_helpers.dart';

void main() {
  setUpAll(() async {
    await init();
  });
  setUp(() async {
    // set SharedPreferences values
    SharedPreferences.setMockInitialValues({});
    // Hive setup
    await setUpTestHive();
    // add profile
    // await locator<AppData>().addProfileFromKey(wKeysData2());
  });
  tearDown(() async {
    await tearDownTestHive();
  });

  testWidgets('it show list of worker profiles', (tester) async {
    final wKey = wKeysData2();
    final ref = ProviderContainer(
      overrides: [
        httpClientProvider(wKey.certificate)
            .overrideWithValue(getMockHttpClient()),
      ],
    );
    const widgetForTesting = ListOfProfiles();
    await tester.pumpWidget(
      ProviderScope(
        parent: ref,
        child: localizedMaterialApp(
          widgetForTesting,
        ),
      ),
    );
    ref.read(workerKeys.notifier).addKey(wKey);
    final wp = ref.read(workerProfiles).first;
    await tester.runAsync<void>(() async {
      await wp.postInit();
    });
    expect(wp.key.name, wKeysData2().name);
    await tester.pumpAndSettle();
    // Check
    expect(find.textContaining(locator<S>().authorizePlease), findsNothing);
    expect(find.text(wKeysData2().name), findsOneWidget);
  });

  testWidgets("it show list of worker's clients", (tester) async {
    final wKey = wKeysData2();
    final ref = ProviderContainer(
      overrides: [
        httpClientProvider(wKey.certificate)
            .overrideWithValue(getMockHttpClient()),
      ],
    );
    const widgetForTesting = ClientScreen();
    await tester.pumpWidget(
      ProviderScope(
        parent: ref,
        child: localizedMaterialApp(
          widgetForTesting,
        ),
      ),
    );
    ref.read(workerKeys.notifier).addKey(wKey);
    final wp = ref.read(workerProfiles).first;
    await tester.runAsync<void>(() async {
      await wp.postInit();
    });
    ref.read(lastApiKey.notifier).state = wp.apiKey;
    await tester.pumpAndSettle();
    // Check
    expect(
      find.text(wp.clients.first.contract),
      findsOneWidget,
    );
    expect(find.textContaining(locator<S>().emptyListOfPeople), findsNothing);
  });

  testWidgets('it show list of services ', (tester) async {
    final wKey = wKeysData2();
    final ref = ProviderContainer(
      overrides: [
        httpClientProvider(wKey.certificate)
            .overrideWithValue(getMockHttpClient()),
      ],
    );
    const widgetForTesting = ClientServicesListScreen();
    await tester.pumpWidget(
      ProviderScope(
        parent: ref,
        child: localizedMaterialApp(
          widgetForTesting,
        ),
      ),
    );
    ref.read(workerKeys.notifier).addKey(wKey);
    final wp = ref.read(workerProfiles).first;
    await tester.runAsync<void>(() async {
      await wp.postInit();
    });
    ref.read(lastApiKey.notifier).state = wp.apiKey;
    ref.read(lastClientId.notifier).state = wp.clients.first.contractId;
    await tester.pumpAndSettle();
    // Scroll until the item to be found appears.
    final itemFinder = find.text('Покупка продуктов питания');
    // final listFinder = find.byKey(const ValueKey('MainScroll'));
    // await tester.scrollUntilVisible(
    //   itemFinder,
    //   500.0,
    //   scrollable: listFinder ,
    // );
    // Check
    expect(itemFinder, findsOneWidget);
    expect(find.textContaining('Список положенных услуг пуст,'), findsNothing);
  });

  testWidgets('it show empty list of services', (tester) async {
    final wKey = wKeysData2();
    final ref = ProviderContainer(
      overrides: [
        httpClientProvider(wKey.certificate)
            .overrideWithValue(getMockHttpClient()),
      ],
    );
    ref.read(workerKeys.notifier).addKey(wKey);
    final wp = ref.read(workerProfiles).first;
    await tester.runAsync<void>(() async {
      await wp.postInit();
    });
    ref.read(lastApiKey.notifier).state = wp.apiKey;
    ref.read(lastClientId.notifier).state = wp.clients[1].contractId;
    wp.clients[1].services.clear();
    expect(wp.clients[1].services.isEmpty, true);
    const widgetForTesting = ClientServicesListScreen();
    await tester.pumpWidget(
      ProviderScope(
        parent: ref,
        child: localizedMaterialApp(
          widgetForTesting,
        ),
      ),
    );
    await tester.pumpAndSettle(const Duration(seconds: 5));
    final listFinder = find.byKey(const ValueKey('MainScroll'));
    expect(listFinder, findsNothing);
    expect(
      find.textContaining('Список положенных услуг пуст,'),
      findsOneWidget,
    );
  });
}
