import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'google_api_service.dart';
import 'wellbeing_service.dart';
import '../models/focus_session.dart';
import '../models/sleep_log.dart';
import 'time_audit_service.dart';
import '../../main.dart';

class LedgerBreakdown {
  final double totalHours = 168.0;
  final double sleepHours;          // Logged nights averaged, else the user's baseline, × 7
  final bool sleepIsObserved;       // True when at least one SleepLog exists this week
  final double maintenanceHours;    // Biological buffer (food, hygiene)
  final double calendarHours;       // Google Calendar, excluding K.A.I.R.O. ritual/peak blocks
  final double recurringHours;      // User-defined recurring blocks (classes, gym, commute…)
  final double urgentHours;         // This week's urgent overrides
  final double observedFocusHours;  // Observed from Focus Engine sessions
  final double screenTimeHours;     // Android UsageStats since Monday (overlaps other buckets)
  final double unobservedHours;     // The true remaining bandwidth

  const LedgerBreakdown({
    required this.sleepHours,
    this.sleepIsObserved = false,
    required this.maintenanceHours,
    required this.calendarHours,
    this.recurringHours = 0.0,
    this.urgentHours = 0.0,
    required this.observedFocusHours,
    required this.screenTimeHours,
    required this.unobservedHours,
  });

  /// Recurring blocks + urgent overrides: committed time that isn't on the calendar.
  double get commitmentHours => recurringHours + urgentHours;

  double get allocatedHours =>
      sleepHours + maintenanceHours + calendarHours + commitmentHours + observedFocusHours;

  double get capacityPercent =>
      ((allocatedHours / totalHours) * 100).clamp(0, 100);
}

/// Single source of truth for the weekly 168-hour budget. The TIME tab, the AI
/// context (via [TimeAuditService.calculateWeeklyAudit]) and exports all read from here.
class LedgerService {
  final Isar isar;
  LedgerService(this.isar);

  static const double maintenanceHoursPerDay = 2.0; // meals, hygiene

  /// Calendar blocks K.A.I.R.O. itself schedules for peaks/rituals. They are excluded
  /// from calendar hours because the actual work is counted via focus sessions.
  static bool isKairoEvent(String title) {
    return title.startsWith('🔥') ||
        title.startsWith('⚡') ||
        title.startsWith('🧘') ||
        title.startsWith('🔪') ||
        title.startsWith('K.A.I.R.O') ||
        title.contains('PEAK 1:') ||
        title.contains('PEAK 2:');
  }

  Future<LedgerBreakdown> calculateWeeklyBreakdown() async {
    final weekStart = GoogleApiService.getStartOfCurrentWeek();
    final timeAudit = TimeAuditService();

    // 1. Sleep: average of this week's logged nights, falling back to the baseline
    final baseline = await timeAudit.getSleepBaseline();
    final logs = await isar.sleepLogs.filter().dateGreaterThan(weekStart, include: true).findAll();
    final loggedNights = logs.where((l) => l.hoursSlept > 0).toList();
    final sleepPerNight = loggedNights.isEmpty
        ? baseline
        : loggedNights.fold<double>(0, (sum, l) => sum + l.hoursSlept) / loggedNights.length;
    final sleepHours = sleepPerNight * 7;
    const maintenanceHours = maintenanceHoursPerDay * 7;

    // 2. Calendar commitments (excluding K.A.I.R.O.-generated blocks)
    double calendarHours = 0.0;
    try {
      final googleApi = GoogleApiService();
      if (googleApi.currentUser != null) {
        final events = await googleApi.fetchWeeklyEvents();
        for (final event in events) {
          if (event.start?.dateTime == null || event.end?.dateTime == null) continue;
          if (isKairoEvent(event.summary ?? '')) continue;
          final start = event.start!.dateTime!.toLocal();
          final end = event.end!.dateTime!.toLocal();
          final duration = end.difference(start).inMinutes / 60.0;
          if (duration > 0) calendarHours += duration;
        }
      }
    } catch (_) {
      // Offline fallback
    }

    // 3. Recurring blocks and urgent overrides
    final recurring = await timeAudit.getCustomRecurringBlocks();
    final recurringHours = recurring.fold<double>(0, (sum, b) => sum + b.hoursPerWeek);
    final urgent = await timeAudit.getUrgentOverrides();
    final urgentHours = urgent.fold<double>(0, (sum, u) => sum + u.hours);

    // 4. Observed Focus sessions for the current week
    double focusHours = 0.0;
    try {
      final sessions = await isar.focusSessions
          .filter()
          .startTimeGreaterThan(weekStart, include: true)
          .findAll();
      for (final s in sessions) {
        focusHours += s.actualDurationMinutes / 60.0;
      }
    } catch (_) {}

    // 5. Screen time since Monday (informational — overlaps the buckets above)
    double screenHours = 0.0;
    try {
      final hasPerm = await WellbeingService.checkUsagePermission();
      if (hasPerm) {
        screenHours = await WellbeingService.getScreenTimeSince(weekStart);
      }
    } catch (_) {}

    final allocated = sleepHours + maintenanceHours + calendarHours + recurringHours + urgentHours + focusHours;
    final unobserved = (168.0 - allocated).clamp(0.0, 168.0);

    return LedgerBreakdown(
      sleepHours: sleepHours,
      sleepIsObserved: loggedNights.isNotEmpty,
      maintenanceHours: maintenanceHours,
      calendarHours: calendarHours,
      recurringHours: recurringHours,
      urgentHours: urgentHours,
      observedFocusHours: focusHours,
      screenTimeHours: screenHours,
      unobservedHours: unobserved,
    );
  }
}

final ledgerServiceProvider = Provider<LedgerService>((ref) {
  return LedgerService(isar);
});

final weeklyLedgerProvider = FutureProvider<LedgerBreakdown>((ref) async {
  final service = ref.watch(ledgerServiceProvider);
  return await service.calculateWeeklyBreakdown();
});
