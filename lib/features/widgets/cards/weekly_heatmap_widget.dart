import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:intl/intl.dart';
import '../../../main.dart';
import '../../../core/models/task.dart';

/// Provider that fetches completed task count per day for the last 28 days (4 weeks).
final weeklyHeatmapProvider = FutureProvider<Map<DateTime, int>>((ref) async {
  final now = DateTime.now();
  final startDate = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 27));
  
  final allTasks = await isar.tasks.where().findAll();
  final Map<DateTime, int> counts = {};

  // Initialize all 28 days with 0
  for (int i = 0; i < 28; i++) {
    final day = startDate.add(Duration(days: i));
    counts[day] = 0;
  }

  // Populate counts from completed tasks (based on createdAt or approximation)
  for (final task in allTasks) {
    if (task.isCompleted) {
      final taskDay = DateTime(task.createdAt.year, task.createdAt.month, task.createdAt.day);
      if (counts.containsKey(taskDay)) {
        counts[taskDay] = (counts[taskDay] ?? 0) + 1;
      }
    }
  }

  return counts;
});

/// "Weekly Heatmap" — GitHub/Apple Activity inspired 4-week grid
/// showing intensity of completed tasks.
class WeeklyHeatmapWidget extends ConsumerStatefulWidget {
  const WeeklyHeatmapWidget({super.key});

  @override
  ConsumerState<WeeklyHeatmapWidget> createState() => _WeeklyHeatmapWidgetState();
}

class _WeeklyHeatmapWidgetState extends ConsumerState<WeeklyHeatmapWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _appearController;

  @override
  void initState() {
    super.initState();
    _appearController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
  }

  @override
  void dispose() {
    _appearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final heatmapAsync = ref.watch(weeklyHeatmapProvider);

    return _WidgetCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Icon(
                Icons.calendar_view_month_rounded,
                color: Color(0xFFE040FB),
                size: 16,
              ),
              const SizedBox(width: 6),
              const Text(
                '4-WEEK EXECUTION MATRIX',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 9,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text(
                '${DateFormat('MMM d').format(DateTime.now().subtract(const Duration(days: 27)))} - ${DateFormat('MMM d').format(DateTime.now())}',
                style: const TextStyle(
                  color: Colors.white38,
                  fontSize: 8,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Heatmap grid
          heatmapAsync.when(
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(color: Colors.white24, strokeWidth: 2),
                ),
              ),
            ),
            error: (_, __) => const Center(
              child: Text('—', style: TextStyle(color: Colors.white24)),
            ),
            data: (counts) {
              final daysList = counts.keys.toList()..sort();
              final maxCount = counts.values.fold<int>(1, (max, v) => v > max ? v : max);

              return AnimatedBuilder(
                animation: _appearController,
                builder: (context, _) {
                  return Column(
                    children: [
                      // Day labels (S M T W T F S)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: ['M', 'T', 'W', 'T', 'F', 'S', 'S']
                            .map((d) => Expanded(
                                  child: Center(
                                    child: Text(
                                      d,
                                      style: const TextStyle(
                                        color: Colors.white24,
                                        fontSize: 8,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                      const SizedBox(height: 6),

                      // 4 rows x 7 cols grid
                      for (int row = 0; row < 4; row++) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            for (int col = 0; col < 7; col++) ...[
                              Builder(
                                builder: (context) {
                                  final idx = row * 7 + col;
                                  if (idx >= daysList.length) {
                                    return const Expanded(child: SizedBox());
                                  }
                                  final day = daysList[idx];
                                  final count = counts[day] ?? 0;
                                  final intensity = (count / maxCount).clamp(0.0, 1.0);
                                  final isToday = idx == daysList.length - 1;

                                  // Staggered reveal
                                  final cellDelay = (idx / 28.0) * 0.6;
                                  final cellProgress =
                                      ((_appearController.value - cellDelay) / 0.4).clamp(0.0, 1.0);

                                  return Expanded(
                                    child: Transform.scale(
                                      scale: cellProgress,
                                      child: Container(
                                        margin: const EdgeInsets.all(3),
                                        height: 22,
                                        decoration: BoxDecoration(
                                          color: count == 0
                                              ? Colors.white.withValues(alpha: 0.05)
                                              : Color.lerp(
                                                  const Color(0xFF4A148C),
                                                  const Color(0xFFE040FB),
                                                  intensity,
                                                )!.withValues(alpha: 0.8),
                                          borderRadius: BorderRadius.circular(4),
                                          border: isToday
                                              ? Border.all(color: const Color(0xFFE040FB), width: 1.5)
                                              : null,
                                          boxShadow: count > 0 && cellProgress > 0.8
                                              ? [
                                                  BoxShadow(
                                                    color: const Color(0xFFE040FB)
                                                        .withValues(alpha: intensity * 0.3),
                                                    blurRadius: 4,
                                                  )
                                                ]
                                              : [],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ]
                          ],
                        ),
                        if (row < 3) const SizedBox(height: 2),
                      ],
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _WidgetCard extends StatelessWidget {
  final Widget child;
  const _WidgetCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}
