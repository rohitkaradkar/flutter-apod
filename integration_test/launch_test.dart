import 'package:apod/app.dart';
import 'package:apod/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('toolbar text is present', (tester) async {
    await preRunSetUp();

    await tester.pumpWidget(const ApodApp());
    await tester.pumpAndSettle();
    expect(find.text('Astronomy Picture of the Day'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
