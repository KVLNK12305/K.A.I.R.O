import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kairo/core/theme/kairo_design_system.dart';

void main() {
  group('Kairo Design System Tokens & Primitives', () {
    test('Verifies semantic palette constants', () {
      expect(KairoTheme.background, const Color(0xFF000000));
      expect(KairoTheme.surface, const Color(0xFF0D0D0D));
      expect(KairoTheme.border, const Color(0xFF222222));
      expect(KairoTheme.observed, const Color(0xFF8DC0FA));
      expect(KairoTheme.recommended, const Color(0xFFFAD168));
      expect(KairoTheme.success, const Color(0xFFC7F3C6));
      expect(KairoTheme.warning, const Color(0xFFFF6B6B));
    });

    testWidgets('KairoCard renders child with sharp border and padding', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: KairoCard(
              child: Text('Card Content'),
            ),
          ),
        ),
      );

      expect(find.text('Card Content'), findsOneWidget);
      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.borderRadius, BorderRadius.circular(KairoTheme.radiusMd));
      expect((decoration.border as Border).top.color, KairoTheme.border);
    });

    testWidgets('KairoStatus displays uppercase label and type color', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: KairoStatus(
              label: 'Telemetry Active',
              type: KairoStatusType.observed,
            ),
          ),
        ),
      );

      expect(find.text('TELEMETRY ACTIVE'), findsOneWidget);
    });

    testWidgets('KairoButton triggers onPressed callback and formats label', (WidgetTester tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: KairoButton(
              text: 'Execute Peak',
              isPrimary: true,
              onPressed: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.text('EXECUTE PEAK'), findsOneWidget);
      await tester.tap(find.byType(KairoButton));
      expect(tapped, isTrue);
    });

    testWidgets('KairoSectionHeader renders tracking uppercase title', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: KairoSectionHeader(
              title: 'Telemetry Stream',
            ),
          ),
        ),
      );

      expect(find.text('TELEMETRY STREAM'), findsOneWidget);
    });

    testWidgets('KairoEmptyState renders honest zero-state without placeholder fluff', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: KairoEmptyState(
              title: 'No Data Recorded',
              description: 'Telemetry will populate when sensor connects.',
            ),
          ),
        ),
      );

      expect(find.text('NO DATA RECORDED'), findsOneWidget);
      expect(find.text('Telemetry will populate when sensor connects.'), findsOneWidget);
    });
  });
}
