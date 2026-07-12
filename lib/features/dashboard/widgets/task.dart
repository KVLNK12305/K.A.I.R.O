import 'package:flutter/material.dart';
import '../../../core/models/task.dart';


class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onChanged;

  const TaskTile({super.key, required this.task, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Use Padding instead of Container's margin
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        // Move your background color and shape here
        color: Colors.white.withAlpha(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: task.isCompleted ? Colors.white54 : Colors.white10,
          ),
        ),
        clipBehavior: Clip.antiAlias, // Ensures the splash doesn't bleed outside the rounded corners
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
          subtitle: Row(
            children: [
              Text(
                task.category,
                style: const TextStyle(color: Colors.white30, fontSize: 10),
              ),
              if (task.subTasks.isNotEmpty) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${task.completedSubTasks.length}/${task.subTasks.length} SUBTASKS',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
          value: task.isCompleted,
          onChanged: (val) {
            if (val != null) {
              task.isCompleted = val;
              onChanged();
            }
          },
        ),
      ),
    );
  }
}