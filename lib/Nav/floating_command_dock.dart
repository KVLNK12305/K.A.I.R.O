import 'dart:ui';
import 'package:flutter/material.dart';
import '../core/theme/kairo_design_system.dart';

class FloatingCommandDock extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onItemSelected;

  const FloatingCommandDock({
    super.key,
    required this.currentIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(KairoTheme.radiusLg),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF0C0C0C).withValues(alpha: 0.90),
              borderRadius: BorderRadius.circular(KairoTheme.radiusLg),
              border: Border.all(color: KairoTheme.borderActive, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.7),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildNavItem(0, Icons.adjust_rounded, 'TODAY'),
                const SizedBox(width: 4),
                _buildNavItem(1, Icons.hourglass_bottom_rounded, 'TIME'),
                const SizedBox(width: 4),
                _buildNavItem(2, Icons.account_balance_wallet_outlined, 'MONEY'),
                const SizedBox(width: 4),
                _buildNavItem(3, Icons.shield_outlined, 'WORK'),
                const SizedBox(width: 4),
                _buildNavItem(4, Icons.explore_outlined, 'REVIEW'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onItemSelected(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutQuart,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 12 : 8,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? KairoTheme.surfaceElevated : Colors.transparent,
          borderRadius: BorderRadius.circular(KairoTheme.radiusMd),
          border: isSelected ? Border.all(color: KairoTheme.borderActive, width: 1) : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? KairoTheme.textPrimary : KairoTheme.textMuted,
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: KairoTheme.textPrimary,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'monospace',
                  letterSpacing: 1,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
