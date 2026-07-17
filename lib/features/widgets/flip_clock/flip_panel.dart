import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'flip_clock_themes.dart';

/// A single digit card that performs a 3D split-flap flip animation.
///
/// The animation choreography:
/// 1. Old top half is static, new bottom half is static (starting state)
/// 2. Old top half flips DOWN (rotateX from 0 → π/2) revealing new digit behind
/// 3. New bottom half flips UP into place (rotateX from -π/2 → 0)
/// 4. Settle — subtle bounce at the end
class FlipPanel extends StatefulWidget {
  final String digit;
  final FlipClockThemeData theme;
  final double width;
  final double height;

  const FlipPanel({
    super.key,
    required this.digit,
    required this.theme,
    this.width = 52,
    this.height = 72,
  });

  @override
  State<FlipPanel> createState() => _FlipPanelState();
}

class _FlipPanelState extends State<FlipPanel>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  String _currentDigit = '';
  String _previousDigit = '';

  @override
  void initState() {
    super.initState();
    _currentDigit = widget.digit;
    _previousDigit = widget.digit;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
  }

  @override
  void didUpdateWidget(FlipPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.digit != _currentDigit) {
      _previousDigit = _currentDigit;
      _currentDigit = widget.digit;
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final w = widget.width;
    final h = widget.height;
    final halfH = h / 2;

    return SizedBox(
      width: w,
      height: h,
      child: Stack(
        children: [
          // ═══ AMBIENT GLOW ═══
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                final glowVal = _controller.isAnimating
                    ? math.sin(_controller.value * math.pi) * 0.6 + 0.4
                    : 0.3;
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(theme.borderRadius),
                    boxShadow: [
                      BoxShadow(
                        color: theme.glowColor
                            .withValues(alpha: theme.glowIntensity * glowVal),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // ═══ STATIC LAYERS ═══
          Column(
            children: [
              // New digit top half (revealed as old top flips away)
              _buildHalf(
                digit: _currentDigit,
                isTop: true,
                theme: theme,
                width: w,
                height: halfH,
              ),
              // Old digit bottom half (visible until new bottom flips in)
              _buildHalf(
                digit: _previousDigit,
                isTop: false,
                theme: theme,
                width: w,
                height: halfH,
              ),
            ],
          ),

          // ═══ ANIMATED FLIPPING LAYERS ═══
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return Stack(
                children: [
                  // Old top half flipping DOWN (first half of animation)
                  if (_controller.value < 0.5)
                    _buildFlippingHalf(
                      digit: _previousDigit,
                      isTop: true,
                      angle: _controller.value * math.pi,
                      theme: theme,
                      width: w,
                      height: halfH,
                    ),

                  // New bottom half flipping UP (second half of animation)
                  if (_controller.value >= 0.5)
                    _buildFlippingHalf(
                      digit: _currentDigit,
                      isTop: false,
                      angle: (1.0 - _controller.value) * math.pi,
                      theme: theme,
                      width: w,
                      height: halfH,
                      isBottomFlip: true,
                    ),

                  // ═══ DIVIDER LINE ═══
                  Positioned(
                    top: halfH - 0.5,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 1.5,
                      decoration: BoxDecoration(
                        color: theme.dividerColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.5),
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  /// Builds a static half of the digit card.
  Widget _buildHalf({
    required String digit,
    required bool isTop,
    required FlipClockThemeData theme,
    required double width,
    required double height,
  }) {
    return ClipRect(
      child: Align(
        alignment: isTop ? Alignment.topCenter : Alignment.bottomCenter,
        heightFactor: 0.5,
        child: _buildCard(
          digit: digit,
          theme: theme,
          width: width,
          height: height * 2,
          isTop: isTop,
        ),
      ),
    );
  }

  /// Builds an animating (flipping) half with 3D perspective transform.
  Widget _buildFlippingHalf({
    required String digit,
    required bool isTop,
    required double angle,
    required FlipClockThemeData theme,
    required double width,
    required double height,
    bool isBottomFlip = false,
  }) {
    final transform = Matrix4.identity()
      ..setEntry(3, 2, 0.003) // perspective
      ..rotateX(isTop ? angle : -angle);

    return Positioned(
      top: isTop ? 0 : height,
      left: 0,
      right: 0,
      child: Transform(
        transform: transform,
        alignment: isTop ? Alignment.bottomCenter : Alignment.topCenter,
        child: Stack(
          children: [
            ClipRect(
              child: Align(
                alignment:
                    isTop ? Alignment.topCenter : Alignment.bottomCenter,
                heightFactor: 0.5,
                child: _buildCard(
                  digit: digit,
                  theme: theme,
                  width: width,
                  height: height * 2,
                  isTop: isTop,
                ),
              ),
            ),
            // Shadow overlay — darkens as the panel flips
            Positioned.fill(
              child: ClipRect(
                child: Align(
                  alignment:
                      isTop ? Alignment.topCenter : Alignment.bottomCenter,
                  heightFactor: 0.5,
                  child: Container(
                    width: width,
                    height: height * 2,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(
                        alpha: isTop
                            ? (_controller.value * 0.6).clamp(0.0, 0.6)
                            : ((1.0 - _controller.value) * 0.6)
                                .clamp(0.0, 0.6),
                      ),
                      borderRadius:
                          BorderRadius.circular(theme.borderRadius),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the full digit card (will be clipped to top/bottom half).
  Widget _buildCard({
    required String digit,
    required FlipClockThemeData theme,
    required double width,
    required double height,
    required bool isTop,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(theme.borderRadius),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            isTop ? theme.cardHighlight : theme.cardColor,
            isTop ? theme.cardColor : theme.cardColor,
          ],
        ),
        border: Border.all(
          color: theme.reflectionColor
              .withValues(alpha: theme.reflectionOpacity),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.5),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: theme.textGradient.length >= 2
                  ? theme.textGradient
                  : [theme.textColor, theme.textColor],
            ).createShader(bounds);
          },
          child: Text(
            digit,
            style: TextStyle(
              fontSize: height * 0.6,
              fontWeight: FontWeight.w800,
              color: Colors.white, // Masked by shader
              height: 1.0,
              fontFamily: 'monospace',
              shadows: [
                Shadow(
                  color: theme.glowColor
                      .withValues(alpha: theme.glowIntensity),
                  blurRadius: 12,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
