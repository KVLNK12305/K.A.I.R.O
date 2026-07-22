import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:intl/intl.dart';
import '../../../main.dart';
import '../../../core/models/task.dart';
import '../../../core/models/psychosomatic_scan.dart';
import '../../../core/models/daily_metric.dart';
import '../../../core/theme/app_theme.dart';

final heatmapGridProvider = FutureProvider.autoDispose<Map<DateTime, int>>((ref) async {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final startDate = today.subtract(const Duration(days: 90));

  final tasks = await isar.tasks.where().findAll();
  final scans = await isar.psychosomaticScans.where().findAll();
  final metrics = await isar.dailyMetrics.where().findAll();

  final Map<DateTime, int> intensityMap = {};

  for (int i = 0; i <= 90; i++) {
    final date = startDate.add(Duration(days: i));
    int score = 0;

    // Check completed tasks on this day
    final dayTasks = tasks.where((t) =>
        t.isCompleted &&
        t.createdAt.year == date.year &&
        t.createdAt.month == date.month &&
        t.createdAt.day == date.day);
    score += dayTasks.length * 2;

    // Check scan
    final hasScan = scans.any((s) =>
        s.date.year == date.year &&
        s.date.month == date.month &&
        s.date.day == date.day);
    if (hasScan) score += 2;

    // Check metrics
    final dayMetric = metrics.where((m) =>
        m.date.year == date.year &&
        m.date.month == date.month &&
        m.date.day == date.day).firstOrNull;
    if (dayMetric != null && (dayMetric.commitsMade > 0 || dayMetric.studyHours > 0)) {
      score += 2;
    }

    // Map 0-10+ score to level 0-4
    if (score == 0) {
      intensityMap[date] = 0;
    } else if (score <= 2) {
      intensityMap[date] = 1;
    } else if (score <= 4) {
      intensityMap[date] = 2;
    } else if (score <= 6) {
      intensityMap[date] = 3;
    } else {
      intensityMap[date] = 4;
    }
  }

  return intensityMap;
});

class DisciplineHeatmapWidget extends ConsumerWidget {
  const DisciplineHeatmapWidget({super.key});

  Color _getColorForLevel(int level) {
    switch (level) {
      case 1:
        return const Color(0xFF004D40);
      case 2:
        return const Color(0xFF00695C);
      case 3:
        return const Color(0xFF00BFA5);
      case 4:
        return const Color(0xFF00E676);
      default:
        return const Color(0xFF1E1E1E);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gridAsync = ref.watch(heatmapGridProvider);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF14141A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.accent.withAlpha(40),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.grid_view_rounded, color: AppTheme.accent, size: 20),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "DISCIPLINE HEATMAP (90-DAY MATRIX)",
                      style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2),
                    Text(
                      "Execution density & habit momentum over time",
                      style: TextStyle(color: Colors.white54, fontSize: 11),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          gridAsync.when(
            data: (map) {
              final dates = map.keys.toList()..sort();
              if (dates.isEmpty) return const SizedBox.shrink();

              // Calculate streaks from map
              int currentStreak = 0;
              int maxStreak = 0;
              int tempStreak = 0;
              for (final date in dates) {
                if ((map[date] ?? 0) > 0) {
                  tempStreak++;
                  if (tempStreak > maxStreak) maxStreak = tempStreak;
                } else {
                  tempStreak = 0;
                }
              }
              // Current streak working backwards from today
              for (int i = dates.length - 1; i >= 0; i--) {
                if ((map[dates[i]] ?? 0) > 0) {
                  currentStreak++;
                } else if (i != dates.length - 1) {
                  break;
                }
              }

              return Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    reverse: true, // Scroll to most recent right away
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate((dates.length / 7).ceil(), (weekIdx) {
                        return Column(
                          children: List.generate(7, (dayIdx) {
                            final idx = weekIdx * 7 + dayIdx;
                            if (idx >= dates.length) return const SizedBox(width: 14, height: 14);
                            final date = dates[idx];
                            final level = map[date] ?? 0;

                            return Tooltip(
                              message: "${DateFormat('MMM d, yyyy').format(date)}: Level $level",
                              child: Container(
                                width: 14,
                                height: 14,
                                margin: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: _getColorForLevel(level),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            );
                          }),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text("Less ", style: TextStyle(color: Colors.white38, fontSize: 10)),
                          ...List.generate(5, (l) => Container(
                                width: 10,
                                height: 10,
                                margin: const EdgeInsets.symmetric(horizontal: 2),
                                decoration: BoxDecoration(color: _getColorForLevel(l), borderRadius: BorderRadius.circular(2)),
                              )),
                          const Text(" More", style: TextStyle(color: Colors.white38, fontSize: 10)),
                        ],
                      ),
                      Text("Max Chain: ${maxStreak}d • Live: ${currentStreak}d", style: const TextStyle(color: AppTheme.accent, fontSize: 11, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              );
            },
            loading: () => const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator(color: Colors.white24, strokeWidth: 2))),
            error: (err, _) => Text("Error generating heatmap: $err", style: const TextStyle(color: Colors.redAccent, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
