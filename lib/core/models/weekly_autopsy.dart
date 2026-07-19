import 'package:isar/isar.dart';

part 'weekly_autopsy.g.dart';

@collection
class WeeklyAutopsy {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late DateTime weekStartDate;

  late DateTime weekEndDate;

  /// Composite Power Score (0 - 100).
  double powerScore = 0.0;

  /// Average psychosomatic stress score for the week.
  double averageStressScore = 0.0;

  /// Percentage of assigned Peak 1 and Peak 2 tasks completed.
  double peakExecutionRate = 0.0;

  /// Total WakaTime coding hours logged across the week.
  double wakatimeTotalHours = 0.0;

  /// Total GitHub PRs merged/created.
  int githubPrCount = 0;

  /// Financial burn rate / expenses for the week.
  double financeBurnRate = 0.0;

  /// AI Brutalist Verdict (unfiltered assessment of the week).
  String aiVerdict = '';

  /// AI identified systemic root cause of failure or drag.
  String aiRootCause = '';

  /// AI required action/pivot for the upcoming week.
  String aiRequiredPivot = '';

  DateTime createdAt = DateTime.now();

  WeeklyAutopsy();
}
