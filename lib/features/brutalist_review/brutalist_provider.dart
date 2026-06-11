import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../../main.dart';
import '../../core/models/brutalist_review.dart';
import '../../core/models/task.dart';

// ─── State ───────────────────────────────────────────────────────────────────

class BrutalistState {
  final BrutalistReview? todayReview;
  final List<Task> unresolvedTasks;
  final bool isLoading;
  final String? error;

  const BrutalistState({
    this.todayReview,
    this.unresolvedTasks = const [],
    this.isLoading = false,
    this.error,
  });

  BrutalistState copyWith({
    BrutalistReview? todayReview,
    List<Task>? unresolvedTasks,
    bool? isLoading,
    String? error,
  }) {
    return BrutalistState(
      todayReview: todayReview ?? this.todayReview,
      unresolvedTasks: unresolvedTasks ?? this.unresolvedTasks,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// ─── Notifier ─────────────────────────────────────────────────────────────────

class BrutalistNotifier extends StateNotifier<BrutalistState> {
  BrutalistNotifier() : super(const BrutalistState(isLoading: true)) {
    _loadToday();
  }

  Future<void> _loadToday() async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    // Dart-side filter — avoids dependency on generated schema methods.
    final allReviews = await isar.brutalistReviews.where().anyId().findAll();
    final existing = allReviews.where((r) {
      return r.date.isAfter(startOfDay.subtract(const Duration(seconds: 1))) &&
          r.date.isBefore(endOfDay);
    }).firstOrNull;

    // Find unresolved peak tasks created today
    final allTasks = await isar.tasks.where().anyId().findAll();
    final unresolved = allTasks.where((t) {
      return (t.energySlot == EnergySlot.peak1 || t.energySlot == EnergySlot.peak2) &&
             t.createdAt.isAfter(startOfDay.subtract(const Duration(seconds: 1))) &&
             !t.isCompleted;
    }).toList();

    if (existing != null) {
      state = BrutalistState(todayReview: existing, unresolvedTasks: unresolved);
    } else {
      // Create a blank draft for today
      final newReview = BrutalistReview()..date = startOfDay;
      state = BrutalistState(todayReview: newReview, unresolvedTasks: unresolved);
    }
  }

  Future<void> save({
    required String vent,
    required String highlight,
    required CowardiceTag cowardiceTag,
    required String cowardiceDescription,
    required double futureCostLost,
  }) async {
    final review = state.todayReview ?? BrutalistReview();
    review
      ..date = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
      ..vent = vent.length > 300 ? vent.substring(0, 300) : vent
      ..highlight = highlight
      ..cowardiceTag = cowardiceTag
      ..cowardiceDescription = cowardiceDescription
      ..futureCostLost = futureCostLost
      ..isCompleted = true;

    await isar.writeTxn(() async {
      await isar.brutalistReviews.put(review);
    });

    // ENFORCEMENT: If cowardice was logged, block Recovery tasks for tomorrow.
    if (cowardiceTag != CowardiceTag.none) {
      await _blockRecoveryTasksForTomorrow();
    }

    state = state.copyWith(todayReview: review);
  }

  /// Marks all Recovery-slot tasks scheduled for tomorrow as blocked
  /// by flagging them as failed with etiology "TaskAversive" until
  /// the cowardice action is rectified.
  Future<void> _blockRecoveryTasksForTomorrow() async {
    // Dart-side filter — energySlotEqualTo requires the generated schema.
    final allTasks = await isar.tasks.where().anyId().findAll();
    final recoveryTasks = allTasks
        .where((t) => t.energySlot == EnergySlot.recovery && !t.isCompleted)
        .toList();

    if (recoveryTasks.isEmpty) return;

    await isar.writeTxn(() async {
      for (final task in recoveryTasks) {
        task.isFailed = true;
        task.failureEtiology = FailureEtiology.taskAversive;
      }
      await isar.tasks.putAll(recoveryTasks);
    });
  }

  bool get hasCompletedToday => state.todayReview?.isCompleted == true;
}

// ─── Provider ─────────────────────────────────────────────────────────────────

final brutalistProvider =
    StateNotifierProvider<BrutalistNotifier, BrutalistState>((ref) {
  return BrutalistNotifier();
});
