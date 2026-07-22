import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../features/dashboard/providers/task_provider.dart';

class Daily24hAllocationWidget extends ConsumerStatefulWidget {
  const Daily24hAllocationWidget({super.key});

  @override
  ConsumerState<Daily24hAllocationWidget> createState() => _Daily24hAllocationWidgetState();
}

class _Daily24hAllocationWidgetState extends ConsumerState<Daily24hAllocationWidget> {
  bool _isExpanded = false;

  String _formatDuration(double hoursDouble, {Duration? durationObj}) {
    final totalMinutes = durationObj != null ? durationObj.inMinutes : (hoursDouble * 60).round();
    if (totalMinutes <= 0) return "0m";
    final hrs = totalMinutes ~/ 60;
    final mins = totalMinutes % 60;
    if (hrs == 0) {
      return "${mins}m";
    } else if (mins == 0) {
      return "${hrs}h";
    } else {
      return "${hrs}h ${mins}m";
    }
  }

  @override
  Widget build(BuildContext context) {
    final dashboardState = ref.watch(taskProvider);
    final events = dashboardState.googleEvents;

    // Calculate class/calendar hours for today
    double classHours = 0.0;
    List<calendar.Event> todayClasses = [];

    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = todayStart.add(const Duration(days: 1));

    for (var event in events) {
      DateTime? start = event.start?.dateTime ?? event.start?.date;
      DateTime? end = event.end?.dateTime ?? event.end?.date;

      if (start != null && end != null) {
        if (start.isAfter(todayStart.subtract(const Duration(seconds: 1))) && start.isBefore(todayEnd)) {
          todayClasses.add(event);
          double duration = end.difference(start).inMinutes / 60.0;
          classHours += duration > 0 ? duration : 1.0;
        }
      }
    }

    // Assumptions for 24h baseline budget
    const double sleepHours = 7.5;
    const double peakWorkHours = 4.0;
    double remainingFreeHours = (24.0 - (sleepHours + classHours + peakWorkHours)).clamp(0.0, 24.0);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        children: [
          // Header / Summary Row
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Icon(Icons.schedule_rounded, color: AppTheme.warning, size: 16),
                            const SizedBox(width: 6),
                            const Flexible(
                              child: Text(
                                "DAILY 24H AUDIT",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontFamily: 'monospace',
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.purple.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.purple.withValues(alpha: 0.4)),
                              ),
                              child: Text(
                                "${_formatDuration(classHours)} Classes",
                                style: const TextStyle(color: Colors.purpleAccent, fontSize: 9, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        _isExpanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                        color: Colors.white54,
                        size: 18,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Segmented 24-hour horizontal bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: SizedBox(
                      height: 10,
                      child: Row(
                        children: [
                          Expanded(
                            flex: (sleepHours * 10).toInt(),
                            child: Container(color: const Color(0xFF1E88E5)),
                          ),
                          if (classHours > 0)
                            Expanded(
                              flex: (classHours * 10).toInt().clamp(1, 240),
                              child: Container(color: const Color(0xFF8E24AA)),
                            ),
                          Expanded(
                            flex: (peakWorkHours * 10).toInt(),
                            child: Container(color: AppTheme.warning),
                          ),
                          Expanded(
                            flex: (remainingFreeHours * 10).toInt().clamp(1, 240),
                            child: Container(color: const Color(0xFF43A047)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Expanded Details
          if (_isExpanded) ...[
            const Divider(color: Color(0xFF222222), height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      _buildLegendItem("Sleep", _formatDuration(sleepHours), const Color(0xFF1E88E5)),
                      _buildLegendItem("Classes/Events", _formatDuration(classHours), const Color(0xFF8E24AA)),
                      _buildLegendItem("Peak Work", _formatDuration(peakWorkHours), AppTheme.warning),
                      _buildLegendItem("Free Hours", _formatDuration(remainingFreeHours), const Color(0xFF43A047)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "TODAY'S CLASSES & CALENDAR EVENTS:",
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 10,
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (todayClasses.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.02),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        "No Google Calendar classes or events scheduled for today.",
                        style: TextStyle(color: Colors.white38, fontSize: 11, fontStyle: FontStyle.italic),
                      ),
                    )
                  else
                    ...todayClasses.map((evt) {
                      final start = evt.start?.dateTime?.toLocal() ?? evt.start?.date;
                      final end = evt.end?.dateTime?.toLocal() ?? evt.end?.date;

                      final timeStr = (start != null && end != null)
                          ? "${DateFormat('HH:mm').format(start)} - ${DateFormat('HH:mm').format(end)}"
                          : "All Day";

                      final durationStr = (start != null && end != null)
                          ? _formatDuration(0, durationObj: end.difference(start))
                          : "Full Day";

                      return Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF8E24AA).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFF8E24AA).withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  const Icon(Icons.school_outlined, size: 14, color: Colors.purpleAccent),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      evt.summary ?? "Untitled Class/Event",
                                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  timeStr,
                                  style: const TextStyle(color: Colors.white70, fontSize: 11, fontFamily: 'monospace'),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.white10,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    durationStr,
                                    style: const TextStyle(color: Colors.purpleAccent, fontSize: 10, fontFamily: 'monospace', fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, String value, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          "$label: ",
          style: const TextStyle(color: Colors.white54, fontSize: 11),
        ),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'monospace'),
        ),
      ],
    );
  }
}
