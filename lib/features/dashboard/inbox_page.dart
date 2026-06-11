import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/ms_todo_provider.dart';

class InboxPage extends ConsumerWidget {
  const InboxPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(msTodoProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text('STAGING INBOX', style: TextStyle(fontSize: 12, letterSpacing: 2)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white54, size: 20),
            onPressed: () => ref.read(msTodoProvider.notifier).fetchTasks(),
          )
        ],
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white24))
          : !state.isAuthenticated
              ? _buildAuthPrompt(ref)
              : state.tasks.isEmpty
                  ? _buildEmptyState()
                  : _buildTaskList(state.tasks),
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

  Widget _buildTaskList(List<MsTodoTask> tasks) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 16, bottom: 120),
      itemCount: tasks.length,
      itemBuilder: (ctx, idx) {
        final task = tasks[idx];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF111111),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF2A2A2A)),
          ),
          child: Row(
            children: [
              const Icon(Icons.circle_outlined, color: Colors.white38, size: 16),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  task.title,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
              const Icon(Icons.drag_indicator, color: Colors.white24, size: 16),
            ],
          ),
        );
      },
    );
  }
}

