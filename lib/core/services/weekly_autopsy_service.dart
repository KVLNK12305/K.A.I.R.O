import 'dart:convert';
import 'package:isar/isar.dart';
import '../models/weekly_autopsy.dart';
import '../models/task.dart';
import '../models/psychosomatic_scan.dart';
import 'ai_service.dart';
import 'streak_service.dart';

class WeeklyAutopsyService {
  final Isar isar;
  final AiService _aiService = AiService();

  WeeklyAutopsyService(this.isar);

  Future<WeeklyAutopsy?> getLatestAutopsy() async {
    return await isar.weeklyAutopsys.where().sortByWeekStartDateDesc().findFirst();
  }

  Future<List<WeeklyAutopsy>> getHistoricalAutopsies() async {
    return await isar.weeklyAutopsys.where().sortByWeekStartDateDesc().findAll();
  }

  Future<WeeklyAutopsy> generateOrUpdateWeeklyAutopsy({
    double wakatimeHours = 0.0,
    int githubPrs = 0,
    double burnRate = 0.0,
  }) async {
    final now = DateTime.now();
    final weekEndDate = now;
    final weekStartDate = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 7));

    // 1. Psychosomatic Stress Average
    final scans = await isar.psychosomaticScans
        .filter()
        .dateBetween(weekStartDate, weekEndDate)
        .findAll();
    double avgStress = 0.0;
    if (scans.isNotEmpty) {
      double sum = 0;
      for (final s in scans) {
        sum += s.stressScore;
      }
      avgStress = sum / scans.length;
    }

    // 2. Peak Tasks Execution Rate
    final allTasks = await isar.tasks.where().findAll();
    final weeklyPeakTasks = allTasks.where((t) =>
        (t.energySlot == EnergySlot.peak1 || t.energySlot == EnergySlot.peak2) &&
        t.createdAt.isAfter(weekStartDate)).toList();
    
    double peakRate = 0.0;
    if (weeklyPeakTasks.isNotEmpty) {
      final completed = weeklyPeakTasks.where((t) => t.isCompleted).length;
      peakRate = completed / weeklyPeakTasks.length;
    } else {
      peakRate = 0.5; // Neutral baseline if no tasks tracked
    }

    // 3. Power Score Calculation
    final streakDay = await StreakService().getDayNumber();
    final habitFactor = (streakDay / 21.0).clamp(0.0, 1.0);
    double powerScore = (peakRate * 100 * 0.45) + ((100 - avgStress) * 0.25) + (habitFactor * 100 * 0.30);
    powerScore = powerScore.clamp(0.0, 100.0);

    // 4. AI Synthesis Prompt
    final prompt = '''
You are the K.A.I.R.O. Weekly Autopsy Engine. Review this user's quantitative performance over the past 7 days and output exact brutalist feedback.

=== 7-DAY METRICS ===
- Composite Power Score: ${powerScore.toStringAsFixed(1)} / 100
- Peak Task Execution Rate: ${(peakRate * 100).toStringAsFixed(1)}% (${weeklyPeakTasks.where((t) => t.isCompleted).length} of ${weeklyPeakTasks.length} tasks completed)
- Average Body/Mind Stress Score: ${avgStress.toStringAsFixed(1)}%
- Deep Work (WakaTime): ${wakatimeHours.toStringAsFixed(1)} hours
- GitHub PRs Logged: $githubPrs
- Financial Burn Rate: \$${burnRate.toStringAsFixed(2)}
- Habit Streak Day: $streakDay of 21
=====================

You MUST respond strictly in valid JSON format with exactly these three string keys:
{
  "verdict": "Unfiltered, direct 2-3 sentence assessment of the week's overall trajectory and output.",
  "rootCause": "The single systemic bottleneck, psychological drag, or excuse causing failure or stagnation this week.",
  "requiredPivot": "One non-negotiable, concrete systemic change or rule required for next week to force ascension."
}
Do not include markdown code block formatting (like ```json), output raw JSON only.
''';

    String verdict = "Execution was moderate. Data indicates partial systemic alignment.";
    String rootCause = "Inconsistent Peak task completion combined with fluctuating psychosomatic recovery.";
    String requiredPivot = "Enforce 100% completion of Peak 1 before 12:00 PM every day without exception.";

    try {
      final response = await _aiService.chat([
        {'role': 'system', 'content': 'You are K.A.I.R.O. Respond only with valid JSON.'},
        {'role': 'user', 'content': prompt},
      ]);

      final cleaned = response.replaceAll('```json', '').replaceAll('```', '').trim();
      final decoded = jsonDecode(cleaned) as Map<String, dynamic>;
      if (decoded['verdict'] != null) verdict = decoded['verdict'].toString();
      if (decoded['rootCause'] != null) rootCause = decoded['rootCause'].toString();
      if (decoded['requiredPivot'] != null) requiredPivot = decoded['requiredPivot'].toString();
    } catch (e) {
      // Fallback if AI synthesis errors or returns non-JSON — use structured fallbacks based on score
      if (powerScore < 40) {
        verdict = "CRITICAL FAILURE: Power score sits at ${powerScore.toStringAsFixed(1)}/100. You spent this week in survival mode or self-deception.";
        rootCause = "High stress (${avgStress.toStringAsFixed(0)}%) and failure to complete committed Peak assignments.";
        requiredPivot = "Cut all non-essential tasks. Complete exactly one Peak task daily and log your body scan.";
      } else if (powerScore > 75) {
        verdict = "FORMIDABLE MOMENTUM: Power score reached ${powerScore.toStringAsFixed(1)}/100. High execution rate across Peak priorities.";
        rootCause = "Disciplined adherence to daily rituals and strong momentum on high-leverage tasks.";
        requiredPivot = "Push targets 20% higher next week while protecting sleep baseline to prevent burnout.";
      }
    }

    final autopsy = WeeklyAutopsy()
      ..weekStartDate = weekStartDate
      ..weekEndDate = weekEndDate
      ..powerScore = powerScore
      ..averageStressScore = avgStress
      ..peakExecutionRate = peakRate
      ..wakatimeTotalHours = wakatimeHours
      ..githubPrCount = githubPrs
      ..financeBurnRate = burnRate
      ..aiVerdict = verdict
      ..aiRootCause = rootCause
      ..aiRequiredPivot = requiredPivot
      ..createdAt = now;

    await isar.writeTxn(() async {
      await isar.weeklyAutopsys.put(autopsy);
    });

    return autopsy;
  }
}
