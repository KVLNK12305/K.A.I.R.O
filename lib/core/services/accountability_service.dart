import 'package:isar/isar.dart';
import '../models/task.dart';

class AccountabilityService {
  final Isar isar;
  AccountabilityService(this.isar);

  /// Analyzes commitments and task execution to identify structural divergence.
  /// Reports observations objectively without triggering lockouts or external dispatches.
  Future<List<String>> checkSystemAndTriggerIfNeeded() async {
    final observations = <String>[];
    final now = DateTime.now();

    // 1. Check weekly execution rate across Peak Tasks
    final sevenDaysAgo = now.subtract(const Duration(days: 7));
    final recentTasks = await isar.tasks.filter().createdAtGreaterThan(sevenDaysAgo).findAll();
    if (recentTasks.length >= 5) {
      final completedCount = recentTasks.where((t) => t.isCompleted).length;
      final executionRate = completedCount / recentTasks.length;
      if (executionRate < 0.30) {
        observations.add('Execution notice: Weekly Peak completion rate is ${(executionRate * 100).toStringAsFixed(0)}%.');
      }
    }

    return observations;
  }
}

