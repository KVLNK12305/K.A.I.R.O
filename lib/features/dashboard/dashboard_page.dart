import 'package:flutter/material.dart';
import '../../core/models/task.dart';
import 'widgets/task.dart';
import 'widgets/coach_tips.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final List<Task> _tasks = [
    Task("50 Pushups (Chest Focus)", "Fitness"),
    Task("Approach 1 stranger today", "Social"),
    Task("Wear fitted plain tee", "Style"),
    Task("Read 10 pages (Stoicism)", "Mindset"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("TODAY'S BLUEPRINT", style: TextStyle(fontSize: 14, letterSpacing: 2)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text("WEEK 12: CONFIDENCE BUILDER", style: TextStyle(color: Colors.white54, fontSize: 10)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (i) {
              final active = i == 3;
              final done = i < 3;
              return Container(
                width: 40,
                height: 60,
                decoration: BoxDecoration(
                  color: active ? Colors.white : (done ? Colors.white24 : Colors.black),
                  border: Border.all(color: Colors.white24),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    ["M", "T", "W", "T", "F", "S", "S"][i],
                    style: TextStyle(
                      color: active ? Colors.black : Colors.white54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 30),
          const Text("DAILY OBJECTIVES", style: TextStyle(color: Colors.white54, letterSpacing: 1)),
          const SizedBox(height: 10),
          ..._tasks.map((t) => TaskTile(task: t, onChanged: () => setState(() {}))),
          const SizedBox(height: 30),
          const CoachTip(),
        ]),
      ),
    );
  }
}
