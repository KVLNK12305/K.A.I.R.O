import 'package:flutter/material.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:isar/isar.dart';
import 'dart:async';

import '../../core/models/task.dart';
import 'widgets/task.dart';
import 'widgets/coach_tips.dart';
// Import your main.dart file here to access your global 'isar' instance
import '../../main.dart'; 

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late StreamSubscription<List<SharedMediaFile>> _intentDataStreamSubscription;

  // Changed to a non-final list that starts empty and populates from Isar
  List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();

    // 1. Load saved tasks from the database immediately when the page opens
    _loadTasks();

    // 2. Listen for shared data while the app is running in the background
    _intentDataStreamSubscription = ReceiveSharingIntent.instance.getMediaStream().listen((List<SharedMediaFile> value) {
      if (value.isNotEmpty && value.first.type == SharedMediaType.text) {
        _handleSharedText(value.first.path);
      }
    });

    // 3. Catch shared data if the app was completely closed
    ReceiveSharingIntent.instance.getInitialMedia().then((List<SharedMediaFile> value) {
      if (value.isNotEmpty && value.first.type == SharedMediaType.text) {
        _handleSharedText(value.first.path);
        
        // Clear the intent so it doesn't duplicate the task if you hot restart
        ReceiveSharingIntent.instance.reset(); 
      }
    });
  }

  // Reads all tasks stored in the Isar database
  Future<void> _loadTasks() async {
    final tasksFromDB = await isar.tasks.where().findAll();
    setState(() {
      _tasks = tasksFromDB;
    });
  }

  // Catches the text, writes it to Isar, and updates the view
  void _handleSharedText(String text) async {
    final newTask = Task(text, "AI Suggestion");

    // All Isar writes must happen inside a write transaction
    await isar.writeTxn(() async {
      await isar.tasks.put(newTask);
    });

    // Refresh our local state list from the database
    _loadTasks();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Blueprint updated from Share!'),
        backgroundColor: Colors.white24,
      ),
    );
  }

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    super.dispose();
  }

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
          
          // Render nothing or a placeholder message if database is empty
          if (_tasks.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                "No objectives yet. Share ideas from Gemini to add them here!",
                style: TextStyle(color: Colors.white30, fontSize: 12),
              ),
            ),

          // Maps over persistent tasks from database
          ..._tasks.map((t) => TaskTile(
                task: t, 
                onChanged: () async {
                  // Save the checkbox state modification directly to Isar
                  await isar.writeTxn(() async {
                    await isar.tasks.put(t);
                  });
                  // Trigger UI refresh to show checked/line-through styling
                  setState(() {});
                },
              )),
          const SizedBox(height: 30),
          const CoachTip(),
        ]),
      ),
    );
  }
}