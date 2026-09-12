import 'package:flutter/material.dart';

/// K.A.I.R.O. Design System Tokens & Semantic Primitives
/// Principles: Sharp, Sparse, Editorial, High Information Density, Zero Slop.
class KairoTheme {
  // ─── Semantic Palette ───
  static const Color background = Color(0xFF000000); // Pure Black
  static const Color surface = Color(0xFF0D0D0D);    // Deep Charcoal
  static const Color surfaceElevated = Color(0xFF161616); // Modals / Inputs / Elevated
  static const Color border = Color(0xFF222222);     // 1px Hairline Border
  static const Color borderActive = Color(0xFF383838);

  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xB3FFFFFF); // 70%
  static const Color textMuted = Color(0x61FFFFFF);     // 38%
  static const Color textFaint = Color(0x38FFFFFF);     // 22%

  // ─── Epistemic Source Colors ───
  static const Color observed = Color(0xFF8DC0FA);    // Pastel Blue: Active device telemetry
  static const Color inferred = Color(0xFFD1C4E9);    // Pastel Purple: Baseline model inference
  static const Color recommended = Color(0xFFFAD168); // Pastel Amber: Action guidance / priority
  static const Color success = Color(0xFFC7F3C6);     // Pastel Mint: Verifiable completion
  static const Color warning = Color(0xFFFF6B6B);     // Muted Coral Red: Divergence / risk

  // ─── Spacing Scale ───
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 28.0;

  // ─── Corner Radii (Disciplined, Non-Bubbly) ───
  static const double radiusSm = 4.0;
  static const double radiusMd = 8.0;
  static const double radiusLg = 12.0;

  // ─── Typography Presets ───
  static const TextStyle display = TextStyle(
    color: textPrimary,
    fontSize: 26,
    fontWeight: FontWeight.w900,
    letterSpacing: -0.5,
  );

  static const TextStyle title = TextStyle(
    color: textPrimary,
    fontSize: 18,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.2,
  );

  static const TextStyle sectionHeader = TextStyle(
    color: textMuted,
    fontSize: 10,
    fontWeight: FontWeight.w800,
    fontFamily: 'monospace',
    letterSpacing: 1.5,
  );

  static const TextStyle monoNumber = TextStyle(
    color: textPrimary,
    fontSize: 20,
    fontWeight: FontWeight.w900,
    fontFamily: 'monospace',
  );

  static const TextStyle body = TextStyle(
    color: textSecondary,
    fontSize: 13,
    height: 1.4,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle meta = TextStyle(
    color: textMuted,
    fontSize: 11,
    fontWeight: FontWeight.w500,
  );
}

/// Minimalist Card Container with sharp corners and hairline border
class KairoCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final Color? borderColor;
  final VoidCallback? onTap;

  const KairoCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(KairoTheme.lg),
    this.backgroundColor,
    this.borderColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? KairoTheme.surface,
        borderRadius: BorderRadius.circular(KairoTheme.radiusMd),
        border: Border.all(color: borderColor ?? KairoTheme.border, width: 1),
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: card,
      );
    }
    return card;
  }
}

/// Sparse, tracked section header with optional trailing action
class KairoSectionHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final EdgeInsetsGeometry padding;

  const KairoSectionHeader({
    super.key,
    required this.title,
    this.trailing,
    this.padding = const EdgeInsets.fromLTRB(KairoTheme.xl, KairoTheme.xl, KairoTheme.xl, KairoTheme.sm),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title.toUpperCase(),
              style: KairoTheme.sectionHeader,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 8),
            trailing!,
          ],
        ],
      ),
    );
  }
}

/// Metric display with source annotation (Observed, Inferred, Calendar)
class KairoMetric extends StatelessWidget {
  final String label;
  final String value;
  final String? unit;
  final String? subtitle;
  final Color? accentColor;
  final String? sourceTag; // e.g. "OBSERVED", "INFERRED", "CALENDAR"

  const KairoMetric({
    super.key,
    required this.label,
    required this.value,
    this.unit,
    this.subtitle,
    this.accentColor,
    this.sourceTag,
  });

  @override
  Widget build(BuildContext context) {
    final color = accentColor ?? KairoTheme.textPrimary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label.toUpperCase(), style: KairoTheme.sectionHeader),
            if (sourceTag != null) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Text(
                  sourceTag!,
                  style: TextStyle(
                    color: color,
                    fontSize: 8,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.w900,
                fontFamily: 'monospace',
              ),
            ),
            if (unit != null) ...[
              const SizedBox(width: 4),
              Text(unit!, style: TextStyle(color: color.withValues(alpha: 0.6), fontSize: 11, fontWeight: FontWeight.bold)),
            ],
          ],
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 2),
          Text(subtitle!, style: KairoTheme.meta, maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ],
    );
  }
}

enum KairoStatusType {
  observed,
  inferred,
  recommended,
  success,
  warning,
  muted,
}

/// Semantic Status Chip with sharp borders
class KairoStatus extends StatelessWidget {
  final String label;
  final Color? color;
  final KairoStatusType? type;

  const KairoStatus({
    super.key,
    required this.label,
    this.color,
    this.type,
  });

  Color _resolveColor() {
    if (color != null) return color!;
    switch (type) {
      case KairoStatusType.observed:
        return KairoTheme.observed;
      case KairoStatusType.inferred:
        return KairoTheme.inferred;
      case KairoStatusType.recommended:
        return KairoTheme.recommended;
      case KairoStatusType.success:
        return KairoTheme.success;
      case KairoStatusType.warning:
        return KairoTheme.warning;
      case KairoStatusType.muted:
      default:
        return KairoTheme.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = _resolveColor();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: activeColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(KairoTheme.radiusSm),
        border: Border.all(color: activeColor.withValues(alpha: 0.3), width: 1),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: activeColor,
          fontSize: 9,
          fontWeight: FontWeight.w900,
          fontFamily: 'monospace',
          letterSpacing: 0.8,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

/// Editorial Button with sharp borders and restrained style
class KairoButton extends StatelessWidget {
  final String? label;
  final String? text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isPrimary;
  final bool isFullWidth;
  final bool isLoading;

  const KairoButton({
    super.key,
    this.label,
    this.text,
    required this.onPressed,
    this.icon,
    this.isPrimary = true,
    this.isFullWidth = false,
    this.isLoading = false,
  });

  String get _buttonText => (text ?? label ?? '').toUpperCase();

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (isLoading) {
      content = const SizedBox(
        height: 14,
        width: 14,
        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
      );
    } else if (icon != null) {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 15),
          const SizedBox(width: 8),
          Flexible(child: Text(_buttonText, maxLines: 1, overflow: TextOverflow.ellipsis)),
        ],
      );
    } else {
      content = Text(_buttonText);
    }

    final btnStyle = isPrimary
        ? ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(KairoTheme.radiusSm)),
            textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1.1, fontFamily: 'monospace'),
          )
        : OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            side: const BorderSide(color: KairoTheme.border, width: 1),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(KairoTheme.radiusSm)),
            textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1.1, fontFamily: 'monospace'),
          );

    final widget = isPrimary
        ? ElevatedButton(onPressed: isLoading ? null : onPressed, style: btnStyle, child: content)
        : OutlinedButton(onPressed: isLoading ? null : onPressed, style: btnStyle, child: content);

    if (isFullWidth) {
      return SizedBox(width: double.infinity, child: widget);
    }
    return widget;
  }
}

/// 1px Hairline Divider
class KairoDivider extends StatelessWidget {
  final double verticalMargin;
  final EdgeInsetsGeometry? margin;
  const KairoDivider({super.key, this.verticalMargin = KairoTheme.lg, this.margin});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.symmetric(vertical: verticalMargin),
      child: const Divider(height: 1, color: KairoTheme.border),
    );
  }
}

/// Honest Empty State (No pretend data)
class KairoEmptyState extends StatelessWidget {
  final String title;
  final String description;
  final Widget? action;

  const KairoEmptyState({
    super.key,
    required this.title,
    required this.description,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(KairoTheme.xxl),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title.toUpperCase(),
              style: const TextStyle(
                color: KairoTheme.textMuted,
                fontSize: 12,
                fontWeight: FontWeight.w800,
                fontFamily: 'monospace',
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: KairoTheme.textFaint,
                fontSize: 12,
                height: 1.4,
              ),
            ),
            if (action != null) ...[
              const SizedBox(height: 16),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
