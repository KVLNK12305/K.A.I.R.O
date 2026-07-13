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
            color: task.carryForwardCount >= 2
                ? Colors.orangeAccent.withValues(alpha: 0.6)
                : (task.isCompleted ? Colors.white54 : Colors.white10),
          ),
        ),
        clipBehavior: Clip.antiAlias,
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
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Wrap(
              spacing: 6,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  task.category,
                  style: const TextStyle(color: Colors.white30, fontSize: 10),
                ),
                if (task.subTasks.isNotEmpty)
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
                if (task.progressPercent > 0 && !task.isCompleted)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.greenAccent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: Colors.greenAccent.withValues(alpha: 0.4),
                        width: 0.5,
                      ),
                    ),
                    child: Text(
                      '${task.progressPercent}% DONE',
                      style: const TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                if (task.isCarriedForward)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: (task.carryForwardCount >= 2 ? Colors.redAccent : Colors.orangeAccent)
                          .withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: (task.carryForwardCount >= 2 ? Colors.redAccent : Colors.orangeAccent)
                            .withValues(alpha: 0.4),
                        width: 0.5,
                      ),
                    ),
                    child: Text(
                      task.carryForwardCount >= 2
                          ? 'CARRIED ×${task.carryForwardCount} • EXECUTE OR KILL'
                          : 'CARRIED ×${task.carryForwardCount}',
                      style: TextStyle(
                        color: task.carryForwardCount >= 2 ? Colors.redAccent : Colors.orangeAccent,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
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