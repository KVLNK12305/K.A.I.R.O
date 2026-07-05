import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:shared_preferences/shared_preferences.dart';
import 'google_api_service.dart';

class UrgentOverride {
  final String title;
  final double hours;
  final String date;

  UrgentOverride({
    required this.title,
    required this.hours,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'hours': hours,
        'date': date,
      };

  factory UrgentOverride.fromJson(Map<String, dynamic> json) => UrgentOverride(
        title: json['title'] as String? ?? 'Urgent Task',
        hours: (json['hours'] as num?)?.toDouble() ?? 1.0,
        date: json['date'] as String? ?? '',
      );
}

class TimeAuditResult {
  final double totalHours = 168.0;
  final double sleepHours;
  final double calendarHours;
  final double urgentHours;
  final double peakWorkHours;
  final double freeHours;
  final String brutalAssessment;
  final List<UrgentOverride> urgentOverrides;

  TimeAuditResult({
    required this.sleepHours,
    required this.calendarHours,
    required this.urgentHours,
    required this.peakWorkHours,
    required this.freeHours,
    required this.brutalAssessment,
    required this.urgentOverrides,
  });
}

class TimeAuditService {
  static final TimeAuditService _instance = TimeAuditService._internal();
  factory TimeAuditService() => _instance;
  TimeAuditService._internal();

  static const String _keySleepHours = 'kairo_sleep_hours_per_night';
  static const String _keyUrgentOverrides = 'kairo_urgent_overrides';
  static const String _keyUrgentWeekStart = 'kairo_urgent_week_start';

  Future<double> getSleepBaseline() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_keySleepHours) ?? 7.0; // default 7h/night
  }

  Future<void> setSleepBaseline(double hoursPerNight) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keySleepHours, hoursPerNight);
  }

  Future<void> _autoResetIfNewWeek(SharedPreferences prefs) async {
    final storedWeekStart = prefs.getString(_keyUrgentWeekStart);
    final currentWeekStart = GoogleApiService.getStartOfCurrentWeek().toIso8601String().substring(0, 10);

    if (storedWeekStart != currentWeekStart) {
      await prefs.setStringList(_keyUrgentOverrides, []);
      await prefs.setString(_keyUrgentWeekStart, currentWeekStart);
      debugPrint("Weekly audit reset for week starting $currentWeekStart");
    }
  }

  Future<List<UrgentOverride>> getUrgentOverrides() async {
    final prefs = await SharedPreferences.getInstance();
    await _autoResetIfNewWeek(prefs);
    final list = prefs.getStringList(_keyUrgentOverrides) ?? [];
    return list.map((item) {
      try {
        return UrgentOverride.fromJson(jsonDecode(item) as Map<String, dynamic>);
      } catch (e) {
        return UrgentOverride(title: 'Urgent Task', hours: 1.0, date: '');
      }
    }).toList();
  }

  Future<void> addUrgentOverride(String title, double hours) async {
    final prefs = await SharedPreferences.getInstance();
    await _autoResetIfNewWeek(prefs);
    final list = prefs.getStringList(_keyUrgentOverrides) ?? [];
    
    final override = UrgentOverride(
      title: title,
      hours: hours,
      date: DateTime.now().toIso8601String().substring(0, 10),
    );
    list.add(jsonEncode(override.toJson()));
    await prefs.setStringList(_keyUrgentOverrides, list);
    debugPrint("Added urgent override: $title ($hours h)");
  }

  Future<TimeAuditResult> calculateWeeklyAudit(List<calendar.Event> weeklyEvents) async {
    final prefs = await SharedPreferences.getInstance();
    await _autoResetIfNewWeek(prefs);

    final sleepPerNight = prefs.getDouble(_keySleepHours) ?? 7.0;
    final sleepHours = sleepPerNight * 7.0;

    double calendarHours = 0.0;
    double peakWorkHours = 0.0;

    for (final event in weeklyEvents) {
      // Exclude all-day events (no dateTime)
      if (event.start?.dateTime == null || event.end?.dateTime == null) {
        continue;
      }

      final start = event.start!.dateTime!.toLocal();
      final end = event.end!.dateTime!.toLocal();
      final durationHours = end.difference(start).inMinutes / 60.0;
      if (durationHours <= 0) continue;

      final title = event.summary ?? '';
      
      // Check if this is a K.A.I.R.O ritual or Peak block
      final isKairoEvent = title.startsWith('🔥') ||
          title.startsWith('⚡') ||
          title.startsWith('🧘') ||
          title.startsWith('🔪') ||
          title.startsWith('K.A.I.R.O') ||
          title.contains('PEAK 1:') ||
          title.contains('PEAK 2:');

      if (isKairoEvent) {
        peakWorkHours += durationHours;
      } else {
        calendarHours += durationHours;
      }
    }

    final urgentList = await getUrgentOverrides();
    double urgentHours = 0.0;
    for (final u in urgentList) {
      urgentHours += u.hours;
    }

    // Default estimate if user hasn't synced rituals to calendar yet: assume at least 3.5h/day of peak work for 5 days = 17.5h
    if (peakWorkHours == 0.0 && weeklyEvents.isNotEmpty) {
      peakWorkHours = 17.5;
    }

    double freeHours = 168.0 - (sleepHours + calendarHours + urgentHours + peakWorkHours);
    if (freeHours < 0) freeHours = 0.0;

    String assessment;
    if (freeHours > 50) {
      assessment = "${freeHours.toStringAsFixed(1)} hours unallocated. Abundant bandwidth. Zero excuses for non-execution.";
    } else if (freeHours >= 30) {
      assessment = "${freeHours.toStringAsFixed(1)} hours free. Moderate bandwidth. Prioritize execution ruthlessly.";
    } else if (freeHours >= 15) {
      assessment = "WARNING: Only ${freeHours.toStringAsFixed(1)} hours free. Severe bandwidth compression. Cut non-essential admin.";
    } else {
      assessment = "CRITICAL: ${freeHours.toStringAsFixed(1)} hours remaining. You are in survival mode. Cancel everything non-essential NOW.";
    }

    return TimeAuditResult(
      sleepHours: sleepHours,
      calendarHours: calendarHours,
      urgentHours: urgentHours,
      peakWorkHours: peakWorkHours,
      freeHours: freeHours,
      brutalAssessment: assessment,
      urgentOverrides: urgentList,
    );
  }
}
