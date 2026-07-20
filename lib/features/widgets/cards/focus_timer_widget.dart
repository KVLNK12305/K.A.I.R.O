import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/focus_timer_service.dart';
import '../../../main.dart';

class FocusTimerWidget extends ConsumerStatefulWidget {
  const FocusTimerWidget({super.key});

  @override
  ConsumerState<FocusTimerWidget> createState() => _FocusTimerWidgetState();
}

class _FocusTimerWidgetState extends ConsumerState<FocusTimerWidget> {
  final TextEditingController _titleController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  String _formatTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final timerState = ref.watch(focusTimerProvider);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: timerState.isRunning
              ? (timerState.isPaused ? Colors.amber.withValues(alpha: 0.4) : const Color(0xFF00E676).withValues(alpha: 0.4))
              : Colors.white.withValues(alpha: 0.08),
          width: timerState.isRunning ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      timerState.isRunning ? Icons.timer : Icons.timer_outlined,
                      color: timerState.isRunning ? (timerState.isPaused ? Colors.amber : const Color(0xFF00E676)) : Colors.white54,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'FOCUS ENGINE • POMODORO',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 9,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              if (timerState.isRunning && timerState.distractionCount > 0) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.redAccent.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 12),
                      const SizedBox(width: 4),
                      Text(
                        '${timerState.distractionCount} DISTRACTIONS',
                        style: const TextStyle(color: Colors.redAccent, fontSize: 9, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),

          if (!timerState.isRunning) ...[
            // Input for task title
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF0F0F0F),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white12),
              ),
              child: TextField(
                controller: _titleController,
                style: const TextStyle(color: Colors.white, fontSize: 13),
                decoration: const InputDecoration(
                  hintText: 'What exact problem are you conquering right now?',
                  hintStyle: TextStyle(color: Colors.white24, fontSize: 12),
                  contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Duration selection buttons
            Row(
              children: [
                Expanded(
                  child: _buildSprintButton('25m SPRINT', 25, const Color(0xFF00E676)),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildSprintButton('50m DEEP', 50, Colors.amber),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildSprintButton('90m PROTOCOL', 90, Colors.blueAccent),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Today stats
            FutureBuilder<double>(
              future: FocusService(isar).getTodayTotalFocusHours(),
              builder: (context, snapshot) {
                final hours = snapshot.data ?? 0.0;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'TODAY\'S DEEP WORK: ${hours.toStringAsFixed(1)}h',
                      style: const TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
                    ),
                    const Text(
                      'STRICT MONITORING ON',
                      style: TextStyle(color: Colors.white24, fontSize: 9, letterSpacing: 1),
                    ),
                  ],
                );
              },
            ),
          ] else ...[
            // Live running countdown state
            Center(
              child: Column(
                children: [
                  Text(
                    timerState.activeSession?.title ?? 'Deep Work Block',
                    style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _formatTime(timerState.secondsRemaining),
                    style: TextStyle(
                      color: timerState.isPaused ? Colors.amber : const Color(0xFF00E676),
                      fontSize: 48,
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    timerState.isPaused
                        ? 'PAUSED • STAY DISCIPLINED'
                        : 'IN PROGRESS • DO NOT LEAVE THIS SCREEN OR APP',
                    style: TextStyle(
                      color: timerState.isPaused ? Colors.amber.withValues(alpha: 0.7) : Colors.white38,
                      fontSize: 10,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            if (timerState.isPaused) {
                              ref.read(focusTimerProvider.notifier).resumeSession();
                            } else {
                              ref.read(focusTimerProvider.notifier).pauseSession();
                            }
                          },
                          icon: Icon(timerState.isPaused ? Icons.play_arrow : Icons.pause, size: 16, color: Colors.white),
                          label: Text(
                            timerState.isPaused ? 'RESUME' : 'PAUSE',
                            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: const BorderSide(color: Colors.white24),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final completed = await ref.read(focusTimerProvider.notifier).completeSession();
                            if (context.mounted && completed != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Focus Block Logged: ${completed.actualDurationMinutes}m (${completed.distractionCount} distractions)',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: const Color(0xFF141414),
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.check, size: 16, color: Colors.black),
                          label: const Text(
                            'COMPLETE',
                            style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00E676),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () {
                          ref.read(focusTimerProvider.notifier).cancelSession();
                        },
                        icon: const Icon(Icons.close, color: Colors.white38, size: 20),
                        tooltip: 'Abort Session',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSprintButton(String label, int minutes, Color color) {
    return InkWell(
      onTap: () {
        final title = _titleController.text.trim();
        ref.read(focusTimerProvider.notifier).startSession(title, durationMinutes: minutes);
        _titleController.clear();
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }
}
