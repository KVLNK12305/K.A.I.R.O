import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

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

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
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
    if (!_initialized) await init();

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'kairo_discipline_engine_v2',
        'K.A.I.R.O Discipline Engine',
        channelDescription: 'Unrelenting daily habit and ritual reminders',
        importance: Importance.max,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
        largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
        color: Color(0xFFE53935),
      ),
    );

    final scheduleSlots = [
      {'id': 1, 'hour': 6, 'min': 5, 'title': 'K.A.I.R.O — 🌅 Morning Enforcer', 'body': 'Assign your peak energy before the day steals it.'},
      {'id': 2, 'hour': 9, 'min': 30, 'title': 'K.A.I.R.O — ⚡ Peak 1 Checkpoint', 'body': 'Are you executing on your highest priority or drifting into entropy?'},
      {'id': 3, 'hour': 14, 'min': 0, 'title': 'K.A.I.R.O — 🧘 Recovery Block', 'body': 'Low-stakes admin. Protect your cognitive bandwidth.'},
      {'id': 4, 'hour': 18, 'min': 5, 'title': 'K.A.I.R.O — 🔪 Evening Interrogation', 'body': 'The Brutalist Review awaits. Confront the truth of your day.'},
      {'id': 5, 'hour': 21, 'min': 0, 'title': 'K.A.I.R.O — 🔥 21-Day Streak Checkpoint', 'body': 'Did you conquer today? Log your evening review to protect your streak.'},
    ];

    for (final slot in scheduleSlots) {
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
        debugPrint("Exact schedule failed for ${slot['id']}, falling back to inexact: $e");
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
    debugPrint("Scheduled 5 daily recurring discipline notifications.");
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
        icon: '@mipmap/ic_launcher',
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

  Future<void> showInstantNotification(String title, String body, {int id = 999}) async {
    if (!_initialized) await init();
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'kairo_instant_v2',
        'System Alerts',
        channelDescription: 'Instant system alerts and notifications',
        importance: Importance.max,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
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
        icon: '@mipmap/ic_launcher',
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

  Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }
}
