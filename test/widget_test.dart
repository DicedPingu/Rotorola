import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotorola/main.dart';

void main() {
  testWidgets('Smoke test RotorolaApp', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: RotorolaApp(),
      ),
    );

    // Verify that the main app loads.
    expect(find.byType(RotorolaApp), findsOneWidget);
  });
}
