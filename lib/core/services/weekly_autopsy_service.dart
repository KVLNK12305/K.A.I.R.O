import 'dart:convert';
import 'package:isar/isar.dart';
import '../models/weekly_autopsy.dart';
import '../models/psychosomatic_scan.dart';
import 'ai_service.dart';
import 'daily_plan_service.dart';
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
    double focusHours = 0.0,
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

    // 2. Peak Execution Rate (committed DailyPlan Peaks)
    final peakStats = await DailyPlanService(isar).getPeakExecutionSince(weekStartDate);
    final peakRate = peakStats.rate ?? 0.5; // Neutral baseline if no peaks committed

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
- Peak Task Execution Rate: ${(peakRate * 100).toStringAsFixed(1)}% (${peakStats.completed} of ${peakStats.committed} committed Peaks completed)
- Average Body/Mind Stress Score: ${avgStress.toStringAsFixed(1)}%
- Deep Work (Focus Engine sessions): ${focusHours.toStringAsFixed(1)} hours
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

  /// Calculates mid-week telemetry (Mon-Wed) and projects the predicted Sunday Power Score.
  Future<PreMortemForecast> generatePreMortemForecast() async {
    final now = DateTime.now();
    final daysSinceMonday = (now.weekday - 1).clamp(1, 7);
    final weekStart = DateTime(now.year, now.month, now.day).subtract(Duration(days: daysSinceMonday));

    final scans = await isar.psychosomaticScans
        .filter()
        .dateBetween(weekStart, now)
        .findAll();
    double avgStress = 0.0;
    if (scans.isNotEmpty) {
      double sum = 0;
      for (final s in scans) {
        sum += s.stressScore;
      }
      avgStress = sum / scans.length;
    }

    final peakRate = (await DailyPlanService(isar).getPeakExecutionSince(weekStart)).rate ?? 0.5;

    final streakDay = await StreakService().getDayNumber();
    final habitFactor = (streakDay / 21.0).clamp(0.0, 1.0);
    double predictedScore = (peakRate * 100 * 0.45) + ((100 - avgStress) * 0.25) + (habitFactor * 100 * 0.30);
    predictedScore = predictedScore.clamp(0.0, 100.0);

    final isCriticalRisk = predictedScore < 45.0 || peakRate < 0.35;

    return PreMortemForecast(
      predictedSundayScore: predictedScore,
      midWeekPeakRate: peakRate,
      midWeekAvgStress: avgStress,
      isCriticalRisk: isCriticalRisk,
      suggestedIntervention: isCriticalRisk
          ? 'CRITICAL FAILURE FORECAST: Mid-week Peak rate is ${(peakRate * 100).toStringAsFixed(0)}%. Auto-triggering Crucible Lockdown.'
          : 'ON TRACK: Projected Sunday Power Score is ${predictedScore.toStringAsFixed(1)}/100.',
    );
  }
}

class PreMortemForecast {
  final double predictedSundayScore;
  final double midWeekPeakRate;
  final double midWeekAvgStress;
  final bool isCriticalRisk;
  final String suggestedIntervention;

  PreMortemForecast({
    required this.predictedSundayScore,
    required this.midWeekPeakRate,
    required this.midWeekAvgStress,
    required this.isCriticalRisk,
    required this.suggestedIntervention,
  });
}

