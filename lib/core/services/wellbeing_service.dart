import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class WellbeingService {
  static const MethodChannel _channel = MethodChannel('com.kairo.app/wellbeing');

  /// Checks if the app has permission to modify Do Not Disturb / Notification Policy.
  static Future<bool> checkDndPermission() async {
    try {
      final bool granted = await _channel.invokeMethod('checkDndPermission') ?? false;
      return granted;
    } catch (e) {
      debugPrint('Error checking DND permission: $e');
      return false;
    }
  }

  /// Opens the Android settings for the user to grant DND access if not already granted.
  /// Returns true if the settings page was opened.
  static Future<bool> requestDndPermission() async {
    try {
      final bool opened = await _channel.invokeMethod('requestDndPermission') ?? false;
      return opened;
    } catch (e) {
      debugPrint('Error requesting DND permission: $e');
      return false;
    }
  }

  /// Enables or disables Focus Mode (Priority Only Do Not Disturb).
  /// Requires DND permission to be granted first.
  static Future<void> setFocusMode(bool enabled) async {
    try {
      await _channel.invokeMethod('setFocusMode', {'enabled': enabled});
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint('Cannot set Focus Mode: Notification Policy Access denied. Requesting permission...');
        await requestDndPermission();
      } else {
        debugPrint('Error setting Focus Mode: $e');
      }
    } catch (e) {
      debugPrint('Unknown error setting Focus Mode: $e');
    }
  }

  /// Checks if the app has permission to access Usage Stats (Screen Time).
  static Future<bool> checkUsagePermission() async {
    try {
      final bool granted = await _channel.invokeMethod('checkUsagePermission') ?? false;
      return granted;
    } catch (e) {
      debugPrint('Error checking usage permission: $e');
      return false;
    }
  }

  /// Opens the Android settings for the user to grant Usage Access if not already granted.
  static Future<bool> requestUsagePermission() async {
    try {
      final bool opened = await _channel.invokeMethod('requestUsagePermission') ?? false;
      return opened;
    } catch (e) {
      debugPrint('Error requesting usage permission: $e');
      return false;
    }
  }

  /// Fetches the total daily screen time in hours for today.
  static Future<double> getDailyScreenTime() async {
    try {
      final double hours = await _channel.invokeMethod('getDailyScreenTime') ?? 0.0;
      return hours;
    } catch (e) {
      debugPrint('Error fetching screen time: $e');
      return 0.0;
    }
  }
}
