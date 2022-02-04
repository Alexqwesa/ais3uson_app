import 'package:ais3uson_app/app_root.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {

  // enableFlutterDriverExtension();
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Main window', (tester) async {
    await tester.pumpWidget(const AppRoot());
    await tester.pumpAndSettle();
    // Verify start screen
    expect(find.text('Тестовое отделение 2'), findsNothing);
    expect(find.text('Тестовое отделение'), findsNothing);
    expect(find.text('Авторизируйтесь (отсканируйте QR код)'), findsOneWidget);
  });
}