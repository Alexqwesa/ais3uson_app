import 'package:ais3uson_app/global_helpers.dart';
import 'package:ais3uson_app/main.dart';
import 'package:ais3uson_app/providers.dart';
import 'package:ais3uson_app/src/stubs_for_testing/default_data.dart';
import 'package:ais3uson_app/src/stubs_for_testing/worker_keys_data.dart';
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
  });
  setUp(() async {
    // set SharedPreferences values
    SharedPreferences.setMockInitialValues({});
    // SharedPreferences.setMockInitialValues({Departments.name: '[$qrData2WithAutossl]'});
    //
    // > locator
    //
    await locator.reset();
    final sharedPreferences = await SharedPreferences.getInstance();
    locator
      ..registerLazySingleton<AppLocalizations>(() => const Locale('en').tr)
      ..registerLazySingleton<SharedPreferences>(() => sharedPreferences);
    // Hive setup
    await setUpTestHive();
  });
  tearDown(() async {
    await tearDownTestHive();
  });

  testWidgets('it open Main window', (tester) async {
    final wKey = testWorkerKey();
    await runMain();
    await tester.pumpAndSettle();
    // Verify start screen.
    expect(find.text(wKey.dep), findsNothing);
    expect(find.text(tr().authorizePlease), findsOneWidget);
  });

  testWidgets('it load department from SharedPreferences', (tester) async {
    final wKey = testWorkerKey();
    // SharedPreferences.setMockInitialValues({Departments.name: '[$qrData2WithAutossl]'});
    // await setupSomePreferences(Departments.name, '[$qrData2WithAutossl]');
    await locator<SharedPreferences>()
        .setString(Departments.name, '[$qrData2WithLocalCache]');
    await runMain();
    await tester.pumpAndSettle();
    // Verify start screen.
    expect(find.text(wKey.dep), findsOneWidget);
    expect(find.text(tr().authorizePlease), findsNothing);
  });

  testWidgets('it add test Department', (tester) async {
    await openAndAddDepartment(tester);
  });

  testWidgets('it delete test Department', (tester) async {
    final wKey = await openAndAddDepartment(tester);
    // open drawer
    final appBarMenuIcon = find.descendant(
      of: find.byType(AppBar),
      matching: find.widgetWithIcon(IconButton, Icons.menu),
    );
    await tester.tap(appBarMenuIcon);
    await tester.pumpAndSettle();
    // click add department
    final delDep = find.text(tr().deleteDep);
    expect(delDep, findsOneWidget);
    await tester.tap(delDep);
    await tester.pumpAndSettle();
    // delete department screen here
    final depButton = find.text(wKey.dep);
    await tester.tap(depButton);
    await tester.pumpAndSettle();
    final confirm = find.byType(ElevatedButton);
    await tester.tap(confirm);
    await tester.pumpAndSettle();
    // return to main screen
    expect(find.text(tr().authorizePlease), findsOneWidget);
    expect(find.text(wKey.dep), findsNothing);
  });
}
