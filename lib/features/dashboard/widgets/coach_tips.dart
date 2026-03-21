import 'package:flutter/material.dart';

class CoachTip extends StatelessWidget {
  const CoachTip({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF64FFDA).withAlpha(26),
        border: Border.all(
          color: const Color(0xFF64FFDA).withAlpha(77),
        ),
        /*
        0.1 × 255 ≈ 25.5 → 26
        0.3 × 255 ≈ 76.5 → 77
        */
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        children: [
          Icon(Icons.lightbulb_outline, color: Color(0xFF64FFDA)),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "Coach Tip: Keep your chin parallel to the ground when walking to instantly boost perceived confidence.",
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
