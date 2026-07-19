import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persisted preferences for the widget page.
class WidgetPreferences {
  final Set<String> visibleWidgets;

  const WidgetPreferences({
    this.visibleWidgets = const {
      'streak_flame',
      'energy_arc',
      'task_pulse',
      'weekly_heatmap',
      'liar_detector',
      'quote_prism',
      'decision_journal',
      'discipline_heatmap',
    },
  });

  WidgetPreferences copyWith({
    Set<String>? visibleWidgets,
  }) {
    return WidgetPreferences(
      visibleWidgets: visibleWidgets ?? this.visibleWidgets,
    );
  }
}

class WidgetPreferencesNotifier extends StateNotifier<WidgetPreferences> {
  WidgetPreferencesNotifier() : super(const WidgetPreferences()) {
    _load();
  }

  static const _keyVisibleWidgets = 'kairo_widget_visible';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = WidgetPreferences(
      visibleWidgets: (prefs.getStringList(_keyVisibleWidgets) ?? [
        'streak_flame',
        'energy_arc',
        'task_pulse',
        'weekly_heatmap',
        'liar_detector',
        'quote_prism',
        'decision_journal',
        'discipline_heatmap',
      ]).toSet(),
    );
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
