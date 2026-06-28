import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

/// Provides and persists the daily objective text.
final objectiveProvider =
    AsyncNotifierProvider<ObjectiveNotifier, String>(() {
  return ObjectiveNotifier();
});

class ObjectiveNotifier extends AsyncNotifier<String> {
  Timer? _debounce;

  static String _todayKey() {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return 'kairo_objective_$today';
  }

  @override
  FutureOr<String> build() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_todayKey()) ?? '';
  }

  void updateObjective(String content) {
    state = AsyncValue.data(content);

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_todayKey(), content);
    });
  }
}
