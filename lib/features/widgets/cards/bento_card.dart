import 'package:flutter/material.dart';

/// Reusable Bento Box Card container for K.A.I.R.O.
/// Supports both sleek glassmorphism and modern Neo-Pastel color-block editorial styles.
class BentoCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? borderColor;
  final Color? backgroundColor;
  final double borderRadius;
  final VoidCallback? onTap;

  const BentoCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.borderColor,
    this.backgroundColor,
    this.borderRadius = 20.0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBorderColor = borderColor ?? Colors.white.withValues(alpha: 0.1);
    final effectiveBgColor = backgroundColor ?? const Color(0xFF141418);

    final cardChild = Container(
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: effectiveBgColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: effectiveBorderColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: cardChild,
      );
    }

    return cardChild;
  }
}
