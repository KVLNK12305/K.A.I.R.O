import 'package:isar/isar.dart';

part 'task.g.dart';

/// Cognitive demand slot for the Energy Economy system.
enum EnergySlot {
  peak1,      // Morning — highest cognitive load
  peak2,      // Late morning — second wind
  recovery,   // Afternoon — admin, low-stakes work
  unassigned, // Not yet placed in the energy budget
}

/// Why a task failed or was moved. Used to map the architecture of self-sabotage.
enum FailureEtiology {
  none,
  miscalibratedEnergy,
  taskAversive,
  scopeTooLarge,
  protectedTimeStolen,
  didntWantItEnough,
}

@collection
class Task {
  Id id = Isar.autoIncrement;

  String title;
  String category;
  bool isCompleted;
  DateTime createdAt = DateTime.now();

  /// Energy Economy: which cognitive slot this task belongs to.
  @enumerated
  EnergySlot energySlot = EnergySlot.unassigned;

  /// Energy Economy: root cause tag when a task is failed or skipped.
  @enumerated
  FailureEtiology failureEtiology = FailureEtiology.none;

  /// Whether this task was explicitly failed (vs just not done yet).
  bool isFailed = false;

  /// Subtasks checklist items for granular execution.
  List<String> subTasks = [];

  /// Subtasks that have been checked as completed.
  List<String> completedSubTasks = [];

  /// Progress percentage (0–100) set during Brutalist Review triage.
  int progressPercent = 0;

  /// Whether this task was carried forward to the next day (in-progress, not failed).
  bool isCarriedForward = false;

  /// How many times this task has been carried forward. Detects chronic procrastination.
  int carryForwardCount = 0;

  Task(this.title, this.category, {this.isCompleted = false});
}