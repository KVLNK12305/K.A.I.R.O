import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../models/daily_plan.dart';
import '../models/task.dart';
import 'home_widget_sync_service.dart';
import '../../main.dart';

class DailyPlanService {
  final Isar isar;
  DailyPlanService(this.isar);

  DateTime _todayStart() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  Future<DailyPlan?> getTodayPlan() async {
    final dateKey = _todayStart();
    return await isar.dailyPlans.filter().dateEqualTo(dateKey).findFirst();
  }

  Future<DailyPlan> setTodayPeaks({
    required String peak1Title,
    required String peak1Outcome,
    int peak1DurationMinutes = 90,
    required String peak2Title,
    required String peak2Outcome,
    int peak2DurationMinutes = 90,
    String? nonNegotiableNote,
  }) async {
    final dateKey = _todayStart();
    var plan = await isar.dailyPlans.filter().dateEqualTo(dateKey).findFirst();
    plan ??= DailyPlan()..date = dateKey;

    plan.peak1Title = peak1Title.trim();
    plan.peak1Outcome = peak1Outcome.trim();
    plan.peak1DurationMinutes = peak1DurationMinutes;
    plan.peak2Title = peak2Title.trim();
    plan.peak2Outcome = peak2Outcome.trim();
    plan.peak2DurationMinutes = peak2DurationMinutes;
    plan.nonNegotiableNote = nonNegotiableNote?.trim();
    plan.plannedAt = DateTime.now();

    await isar.writeTxn(() async {
      await isar.dailyPlans.put(plan!);
    });

    // Update Android Home Widgets
    HomeWidgetSyncService.syncDailyPeaks(
      peak1: plan.peak1Title,
      peak1Done: plan.peak1Completed,
      peak2: plan.peak2Title,
      peak2Done: plan.peak2Completed,
    );

    return plan;
  }

  Future<DailyPlan?> togglePeak({required int peakNumber}) async {
    final dateKey = _todayStart();
    final plan = await isar.dailyPlans.filter().dateEqualTo(dateKey).findFirst();
    if (plan == null) return null;

    if (peakNumber == 1) {
      plan.peak1Completed = !plan.peak1Completed;
    } else if (peakNumber == 2) {
      plan.peak2Completed = !plan.peak2Completed;
    }
    plan.reviewedAt = DateTime.now();

    await isar.writeTxn(() async {
      await isar.dailyPlans.put(plan);
    });

    // Update Android Home Widgets
    HomeWidgetSyncService.syncDailyPeaks(
      peak1: plan.peak1Title,
      peak1Done: plan.peak1Completed,
      peak2: plan.peak2Title,
      peak2Done: plan.peak2Completed,
    );

    return plan;
  }

  /// Committed vs completed peaks across all DailyPlans dated on/after [start].
  Future<PeakExecutionStats> getPeakExecutionSince(DateTime start) async {
    final plans = await isar.dailyPlans.filter().dateGreaterThan(start, include: true).findAll();
    int committed = 0;
    int completed = 0;
    for (final p in plans) {
      if (p.peak1Title.trim().isNotEmpty) {
        committed++;
        if (p.peak1Completed) completed++;
      }
      if (p.peak2Title.trim().isNotEmpty) {
        committed++;
        if (p.peak2Completed) completed++;
      }
    }
    return PeakExecutionStats(committed: committed, completed: completed);
  }

  /// Tasks committed from Needs / Project DNA that are not yet done.
  Future<List<Task>> getOpenTasks() async {
    return await isar.tasks
        .filter()
        .isCompletedEqualTo(false)
        .and()
        .isFailedEqualTo(false)
        .sortByCreatedAtDesc()
        .findAll();
  }

  Future<void> setTaskCompleted(int taskId, bool completed) async {
    final task = await isar.tasks.get(taskId);
    if (task == null) return;
    task.isCompleted = completed;
    task.progressPercent = completed ? 100 : task.progressPercent;
    await isar.writeTxn(() async {
      await isar.tasks.put(task);
    });
  }
}

class PeakExecutionStats {
  final int committed;
  final int completed;
  const PeakExecutionStats({required this.committed, required this.completed});

  /// Null when nothing was committed, so callers can pick their own neutral baseline.
  double? get rate => committed == 0 ? null : completed / committed;
}

final dailyPlanServiceProvider = Provider<DailyPlanService>((ref) {
  return DailyPlanService(isar);
});

final todayPlanProvider = FutureProvider<DailyPlan?>((ref) async {
  final service = ref.watch(dailyPlanServiceProvider);
  return await service.getTodayPlan();
});

final openTasksProvider = FutureProvider.autoDispose<List<Task>>((ref) async {
  final service = ref.watch(dailyPlanServiceProvider);
  return await service.getOpenTasks();
});
