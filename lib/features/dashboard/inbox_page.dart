import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'providers/ms_todo_provider.dart';
import '../../core/theme/app_theme.dart';

class InboxPage extends ConsumerWidget {
  const InboxPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(msTodoProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        title: const Text('STAGING INBOX', style: TextStyle(fontSize: 12, letterSpacing: 2)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white54, size: 20),
            onPressed: () => ref.read(msTodoProvider.notifier).fetchTasks(),
          )
        ],
      ),
      floatingActionButton: state.isAuthenticated && state.lists.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.only(bottom: 80.0),
              child: FloatingActionButton(
                backgroundColor: Colors.white10,
                elevation: 0,
                onPressed: () => _showTaskSheet(context, ref, state.lists),
                child: const Icon(Icons.add, color: Colors.white),
              ),
            )
          : null,
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white24))
          : !state.isAuthenticated
              ? _buildAuthPrompt(ref)
              : state.error != null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
                            const SizedBox(height: 16),
                            Text(
                              state.error!,
                              style: const TextStyle(color: Colors.redAccent),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.white10),
                              icon: const Icon(Icons.logout, color: Colors.white),
                              label: const Text('SIGN OUT & RESET', style: TextStyle(color: Colors.white)),
                              onPressed: () => ref.read(msTodoProvider.notifier).logout(),
                            ),
                          ],
                        ),
                      ),
                    )
                  : state.lists.every((list) => list.tasks.isEmpty)
                      ? _buildEmptyState()
                      : _buildTaskList(context, ref, state.lists),
    );
  }

  void _showTaskSheet(
    BuildContext context,
    WidgetRef ref,
    List<MsTodoList> lists, {
    MsTodoList? initialList,
    MsTodoTask? existingTask,
  }) {
    final isEditing = existingTask != null;
    String selectedListId = initialList?.id ?? lists.first.id;
    final taskController = TextEditingController(text: existingTask?.title ?? '');
    final notesController = TextEditingController(text: existingTask?.body ?? '');
    
    DateTime? selectedDueDate = existingTask?.dueDate;
    DateTime? selectedReminderDate = existingTask?.reminderDateTime;
    bool isReminderOn = existingTask?.isReminderOn ?? false;
    String selectedImportance = existingTask?.importance ?? 'normal';
    final subtaskController = TextEditingController();
    List<String> subTasks = existingTask?.subTasks.map((s) => s.title).toList() ?? [];
    Set<String> completedSubTasks = existingTask?.subTasks
            .where((s) => s.isChecked)
            .map((s) => s.title)
            .toSet() ??
        {};

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Color(0xFF0F0F0F),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  border: Border(top: BorderSide(color: Color(0xFF2A2A2A))),
                ),
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isEditing ? 'EDIT TASK' : 'NEW TASK',
                          style: const TextStyle(
                            color: Colors.white38,
                            fontSize: 10,
                            letterSpacing: 2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (!isEditing) ...[
                          DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedListId,
                              dropdownColor: const Color(0xFF1A1A1A),
                              isExpanded: true,
                              icon: const Icon(Icons.arrow_drop_down, color: Colors.white38),
                              style: const TextStyle(color: Colors.white70, fontSize: 14),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    selectedListId = newValue;
                                  });
                                }
                              },
                              items: lists.map<DropdownMenuItem<String>>((MsTodoList list) {
                                return DropdownMenuItem<String>(
                                  value: list.id,
                                  child: Text(list.name),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                        TextField(
                          controller: taskController,
                          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          autofocus: !isEditing,
                          decoration: InputDecoration(
                            hintText: "What needs to be done?",
                            hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.2)),
                            border: InputBorder.none,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // IMPORTANCE SELECTOR
                        const Text(
                          'IMPORTANCE',
                          style: TextStyle(color: Colors.white38, fontSize: 10, letterSpacing: 1.5),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: ['low', 'normal', 'high'].map((imp) {
                            final isSelected = selectedImportance == imp;
                            Color accentColor = Colors.white54;
                            if (imp == 'high') accentColor = Colors.redAccent;
                            if (imp == 'low') accentColor = Colors.blueAccent;
                            
                            return Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => selectedImportance = imp),
                                child: Container(
                                  margin: EdgeInsets.only(right: imp != 'high' ? 8 : 0),
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: isSelected ? accentColor.withValues(alpha: 0.2) : const Color(0xFF1A1A1A),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: isSelected ? accentColor : const Color(0xFF2A2A2A),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    imp.toUpperCase(),
                                    style: TextStyle(
                                      color: isSelected ? accentColor : Colors.white54,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),
                        // DUE DATE PICKER
                        _buildPickerRow(
                          icon: Icons.calendar_today_outlined,
                          label: 'DUE DATE',
                          valueText: selectedDueDate != null
                              ? DateFormat('EEE, MMM d, y').format(selectedDueDate!)
                              : 'None',
                          onTap: () async {
                            final now = DateTime.now();
                            final date = await showDatePicker(
                              context: context,
                              initialDate: selectedDueDate ?? now,
                              firstDate: now.subtract(const Duration(days: 365)),
                              lastDate: now.add(const Duration(days: 365 * 5)),
                              builder: (context, child) => Theme(
                                data: ThemeData.dark().copyWith(
                                  colorScheme: const ColorScheme.dark(
                                    primary: Colors.white,
                                    onPrimary: Colors.black,
                                    surface: Color(0xFF1A1A1A),
                                  ),
                                ),
                                child: child!,
                              ),
                            );
                            if (date != null) {
                              setState(() {
                                selectedDueDate = DateTime(
                                  date.year,
                                  date.month,
                                  date.day,
                                );
                              });
                            }
                          },
                          onClear: selectedDueDate != null ? () => setState(() => selectedDueDate = null) : null,
                        ),
                        const SizedBox(height: 12),
                        // REMINDER PICKER
                        _buildPickerRow(
                          icon: Icons.notifications_none_outlined,
                          label: 'REMINDER',
                          valueText: isReminderOn && selectedReminderDate != null
                              ? DateFormat('EEE, MMM d - h:mm a').format(selectedReminderDate!)
                              : 'None',
                          onTap: () async {
                            final now = DateTime.now();
                            final date = await showDatePicker(
                              context: context,
                              initialDate: selectedReminderDate ?? now,
                              firstDate: now,
                              lastDate: now.add(const Duration(days: 365 * 5)),
                              builder: (context, child) => Theme(
                                data: ThemeData.dark().copyWith(
                                  colorScheme: const ColorScheme.dark(
                                    primary: Colors.white,
                                    onPrimary: Colors.black,
                                    surface: Color(0xFF1A1A1A),
                                  ),
                                ),
                                child: child!,
                              ),
                            );
                            if (date != null) {
                              if (!context.mounted) return;
                              final time = await showTimePicker(
                                context: context,
                                initialTime: selectedReminderDate != null
                                    ? TimeOfDay.fromDateTime(selectedReminderDate!)
                                    : const TimeOfDay(hour: 9, minute: 0),
                                builder: (context, child) => Theme(
                                  data: ThemeData.dark().copyWith(
                                    colorScheme: const ColorScheme.dark(
                                      primary: Colors.white,
                                      onPrimary: Colors.black,
                                      surface: Color(0xFF1A1A1A),
                                    ),
                                  ),
                                  child: child!,
                                ),
                              );
                              if (time != null) {
                                setState(() {
                                  selectedReminderDate = DateTime(
                                    date.year,
                                    date.month,
                                    date.day,
                                    time.hour,
                                    time.minute,
                                  );
                                  isReminderOn = true;
                                });
                              }
                            }
                          },
                          onClear: isReminderOn ? () => setState(() {
                            isReminderOn = false;
                            selectedReminderDate = null;
                          }) : null,
                        ),
                        const SizedBox(height: 20),
                        // NOTES FIELD
                        const Text(
                          'NOTES',
                          style: TextStyle(color: Colors.white38, fontSize: 10, letterSpacing: 1.5),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A1A1A),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFF2A2A2A)),
                          ),
                          child: TextField(
                            controller: notesController,
                            style: const TextStyle(color: Colors.white70, fontSize: 14),
                            maxLines: 4,
                            minLines: 2,
                            decoration: InputDecoration(
                              hintText: "Add notes, details or links...",
                              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.2)),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // SUBTASKS FIELD & CHECKLIST
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'SUBTASKS / EXECUTION CHECKLIST',
                              style: TextStyle(color: Colors.white38, fontSize: 10, letterSpacing: 1.5),
                            ),
                            if (subTasks.isNotEmpty)
                              Text(
                                '${completedSubTasks.length}/${subTasks.length} COMPLETED',
                                style: const TextStyle(color: AppTheme.accent, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1A1A1A),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: const Color(0xFF2A2A2A)),
                                ),
                                child: TextField(
                                  controller: subtaskController,
                                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                                  decoration: InputDecoration(
                                    hintText: "Add step to checklist...",
                                    hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.2)),
                                    border: InputBorder.none,
                                  ),
                                  onSubmitted: (val) {
                                    final text = val.trim();
                                    if (text.isNotEmpty) {
                                      setState(() {
                                        subTasks.add(text);
                                        subtaskController.clear();
                                      });
                                      if (existingTask != null && initialList != null) {
                                        ref.read(msTodoProvider.notifier).addChecklistItem(
                                          initialList.id,
                                          existingTask.id,
                                          text,
                                        );
                                      }
                                    }
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              style: IconButton.styleFrom(
                                backgroundColor: const Color(0xFF2A2A2A),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              icon: const Icon(Icons.add, color: Colors.white, size: 20),
                              onPressed: () {
                                final text = subtaskController.text.trim();
                                if (text.isNotEmpty) {
                                  setState(() {
                                    subTasks.add(text);
                                    subtaskController.clear();
                                  });
                                  if (existingTask != null && initialList != null) {
                                    ref.read(msTodoProvider.notifier).addChecklistItem(
                                      initialList.id,
                                      existingTask.id,
                                      text,
                                    );
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                        if (subTasks.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF141414),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.white10),
                            ),
                            child: Column(
                              children: subTasks.asMap().entries.map((entry) {
                                final idx = entry.key;
                                final st = entry.value;
                                final isDone = completedSubTasks.contains(st);
                                return CheckboxListTile(
                                  dense: true,
                                  activeColor: AppTheme.accent,
                                  checkColor: Colors.black,
                                  title: Text(
                                    st,
                                    style: TextStyle(
                                      color: isDone ? Colors.white38 : Colors.white70,
                                      fontSize: 13,
                                      decoration: isDone ? TextDecoration.lineThrough : null,
                                    ),
                                  ),
                                  value: isDone,
                                  onChanged: (val) {
                                    setState(() {
                                      if (val == true) {
                                        completedSubTasks.add(st);
                                      } else {
                                        completedSubTasks.remove(st);
                                      }
                                    });
                                    if (existingTask != null && initialList != null) {
                                      final msItem = existingTask.subTasks
                                          .where((item) => item.title == st)
                                          .firstOrNull;
                                      if (msItem != null) {
                                        ref.read(msTodoProvider.notifier).toggleChecklistItem(
                                          initialList.id,
                                          existingTask.id,
                                          msItem.id,
                                          val == true,
                                        );
                                      }
                                    }
                                  },
                                  secondary: IconButton(
                                    icon: const Icon(Icons.close, color: Colors.white38, size: 16),
                                    onPressed: () {
                                      setState(() {
                                        subTasks.removeAt(idx);
                                        completedSubTasks.remove(st);
                                      });
                                      if (existingTask != null && initialList != null) {
                                        final msItem = existingTask.subTasks
                                            .where((item) => item.title == st)
                                            .firstOrNull;
                                        if (msItem != null) {
                                          ref.read(msTodoProvider.notifier).deleteChecklistItem(
                                            initialList.id,
                                            existingTask.id,
                                            msItem.id,
                                          );
                                        }
                                      }
                                    },
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: () {
                              final titleText = taskController.text.trim();
                              if (titleText.isNotEmpty) {
                                if (isEditing) {
                                  ref.read(msTodoProvider.notifier).updateTask(
                                    selectedListId,
                                    existingTask.id,
                                    title: titleText,
                                    dueDate: selectedDueDate,
                                    clearDueDate: selectedDueDate == null && existingTask.dueDate != null,
                                    reminderDateTime: selectedReminderDate,
                                    clearReminder: !isReminderOn && existingTask.isReminderOn,
                                    isReminderOn: isReminderOn,
                                    importance: selectedImportance,
                                    body: notesController.text.trim(),
                                    clearBody: notesController.text.trim().isEmpty && (existingTask.body?.isNotEmpty ?? false),
                                  );
                                } else {
                                  ref.read(msTodoProvider.notifier).createTask(
                                    selectedListId,
                                    titleText,
                                    dueDate: selectedDueDate,
                                    reminderDateTime: selectedReminderDate,
                                    isReminderOn: isReminderOn,
                                    importance: selectedImportance,
                                    body: notesController.text.trim(),
                                  );
                                }
                                Navigator.pop(ctx);
                              }
                            },
                            child: Text(
                              isEditing ? 'UPDATE TASK' : 'SAVE TASK',
                              style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        );
      },
    );
  }

  Widget _buildPickerRow({
    required IconData icon,
    required String label,
    required String valueText,
    required VoidCallback onTap,
    VoidCallback? onClear,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF2A2A2A)),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white54, size: 18),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                valueText,
                textAlign: TextAlign.right,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
            if (onClear != null) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onClear,
                behavior: HitTestBehavior.opaque,
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(Icons.close, color: Colors.white38, size: 16),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAuthPrompt(WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.lock_outline, color: Colors.white38, size: 64),
          const SizedBox(height: 24),
          const Text('MICROSOFT TO DO', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 2)),
          const SizedBox(height: 8),
          const Text('Connect your account to sync tasks.', style: TextStyle(color: Colors.white38)),
          const SizedBox(height: 32),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0078D4)),
            onPressed: () => ref.read(msTodoProvider.notifier).login(),
            child: const Text('CONNECT ACCOUNT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.done_all, color: Colors.white24, size: 64),
          SizedBox(height: 16),
          Text('INBOX CLEAR', style: TextStyle(color: Colors.white60, fontSize: 16, letterSpacing: 2, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }

  Widget _buildTaskList(BuildContext context, WidgetRef ref, List<MsTodoList> lists) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 16, bottom: 120),
      itemCount: lists.length,
      itemBuilder: (ctx, idx) {
        final list = lists[idx];
        if (list.tasks.isEmpty) return const SizedBox.shrink(); // Skip empty lists
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Text(
                list.name.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 10,
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...list.tasks.map((task) {
              final isOverdue = task.dueDate != null && task.dueDate!.isBefore(DateTime.now()) && !task.isCompleted;
              final isHighImportance = task.importance == 'high';

              return Dismissible(
                key: Key(task.id),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  ref.read(msTodoProvider.notifier).deleteTask(list.id, task.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Task deleted', style: TextStyle(color: Colors.white)),
                      backgroundColor: Color(0xFF2A2A2A),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                background: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete_outline, color: Colors.redAccent),
                ),
                child: GestureDetector(
                  onTap: () => _showTaskSheet(context, ref, lists, initialList: list, existingTask: task),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF111111),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isOverdue
                            ? Colors.redAccent.withValues(alpha: 0.6)
                            : isHighImportance
                                ? Colors.amber.withValues(alpha: 0.4)
                                : const Color(0xFF2A2A2A),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                ref.read(msTodoProvider.notifier).completeTask(list.id, task.id);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(top: 2.0),
                                child: Icon(
                                  Icons.circle_outlined,
                                  color: isOverdue ? Colors.redAccent : Colors.white38,
                                  size: 20,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    task.title,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: isHighImportance ? FontWeight.bold : FontWeight.normal,
                                    ),
                                  ),
                                  if (task.body != null && task.body!.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      task.body!,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(color: Colors.white54, fontSize: 12),
                                    ),
                                  ],
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 6,
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    children: [
                                      if (task.dueDate != null)
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: isOverdue
                                                ? Colors.redAccent.withValues(alpha: 0.2)
                                                : Colors.white10,
                                            borderRadius: BorderRadius.circular(4),
                                            border: Border.all(
                                              color: isOverdue ? Colors.redAccent : Colors.white24,
                                              width: 0.5,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.calendar_today,
                                                size: 10,
                                                color: isOverdue ? Colors.redAccent : Colors.white70,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                DateFormat('MMM d').format(task.dueDate!),
                                                style: TextStyle(
                                                  color: isOverdue ? Colors.redAccent : Colors.white70,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      if (task.isReminderOn && task.reminderDateTime != null)
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.notifications_active, size: 12, color: Colors.amber.withValues(alpha: 0.8)),
                                            const SizedBox(width: 4),
                                            Text(
                                              DateFormat('MMM d, h:mm a').format(task.reminderDateTime!),
                                              style: TextStyle(color: Colors.amber.withValues(alpha: 0.8), fontSize: 11),
                                            ),
                                          ],
                                        ),
                                      if (task.importance == 'high')
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.redAccent.withValues(alpha: 0.15),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: const Text(
                                            'HIGH',
                                            style: TextStyle(
                                              color: Colors.redAccent,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        )
                                      else if (task.importance == 'low')
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.blueAccent.withValues(alpha: 0.15),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: const Text(
                                            'LOW',
                                            style: TextStyle(
                                              color: Colors.blueAccent,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ),
                                      if (task.subTasks.isNotEmpty)
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: AppTheme.accent.withValues(alpha: 0.15),
                                            borderRadius: BorderRadius.circular(4),
                                            border: Border.all(color: AppTheme.accent.withValues(alpha: 0.4), width: 0.5),
                                          ),
                                          child: Text(
                                            '${task.subTasks.where((s) => s.isChecked).length}/${task.subTasks.length} SUBTASKS',
                                            style: const TextStyle(
                                              color: AppTheme.accent,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  if (task.subTasks.isNotEmpty) ...[
                                    const SizedBox(height: 10),
                                    Column(
                                      children: task.subTasks.map((st) {
                                        return Padding(
                                          padding: const EdgeInsets.only(bottom: 4),
                                          child: Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  ref.read(msTodoProvider.notifier).toggleChecklistItem(
                                                    list.id,
                                                    task.id,
                                                    st.id,
                                                    !st.isChecked,
                                                  );
                                                },
                                                child: Icon(
                                                  st.isChecked ? Icons.check_box : Icons.check_box_outline_blank,
                                                  size: 16,
                                                  color: st.isChecked ? AppTheme.accent : Colors.white38,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  st.title,
                                                  style: TextStyle(
                                                    color: st.isChecked ? Colors.white38 : Colors.white70,
                                                    fontSize: 12,
                                                    decoration: st.isChecked ? TextDecoration.lineThrough : null,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}


