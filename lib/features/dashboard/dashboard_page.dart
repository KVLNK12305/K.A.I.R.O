import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'dart:io';

import 'providers/task_provider.dart';
import '../wardrobe/providers/wardrobe_provider.dart';
import 'widgets/task.dart';
import 'widgets/coach_tips.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(taskProvider);
    final wardrobe = ref.watch(wardrobeProvider);
    final now = DateTime.now();
    final currentDayIndex = now.weekday - 1; // 0 = Mon, 6 = Sun
    final weekStart = now.subtract(Duration(days: currentDayIndex));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("TODAY'S BLUEPRINT", style: TextStyle(fontSize: 14, letterSpacing: 2)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("WEEK OF ${DateFormat('MMMM d').format(weekStart)}".toUpperCase(), style: const TextStyle(color: Colors.white54, fontSize: 10)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (i) {
              final active = i == currentDayIndex;
              final done = i < currentDayIndex;
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
          // Google Events Timeline
          if (state.googleEvents.isNotEmpty) ...[
            const SizedBox(height: 30),
            const Text("TODAY'S SCHEDULE", style: TextStyle(color: Colors.white54, letterSpacing: 1)),
            const SizedBox(height: 10),
            ...state.googleEvents.map((e) {
              final start = e.start?.dateTime?.toLocal() ?? DateTime.now();
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withAlpha(20),
                  border: Border.all(color: Colors.blue.withAlpha(40)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Text(DateFormat('h:mm a').format(start), style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 12)),
                    const SizedBox(width: 16),
                    Expanded(child: Text(e.summary ?? "Busy", style: const TextStyle(color: Colors.white))),
                  ],
                ),
              );
            }),
          ],

          const SizedBox(height: 30),
          const Text("DAILY OBJECTIVES", style: TextStyle(color: Colors.white54, letterSpacing: 1)),
          const SizedBox(height: 10),
          
          if (state.isLoading)
            const Center(child: CircularProgressIndicator(color: Colors.white24)),

          // Render nothing or a placeholder message if database is empty
          if (!state.isLoading && state.isarTasks.isEmpty && state.googleTasks.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                "No objectives yet. Share ideas from Gemini to add them here!",
                style: TextStyle(color: Colors.white30, fontSize: 12),
              ),
            ),

          // Google Tasks
          ...state.googleTasks.map((t) => ListTile(
            leading: const Icon(Icons.check_box_outline_blank, color: Colors.white38),
            title: Text(t.title ?? "Task", style: const TextStyle(color: Colors.white)),
            subtitle: const Text("Google Tasks", style: TextStyle(color: Colors.white30, fontSize: 10)),
            contentPadding: EdgeInsets.zero,
          )),

          // Maps over persistent tasks from database
          ...state.isarTasks.map((t) => TaskTile(
                task: t, 
                onChanged: () {
                  ref.read(taskProvider.notifier).updateTask(t);
                },
              )),

          if (wardrobe.outfitOfTheDay != null) ...[
            const SizedBox(height: 30),
            const Text("OUTFIT OF THE DAY", style: TextStyle(color: Colors.white54, letterSpacing: 1)),
            const SizedBox(height: 10),
            Container(
              height: 120,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white24),
              ),
              child: Row(
                children: [
                  _buildOutfitImage(wardrobe.outfitOfTheDay!.top.localImagePath),
                  _buildOutfitImage(wardrobe.outfitOfTheDay!.bottom.localImagePath),
                  if (wardrobe.outfitOfTheDay!.shoes != null)
                    _buildOutfitImage(wardrobe.outfitOfTheDay!.shoes!.localImagePath),
                ],
              ),
            ),
          ],

          const SizedBox(height: 30),
          const CoachTip(),
        ]),
      ),
    );
  }

  Widget _buildOutfitImage(String path) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: const Border(right: BorderSide(color: Colors.black)),
          image: DecorationImage(
            image: FileImage(File(path)),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}