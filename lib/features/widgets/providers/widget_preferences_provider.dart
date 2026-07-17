import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persisted preferences for the widget page.
class WidgetPreferences {
  final int clockThemeIndex;
  final bool is24Hour;
  final bool showSeconds;
  final Set<String> visibleWidgets;

  const WidgetPreferences({
    this.clockThemeIndex = 0,
    this.is24Hour = false,
    this.showSeconds = true,
    this.visibleWidgets = const {
      'streak_flame',
      'energy_arc',
      'task_pulse',
      'weekly_heatmap',
      'liar_detector',
      'quote_prism',
    },
  });

  WidgetPreferences copyWith({
    int? clockThemeIndex,
    bool? is24Hour,
    bool? showSeconds,
    Set<String>? visibleWidgets,
  }) {
    return WidgetPreferences(
      clockThemeIndex: clockThemeIndex ?? this.clockThemeIndex,
      is24Hour: is24Hour ?? this.is24Hour,
      showSeconds: showSeconds ?? this.showSeconds,
      visibleWidgets: visibleWidgets ?? this.visibleWidgets,
    );
  }
}

class WidgetPreferencesNotifier extends StateNotifier<WidgetPreferences> {
  WidgetPreferencesNotifier() : super(const WidgetPreferences()) {
    _load();
  }

  static const _keyThemeIndex = 'kairo_widget_clock_theme';
  static const _keyIs24Hour = 'kairo_widget_24h';
  static const _keyShowSeconds = 'kairo_widget_show_seconds';
  static const _keyVisibleWidgets = 'kairo_widget_visible';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = WidgetPreferences(
      clockThemeIndex: prefs.getInt(_keyThemeIndex) ?? 0,
      is24Hour: prefs.getBool(_keyIs24Hour) ?? false,
      showSeconds: prefs.getBool(_keyShowSeconds) ?? true,
      visibleWidgets: (prefs.getStringList(_keyVisibleWidgets) ?? [
        'streak_flame',
        'energy_arc',
        'task_pulse',
        'weekly_heatmap',
        'liar_detector',
        'quote_prism',
      ]).toSet(),
    );
  }

  Future<void> setThemeIndex(int index) async {
    state = state.copyWith(clockThemeIndex: index);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyThemeIndex, index);
  }

  Future<void> toggle24Hour() async {
    state = state.copyWith(is24Hour: !state.is24Hour);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIs24Hour, state.is24Hour);
  }

  Future<void> toggleSeconds() async {
    state = state.copyWith(showSeconds: !state.showSeconds);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyShowSeconds, state.showSeconds);
  }

  Future<void> toggleWidget(String key) async {
    final updated = Set<String>.from(state.visibleWidgets);
    if (updated.contains(key)) {
      updated.remove(key);
    } else {
      updated.add(key);
    }
    state = state.copyWith(visibleWidgets: updated);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keyVisibleWidgets, updated.toList());
  }
}

final widgetPreferencesProvider =
    StateNotifierProvider<WidgetPreferencesNotifier, WidgetPreferences>((ref) {
  return WidgetPreferencesNotifier();
});
