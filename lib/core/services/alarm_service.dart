import 'dart:io';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/foundation.dart';

class AlarmService {
  static final AlarmService _instance = AlarmService._internal();
  factory AlarmService() => _instance;
  AlarmService._internal();

  /// Fires an Android Intent to set an alarm in the native Clock app.
  /// This bypasses Do Not Disturb and cannot be swiped away like a push notification.
  Future<bool> setAlarm({
    required int hour,
    required int minute,
    required String label,
    List<int>? days, // ISO days: 1=Mon, 7=Sun
    bool skipUi = false,
  }) async {
    if (!Platform.isAndroid) {
      debugPrint("Native Alarm Intents are only supported on Android.");
      return false;
    }
    try {
      final arguments = <String, dynamic>{
        'android.intent.extra.alarm.HOUR': hour,
        'android.intent.extra.alarm.MINUTES': minute,
        'android.intent.extra.alarm.MESSAGE': label,
        'android.intent.extra.alarm.SKIP_UI': skipUi,
      };

      if (days != null && days.isNotEmpty) {
        // In Android AlarmClock, EXTRA_DAYS expects Calendar days: SUNDAY=1, MONDAY=2...SATURDAY=7.
        final androidDays = days.map((d) => d == 7 ? 1 : d + 1).toList();
        arguments['android.intent.extra.alarm.DAYS'] = androidDays;
      }

      final intent = AndroidIntent(
        action: 'android.intent.action.SET_ALARM',
        arguments: arguments,
        flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
      );
      await intent.launch();
      debugPrint("Fired SET_ALARM intent for $hour:$minute ($label)");
      return true;
    } catch (e) {
      debugPrint("Failed to set native alarm: $e");
      return false;
    }
  }

  /// Sets the daily recurring 06:00 Morning Enforcer alarm.
  Future<bool> setMorningAlarm({int hour = 6, int minute = 0}) async {
    return await setAlarm(
      hour: hour,
      minute: minute,
      label: "⏰ K.A.I.R.O: MORNING ENFORCER",
      days: [1, 2, 3, 4, 5, 6, 7],
      skipUi: false,
    );
  }

  /// Sets the daily recurring 18:00 Evening Interrogation alarm.
  Future<bool> setEveningAlarm({int hour = 18, int minute = 0}) async {
    return await setAlarm(
      hour: hour,
      minute: minute,
      label: "⏰ K.A.I.R.O: EVENING INTERROGATION",
      days: [1, 2, 3, 4, 5, 6, 7],
      skipUi: false,
    );
  }

  /// Opens the native system Clock app so the user can verify or manage their alarms.
  Future<void> openClockApp() async {
    if (!Platform.isAndroid) return;
    try {
      const intent = AndroidIntent(
        action: 'android.intent.action.SHOW_ALARMS',
        flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
      );
      await intent.launch();
    } catch (e) {
      debugPrint("Failed to open Clock app: $e");
    }
  }
}
