import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../models/sleep_log.dart';
import '../models/psychosomatic_scan.dart';
import '../../main.dart';

class SleepCorrelationReport {
  final double averageHoursSlept;
  final double averageQuality;
  final String correlationInsight;
  final String recommendedBedTime;

  const SleepCorrelationReport({
    required this.averageHoursSlept,
    required this.averageQuality,
    required this.correlationInsight,
    required this.recommendedBedTime,
  });
}

class SleepIntelligenceService {
  final Isar isar;
  SleepIntelligenceService(this.isar);

  Future<SleepLog?> getTodayLog() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    return await isar.sleepLogs.filter().dateEqualTo(startOfDay).findFirst();
  }

  Future<List<SleepLog>> getRecentLogs({int days = 14}) async {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    return await isar.sleepLogs.filter().dateGreaterThan(cutoff).sortByDateDesc().findAll();
  }

  Future<void> logSleep({
    required DateTime date,
    required double hours,
    required int quality,
    String? bedTime,
    String? wakeTime,
    String? notes,
  }) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    var existing = await isar.sleepLogs.filter().dateEqualTo(startOfDay).findFirst();
    existing ??= SleepLog(date: startOfDay);

    existing.hoursSlept = hours;
    existing.qualityRating = quality;
    existing.bedTime = bedTime;
    existing.wakeTime = wakeTime;
    existing.notes = notes;

    await isar.writeTxn(() async {
      await isar.sleepLogs.put(existing!);
    });
  }

  Future<SleepCorrelationReport> calculateCorrelation() async {
    final logs = await getRecentLogs(days: 30);
    if (logs.isEmpty) {
      return const SleepCorrelationReport(
        averageHoursSlept: 7.0,
        averageQuality: 3.0,
        correlationInsight: "No sleep logs recorded yet. Log tonight's sleep to activate correlation analysis.",
        recommendedBedTime: "23:00",
      );
    }

    final avgHours = logs.fold<double>(0.0, (sum, l) => sum + l.hoursSlept) / logs.length;
    final avgQuality = logs.fold<int>(0, (sum, l) => sum + l.qualityRating) / logs.length;

    // Cross-reference with PsychosomaticScans over the same dates
    final scans = await isar.psychosomaticScans.where().findAll();
    final scanMap = {for (var s in scans) DateTime(s.date.year, s.date.month, s.date.day): s};

    double stressLowSleep = 0.0;
    int countLowSleep = 0;
    double stressNormalSleep = 0.0;
    int countNormalSleep = 0;

    for (final l in logs) {
      final dateKey = DateTime(l.date.year, l.date.month, l.date.day);
      final scan = scanMap[dateKey];
      if (scan != null) {
        // Calculate somatic stress
        final stress = (scan.muscleTension + scan.headStomachDisturbance + scan.jawClench + scan.skinReaction) / 4.0;
        if (l.hoursSlept < 6.5) {
          stressLowSleep += stress;
          countLowSleep++;
        } else {
          stressNormalSleep += stress;
          countNormalSleep++;
        }
      }
    }

    String insight = "Sleep duration has averaged ${avgHours.toStringAsFixed(1)}h over the last ${logs.length} days.";
    if (countLowSleep > 0 && countNormalSleep > 0) {
      final avgStressLow = stressLowSleep / countLowSleep;
      final avgStressNormal = stressNormalSleep / countNormalSleep;
      if (avgStressLow > avgStressNormal) {
        final diffPercent = ((avgStressLow - avgStressNormal) / (avgStressNormal == 0 ? 1 : avgStressNormal) * 100).round();
        insight = "When you sleep under 6.5h, your somatic stress score jumps +$diffPercent% higher than when well-rested.";
      } else {
        insight = "Sleep discipline is currently stabilizing somatic stress across your daily cycles.";
      }
    } else if (avgHours < 6.5) {
      insight = "Warning: Chronic sleep deficit detected (${avgHours.toStringAsFixed(1)}h avg). System recovery bandwidth is compromised.";
    }

    return SleepCorrelationReport(
      averageHoursSlept: avgHours,
      averageQuality: avgQuality,
      correlationInsight: insight,
      recommendedBedTime: "22:45",
    );
  }
}

final sleepIntelligenceProvider = FutureProvider<SleepCorrelationReport>((ref) async {
  final service = SleepIntelligenceService(isar);
  return await service.calculateCorrelation();
});

final todaySleepLogProvider = FutureProvider<SleepLog?>((ref) async {
  final service = SleepIntelligenceService(isar);
  return await service.getTodayLog();
});
