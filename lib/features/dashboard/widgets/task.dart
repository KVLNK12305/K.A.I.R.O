import 'package:flutter/material.dart';
import '../../../core/models/task.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onChanged;

  const TaskTile({super.key, required this.task, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(8),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: task.isCompleted ? Colors.white54 : Colors.white10),
      ),
      child: CheckboxListTile(
        activeColor: Colors.white,
        checkColor: Colors.black,
        title: Text(
          task.title,
          style: TextStyle(
            color: task.isCompleted ? Colors.white38 : Colors.white,
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(task.category, style: const TextStyle(color: Colors.white30, fontSize: 10)),
        value: task.isCompleted,
        onChanged: (val) {
          task.isCompleted = val!;
          onChanged();
        },
      ),
    );
  }
}
