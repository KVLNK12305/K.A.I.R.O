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

class CustomRecurringBlock {
  final String id;
  final String title;
  final double hoursPerWeek;
  final String category; // e.g. 'Classes / Lectures', 'Physical / Training', 'Commute', 'Admin / Chores', 'Other'
  final int colorHex;

  CustomRecurringBlock({
    required this.id,
    required this.title,
    required this.hoursPerWeek,
    required this.category,
    this.colorHex = 0xFF8E24AA,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'hoursPerWeek': hoursPerWeek,
        'category': category,
        'colorHex': colorHex,
      };

  factory CustomRecurringBlock.fromJson(Map<String, dynamic> json) => CustomRecurringBlock(
        id: json['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
        title: json['title'] as String? ?? 'Commitment',
        hoursPerWeek: (json['hoursPerWeek'] as num?)?.toDouble() ?? 5.0,
        category: json['category'] as String? ?? 'Classes / Lectures',
        colorHex: (json['colorHex'] as num?)?.toInt() ?? 0xFF8E24AA,
      );
}

class TimeAuditResult {
  final double totalHours = 168.0;
  final double sleepHours;
  final double calendarHours;
  final double urgentHours;
  final double peakWorkHours;
  final double customRecurringHours;
  final double freeHours;
  final String brutalAssessment;
  final List<UrgentOverride> urgentOverrides;
  final List<CustomRecurringBlock> customRecurringBlocks;

  TimeAuditResult({
    required this.sleepHours,
    required this.calendarHours,
    required this.urgentHours,
    required this.peakWorkHours,
    required this.customRecurringHours,
    required this.freeHours,
    required this.brutalAssessment,
    required this.urgentOverrides,
    required this.customRecurringBlocks,
  });
}

class TimeAuditService {
  static final TimeAuditService _instance = TimeAuditService._internal();
  factory TimeAuditService() => _instance;
  TimeAuditService._internal();

  static const String _keySleepHours = 'kairo_sleep_hours_per_night';
  static const String _keyUrgentOverrides = 'kairo_urgent_overrides';
  static const String _keyUrgentWeekStart = 'kairo_urgent_week_start';
  static const String _keyCustomBlocks = 'kairo_custom_recurring_blocks';
  static const String _keyCustomSeeded = 'kairo_custom_recurring_seeded';

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

  Future<List<CustomRecurringBlock>> getCustomRecurringBlocks() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_keyCustomSeeded) != true) {
      final defaults = [
        CustomRecurringBlock(id: 'classes_default', title: 'University Classes & Labs', hoursPerWeek: 15.0, category: 'Classes / Lectures', colorHex: 0xFF8E24AA),
        CustomRecurringBlock(id: 'gym_default', title: 'Physical Training / Gym', hoursPerWeek: 6.0, category: 'Physical / Training', colorHex: 0xFF00ACC1),
        CustomRecurringBlock(id: 'commute_default', title: 'Commute & Transit', hoursPerWeek: 5.0, category: 'Commute', colorHex: 0xFFFB8C00),
      ];
      await prefs.setStringList(_keyCustomBlocks, defaults.map((b) => jsonEncode(b.toJson())).toList());
      await prefs.setBool(_keyCustomSeeded, true);
      return defaults;
    }

    final list = prefs.getStringList(_keyCustomBlocks) ?? [];
    return list.map((item) {
      try {
        return CustomRecurringBlock.fromJson(jsonDecode(item) as Map<String, dynamic>);
      } catch (e) {
        return CustomRecurringBlock(id: 'err', title: 'Commitment', hoursPerWeek: 2.0, category: 'Other');
      }
    }).toList();
  }

  Future<void> addCustomRecurringBlock(String title, double hoursPerWeek, String category, int colorHex) async {
    final blocks = await getCustomRecurringBlocks();
    blocks.add(CustomRecurringBlock(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      hoursPerWeek: hoursPerWeek,
      category: category,
      colorHex: colorHex,
    ));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keyCustomBlocks, blocks.map((b) => jsonEncode(b.toJson())).toList());
  }

  Future<void> updateCustomRecurringBlock(String id, String title, double hoursPerWeek, String category, int colorHex) async {
    final blocks = await getCustomRecurringBlocks();
    final index = blocks.indexWhere((b) => b.id == id);
    if (index != -1) {
      blocks[index] = CustomRecurringBlock(
        id: id,
        title: title,
        hoursPerWeek: hoursPerWeek,
        category: category,
        colorHex: colorHex,
      );
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_keyCustomBlocks, blocks.map((b) => jsonEncode(b.toJson())).toList());
    }
  }

  Future<void> deleteCustomRecurringBlock(String id) async {
    final blocks = await getCustomRecurringBlocks();
    blocks.removeWhere((b) => b.id == id);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keyCustomBlocks, blocks.map((b) => jsonEncode(b.toJson())).toList());
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

    final customList = await getCustomRecurringBlocks();
    double customHours = 0.0;
    for (final c in customList) {
      customHours += c.hoursPerWeek;
    }

    // Default estimate if user hasn't synced rituals to calendar yet: assume at least 3.5h/day of peak work for 5 days = 17.5h
    if (peakWorkHours == 0.0 && weeklyEvents.isNotEmpty) {
      peakWorkHours = 17.5;
    }

    double freeHours = 168.0 - (sleepHours + calendarHours + urgentHours + peakWorkHours + customHours);
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
      customRecurringHours: customHours,
      freeHours: freeHours,
      brutalAssessment: assessment,
      urgentOverrides: urgentList,
      customRecurringBlocks: customList,
    );
  }
}
