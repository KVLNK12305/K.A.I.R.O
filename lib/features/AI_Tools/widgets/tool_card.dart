import 'package:flutter/material.dart';
import '../mock_scanner.dart';

class ToolCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;

  const ToolCard({super.key, required this.icon, required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => MockScannerPage(title: title, accent: color)),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(13),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
