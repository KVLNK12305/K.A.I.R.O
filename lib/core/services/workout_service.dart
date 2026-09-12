import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../models/workout_session.dart';
import '../../main.dart';

class WorkoutStats {
  final int sessionsCount;
  final double totalVolumeKg;
  final int totalMinutes;

  const WorkoutStats({
    required this.sessionsCount,
    required this.totalVolumeKg,
    required this.totalMinutes,
  });
}

class WorkoutService {
  final Isar isar;

  WorkoutService(this.isar);

  Future<List<WorkoutSession>> getRecentSessions({int limit = 20}) async {
    return await isar.workoutSessions
        .where()
        .sortByStartTimeDesc()
        .limit(limit)
        .findAll();
  }

  Future<WorkoutSession> saveSession(WorkoutSession session) async {
    await isar.writeTxn(() async {
      await isar.workoutSessions.put(session);
    });
    return session;
  }

  Future<void> deleteSession(Id id) async {
    await isar.writeTxn(() async {
      await isar.workoutSessions.delete(id);
    });
  }

  Future<WorkoutStats> getWeeklyStats() async {
    final now = DateTime.now();
    final weekStart = DateTime(now.year, now.month, now.day).subtract(Duration(days: now.weekday - 1));

    final sessions = await isar.workoutSessions
        .filter()
        .startTimeGreaterThan(weekStart.subtract(const Duration(seconds: 1)))
        .findAll();

    int totalMinutes = 0;
    double totalVol = 0.0;
    for (final s in sessions) {
      totalMinutes += s.durationMinutes;
      totalVol += s.totalVolumeKg;
    }

    return WorkoutStats(
      sessionsCount: sessions.length,
      totalVolumeKg: totalVol,
      totalMinutes: totalMinutes,
    );
  }
}

final workoutServiceProvider = Provider<WorkoutService>((ref) {
  return WorkoutService(isar);
});

final recentWorkoutsProvider = FutureProvider<List<WorkoutSession>>((ref) async {
  return await ref.watch(workoutServiceProvider).getRecentSessions();
});

final weeklyWorkoutStatsProvider = FutureProvider<WorkoutStats>((ref) async {
  return await ref.watch(workoutServiceProvider).getWeeklyStats();
});
