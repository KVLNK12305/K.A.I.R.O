import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../../main.dart';
import '../../core/models/liar_goal.dart';

// ─── State ───────────────────────────────────────────────────────────────────

class LiarsChartState {
  final List<LiarGoal> goals;
  final bool isLoading;
  final String? webhookError;

  const LiarsChartState({
    this.goals = const [],
    this.isLoading = false,
    this.webhookError,
  });

  LiarsChartState copyWith({
    List<LiarGoal>? goals,
    bool? isLoading,
    String? webhookError,
  }) {
    return LiarsChartState(
      goals: goals ?? this.goals,
      isLoading: isLoading ?? this.isLoading,
      webhookError: webhookError,
    );
  }
}

// ─── Notifier ─────────────────────────────────────────────────────────────────

class LiarsChartNotifier extends StateNotifier<LiarsChartState> {
  LiarsChartNotifier()
      : super(const LiarsChartState(isLoading: true)) {
    _load();
  }

  Future<void> _load() async {
    final goals = await isar.liarGoals.where().anyId().findAll();
    // Recompute liarsChartActive for each goal
    await isar.writeTxn(() async {
      for (final goal in goals) {
        final wasActive = goal.liarsChartActive;
        final isActive = goal.isLeadFlat() || goal.isLeverDisconnected();
        if (isActive != wasActive) {
          goal.liarsChartActive = isActive;
          await isar.liarGoals.put(goal);
        }
      }
    });
    state = LiarsChartState(goals: goals);
  }

  Future<void> addGoal(LiarGoal goal) async {
    await isar.writeTxn(() async {
      await isar.liarGoals.put(goal);
    });
    await _load();
  }

  Future<void> pivotStrategy(int goalId) async {
    final goal = await isar.liarGoals.get(goalId);
    if (goal == null) return;
    
    // The penalty of a bad strategy: History is wiped. You start over.
    goal.leadHistory.clear();
    goal.lagHistory.clear();
    goal.liarsChartActive = false;
    
    await isar.writeTxn(() async {
      await isar.liarGoals.put(goal);
    });
    
    await _load();
  }

  Future<void> deleteGoal(int id) async {
    await isar.writeTxn(() async {
      await isar.liarGoals.delete(id);
    });
    await _load();
  }

  /// Log a new data point for a goal's lead and lag metrics.
  Future<void> logMetrics({
    required int goalId,
    required double leadValue,
    required double lagValue,
  }) async {
    final goal = await isar.liarGoals.get(goalId);
    if (goal == null) return;

    goal.leadHistory.add(leadValue);
    goal.lagHistory.add(lagValue);
    goal.liarsChartActive = goal.isLeadFlat() || goal.isLeverDisconnected();

    await isar.writeTxn(() async {
      await isar.liarGoals.put(goal);
    });
    await _load();
  }

  /// Simulates sending the accountability webhook (email/message).
  /// In production, this calls your configured endpoint.
  Future<bool> triggerAccountabilityWebhook(LiarGoal goal) async {
    // TODO: Replace with actual HTTP call (email API, Telegram bot, etc.)
    // For now, returns true to simulate success.
    // The UI will show the composed message and allow manual copy/send.
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }
}

// ─── Provider ─────────────────────────────────────────────────────────────────

final liarsChartProvider =
    StateNotifierProvider<LiarsChartNotifier, LiarsChartState>((ref) {
  return LiarsChartNotifier();
});
