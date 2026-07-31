import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'home_widget_sync_service.dart';

class StreakService {
  static final StreakService _instance = StreakService._internal();
  factory StreakService() => _instance;
  StreakService._internal();

  static const String _keyStartDate = 'kairo_streak_start_date';
  static const String _keyCompletedDays = 'kairo_streak_completed_days';
  static const String _keyStreakBroken = 'kairo_streak_broken';

  String _todayStr() => DateFormat('yyyy-MM-dd').format(DateTime.now());
  String _yesterdayStr() => DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 1)));

  Future<void> initOrCheckStreak() async {
    final prefs = await SharedPreferences.getInstance();
    final startDate = prefs.getString(_keyStartDate);

    if (startDate == null) {
      // First ever run or reset
      await prefs.setString(_keyStartDate, _todayStr());
      await prefs.setStringList(_keyCompletedDays, []);
      await prefs.setBool(_keyStreakBroken, false);
      HomeWidgetSyncService.syncStreakData();
      return;
    }

    final completedDays = prefs.getStringList(_keyCompletedDays) ?? [];
    final today = _todayStr();
    final yesterday = _yesterdayStr();

    if (startDate != today && !completedDays.contains(yesterday) && !completedDays.contains(today)) {
      // The chain was broken!
      await prefs.setBool(_keyStreakBroken, true);
    }
    HomeWidgetSyncService.syncStreakData();
  }

  Future<bool> isStreakBroken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyStreakBroken) ?? false;
  }

  Future<void> resetStreak() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyStartDate, _todayStr());
    await prefs.setStringList(_keyCompletedDays, []);
    await prefs.setBool(_keyStreakBroken, false);
    HomeWidgetSyncService.syncStreakData();
  }

  Future<int> recordDayComplete() async {
    final prefs = await SharedPreferences.getInstance();
    var completedDays = prefs.getStringList(_keyCompletedDays) ?? [];
    final today = _todayStr();

    if (!completedDays.contains(today)) {
      completedDays.add(today);
      await prefs.setStringList(_keyCompletedDays, completedDays);
    }
    await prefs.setBool(_keyStreakBroken, false);
    HomeWidgetSyncService.syncStreakData();

    return getDayNumberSync(prefs);
  }

  Future<int> getDayNumber() async {
    final prefs = await SharedPreferences.getInstance();
    return getDayNumberSync(prefs);
  }

  int getDayNumberSync(SharedPreferences prefs) {
    final startDateStr = prefs.getString(_keyStartDate) ?? _todayStr();
    try {
      final start = DateTime.parse(startDateStr);
      final now = DateTime.now();
      final diff = DateTime(now.year, now.month, now.day).difference(DateTime(start.year, start.month, start.day)).inDays;
      final day = diff + 1;
      return day > 21 ? 21 : (day < 1 ? 1 : day);
    } catch (e) {
      return 1;
    }
  }

  Future<List<String>> getCompletedDays() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keyCompletedDays) ?? [];
  }
}
