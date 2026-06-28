import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
                onPressed: () => _showAddTaskSheet(context, ref, state.lists),
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

  void _showAddTaskSheet(BuildContext context, WidgetRef ref, List<MsTodoList> lists) {
    String selectedListId = lists.first.id;
    final taskController = TextEditingController();

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
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Color(0xEE0A0A0A),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'NEW TASK',
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: 10,
                          letterSpacing: 2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
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
                      TextField(
                        controller: taskController,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: "What needs to be done?",
                          hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.2)),
                          border: InputBorder.none,
                        ),
                        onSubmitted: (value) {
                          if (value.trim().isNotEmpty) {
                            ref.read(msTodoProvider.notifier).createTask(selectedListId, value.trim());
                            Navigator.pop(ctx);
                          }
                        },
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white10,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () {
                            if (taskController.text.trim().isNotEmpty) {
                              ref.read(msTodoProvider.notifier).createTask(selectedListId, taskController.text.trim());
                              Navigator.pop(ctx);
                            }
                          },
                          child: const Text('SAVE TASK', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            );
          }
        );
      },
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
            ...list.tasks.map((task) => Dismissible(
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
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF111111),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF2A2A2A)),
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            ref.read(msTodoProvider.notifier).completeTask(list.id, task.id);
                          },
                          child: const Icon(Icons.circle_outlined, color: Colors.white38, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            task.title,
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}

