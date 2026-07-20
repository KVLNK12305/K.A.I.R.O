import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/liar_goal.dart';
import '../models/crucible_state.dart';
import '../models/task.dart';
import 'notification_service.dart';

class AccountabilityService {
  final Isar isar;
  AccountabilityService(this.isar);

  Future<List<String>> checkSystemAndTriggerIfNeeded() async {
    final triggeredInsights = <String>[];
    final now = DateTime.now();
    final todayKey = now.toIso8601String().substring(0, 10);
    final prefs = await SharedPreferences.getInstance();

    // 1. Check Liar Goals for flat lead metrics / disconnected levers
    final liarGoals = await isar.liarGoals.where().findAll();
    for (final goal in liarGoals) {
      final isFlat = goal.isLeadFlat(cycles: 3);
      final isDisconnected = goal.isLeverDisconnected(cycles: 3);
      final isSevereFlat = goal.isLeadFlat(cycles: 4);

      if (isFlat || isDisconnected || goal.liarsChartActive) {
        final reason = isSevereFlat
            ? "Lead metric flat for 4+ consecutive cycles (Critical Stagnation)"
            : (isFlat
                ? "Lead metric flat across 3 cycles"
                : (isDisconnected ? "Lever disconnected (lead rising but lag flat)" : "Manually flagged Liar Goal"));

        final nukeSentKey = 'kairo_nuke_sent_${goal.id}_$todayKey';
        if (prefs.getBool(nukeSentKey) != true) {
          await NotificationService().showAccountabilityNukeAlert(
            goalTitle: goal.title,
            reason: reason,
            contactEmail: goal.accountabilityContact,
          );
          await prefs.setBool(nukeSentKey, true);
          triggeredInsights.add('🚨 Nuke Triggered for "${goal.title}": $reason');

          if (goal.accountabilityContact.isNotEmpty) {
            await _dispatchExternalAlert(goal.title, reason, goal.accountabilityContact);
          }
        }

        // Auto-trigger Crucible if severe flat (4 cycles of zero action)
        if (isSevereFlat) {
          await _forceCrucibleLockdown(
            commitment: 'Forced Lockdown: Execute immediate lead action for "${goal.title}"',
            reason: reason,
          );
          triggeredInsights.add('🔥 Crucible Auto-Triggered due to severe stagnation on "${goal.title}".');
        }
      }
    }

    // 2. Check weekly execution rate across Peak Tasks
    final sevenDaysAgo = now.subtract(const Duration(days: 7));
    final recentTasks = await isar.tasks.filter().createdAtGreaterThan(sevenDaysAgo).findAll();
    if (recentTasks.length >= 5) {
      final completedCount = recentTasks.where((t) => t.isCompleted).length;
      final executionRate = completedCount / recentTasks.length;
      if (executionRate < 0.30) {
        final nukeSentKey = 'kairo_nuke_exec_rate_$todayKey';
        if (prefs.getBool(nukeSentKey) != true) {
          final reason = 'Weekly Peak Execution Rate dropped to ${(executionRate * 100).toStringAsFixed(0)}% (<30% threshold)';
          await NotificationService().showAccountabilityNukeAlert(
            goalTitle: 'System Execution Rate Failure',
            reason: reason,
          );
          await prefs.setBool(nukeSentKey, true);
          triggeredInsights.add('🚨 System Execution Failure ($reason)');

          await _forceCrucibleLockdown(
            commitment: 'Execution Intervention: Complete 2 pending Peak tasks before unlock.',
            reason: reason,
          );
        }
      }
    }

    return triggeredInsights;
  }

  Future<void> _forceCrucibleLockdown({required String commitment, required String reason}) async {
    await isar.writeTxn(() async {
      var crucible = await isar.crucibleStates.get(1);
      crucible ??= CrucibleState();

      if (!crucible.isActive) {
        crucible.isActive = true;
        crucible.commitment = commitment;
        crucible.triggeredAt = DateTime.now();
        crucible.timesTriggered = crucible.timesTriggered + 1;
        crucible.proofText = '';
        crucible.resolvedAt = null;
        await isar.crucibleStates.put(crucible);
      }
    });
  }

  Future<void> _dispatchExternalAlert(String goalTitle, String reason, String contact) async {
    try {
      debugPrint('Dispatching Accountability Nuke to contact: $contact for goal "$goalTitle" ($reason)');
      // If contact is an HTTP webhook URL
      if (contact.startsWith('http://') || contact.startsWith('https://')) {
        await http.post(
          Uri.parse(contact),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'event': 'ACCOUNTABILITY_NUKE_TRIGGERED',
            'system': 'K.A.I.R.O_ASCENSION',
            'goalTitle': goalTitle,
            'reason': reason,
            'timestamp': DateTime.now().toIso8601String(),
          }),
        ).timeout(const Duration(seconds: 5));
      }
    } catch (e) {
      debugPrint('Notice: External accountability dispatch error: $e');
    }
  }
}
