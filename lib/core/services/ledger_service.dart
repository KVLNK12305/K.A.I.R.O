import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'google_api_service.dart';
import 'wellbeing_service.dart';
import '../models/focus_session.dart';
import '../../main.dart';

class LedgerBreakdown {
  final double totalHours = 168.0;
  final double sleepHours;          // Inferred / Estimated
  final double maintenanceHours;    // Biological buffer (food, hygiene, transit)
  final double calendarHours;       // Observed from Google Calendar
  final double observedFocusHours;  // Observed from Focus Engine
  final double screenTimeHours;     // Observed from Android UsageStats
  final double unobservedHours;     // The true remaining bandwidth

  const LedgerBreakdown({
    required this.sleepHours,
    required this.maintenanceHours,
    required this.calendarHours,
    required this.observedFocusHours,
    required this.screenTimeHours,
    required this.unobservedHours,
  });

  double get allocatedHours =>
      sleepHours + maintenanceHours + calendarHours + observedFocusHours;

  double get capacityPercent =>
      ((allocatedHours / totalHours) * 100).clamp(0, 100);
}

class LedgerService {
  final Isar isar;
  LedgerService(this.isar);

  Future<LedgerBreakdown> calculateWeeklyBreakdown() async {
    const double sleepHours = 7.5 * 7;      // 52.5 hours baseline
    const double maintenanceHours = 2.0 * 7; // 14.0 hours baseline (meals, transit, hygiene)

    // 1. Fetch Calendar commitments
    double calendarHours = 0.0;
    try {
      final googleApi = GoogleApiService();
      if (googleApi.currentUser != null) {
        final events = await googleApi.fetchWeeklyEvents();
        for (final event in events) {
          if (event.start?.dateTime != null && event.end?.dateTime != null) {
            final start = event.start!.dateTime!.toLocal();
            final end = event.end!.dateTime!.toLocal();
            final duration = end.difference(start).inMinutes / 60.0;
            if (duration > 0) calendarHours += duration;
          }
        }
      }
    } catch (_) {
      // Offline fallback
    }

    // 2. Fetch observed Focus sessions for the current week
    final now = DateTime.now();
    final weekStart = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: now.weekday - 1));
    
    double focusHours = 0.0;
    try {
      final sessions = await isar.focusSessions
          .filter()
          .startTimeGreaterThan(weekStart)
          .findAll();
      for (final s in sessions) {
        focusHours += s.actualDurationMinutes / 60.0;
      }
    } catch (_) {}

    // 3. Fetch Screen Time
    double screenHours = 0.0;
    try {
      final hasPerm = await WellbeingService.checkUsagePermission();
      if (hasPerm) {
        screenHours = await WellbeingService.getDailyScreenTime();
      }
    } catch (_) {}

    final allocated = sleepHours + maintenanceHours + calendarHours + focusHours;
    final unobserved = (168.0 - allocated).clamp(0.0, 168.0);

    return LedgerBreakdown(
      sleepHours: sleepHours,
      maintenanceHours: maintenanceHours,
      calendarHours: calendarHours,
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
