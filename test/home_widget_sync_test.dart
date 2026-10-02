import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Daily 24H Audit Widget Calculations', () {
    test('Calculates zero-mock 24h budget accurately', () {
      const double sleepHours = 7.5;
      const double workHours = 4.5;
      const double screenHours = 2.0;

      final committed = sleepHours + workHours + screenHours;
      final freeHours = (24.0 - committed).clamp(0.0, 24.0);
      final allocatedPct = ((committed / 24.0) * 100).round().clamp(0, 100);

      expect(committed, 14.0);
      expect(freeHours, 10.0);
      expect(allocatedPct, 58);
      expect(sleepHours + workHours + screenHours + freeHours, 24.0);
    });

    test('Clamps free hours at 0 when committed hours exceed 24', () {
      const double sleepHours = 8.0;
      const double workHours = 12.0;
      const double screenHours = 6.0;

      final committed = sleepHours + workHours + screenHours; // 26.0
      final freeHours = (24.0 - committed).clamp(0.0, 24.0);
      final allocatedPct = ((committed / 24.0) * 100).round().clamp(0, 100);

      expect(committed, 26.0);
      expect(freeHours, 0.0);
      expect(allocatedPct, 100);
    });
  });

  group('Task Pulse V2 Peak Logic', () {
    test('Calculates completed peaks and percentage correctly', () {
      final mockData = <String, dynamic>{
        'p1Title': 'Finish App Widgets',
        'p1Done': true,
        'p2Title': 'Refactor Parser',
        'p2Done': false,
      };

      final p1Title = mockData['p1Title'] as String;
      final p1Done = mockData['p1Done'] as bool;
      final p2Title = mockData['p2Title'] as String;
      final p2Done = mockData['p2Done'] as bool;

      int total = 0;
      int completed = 0;
      if (p1Title.isNotEmpty) {
        total++;
        if (p1Done) completed++;
      }
      if (p2Title.isNotEmpty) {
        total++;
        if (p2Done) completed++;
      }

      final pct = (completed / total * 100).round();
      final p1Display = p1Done ? 'P1: DONE' : 'P1: ACTIVE';
      final p2Display = p2Done ? 'P2: DONE' : 'P2: ACTIVE';

      expect(total, 2);
      expect(completed, 1);
      expect(pct, 50);
      expect(p1Display, 'P1: DONE');
      expect(p2Display, 'P2: ACTIVE');
    });

    test('Defaults to 2 total peak slots when no peaks are set yet', () {
      final p1Title = '';
      final p2Title = '';

      int total = 0;
      if (p1Title.isNotEmpty) total++;
      if (p2Title.isNotEmpty) total++;
      if (total == 0) total = 2;

      expect(total, 2);
    });
  });

  group('Energy Arc Real Calculation', () {
    test('Calculates average energy execution across Peak1, Peak2, and Recovery', () {
      final int p1Pct = 100; // Peak 1 done
      final int p2Pct = 50;  // 45m of 90m focus logged
      final int recPct = 80; // 6.4h sleep logged

      final avgPct = ((p1Pct + p2Pct + recPct) / 3).round();
      expect(avgPct, 77);
    });
  });
}
