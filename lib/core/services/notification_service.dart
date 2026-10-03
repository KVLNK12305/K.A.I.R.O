import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:isar/isar.dart';
import '../models/task.dart';
import '../models/decision_log.dart';
import '../models/psychosomatic_scan.dart';
import '../models/liar_goal.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    tz.initializeTimeZones();
    try {
      final String timeZoneName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    } catch (e) {
      debugPrint("Could not set local timezone: $e. Falling back to UTC.");
      tz.setLocalLocation(tz.UTC);
    }

    if (Platform.isAndroid) {
      final status = await Permission.notification.status;
      if (status.isDenied) {
        await Permission.notification.request();
      }
      final androidPlugin = _notifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      await androidPlugin?.requestNotificationsPermission();
      await androidPlugin?.requestExactAlarmsPermission();
    }

    const androidSettings = AndroidInitializationSettings('@drawable/ic_notification');
    const initSettings = InitializationSettings(android: androidSettings);

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        debugPrint("Notification tapped: ${response.payload}");
      },
    );

    _initialized = true;
    debugPrint("NotificationService initialized successfully.");
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future<void> scheduleDailyNotifications() async {
    // Kept for initial boot fallback
    final slots = [
      {'id': 1, 'hour': 7, 'min': 0, 'title': 'K.A.I.R.O — 🌅 Daily Anchor', 'body': 'What is your single non-negotiable objective today?'},
      {'id': 2, 'hour': 13, 'min': 30, 'title': 'K.A.I.R.O — ⚡ Cognitive Checkpoint', 'body': 'Check your energy reserve before taking on unplanned commitments.'},
      {'id': 3, 'hour': 18, 'min': 30, 'title': 'K.A.I.R.O — 🧘 Evening Reflection', 'body': 'Close today\'s open loops and log your reality review.'},
    ];
    await _scheduleSlots(slots);
  }

  /// Evaluates user's live database state and generates customized, non-generic reminders.
  /// Cancels previously scheduled static slots before rescheduling to prevent ghost notifications.
  Future<void> scheduleContextualNotifications(Isar isar) async {
    if (!_initialized) await init();

    // Cancel stale daily static notifications (IDs 1-3) so they don't ghost alongside contextual ones
    for (final id in [1, 2, 3]) {
      await _notifications.cancel(id);
    }

    final now = DateTime.now();
    final List<Map<String, dynamic>> customizedSlots = [];

    // 1. Check for Pending Overdue Decision Logs
    try {
      final overdueDecisions = await isar.decisionLogs
          .where()
          .filter()
          .verdictEqualTo('Pending')
          .and()
          .reviewDateLessThan(now)
          .findAll();

      if (overdueDecisions.isNotEmpty) {
        final d = overdueDecisions.first;
        customizedSlots.add({
          'id': 10,
          'hour': 12,
          'min': 30,
          'title': 'K.A.I.R.O — 🎯 Decision Retrospective',
          'body': 'Outcome due: Did your prediction for "${d.title}" match reality?',
        });
      }
    } catch (e) {
      debugPrint("Notice: Contextual decision query failed: $e");
    }

    // 2. Check for Incomplete Peak Tasks today
    try {
      final tasks = await isar.tasks
          .where()
          .filter()
          .isCompletedEqualTo(false)
          .and()
          .energySlotEqualTo(EnergySlot.peak1)
          .findAll();

      if (tasks.isNotEmpty) {
        final peakTask = tasks.first;
        customizedSlots.add({
          'id': 11,
          'hour': 14,
          'min': 45,
          'title': 'K.A.I.R.O — ⚡ Peak 1 Momentum',
          'body': 'Circadian drop ahead: Priority "${peakTask.title}" is still unfinished.',
        });
      }
    } catch (e) {
      debugPrint("Notice: Contextual task query failed: $e");
    }

    // 3. Check Psychosomatic Nervous System Load
    try {
      final scans = await isar.psychosomaticScans
          .where()
          .sortByDateDesc()
          .limit(1)
          .findAll();

      if (scans.isNotEmpty && scans.first.stressScore >= 60.0) {
        final stress = scans.first.stressScore.toInt();
        customizedSlots.add({
          'id': 12,
          'hour': 16,
          'min': 30,
          'title': 'K.A.I.R.O — 🧘 Tactical Decompression',
          'body': 'Nervous system load is high ($stress%). Take a 10m pause to restore cognitive reserve.',
        });
      }
    } catch (e) {
      debugPrint("Notice: Contextual scan query failed: $e");
    }

    // 4. Check for Active Liar Goals
    try {
      final activeLiarGoals = await isar.liarGoals
          .where()
          .filter()
          .liarsChartActiveEqualTo(true)
          .findAll();

      if (activeLiarGoals.isNotEmpty) {
        final goal = activeLiarGoals.first;
        customizedSlots.add({
          'id': 13,
          'hour': 20,
          'min': 15,
          'title': 'K.A.I.R.O — 👁️ Self-Honesty Checkpoint',
          'body': 'Anti-delusion check: Have you compromised on "${goal.title}" today?',
        });
      }
    } catch (e) {
      debugPrint("Notice: Contextual liar goal query failed: $e");
    }

    // Fallback baseline slots if specific conditions aren't active
    if (customizedSlots.isEmpty) {
      await scheduleDailyNotifications();
      return;
    }

    // Schedule the contextual slots
    await _scheduleSlots(customizedSlots);
    debugPrint("Scheduled ${customizedSlots.length} situational contextual notifications tailored to user state.");
  }

  Future<void> _scheduleSlots(List<Map<String, dynamic>> slots) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'kairo_discipline_engine_v2',
        'K.A.I.R.O Intelligence Engine',
        channelDescription: 'Situational habit and executive decision reminders',
        importance: Importance.max,
        priority: Priority.high,
        icon: '@drawable/ic_notification',
        largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
        color: Color(0xFF1CB0F6),
      ),
    );

    for (final slot in slots) {
      try {
        await _notifications.zonedSchedule(
          slot['id'] as int,
          slot['title'] as String,
          slot['body'] as String,
          _nextInstanceOfTime(slot['hour'] as int, slot['min'] as int),
          details,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time,
        );
      } catch (e) {
        await _notifications.zonedSchedule(
          slot['id'] as int,
          slot['title'] as String,
          slot['body'] as String,
          _nextInstanceOfTime(slot['hour'] as int, slot['min'] as int),
          details,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time,
        );
      }
    }
  }

  Future<void> show21DayStreakNotification(int currentDay) async {
    if (!_initialized) await init();
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'kairo_streak_tracker_v2',
        '21-Day Habit Streak',
        channelDescription: 'Updates on your 21-day neurobiological rewiring streak',
        importance: Importance.max,
        priority: Priority.high,
        icon: '@drawable/ic_notification',
        largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
        color: Color(0xFFE53935),
      ),
    );

    await _notifications.show(
      100,
      "K.A.I.R.O — 🔥 Day $currentDay/21 • Habit Streak Active",
      currentDay < 21
          ? "You are rewiring your nervous system. Do not break the chain tomorrow."
          : "🏆 21 Days Complete! Your discipline is now cybernetic instinct.",
      details,
    );
  }

  Future<void> showInstantNotification(String title, String body, {int? id}) async {
    // Use time-based hash if no explicit ID provided to prevent silent overwrites on rapid calls
    id ??= DateTime.now().millisecondsSinceEpoch % 100000;
    if (!_initialized) await init();
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'kairo_instant_v2',
        'System Alerts',
        channelDescription: 'Instant system alerts and notifications',
        importance: Importance.max,
        priority: Priority.high,
        icon: '@drawable/ic_notification',
        largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
      ),
    );
    final formattedTitle = title.startsWith('K.A.I.R.O') ? title : 'K.A.I.R.O — $title';
    await _notifications.show(id, formattedTitle, body, details);
  }

  Future<void> showAdaptiveAlarmRecommendation(String reason) async {
    if (!_initialized) await init();
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'kairo_adaptive_alarms_v2',
        'Adaptive Alarm Recommendations',
        channelDescription: 'Dynamic alarm suggestions based on Google Calendar schedule',
        importance: Importance.max,
        priority: Priority.high,
        icon: '@drawable/ic_notification',
        largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
        color: Color(0xFFFFA000),
      ),
    );
    await _notifications.show(
      200,
      "K.A.I.R.O — ⚡ Adaptive Alarm Adjustment",
      reason,
      details,
    );
  }

  Future<void> showAccountabilityNukeAlert({
    required String goalTitle,
    required String reason,
    String? contactEmail,
  }) async {
    if (!_initialized) await init();
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'kairo_accountability_nuke',
        'Accountability Nuke Alerts',
        channelDescription: 'Automated accountability alerts when Liar goals or Crucibles fail',
        importance: Importance.max,
        priority: Priority.high,
        icon: '@drawable/ic_notification',
        largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
        color: Color(0xFFFF0000),
      ),
    );
    final contactStr = contactEmail != null && contactEmail.isNotEmpty ? ' Alerted: $contactEmail.' : '';
    await _notifications.show(
      300,
      "K.A.I.R.O — 🚨 ACCOUNTABILITY NUKE TRIGGERED",
      'Goal "$goalTitle" breached ($reason).$contactStr Protocol activated.',
      details,
    );
  }

  Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }
}
