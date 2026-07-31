import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'bento_card.dart';
import '../../../core/theme/app_theme.dart';
import '../../liars_chart/liars_chart_provider.dart';

/// "Liar Detector" — Apple/Samsung sci-fi polygraph waveform widget showing
/// alignment between lead actions and lag outcomes.
class LiarDetectorWidget extends ConsumerStatefulWidget {
  const LiarDetectorWidget({super.key});

  @override
  ConsumerState<LiarDetectorWidget> createState() => _LiarDetectorWidgetState();
}

class _LiarDetectorWidgetState extends ConsumerState<LiarDetectorWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat();
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(liarsChartProvider);
    final goals = state.goals;
    final anyLiar = goals.any((g) => g.liarsChartActive);
    final totalGoals = goals.length;

    final statusColor = anyLiar ? AppTheme.coralRed : AppTheme.inkBlack;
    final statusText = anyLiar ? 'DISCONNECTED LEVER DETECTED' : 'TRUTH LEVERS ALIGNED';

    return BentoCard(
      backgroundColor: AppTheme.pastelPink,
      borderColor: Colors.black.withValues(alpha: 0.12),
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
                      anyLiar ? Icons.warning_amber_rounded : Icons.graphic_eq_rounded,
                      color: AppTheme.inkBlack,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    const Expanded(
                      child: Text(
                        'LIAR DETECT MATRIX',
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
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.inkBlack,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  anyLiar ? 'ALERT' : 'VERIFIED',
                  style: TextStyle(
                    color: anyLiar ? AppTheme.coralRed : AppTheme.pastelGreen,
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'monospace',
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Oscilloscope polygraph waveform
          SizedBox(
            height: 64,
            child: AnimatedBuilder(
              animation: _waveController,
              builder: (context, _) {
                return CustomPaint(
                  size: const Size(double.infinity, 64),
                  painter: _PolygraphPainter(
                    phase: _waveController.value * 2 * math.pi,
                    isAlert: anyLiar,
                    color: statusColor,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),

          // Footer info
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  statusText,
                  style: TextStyle(
                    color: anyLiar ? AppTheme.coralRed : AppTheme.inkBlack,
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  '$totalGoals GOALS TRACKED',
                  style: TextStyle(
                    color: AppTheme.inkBlack.withValues(alpha: 0.6),
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PolygraphPainter extends CustomPainter {
  final double phase;
  final bool isAlert;
  final Color color;

  _PolygraphPainter({
    required this.phase,
    required this.isAlert,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final midY = size.height / 2;
    final width = size.width;

    // Grid lines
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..strokeWidth = 0.5;
    for (int i = 1; i < 4; i++) {
      final y = size.height * (i / 4);
      canvas.drawLine(Offset(0, y), Offset(width, y), gridPaint);
    }
    for (int i = 1; i < 8; i++) {
      final x = width * (i / 8);
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    // Waveform path
    final path = Path();
    path.moveTo(0, midY);

    for (double x = 0; x <= width; x += 2) {
      final normalizedX = x / width;
      // Pulse near center
      final distFromCenter = (normalizedX - 0.5).abs();
      final envelope = math.exp(-math.pow(distFromCenter * 5, 2));

      double wave = math.sin(normalizedX * 20 - phase) * 6;
      if (isAlert) {
        // High frequency jitter in alert mode
        wave += math.sin(normalizedX * 60 + phase * 3) * 12 * envelope;
      } else {
        // Clean heartbeat pulse
        wave += math.sin(normalizedX * 30 - phase * 2) * 18 * envelope;
      }

      path.lineTo(x, midY + wave);
    }

    // Glow line
    final glowPaint = Paint()
      ..color = color.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawPath(path, glowPaint);

    // Sharp core line
    final corePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawPath(path, corePaint);
  }

  @override
  bool shouldRepaint(covariant _PolygraphPainter oldDelegate) {
    return oldDelegate.phase != phase ||
        oldDelegate.isAlert != isAlert ||
        oldDelegate.color != color;
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
