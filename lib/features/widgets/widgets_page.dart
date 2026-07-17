import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'flip_clock/flip_clock_widget.dart';
import 'flip_clock/flip_clock_themes.dart';
import 'cards/streak_flame_widget.dart';
import 'cards/energy_arc_widget.dart';
import 'cards/task_pulse_widget.dart';
import 'cards/weekly_heatmap_widget.dart';
import 'cards/liar_detector_widget.dart';
import 'cards/quote_prism_widget.dart';
import 'providers/widget_preferences_provider.dart';
import '../../core/theme/app_theme.dart';

/// The hero Widgets page featuring the 3D Flip Clock and data-driven widget cards.
class WidgetsPage extends ConsumerStatefulWidget {
  const WidgetsPage({super.key});

  @override
  ConsumerState<WidgetsPage> createState() => _WidgetsPageState();
}

class _WidgetsPageState extends ConsumerState<WidgetsPage> {
  @override
  Widget build(BuildContext context) {
    final prefs = ref.watch(widgetPreferencesProvider);
    final visible = prefs.visibleWidgets;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ═══ HEADER BAR ═══
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF00E676),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'SYSTEM WIDGET DECK',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 10,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.tune_rounded, color: Colors.white70, size: 20),
                      onPressed: () => _showCustomizationSheet(context, ref),
                      tooltip: 'Customize Widgets & Clock',
                    ),
                  ],
                ),
              ),
            ),

            // ═══ HERO 3D FLIP CLOCK ═══
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 12, 20, 24),
                child: FlipClockWidget(),
              ),
            ),

            // ═══ WIDGET CARDS GRID & LIST ═══
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 110), // clearance for bottom dock
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // 2-Column top row for Streak & Energy Arc
                  if (visible.contains('streak_flame') || visible.contains('energy_arc')) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (visible.contains('streak_flame'))
                          const Expanded(
                            child: SizedBox(
                              height: 230,
                              child: StreakFlameWidget(),
                            ),
                          ),
                        if (visible.contains('streak_flame') && visible.contains('energy_arc'))
                          const SizedBox(width: 16),
                        if (visible.contains('energy_arc'))
                          const Expanded(
                            child: SizedBox(
                              height: 230,
                              child: EnergyArcWidget(),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Full width Task Pulse
                  if (visible.contains('task_pulse')) ...[
                    const TaskPulseWidget(),
                    const SizedBox(height: 16),
                  ],

                  // Full width Weekly Heatmap
                  if (visible.contains('weekly_heatmap')) ...[
                    const WeeklyHeatmapWidget(),
                    const SizedBox(height: 16),
                  ],

                  // Full width Liar Detector
                  if (visible.contains('liar_detector')) ...[
                    const LiarDetectorWidget(),
                    const SizedBox(height: 16),
                  ],

                  // Full width Quote Prism
                  if (visible.contains('quote_prism')) ...[
                    const QuotePrismWidget(),
                    const SizedBox(height: 16),
                  ],
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCustomizationSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Consumer(
        builder: (context, ref, _) {
          final prefs = ref.watch(widgetPreferencesProvider);
          final themes = FlipClockThemes.all;

          return Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Color(0xFF14141A),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              border: Border(
                top: BorderSide(color: Colors.white24, width: 0.5),
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        'WIDGET & CLOCK CUSTOMIZATION',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 10,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Clock themes
                    const Text(
                      'CLOCK THEME',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 48,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: themes.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final t = themes[index];
                          final isSelected = prefs.clockThemeIndex == index;
                          return ChoiceChip(
                            label: Text(t.name),
                            selected: isSelected,
                            onSelected: (_) {
                              ref.read(widgetPreferencesProvider.notifier).setThemeIndex(index);
                            },
                            backgroundColor: const Color(0xFF22222E),
                            selectedColor: Colors.white,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.black : Colors.white70,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Clock settings toggles
                    SwitchListTile(
                      title: const Text('24-Hour Time Format', style: TextStyle(color: Colors.white, fontSize: 13)),
                      subtitle: const Text('Display hours from 00 to 23', style: TextStyle(color: Colors.white38, fontSize: 11)),
                      value: prefs.is24Hour,
                      activeThumbColor: Colors.white,
                      onChanged: (_) => ref.read(widgetPreferencesProvider.notifier).toggle24Hour(),
                    ),
                    SwitchListTile(
                      title: const Text('Show Seconds Flip Animation', style: TextStyle(color: Colors.white, fontSize: 13)),
                      subtitle: const Text('Animates the split-flap seconds digits', style: TextStyle(color: Colors.white38, fontSize: 11)),
                      value: prefs.showSeconds,
                      activeThumbColor: Colors.white,
                      onChanged: (_) => ref.read(widgetPreferencesProvider.notifier).toggleSeconds(),
                    ),
                    const Divider(color: Colors.white12, height: 32),

                    // Visible cards
                    const Text(
                      'VISIBLE WIDGET CARDS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _widgetCheckbox(ref, 'streak_flame', 'Streak Flame (Activity Ring)', prefs.visibleWidgets.contains('streak_flame')),
                    _widgetCheckbox(ref, 'energy_arc', 'Energy Arc (Triple Gauge)', prefs.visibleWidgets.contains('energy_arc')),
                    _widgetCheckbox(ref, 'task_pulse', 'Task Pulse (Liquid Progress)', prefs.visibleWidgets.contains('task_pulse')),
                    _widgetCheckbox(ref, 'weekly_heatmap', '4-Week Execution Matrix', prefs.visibleWidgets.contains('weekly_heatmap')),
                    _widgetCheckbox(ref, 'liar_detector', 'Liar Detect Matrix (Polygraph)', prefs.visibleWidgets.contains('liar_detector')),
                    _widgetCheckbox(ref, 'quote_prism', 'Quote Prism (Gita Shloka)', prefs.visibleWidgets.contains('quote_prism')),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _widgetCheckbox(WidgetRef ref, String key, String label, bool isChecked) {
    return CheckboxListTile(
      title: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13)),
      value: isChecked,
      activeColor: Colors.white,
      checkColor: Colors.black,
      onChanged: (_) => ref.read(widgetPreferencesProvider.notifier).toggleWidget(key),
    );
  }
}
