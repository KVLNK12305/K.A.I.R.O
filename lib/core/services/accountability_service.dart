import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import '../models/task.dart';
import '../models/liar_goal.dart';
import 'notification_service.dart';

class AccountabilityService {
  final Isar isar;
  AccountabilityService(this.isar);

  /// Runs all accountability checks and fires real notifications for detected breaches.
  /// Returns the list of observations for callers that want to display them in-app.
  Future<List<String>> runAccountabilityChecks() async {
    final observations = <String>[];
    final notifier = NotificationService();

    // 1. Check weekly execution rate across Peak Tasks
    try {
      final now = DateTime.now();
      final sevenDaysAgo = now.subtract(const Duration(days: 7));
      final recentTasks = await isar.tasks
          .filter()
          .createdAtGreaterThan(sevenDaysAgo)
          .findAll();

      if (recentTasks.length >= 5) {
        final completedCount = recentTasks.where((t) => t.isCompleted).length;
        final executionRate = completedCount / recentTasks.length;
        if (executionRate < 0.30) {
          final msg = 'Weekly Peak completion rate is ${(executionRate * 100).toStringAsFixed(0)}%. Systemic underperformance detected.';
          observations.add(msg);
          await notifier.showInstantNotification(
            '📉 Execution Deficit',
            msg,
          );
        }
      }
    } catch (e) {
      debugPrint('Notice: Accountability task check failed: $e');
    }

    // 2. Check for LiarGoal breaches (flat lead metrics or disconnected lever)
    try {
      final activeLiarGoals = await isar.liarGoals
          .filter()
          .liarsChartActiveEqualTo(true)
          .findAll();

      for (final goal in activeLiarGoals) {
        String? breachReason;

        if (goal.isLeadFlat()) {
          breachReason = 'Lead metric "${goal.leadMetricLabel}" has been flat for 3+ cycles';
        } else if (goal.isLeverDisconnected()) {
          breachReason = 'Lead metric rising but lag metric "${goal.lagMetricLabel}" shows zero movement';
        }

        if (breachReason != null) {
          observations.add('Liar Goal "${goal.title}": $breachReason');
          await notifier.showAccountabilityNukeAlert(
            goalTitle: goal.title,
            reason: breachReason,
            contactEmail: goal.accountabilityContact.isNotEmpty
                ? goal.accountabilityContact
                : null,
          );
        }
      }
    } catch (e) {
      debugPrint('Notice: Accountability liar goal check failed: $e');
    }

    return observations;
  }
}
