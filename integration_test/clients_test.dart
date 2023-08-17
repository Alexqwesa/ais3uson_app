import 'dart:convert';

import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:ais3uson_app/src/generated/l10n.dart';
import 'package:ais3uson_app/src/stubs_for_testing/default_data.dart';
import 'package:ais3uson_app/src/stubs_for_testing/worker_keys_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../test/helpers/setup_and_teardown_helpers.dart';

Future<void> main() async {
  // enableFlutterDriverExtension();

  setUpAll(() async {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
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
    final wKey = testWorkerKey();
    await runMain();
    await tester.pumpAndSettle();
    // open clients
    final depButton = find.text(wKey.dep);
    await tester.tap(depButton);
    await tester.pumpAndSettle();

    final clientsData = (jsonDecode(SERVER_DATA_CLIENTS) as List)
        .whereType<Map<String, dynamic>>();
    // before load
    // expect(find.text(tr().emptyListOfPeople), findsOneWidget);
    // await tester.pump(const Duration(seconds: 1));
    expect(find.text(clientsData.first['client']! as String),
        findsNWidgets(2));
    expect(find.text(clientsData.first['contract']! as String),
        findsOneWidget);

    expect(find.text(tr().emptyListOfPeople), findsNothing);
  });
}
