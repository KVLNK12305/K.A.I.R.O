import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kairo/Nav/floating_command_dock.dart';

void main() {
  testWidgets('FloatingCommandDock renders 5 core V2 tabs and responds to taps', (WidgetTester tester) async {
    int selectedIndex = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: StatefulBuilder(
              builder: (context, setState) {
                return FloatingCommandDock(
                  currentIndex: selectedIndex,
                  onItemSelected: (index) {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                );
              },
            ),
          ),
        ),
      ),
    );

    // Initial state: tab 0 ('TODAY') selected
    expect(find.text('TODAY'), findsOneWidget);

    // Tap tab 1 (Time icon)
    final timeIconFinder = find.byIcon(Icons.hourglass_bottom_rounded);
    expect(timeIconFinder, findsOneWidget);
    await tester.tap(timeIconFinder);
    await tester.pumpAndSettle();

    expect(selectedIndex, 1);
    expect(find.text('TIME'), findsOneWidget);

    // Tap tab 2 (Money icon)
    final moneyIconFinder = find.byIcon(Icons.account_balance_wallet_outlined);
    expect(moneyIconFinder, findsOneWidget);
    await tester.tap(moneyIconFinder);
    await tester.pumpAndSettle();

    expect(selectedIndex, 2);
    expect(find.text('MONEY'), findsOneWidget);

    // Tap tab 3 (Work icon)
    final workIconFinder = find.byIcon(Icons.shield_outlined);
    expect(workIconFinder, findsOneWidget);
    await tester.tap(workIconFinder);
    await tester.pumpAndSettle();

    expect(selectedIndex, 3);
    expect(find.text('WORK'), findsOneWidget);

    // Tap tab 4 (Review icon)
    final reviewIconFinder = find.byIcon(Icons.explore_outlined);
    expect(reviewIconFinder, findsOneWidget);
    await tester.tap(reviewIconFinder);
    await tester.pumpAndSettle();

    expect(selectedIndex, 4);
    expect(find.text('REVIEW'), findsOneWidget);
  });
}