import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'bento_card.dart';
import '../../../core/theme/app_theme.dart';
import '../../energy_economy/energy_provider.dart';

/// "Task Pulse" — Apple Weather / Widget inspired horizontal progress bar
/// with smooth liquid fill, pulse animation when tasks complete, and clean typography.
class TaskPulseWidget extends ConsumerStatefulWidget {
  const TaskPulseWidget({super.key});

  @override
  ConsumerState<TaskPulseWidget> createState() => _TaskPulseWidgetState();
}

class _TaskPulseWidgetState extends ConsumerState<TaskPulseWidget>
    with TickerProviderStateMixin {
  late AnimationController _fillController;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _fillController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..forward();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _fillController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(energyEconomyProvider);

    final allTasks = [
      ...state.peak1Tasks,
      ...state.peak2Tasks,
      ...state.recoveryTasks,
      ...state.unassignedTasks,
    ];

    final total = allTasks.length;
    final completed = allTasks.where((t) => t.isCompleted).length;
    final pct = total > 0 ? (completed / total).clamp(0.0, 1.0) : 0.0;

    return BentoCard(
      backgroundColor: AppTheme.pastelGreen,
      borderColor: Colors.black.withValues(alpha: 0.12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      color: AppTheme.inkBlack,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    const Expanded(
                      child: Text(
                        'TASK PULSE',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppTheme.inkBlack,
                          fontSize: 10,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.inkBlack,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  total == 0 ? 'NO TASKS' : '$completed OF $total',
                  style: const TextStyle(
                    color: AppTheme.pastelGreen,
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'monospace',
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Liquid bar gauge
          AnimatedBuilder(
            animation: Listenable.merge([_fillController, _pulseController]),
            builder: (context, _) {
              return CustomPaint(
                size: const Size(double.infinity, 24),
                painter: _TaskPulseBarPainter(
                  progress: pct * _fillController.value,
                  pulseValue: _pulseController.value,
                  isAllDone: total > 0 && completed == total,
                ),
              );
            },
          ),
          const SizedBox(height: 14),

          // Footer metrics summary
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _subMetric('PEAK 1', state.peak1Tasks.where((t) => t.isCompleted).length, state.peak1Tasks.length),
                const SizedBox(width: 16),
                _subMetric('PEAK 2', state.peak2Tasks.where((t) => t.isCompleted).length, state.peak2Tasks.length),
                const SizedBox(width: 16),
                _subMetric('RECOVERY', state.recoveryTasks.where((t) => t.isCompleted).length, state.recoveryTasks.length),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _subMetric(String label, int done, int total) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            color: Colors.white38,
            fontSize: 8,
            letterSpacing: 1,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          '$done/$total',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 9,
            fontWeight: FontWeight.w800,
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }
}

class _TaskPulseBarPainter extends CustomPainter {
  final double progress;
  final double pulseValue;
  final bool isAllDone;

  _TaskPulseBarPainter({
    required this.progress,
    required this.pulseValue,
    required this.isAllDone,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(12));

    // Track background
    final bgPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.06)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(rrect, bgPaint);

    if (progress <= 0) return;

    final fillWidth = size.width * progress;
    final fillRect = Rect.fromLTWH(0, 0, fillWidth, size.height);
    final fillRRect = RRect.fromRectAndRadius(fillRect, const Radius.circular(12));

    // Gradient fill
    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        colors: isAllDone
            ? [const Color(0xFF00E676), const Color(0xFF1DE9B6)]
            : [const Color(0xFF6C63FF), const Color(0xFF00E676)],
      ).createShader(fillRect);

    canvas.drawRRect(fillRRect, fillPaint);

    // Glow border/pulse at tip when progressing
    if (progress > 0.05) {
      final tipX = fillWidth - 6;
      final glowPaint = Paint()
        ..color = (isAllDone ? const Color(0xFF00E676) : const Color(0xFF6C63FF))
            .withValues(alpha: 0.4 + pulseValue * 0.4)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
      canvas.drawCircle(Offset(tipX.clamp(6.0, size.width - 6.0), size.height / 2), 8, glowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _TaskPulseBarPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.pulseValue != pulseValue ||
        oldDelegate.isAllDone != isAllDone;
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
