import 'package:isar/isar.dart';
import '../models/task.dart';
import '../models/liar_goal.dart';
import '../models/psychosomatic_scan.dart';
import '../models/crucible_state.dart';
import '../models/decision_log.dart';
import 'streak_service.dart';
import 'time_audit_service.dart';

class SystemicDossier {
  final int streakDay;
  final bool isStreakBroken;
  final double freeHours168;
  final String timeAuditAssessment;
  final bool isCrucibleActive;
  final int crucibleTimesTriggered;
  final String crucibleCommitment;
  final int activeLiarsChartCount;
  final List<String> flaggedLiarGoals;
  final double? todayStressScore;
  final List<String> todayPeakTasksSummary;
  final int completedPeaksCount;
  final int totalPeaksCount;
  final String dominantFailureReason;
  final List<String> pendingDecisionsSummary;
  final String wakatimeStats;
  final String financeBurnToday;

  SystemicDossier({
    required this.streakDay,
    required this.isStreakBroken,
    required this.freeHours168,
    required this.timeAuditAssessment,
    required this.isCrucibleActive,
    required this.crucibleTimesTriggered,
    required this.crucibleCommitment,
    required this.activeLiarsChartCount,
    required this.flaggedLiarGoals,
    this.todayStressScore,
    required this.todayPeakTasksSummary,
    required this.completedPeaksCount,
    required this.totalPeaksCount,
    required this.dominantFailureReason,
    required this.pendingDecisionsSummary,
    required this.wakatimeStats,
    required this.financeBurnToday,
  });

  String toFormattedPromptContext() {
    final stressStr = todayStressScore != null
        ? '${todayStressScore!.toStringAsFixed(0)}% stress level'
        : 'Not scanned yet today';

    final streakStatus = isStreakBroken ? 'BROKEN CHAIN (Day $streakDay)' : 'Active Chain (Day $streakDay of 21)';
    
    final crucibleStr = isCrucibleActive
        ? '⚠️ CRUCIBLE ACTIVE! Locked on: "$crucibleCommitment" (Triggered $crucibleTimesTriggered times total)'
        : 'Inactive ($crucibleTimesTriggered past triggers)';

    final liarsListStr = flaggedLiarGoals.isEmpty
        ? 'All goals currently honest.'
        : flaggedLiarGoals.map((g) => '  - $g').join('\n');

    final peaksListStr = todayPeakTasksSummary.isEmpty
        ? '  - No Peak tasks committed yet today.'
        : todayPeakTasksSummary.map((t) => '  - $t').join('\n');

    final decisionsStr = pendingDecisionsSummary.isEmpty
        ? '  - No high-stakes decisions currently pending review.'
        : pendingDecisionsSummary.map((d) => '  - $d').join('\n');

    return '''
==================================================
        K.A.I.R.O. SYSTEMIC USER DOSSIER
==================================================

1. DISCIPLINE & MOMENTUM:
- Habit Streak: $streakStatus
- Crucible State: $crucibleStr

2. PSYCHOSOMATIC & BANDWIDTH:
- Body/Mind Scan Today: $stressStr
- 168-Hour Time Audit: ${freeHours168.toStringAsFixed(1)} free hours/week remaining ($timeAuditAssessment)

3. PEAK TASK EXECUTION TODAY ($completedPeaksCount/$totalPeaksCount completed | Dominant drag: $dominantFailureReason):
$peaksListStr

4. TRUTH & LIAR'S CHART INTERROGATION ($activeLiarsChartCount flagged):
$liarsListStr

5. DECISION PIPELINE (High-Stakes Assumptions Pending Review):
$decisionsStr

6. OUTPUT & BURN RATE TODAY:
- Deep Work (WakaTime Today): $wakatimeStats
- Financial Burn Rate Today: $financeBurnToday
==================================================
''';
  }
}

class KairoContextService {
  final Isar isar;

  KairoContextService(this.isar);

  Future<SystemicDossier> buildSystemicDossier({
    TimeAuditResult? timeAudit,
    List<Task> peak1Tasks = const [],
    List<Task> peak2Tasks = const [],
    FailureEtiology? dominantEtiology,
    double? todayExpense,
    String wakatimeStats = 'N/A',
  }) async {
    // 1. Streak Status
    final streakDay = await StreakService().getDayNumber();
    final isStreakBroken = await StreakService().isStreakBroken();

    // 2. Time Audit
    final audit = timeAudit ?? await TimeAuditService().calculateWeeklyAudit([]);

    // 3. Crucible State
    final crucible = await isar.crucibleStates.get(1);
    final isCrucibleActive = crucible?.isActive ?? false;
    final crucibleCommitment = crucible?.commitment ?? '';
    final crucibleTimesTriggered = crucible?.timesTriggered ?? 0;

    // 4. Liar's Chart
    final allGoals = await isar.liarGoals.where().findAll();
    final flaggedGoals = <String>[];
    for (final goal in allGoals) {
      if (goal.liarsChartActive || goal.isLeadFlat() || goal.isLeverDisconnected()) {
        final reason = goal.isLeverDisconnected()
            ? 'Lead (${goal.leadMetricLabel}) rising but Lag (${goal.lagMetricLabel}) stagnant'
            : (goal.isLeadFlat() ? 'Lead metric flat for ${goal.leadHistory.length} cycles' : 'Manually flagged');
        flaggedGoals.add('"${goal.title}" -> Flagged: $reason');
      }
    }

    // 5. Psychosomatic Scan Today
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final scan = await isar.psychosomaticScans.where().dateEqualTo(todayStart).findFirst();

    // 6. Peak Tasks Summary
    final peaksSummary = <String>[];
    for (final t in peak1Tasks) {
      peaksSummary.add('[PEAK 1] "${t.title}" -> ${t.isCompleted ? "COMPLETED ✅" : (t.isFailed ? "FAILED ❌ (${t.failureEtiology.name})" : "IN PROGRESS / PENDING")}');
    }
    for (final t in peak2Tasks) {
      peaksSummary.add('[PEAK 2] "${t.title}" -> ${t.isCompleted ? "COMPLETED ✅" : (t.isFailed ? "FAILED ❌ (${t.failureEtiology.name})" : "IN PROGRESS / PENDING")}');
    }
    final completedPeaks = peak1Tasks.where((t) => t.isCompleted).length +
        peak2Tasks.where((t) => t.isCompleted).length;
    final totalPeaks = peak1Tasks.length + peak2Tasks.length;

    // 7. Pending Decisions
    final pendingDecisions = await isar.decisionLogs
        .filter()
        .verdictEqualTo('Pending')
        .findAll();
    final decisionsSummary = pendingDecisions.map((d) {
      final daysRemaining = d.reviewDate.difference(now).inDays;
      return '"${d.title}" (Confidence: ${d.confidenceScore}/10) -> Due for review in $daysRemaining days. Prediction: "${d.expectedOutcome}"';
    }).toList();

    final burnTodayStr = todayExpense != null ? '\$${todayExpense.toStringAsFixed(2)}' : 'N/A';

    return SystemicDossier(
      streakDay: streakDay,
      isStreakBroken: isStreakBroken,
      freeHours168: audit.freeHours,
      timeAuditAssessment: audit.brutalAssessment,
      isCrucibleActive: isCrucibleActive,
      crucibleTimesTriggered: crucibleTimesTriggered,
      crucibleCommitment: crucibleCommitment,
      activeLiarsChartCount: flaggedGoals.length,
      flaggedLiarGoals: flaggedGoals,
      todayStressScore: scan?.stressScore,
      todayPeakTasksSummary: peaksSummary,
      completedPeaksCount: completedPeaks,
      totalPeaksCount: totalPeaks,
      dominantFailureReason: dominantEtiology?.name ?? 'None',
      pendingDecisionsSummary: decisionsSummary,
      wakatimeStats: wakatimeStats,
      financeBurnToday: burnTodayStr,
    );
  }
}
