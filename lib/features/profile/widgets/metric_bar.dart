import 'package:flutter/material.dart';

class MetricBar extends StatelessWidget {
  final String label;
  final double value;
  final Color color;

  const MetricBar({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
            Text("${(value * 100).toInt()}%", style: const TextStyle(color: Colors.white70)),
          ],
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: value,
          minHeight: 6,
          backgroundColor: Colors.white10,
          color: color,
          borderRadius: BorderRadius.circular(3),
        ),
      ]),
    );
  }
}
