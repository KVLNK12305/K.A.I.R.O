import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../energy_economy/energy_provider.dart';

/// "Energy Arc" — Samsung-inspired battery arc gauges showing
/// Peak 1 / Peak 2 / Recovery task completion status.
class EnergyArcWidget extends ConsumerStatefulWidget {
  const EnergyArcWidget({super.key});

  @override
  ConsumerState<EnergyArcWidget> createState() => _EnergyArcWidgetState();
}

class _EnergyArcWidgetState extends ConsumerState<EnergyArcWidget>
    with TickerProviderStateMixin {
  late AnimationController _fillController;
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _fillController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward();

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat();
  }

  @override
  void dispose() {
    _fillController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(energyEconomyProvider);

    final peak1Total = state.peak1Tasks.length;
    final peak1Done = state.peak1Tasks.where((t) => t.isCompleted).length;
    final peak2Total = state.peak2Tasks.length;
    final peak2Done = state.peak2Tasks.where((t) => t.isCompleted).length;
    final recTotal = state.recoveryTasks.length;
    final recDone = state.recoveryTasks.where((t) => t.isCompleted).length;

    final peak1Pct = peak1Total > 0 ? peak1Done / peak1Total : 0.0;
    final peak2Pct = peak2Total > 0 ? peak2Done / peak2Total : 0.0;
    final recPct = recTotal > 0 ? recDone / recTotal : 0.0;

    return _WidgetCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                const Icon(Icons.bolt_rounded, color: Color(0xFFFFA726), size: 16),
                const SizedBox(width: 6),
                const Text(
                  'ENERGY ARC',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 9,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Triple arc gauges
          SizedBox(
            height: 140,
            child: Center(
              child: FittedBox(
                fit: BoxFit.contain,
                child: SizedBox(
                  width: 140,
                  height: 140,
                  child: AnimatedBuilder(
                    animation: Listenable.merge([_fillController, _shimmerController]),
                    builder: (context, _) {
                      return CustomPaint(
                        size: const Size(140, 140),
                        painter: _EnergyArcPainter(
                          peak1: peak1Pct * _fillController.value,
                          peak2: peak2Pct * _fillController.value,
                          recovery: recPct * _fillController.value,
                          shimmerValue: _shimmerController.value,
                          peak1Label: '$peak1Done/$peak1Total',
                          peak2Label: '$peak2Done/$peak2Total',
                          recLabel: '$recDone/$recTotal',
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Legend
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _legend(const Color(0xFFFFA726), 'PEAK 1'),
                const SizedBox(width: 16),
                _legend(const Color(0xFF26C6DA), 'PEAK 2'),
                const SizedBox(width: 16),
                _legend(const Color(0xFFAB47BC), 'RECOVER'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _legend(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white38,
            fontSize: 8,
            letterSpacing: 1,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _EnergyArcPainter extends CustomPainter {
  final double peak1;
  final double peak2;
  final double recovery;
  final double shimmerValue;
  final String peak1Label;
  final String peak2Label;
  final String recLabel;

  _EnergyArcPainter({
    required this.peak1,
    required this.peak2,
    required this.recovery,
    required this.shimmerValue,
    required this.peak1Label,
    required this.peak2Label,
    required this.recLabel,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height * 0.55;
    final center = Offset(centerX, centerY);

    const strokeWidth = 10.0;
    const gap = 14.0;
    final outerRadius = math.min(size.width, size.height) / 2 - 4;
    final middleRadius = outerRadius - gap;
    final innerRadius = middleRadius - gap;

    // Arc parameters: 240-degree arc, starting from bottom-left
    const startAngle = math.pi * 0.65;
    const totalAngle = math.pi * 1.7;

    // Draw each arc
    _drawArc(canvas, center, outerRadius, startAngle, totalAngle, peak1,
        const Color(0xFFFFA726), const Color(0xFFFF7043), strokeWidth);
    _drawArc(canvas, center, middleRadius, startAngle, totalAngle, peak2,
        const Color(0xFF26C6DA), const Color(0xFF0097A7), strokeWidth);
    _drawArc(canvas, center, innerRadius, startAngle, totalAngle, recovery,
        const Color(0xFFAB47BC), const Color(0xFF7B1FA2), strokeWidth);

    // Shimmer effect on arcs
    _drawShimmer(canvas, center, outerRadius, startAngle, totalAngle, peak1, strokeWidth);
    _drawShimmer(canvas, center, middleRadius, startAngle, totalAngle, peak2, strokeWidth);
    _drawShimmer(canvas, center, innerRadius, startAngle, totalAngle, recovery, strokeWidth);

    // Center text
    _drawCenterText(canvas, center);
  }

  void _drawArc(Canvas canvas, Offset center, double radius, double startAngle,
      double totalAngle, double progress, Color color1, Color color2, double strokeWidth) {
    // Background track
    final bgPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      totalAngle,
      false,
      bgPaint,
    );

    if (progress <= 0) return;

    // Progress arc with gradient
    final sweepAngle = totalAngle * progress;
    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        startAngle: startAngle,
        endAngle: startAngle + sweepAngle,
        colors: [color1, color2],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  void _drawShimmer(Canvas canvas, Offset center, double radius,
      double startAngle, double totalAngle, double progress, double strokeWidth) {
    if (progress <= 0) return;

    final sweepAngle = totalAngle * progress;
    final shimmerAngle = startAngle + sweepAngle * shimmerValue;
    final shimmerX = center.dx + radius * math.cos(shimmerAngle);
    final shimmerY = center.dy + radius * math.sin(shimmerAngle);

    final shimmerPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawCircle(Offset(shimmerX, shimmerY), strokeWidth / 2.5, shimmerPaint);
  }

  void _drawCenterText(Canvas canvas, Offset center) {
    final allDone = peak1 >= 1.0 && peak2 >= 1.0 && recovery >= 1.0;
    final avgProgress = ((peak1 + peak2 + recovery) / 3 * 100).round();

    final textPainter = TextPainter(
      text: TextSpan(
        text: allDone ? '✓' : '$avgProgress%',
        style: TextStyle(
          color: allDone ? const Color(0xFF4CAF50) : Colors.white,
          fontSize: allDone ? 24 : 18,
          fontWeight: FontWeight.w800,
          fontFamily: 'monospace',
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(center.dx - textPainter.width / 2, center.dy - textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant _EnergyArcPainter oldDelegate) {
    return oldDelegate.peak1 != peak1 ||
        oldDelegate.peak2 != peak2 ||
        oldDelegate.recovery != recovery ||
        oldDelegate.shimmerValue != shimmerValue;
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
