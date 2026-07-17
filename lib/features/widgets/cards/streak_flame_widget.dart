import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/streak_service.dart';

/// Provider that fetches streak data.
final streakDataProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final service = StreakService();
  final dayNumber = await service.getDayNumber();
  final isBroken = await service.isStreakBroken();
  final completedDays = await service.getCompletedDays();
  return {
    'dayNumber': dayNumber,
    'isBroken': isBroken,
    'completedDays': completedDays.length,
    'totalDays': 21,
  };
});

/// "Streak Flame" — Apple Activity Rings inspired streak visualization.
class StreakFlameWidget extends ConsumerStatefulWidget {
  const StreakFlameWidget({super.key});

  @override
  ConsumerState<StreakFlameWidget> createState() => _StreakFlameWidgetState();
}

class _StreakFlameWidgetState extends ConsumerState<StreakFlameWidget>
    with TickerProviderStateMixin {
  late AnimationController _ringController;
  late AnimationController _pulseController;
  late AnimationController _particleController;

  @override
  void initState() {
    super.initState();
    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..forward();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();
  }

  @override
  void dispose() {
    _ringController.dispose();
    _pulseController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final streakAsync = ref.watch(streakDataProvider);

    return _WidgetCard(
      child: streakAsync.when(
        loading: () => const Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              color: Colors.white24,
              strokeWidth: 2,
            ),
          ),
        ),
        error: (_, __) => const Center(
          child: Text('—', style: TextStyle(color: Colors.white24)),
        ),
        data: (data) {
          final dayNumber = data['dayNumber'] as int;
          final isBroken = data['isBroken'] as bool;
          final completed = data['completedDays'] as int;
          final total = data['totalDays'] as int;
          final progress = (completed / total).clamp(0.0, 1.0);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(
                    isBroken ? Icons.heart_broken : Icons.local_fire_department,
                    color: isBroken
                        ? const Color(0xFFFF4444)
                        : const Color(0xFFFF6B35),
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'STREAK FLAME',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 9,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Ring visualization
              Expanded(
                child: Center(
                  child: AnimatedBuilder(
                    animation: Listenable.merge([
                      _ringController,
                      _pulseController,
                      _particleController,
                    ]),
                    builder: (context, _) {
                      return CustomPaint(
                        size: const Size(120, 120),
                        painter: _StreakRingPainter(
                          progress: progress * _ringController.value,
                          isBroken: isBroken,
                          pulseValue: _pulseController.value,
                          particleValue: _particleController.value,
                          dayNumber: dayNumber,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Footer
              Center(
                child: Text(
                  isBroken
                      ? 'CHAIN BROKEN'
                      : 'DAY $dayNumber OF 21  •  $completed LOGGED',
                  style: TextStyle(
                    color: isBroken
                        ? const Color(0xFFFF4444).withValues(alpha: 0.7)
                        : Colors.white38,
                    fontSize: 9,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Custom painter for the streak ring with particles.
class _StreakRingPainter extends CustomPainter {
  final double progress;
  final bool isBroken;
  final double pulseValue;
  final double particleValue;
  final int dayNumber;

  _StreakRingPainter({
    required this.progress,
    required this.isBroken,
    required this.pulseValue,
    required this.particleValue,
    required this.dayNumber,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 12;

    // Background ring
    final bgPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);

    // Progress ring
    if (progress > 0) {
      final sweepAngle = progress * 2 * math.pi;
      final progressPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8 + (pulseValue * 1.5)
        ..strokeCap = StrokeCap.round
        ..shader = SweepGradient(
          startAngle: -math.pi / 2,
          endAngle: -math.pi / 2 + sweepAngle,
          colors: isBroken
              ? [
                  const Color(0xFFFF4444),
                  const Color(0xFF880000),
                ]
              : [
                  const Color(0xFFFF6B35),
                  const Color(0xFFFFAA00),
                  const Color(0xFFFF3D00),
                ],
          stops: isBroken ? [0.0, 1.0] : [0.0, 0.5, 1.0],
        ).createShader(
          Rect.fromCircle(center: center, radius: radius),
        );

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        sweepAngle,
        false,
        progressPaint,
      );

      // Glow at the tip
      if (!isBroken) {
        final tipAngle = -math.pi / 2 + sweepAngle;
        final tipX = center.dx + radius * math.cos(tipAngle);
        final tipY = center.dy + radius * math.sin(tipAngle);
        final glowPaint = Paint()
          ..color = const Color(0xFFFF6B35).withValues(alpha: 0.4 + pulseValue * 0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
        canvas.drawCircle(Offset(tipX, tipY), 6, glowPaint);
      }
    }

    // Ember particles (when streak is alive)
    if (!isBroken && progress > 0.1) {
      final rng = math.Random(42);
      for (int i = 0; i < 8; i++) {
        final angle = particleValue * 2 * math.pi + (i * math.pi / 4);
        final dist = radius * 0.3 + rng.nextDouble() * radius * 0.5;
        final opacity = (math.sin(particleValue * math.pi * 2 + i) * 0.5 + 0.5)
            .clamp(0.0, 1.0);
        final px = center.dx + dist * math.cos(angle);
        final py = center.dy + dist * math.sin(angle);
        final particlePaint = Paint()
          ..color = Color.lerp(
            const Color(0xFFFF6B35),
            const Color(0xFFFFDD00),
            rng.nextDouble(),
          )!
              .withValues(alpha: opacity * 0.4)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
        canvas.drawCircle(
          Offset(px, py),
          1.5 + rng.nextDouble() * 2,
          particlePaint,
        );
      }
    }

    // Cracked lines when broken
    if (isBroken) {
      final crackPaint = Paint()
        ..color = const Color(0xFFFF4444).withValues(alpha: 0.3 + pulseValue * 0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;
      final rng = math.Random(7);
      for (int i = 0; i < 5; i++) {
        final startAngle = rng.nextDouble() * 2 * math.pi;
        final len = 10.0 + rng.nextDouble() * 15;
        final sx = center.dx + (radius - 5) * math.cos(startAngle);
        final sy = center.dy + (radius - 5) * math.sin(startAngle);
        final ex = sx + len * math.cos(startAngle + rng.nextDouble() - 0.5);
        final ey = sy + len * math.sin(startAngle + rng.nextDouble() - 0.5);
        canvas.drawLine(Offset(sx, sy), Offset(ex, ey), crackPaint);
      }
    }

    // Center text
    final textPainter = TextPainter(
      text: TextSpan(
        text: '$dayNumber',
        style: TextStyle(
          color: isBroken ? const Color(0xFFFF4444) : Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.w800,
          fontFamily: 'monospace',
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2 - 4,
      ),
    );

    // "of 21" label
    final labelPainter = TextPainter(
      text: TextSpan(
        text: isBroken ? 'RESET' : 'of 21',
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.3),
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 1,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    labelPainter.layout();
    labelPainter.paint(
      canvas,
      Offset(
        center.dx - labelPainter.width / 2,
        center.dy + textPainter.height / 2 - 6,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant _StreakRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.pulseValue != pulseValue ||
        oldDelegate.particleValue != particleValue;
  }
}

/// Reusable glassmorphism card wrapper for all widgets.
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
