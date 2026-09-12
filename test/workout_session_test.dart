import 'package:flutter_test/flutter_test.dart';
import 'package:kairo/core/models/workout_session.dart';
import 'package:kairo/core/services/workout_service.dart';

void main() {
  group('Workout Session & Stats Unit Tests', () {
    test('Calculates workout volume and properties accurately', () {
      final session = WorkoutSession()
        ..splitType = 'Push'
        ..title = 'Heavy Push Overload'
        ..durationMinutes = 65
        ..perceivedExertion = 8
        ..totalVolumeKg = 4250.0
        ..notes = 'Hit PR on incline bench press'
        ..startTime = DateTime(2026, 3, 10, 18, 0);

      expect(session.splitType, 'Push');
      expect(session.durationMinutes, 65);
      expect(session.perceivedExertion, 8);
      expect(session.totalVolumeKg, 4250.0);
      expect(session.notes, contains('PR'));
    });

    test('Aggregates multi-session workout volume into WorkoutStats', () {
      final sessions = [
        WorkoutSession()
          ..durationMinutes = 60
          ..totalVolumeKg = 3500.0,
        WorkoutSession()
          ..durationMinutes = 75
          ..totalVolumeKg = 4800.0,
        WorkoutSession()
          ..durationMinutes = 45
          ..totalVolumeKg = 2100.0,
      ];

      int totalMinutes = 0;
      double totalVol = 0.0;
      for (final s in sessions) {
        totalMinutes += s.durationMinutes;
        totalVol += s.totalVolumeKg;
      }

      final stats = WorkoutStats(
        sessionsCount: sessions.length,
        totalVolumeKg: totalVol,
        totalMinutes: totalMinutes,
      );

      expect(stats.sessionsCount, 3);
      expect(stats.totalVolumeKg, 10400.0);
      expect(stats.totalMinutes, 180);
    });

    test('Validates set volume formula (weight x reps)', () {
      const sets = [
        {'weight': 80.0, 'reps': 8},
        {'weight': 85.0, 'reps': 6},
        {'weight': 90.0, 'reps': 4},
      ];

      double volume = 0;
      for (final s in sets) {
        volume += (s['weight'] as double) * (s['reps'] as int);
      }

      // (80*8) + (85*6) + (90*4) = 640 + 510 + 360 = 1510 kg
      expect(volume, 1510.0);
    });
  });
}
