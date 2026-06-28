import 'package:flutter_test/flutter_test.dart';

// ensure this import matches your project name in pubspec.yaml
// based on your error log, it looks like:

import 'package:kairo/main.dart';

void main() {
  testWidgets('Critique AI smoke test', (WidgetTester tester) async {
    // 1. Load the correct App Class (CritiqueAiApp)
    await tester.pumpWidget(const MyApp());
    
    // 2. Wait for the app to fully load
    await tester.pumpAndSettle();

    // 3. Verify that the Dashboard loaded by looking for specific text
    expect(find.text("TODAY'S BLUEPRINT"), findsOneWidget);
    
    // 4. Verify that we are NOT seeing the old counter
    expect(find.text('0'), findsNothing);
  });
}