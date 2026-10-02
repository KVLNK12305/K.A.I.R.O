import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';
import 'package:isar/isar.dart';
import 'package:intl/intl.dart';
import '../../main.dart';
import '../models/daily_plan.dart';
import '../models/focus_session.dart';
import '../models/sleep_log.dart';
import '../models/gita_shloka.dart';
import 'streak_service.dart';
import 'wellbeing_service.dart';
import 'time_audit_service.dart';

class HomeWidgetSyncService {
  static const String groupId = 'group.com.kairo.app';

  /// Syncs data for all 5 native widgets with live Isar records and OS telemetry.
  static Future<void> syncAllWidgets() async {
    try {
      await syncTaskPulseData();
      await syncStreakData();
      await syncEnergyArcData();
      await syncQuotePrismData();
      await syncDailyAuditData();
    } catch (e) {
      debugPrint('Error syncing home widgets: $e');
    }
  }

  /// 1. Task Pulse Widget: Real DailyPlan Peaks & Today's Deep Work Focus Time
  static Future<void> syncTaskPulseData() async {
    try {
      final now = DateTime.now();
      final todayStart = DateTime(now.year, now.month, now.day);
      final todayEnd = todayStart.add(const Duration(days: 1));

      final plan = await isar.dailyPlans.filter().dateEqualTo(todayStart).findFirst();

      final p1Title = plan?.peak1Title.trim() ?? '';
      final p1Done = plan?.peak1Completed ?? false;
      final p2Title = plan?.peak2Title.trim() ?? '';
      final p2Done = plan?.peak2Completed ?? false;

      int totalPeaks = 0;
      int completedPeaks = 0;
      if (p1Title.isNotEmpty) {
        totalPeaks++;
        if (p1Done) completedPeaks++;
      }
      if (p2Title.isNotEmpty) {
        totalPeaks++;
        if (p2Done) completedPeaks++;
      }

      // Default to 2 peak slots if none set yet
      if (totalPeaks == 0) totalPeaks = 2;

      // Real focus time today from completed/in-progress focus sessions
      final todaySessions = await isar.focusSessions
          .filter()
          .startTimeGreaterThan(todayStart)
          .and()
          .startTimeLessThan(todayEnd)
          .findAll();

      final totalFocusMinutes = todaySessions.fold<int>(
        0,
        (sum, s) => sum + (s.actualDurationMinutes > 0 ? s.actualDurationMinutes : (s.completed ? s.plannedDurationMinutes : 0)),
      );

      final p1Display = p1Title.isNotEmpty
          ? (p1Done ? 'P1: DONE' : 'P1: ACTIVE')
          : 'P1: NOT SET';
      final p2Display = p2Title.isNotEmpty
          ? (p2Done ? 'P2: DONE' : 'P2: ACTIVE')
          : 'P2: NOT SET';

      final focusHours = totalFocusMinutes / 60.0;
      final focusDisplay = focusHours > 0
          ? '${focusHours.toStringAsFixed(1)}h FOCUS'
          : '0.0h FOCUS';

      await HomeWidget.saveWidgetData<int>('task_completed', completedPeaks);
      await HomeWidget.saveWidgetData<int>('task_total', totalPeaks);
      await HomeWidget.saveWidgetData<String>('peak1_display', p1Display);
      await HomeWidget.saveWidgetData<String>('peak2_display', p2Display);
      await HomeWidget.saveWidgetData<String>('recovery_display', focusDisplay);
      await HomeWidget.saveWidgetData<String>('peak1_title', p1Title);
      await HomeWidget.saveWidgetData<bool>('peak1_completed', p1Done);
      await HomeWidget.saveWidgetData<String>('peak2_title', p2Title);
      await HomeWidget.saveWidgetData<bool>('peak2_completed', p2Done);

      await HomeWidget.updateWidget(
        name: 'TaskPulseWidgetProvider',
        androidName: 'TaskPulseWidgetProvider',
        qualifiedAndroidName: 'com.kairo.app.widgets.TaskPulseWidgetProvider',
      );
    } catch (e) {
      debugPrint('Error syncing TaskPulse: $e');
    }
  }

  /// Syncs Daily Peaks and cascades updates to TaskPulse, EnergyArc, and 24H Audit
  static Future<void> syncDailyPeaks({
    required String peak1,
    required bool peak1Done,
    required String peak2,
    required bool peak2Done,
  }) async {
    try {
      await syncTaskPulseData();
      await syncEnergyArcData();
      await syncDailyAuditData();
    } catch (e) {
      debugPrint('Error syncing Daily Peaks to home widget: $e');
    }
  }

  /// 2. Energy Arc Widget: Real Peak Execution + Sleep Recovery Metrics
  static Future<void> syncEnergyArcData() async {
    try {
      final now = DateTime.now();
      final todayStart = DateTime(now.year, now.month, now.day);
      final todayEnd = todayStart.add(const Duration(days: 1));

      final plan = await isar.dailyPlans.filter().dateEqualTo(todayStart).findFirst();

      final todaySessions = await isar.focusSessions
          .filter()
          .startTimeGreaterThan(todayStart)
          .and()
          .startTimeLessThan(todayEnd)
          .findAll();

      // Peak 1 %
      int p1Pct = 0;
      if (plan != null && plan.peak1Title.isNotEmpty) {
        if (plan.peak1Completed) {
          p1Pct = 100;
        } else {
          final p1Focus = todaySessions
              .where((s) => s.peakTaskId == 'peak1' || s.title.toLowerCase().contains('peak 1'))
              .fold<int>(0, (sum, s) => sum + s.actualDurationMinutes);
          final plannedMin = plan.peak1DurationMinutes > 0 ? plan.peak1DurationMinutes : 90;
          p1Pct = (p1Focus / plannedMin * 100).round().clamp(0, 100);
        }
      }

      // Peak 2 %
      int p2Pct = 0;
      if (plan != null && plan.peak2Title.isNotEmpty) {
        if (plan.peak2Completed) {
          p2Pct = 100;
        } else {
          final p2Focus = todaySessions
              .where((s) => s.peakTaskId == 'peak2' || s.title.toLowerCase().contains('peak 2'))
              .fold<int>(0, (sum, s) => sum + s.actualDurationMinutes);
          final plannedMin = plan.peak2DurationMinutes > 0 ? plan.peak2DurationMinutes : 90;
          p2Pct = (p2Focus / plannedMin * 100).round().clamp(0, 100);
        }
      }

      // Recovery %: real SleepLog or sleep baseline
      final sleepLog = await isar.sleepLogs.filter().dateEqualTo(todayStart).findFirst();
      int recPct;
      if (sleepLog != null) {
        final hoursScore = (sleepLog.hoursSlept / 8.0).clamp(0.0, 1.0) * 60;
        final qualityScore = (sleepLog.qualityRating / 5.0).clamp(0.0, 1.0) * 40;
        recPct = (hoursScore + qualityScore).round().clamp(0, 100);
      } else {
        final baseline = await TimeAuditService().getSleepBaseline();
        recPct = (baseline / 8.0 * 100).round().clamp(0, 100);
      }

      final avgPct = ((p1Pct + p2Pct + recPct) / 3).round();

      await HomeWidget.saveWidgetData<int>('energy_peak1_pct', p1Pct);
      await HomeWidget.saveWidgetData<int>('energy_peak2_pct', p2Pct);
      await HomeWidget.saveWidgetData<int>('energy_recovery_pct', recPct);
      await HomeWidget.saveWidgetData<int>('energy_avg_pct', avgPct);

      await HomeWidget.updateWidget(
        name: 'EnergyArcWidgetProvider',
        androidName: 'EnergyArcWidgetProvider',
        qualifiedAndroidName: 'com.kairo.app.widgets.EnergyArcWidgetProvider',
      );
    } catch (e) {
      debugPrint('Error syncing EnergyArc: $e');
    }
  }

  /// 3. Daily 24H Audit Widget: 100% Real Sleep, Focus, Screen Time & Free Budget (Zero Mocks)
  static Future<void> syncDailyAuditData() async {
    try {
      final now = DateTime.now();
      final todayStart = DateTime(now.year, now.month, now.day);
      final todayEnd = todayStart.add(const Duration(days: 1));

      // 1. Sleep hours: from today's real SleepLog or user's baseline
      final sleepLog = await isar.sleepLogs.filter().dateEqualTo(todayStart).findFirst();
      final double sleepHours;
      if (sleepLog != null && sleepLog.hoursSlept > 0) {
        sleepHours = sleepLog.hoursSlept;
      } else {
        sleepHours = await TimeAuditService().getSleepBaseline();
      }

      // 2. Work / Deep Focus hours: today's FocusSessions + completed peaks
      final todaySessions = await isar.focusSessions
          .filter()
          .startTimeGreaterThan(todayStart)
          .and()
          .startTimeLessThan(todayEnd)
          .findAll();
      final int sessionMinutes = todaySessions.fold<int>(
        0,
        (sum, s) => sum + (s.actualDurationMinutes > 0 ? s.actualDurationMinutes : (s.completed ? s.plannedDurationMinutes : 0)),
      );

      final plan = await isar.dailyPlans.filter().dateEqualTo(todayStart).findFirst();
      int peakMinutes = 0;
      if (plan != null) {
        if (plan.peak1Completed) peakMinutes += plan.peak1DurationMinutes;
        if (plan.peak2Completed) peakMinutes += plan.peak2DurationMinutes;
      }

      final totalWorkMinutes = sessionMinutes > peakMinutes ? sessionMinutes : peakMinutes;
      final double workHours = totalWorkMinutes / 60.0;

      // 3. Screen / Other hours from Android UsageStats
      double screenHours = 0.0;
      try {
        final hasPerm = await WellbeingService.checkUsagePermission();
        if (hasPerm) {
          screenHours = await WellbeingService.getDailyScreenTime();
        }
      } catch (_) {}

      // 4. Free hours remaining in 24h budget
      final double committed = sleepHours + workHours + screenHours;
      double freeHours = 24.0 - committed;
      if (freeHours < 0.0) freeHours = 0.0;

      final int allocatedPct = ((committed / 24.0) * 100).round().clamp(0, 100);

      await HomeWidget.saveWidgetData<String>('audit_sleep', '${sleepHours.toStringAsFixed(1)}h');
      await HomeWidget.saveWidgetData<String>('audit_work', '${workHours.toStringAsFixed(1)}h');
      await HomeWidget.saveWidgetData<String>('audit_free', '${freeHours.toStringAsFixed(1)}h');
      await HomeWidget.saveWidgetData<int>('audit_allocated_pct', allocatedPct);
      await HomeWidget.saveWidgetData<String>('audit_budget_label', '$allocatedPct% COMMITTED');

      await HomeWidget.updateWidget(
        name: 'DailyAuditWidgetProvider',
        androidName: 'DailyAuditWidgetProvider',
        qualifiedAndroidName: 'com.kairo.app.widgets.DailyAuditWidgetProvider',
      );
    } catch (e) {
      debugPrint('Error syncing DailyAudit: $e');
    }
  }

  /// 4. Quote Prism Widget: Daily Shloka from Gita Wisdom
  static Future<void> syncQuotePrismData() async {
    try {
      final shlokas = await isar.gitaShlokas.where().findAll();
      GitaShloka quote;
      if (shlokas.isNotEmpty) {
        final dayOfYear = int.parse(DateFormat('D').format(DateTime.now()));
        quote = shlokas[dayOfYear % shlokas.length];
      } else {
        quote = GitaShloka(
          chapter: 2,
          verse: 47,
          slok: 'कर्मण्येवाधिकारस्ते मा फलेषु कदाचन।\nमा कर्मफलहेतुर्भूर्मा ते सङ्गोऽस्त्वकर्मणि॥',
          transliteration: '',
          translation: 'You have a right to perform your prescribed duties, but you are not entitled to the fruits of your actions.',
          hindiTranslation: '',
        );
      }

      await HomeWidget.saveWidgetData<int>('quote_chapter', quote.chapter);
      await HomeWidget.saveWidgetData<int>('quote_verse', quote.verse);
      await HomeWidget.saveWidgetData<String>('quote_slok', quote.slok);
      await HomeWidget.saveWidgetData<String>('quote_translation', quote.translation);

      await HomeWidget.updateWidget(
        name: 'QuotePrismWidgetProvider',
        androidName: 'QuotePrismWidgetProvider',
        qualifiedAndroidName: 'com.kairo.app.widgets.QuotePrismWidgetProvider',
      );
    } catch (e) {
      debugPrint('Error syncing QuotePrism: $e');
    }
  }

  /// 5. Streak Flame Widget: Active Discipline Chain
  static Future<void> syncStreakData() async {
    try {
      final service = StreakService();
      final dayNumber = await service.getDayNumber();
      final isBroken = await service.isStreakBroken();
      final completedDays = await service.getCompletedDays();

      await HomeWidget.saveWidgetData<int>('streak_day', dayNumber);
      await HomeWidget.saveWidgetData<bool>('streak_broken', isBroken);
      await HomeWidget.saveWidgetData<int>('streak_completed', completedDays.length);
      await HomeWidget.saveWidgetData<int>('streak_total', 21);

      await HomeWidget.updateWidget(
        name: 'StreakFlameWidgetProvider',
        androidName: 'StreakFlameWidgetProvider',
        qualifiedAndroidName: 'com.kairo.app.widgets.StreakFlameWidgetProvider',
      );
    } catch (e) {
      debugPrint('Error syncing StreakFlame: $e');
    }
  }
}
