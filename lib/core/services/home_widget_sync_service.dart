import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';
import 'package:isar/isar.dart';
import 'package:intl/intl.dart';
import '../../main.dart';
import '../models/task.dart';
import '../models/gita_shloka.dart';
import 'streak_service.dart';

class HomeWidgetSyncService {
  static const String groupId = 'group.com.kairo.app';

  /// Syncs data for all 5 native widgets and updates them.
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

  /// Task Pulse Widget Data
  static Future<void> syncTaskPulseData() async {
    try {
      final tasks = await isar.tasks.where().findAll();

      final peak1Tasks = tasks.where((t) => t.energySlot == EnergySlot.peak1).toList();
      final peak2Tasks = tasks.where((t) => t.energySlot == EnergySlot.peak2).toList();
      final recoveryTasks = tasks.where((t) => t.energySlot == EnergySlot.recovery).toList();
      final unassigned = tasks.where((t) => t.energySlot == EnergySlot.unassigned).toList();

      final allTasks = [...peak1Tasks, ...peak2Tasks, ...recoveryTasks, ...unassigned];
      final total = allTasks.length;
      final completed = allTasks.where((t) => t.isCompleted).length;

      final p1Done = peak1Tasks.where((t) => t.isCompleted).length;
      final p2Done = peak2Tasks.where((t) => t.isCompleted).length;
      final recDone = recoveryTasks.where((t) => t.isCompleted).length;

      await HomeWidget.saveWidgetData<int>('task_completed', completed);
      await HomeWidget.saveWidgetData<int>('task_total', total);
      await HomeWidget.saveWidgetData<int>('peak1_done', p1Done);
      await HomeWidget.saveWidgetData<int>('peak1_total', peak1Tasks.length);
      await HomeWidget.saveWidgetData<int>('peak2_done', p2Done);
      await HomeWidget.saveWidgetData<int>('peak2_total', peak2Tasks.length);
      await HomeWidget.saveWidgetData<int>('recovery_done', recDone);
      await HomeWidget.saveWidgetData<int>('recovery_total', recoveryTasks.length);

      await HomeWidget.updateWidget(
        name: 'TaskPulseWidgetProvider',
        androidName: 'TaskPulseWidgetProvider',
        qualifiedAndroidName: 'com.kairo.app.widgets.TaskPulseWidgetProvider',
      );
    } catch (e) {
      debugPrint('Error syncing TaskPulse: $e');
    }
  }

  /// Streak Flame Widget Data
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

  /// Energy Arc Widget Data
  static Future<void> syncEnergyArcData() async {
    try {
      final tasks = await isar.tasks.where().findAll();

      final peak1Tasks = tasks.where((t) => t.energySlot == EnergySlot.peak1).toList();
      final peak2Tasks = tasks.where((t) => t.energySlot == EnergySlot.peak2).toList();
      final recoveryTasks = tasks.where((t) => t.energySlot == EnergySlot.recovery).toList();

      final p1Pct = peak1Tasks.isNotEmpty
          ? (peak1Tasks.where((t) => t.isCompleted).length / peak1Tasks.length * 100).round()
          : 0;
      final p2Pct = peak2Tasks.isNotEmpty
          ? (peak2Tasks.where((t) => t.isCompleted).length / peak2Tasks.length * 100).round()
          : 0;
      final recPct = recoveryTasks.isNotEmpty
          ? (recoveryTasks.where((t) => t.isCompleted).length / recoveryTasks.length * 100).round()
          : 0;

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

  /// Quote Prism Widget Data
  static Future<void> syncQuotePrismData() async {
    try {
      final shlokas = await isar.gitaShlokas.where().findAll();
      GitaShloka quote;
      if (shlokas.isNotEmpty) {
        // Daily quote based on day of year
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

  /// Daily 24H Audit Widget Data
  static Future<void> syncDailyAuditData() async {
    try {
      const double sleepHours = 7.5;
      const double peakWorkHours = 4.0;
      const double classHours = 0.0;
      const double freeHours = 12.5;

      await HomeWidget.saveWidgetData<String>('audit_sleep', '${sleepHours}h');
      await HomeWidget.saveWidgetData<String>('audit_class', '${classHours}h');
      await HomeWidget.saveWidgetData<String>('audit_work', '${peakWorkHours}h');
      await HomeWidget.saveWidgetData<String>('audit_free', '${freeHours}h');

      await HomeWidget.updateWidget(
        name: 'DailyAuditWidgetProvider',
        androidName: 'DailyAuditWidgetProvider',
        qualifiedAndroidName: 'com.kairo.app.widgets.DailyAuditWidgetProvider',
      );
    } catch (e) {
      debugPrint('Error syncing DailyAudit: $e');
    }
  }
}
