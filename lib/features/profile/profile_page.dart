import 'package:flutter/material.dart';
import 'widgets/metric_bar.dart';
import 'widgets/achievement_tile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("YOUR METRICS", style: TextStyle(letterSpacing: 2, fontSize: 14)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
          MetricBar(label: "Social Skills", value: 0.65, color: Colors.blue),
          MetricBar(label: "Physique", value: 0.80, color: Colors.green),
          MetricBar(label: "Style / Appearance", value: 0.45, color: Colors.purple),
          MetricBar(label: "Discipline", value: 0.90, color: Colors.red),
          SizedBox(height: 30),
          AchievementTile(title: "Early Riser", subtitle: "Woke up at 5AM for 7 days", unlocked: true),
          AchievementTile(title: "Iron Temple", subtitle: "Logged 20 workouts", unlocked: true),
          AchievementTile(title: "Social Butterfly", subtitle: "Approached 50 strangers", unlocked: false),
        ]),
      ),
    );
  }
}
