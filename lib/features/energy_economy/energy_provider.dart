import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../../main.dart';
import '../../core/models/task.dart';

// ─── State ───────────────────────────────────────────────────────────────────

class EnergyEconomyState {
  final List<Task> peak1Tasks;
  final List<Task> peak2Tasks;
  final List<Task> recoveryTasks;
  final List<Task> unassignedTasks;
  final Map<FailureEtiology, int> etiologyProfile; // aggregated over all time
  final bool recoveryBlocked; // triggered by Brutalist cowardice log
  final bool hasAssignedPeaksToday;
  final bool isLoading;
  final String? error;

  const EnergyEconomyState({
    this.peak1Tasks = const [],
    this.peak2Tasks = const [],
    this.recoveryTasks = const [],
    this.unassignedTasks = const [],
    this.etiologyProfile = const {},
    this.recoveryBlocked = false,
    this.hasAssignedPeaksToday = false,
    this.isLoading = false,
    this.error,
  });

  /// The dominant failure reason across all failed tasks.
  FailureEtiology? get dominantEtiology {
    if (etiologyProfile.isEmpty) return null;
    return etiologyProfile.entries
        .reduce((a, b) => a.value >= b.value ? a : b)
        .key;
  }

  EnergyEconomyState copyWith({
    List<Task>? peak1Tasks,
    List<Task>? peak2Tasks,
    List<Task>? recoveryTasks,
    List<Task>? unassignedTasks,
    Map<FailureEtiology, int>? etiologyProfile,
    bool? recoveryBlocked,
    bool? hasAssignedPeaksToday,
    bool? isLoading,
    String? error,
  }) {
    return EnergyEconomyState(
      peak1Tasks: peak1Tasks ?? this.peak1Tasks,
      peak2Tasks: peak2Tasks ?? this.peak2Tasks,
      recoveryTasks: recoveryTasks ?? this.recoveryTasks,
      unassignedTasks: unassignedTasks ?? this.unassignedTasks,
      etiologyProfile: etiologyProfile ?? this.etiologyProfile,
      recoveryBlocked: recoveryBlocked ?? this.recoveryBlocked,
      hasAssignedPeaksToday: hasAssignedPeaksToday ?? this.hasAssignedPeaksToday,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// ─── Notifier ─────────────────────────────────────────────────────────────────

class EnergyEconomyNotifier extends StateNotifier<EnergyEconomyState> {
  EnergyEconomyNotifier()
      : super(const EnergyEconomyState(isLoading: true)) {
    _load();
  }

  Future<void> _load() async {
    final all = await isar.tasks.where().anyId().findAll();

    final peak1 = all.where((t) => t.energySlot == EnergySlot.peak1).toList();
    final peak2 = all.where((t) => t.energySlot == EnergySlot.peak2).toList();
    final recovery =
        all.where((t) => t.energySlot == EnergySlot.recovery).toList();
    final unassigned =
        all.where((t) => t.energySlot == EnergySlot.unassigned).toList();

    // Aggregate failure etiology across all failed tasks
    final Map<FailureEtiology, int> profile = {};
    for (final task in all.where((t) => t.isFailed)) {
      if (task.failureEtiology != FailureEtiology.none) {
        profile[task.failureEtiology] =
            (profile[task.failureEtiology] ?? 0) + 1;
      }
    }

    // Check if recovery is blocked (cowardice logged today)
    final blockedRecovery = recovery.any((t) => t.isFailed);

    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final hasAssignedPeaks = all.any((t) =>
        (t.energySlot == EnergySlot.peak1 || t.energySlot == EnergySlot.peak2) &&
        t.createdAt.isAfter(startOfDay.subtract(const Duration(seconds: 1))));

    state = EnergyEconomyState(
      peak1Tasks: peak1,
      peak2Tasks: peak2,
      recoveryTasks: recovery,
      unassignedTasks: unassigned,
      etiologyProfile: profile,
      recoveryBlocked: blockedRecovery,
      hasAssignedPeaksToday: hasAssignedPeaks,
      isLoading: false,
      error: null,
    );
  }

  Future<void> addTask(String title, String category, EnergySlot slot) async {
    final task = Task(title, category)..energySlot = slot;
    await isar.writeTxn(() async => await isar.tasks.put(task));
    await _load();
  }

  Future<void> completeTask(int taskId) async {
    final task = await isar.tasks.get(taskId);
    if (task == null) return;
    task.isCompleted = true;
    task.isFailed = false;
    task.failureEtiology = FailureEtiology.none;
    await isar.writeTxn(() async => await isar.tasks.put(task));
    await _load();
  }

  Future<void> failTask(int taskId, FailureEtiology etiology) async {
    final task = await isar.tasks.get(taskId);
    if (task == null) return;
    task.isFailed = true;
    task.failureEtiology = etiology;
    await isar.writeTxn(() async => await isar.tasks.put(task));

    // Punitive enforcement: if "ProtectedTimeStolen" is the dominant tag,
    // we surface that in the state. The UI shows a warning that new tasks
    // will be auto-declined. (In a real device integration, this would hook
    // into a calendar API).
    await _load();
  }

  Future<void> moveTask(int taskId, EnergySlot newSlot) async {
    final task = await isar.tasks.get(taskId);
    if (task == null) return;
    task.energySlot = newSlot;
    await isar.writeTxn(() async => await isar.tasks.put(task));
    await _load();
  }

  Future<void> deleteTask(int taskId) async {
    await isar.writeTxn(() async => await isar.tasks.delete(taskId));
    await _load();
  }

  Future<void> logEnergyLeak() async {
    final task = Task("Distraction Leak", "Leak")
      ..energySlot = EnergySlot.unassigned
      ..isFailed = true
      ..failureEtiology = FailureEtiology.none; // Will categorize in evening
    await isar.writeTxn(() async => await isar.tasks.put(task));
    await _load();
  }
}

// ─── Provider ─────────────────────────────────────────────────────────────────

final energyEconomyProvider =
    StateNotifierProvider<EnergyEconomyNotifier, EnergyEconomyState>((ref) {
  return EnergyEconomyNotifier();
});
