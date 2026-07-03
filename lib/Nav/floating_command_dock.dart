import 'dart:ui';
import 'package:flutter/material.dart';

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
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF0A0A0A).withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildNavItem(0, Icons.grid_view_rounded, 'HUB'),
              const SizedBox(width: 8),
              _buildNavItem(1, Icons.all_inbox_rounded, 'INBOX'),
              const SizedBox(width: 8),
              _buildNavItem(2, Icons.monitor_heart_outlined, 'BODY'),
              const SizedBox(width: 8),
              _buildNavItem(3, Icons.show_chart_rounded, 'TRUTH'),
              const SizedBox(width: 8),
              _buildNavItem(4, Icons.psychology_outlined, 'COACH'),
            ],
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
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutQuart,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 16 : 12,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2A2A2A) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? Colors.white : Colors.white38,
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
