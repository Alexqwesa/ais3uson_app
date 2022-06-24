import 'package:ais3uson_app/main.dart' as app;
import 'package:ais3uson_app/src/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:integration_test/integration_test.dart';

Future<void> main() async {
  // enableFlutterDriverExtension();
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter('Ais3uson');
  app.locator.registerLazySingleton<S>(S.new);

  testWidgets('Main window', (tester) async {
    await app.main();
    await tester.pumpAndSettle();
    // Verify start screen
    expect(find.text('Тестовое отделение 2'), findsNothing);
    expect(find.text('Тестовое отделение'), findsNothing);
    expect(find.text(app.tr().authorizePlease), findsOneWidget);
  });
  testWidgets('Main: add test department', (tester) async {
    await app.main();
    await tester.pumpAndSettle();
    // Verify start screen
    expect(find.text(app.tr().authorizePlease), findsOneWidget);
    final appBarIcon = find.descendant(
      of: find.byType(AppBar),
      matching: find.byType(Padding),
    );
    await tester.tap(appBarIcon);
    final addDep = find.text(app.tr().addDepFromText);
    expect(addDep, findsOneWidget);
    await tester.tap(addDep);

    final addDepButton = find.text(app.tr().addDep);

    await tester.tap(addDepButton);

    expect(find.text(app.tr().authorizePlease), findsNothing);
    expect(find.text('Тестовое отделение 2'), findsNothing);
    expect(find.text('Тестовое отделение'), findsOneWidget);
  });
}
