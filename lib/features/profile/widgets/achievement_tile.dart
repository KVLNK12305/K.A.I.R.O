import 'package:flutter/material.dart';

class AchievementTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool unlocked;

  const AchievementTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.unlocked,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(
            unlocked ? Icons.emoji_events : Icons.lock,
            color: unlocked ? Colors.amber : Colors.white12,
          ),
          const SizedBox(width: 16),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              title,
              style: TextStyle(color: unlocked ? Colors.white : Colors.white38),
            ),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.white24, fontSize: 10),
            ),
          ]),
        ],
      ),
    );
  }
}
