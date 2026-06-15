import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/task.dart';
import '../dashboard/providers/ms_todo_provider.dart';
import 'energy_provider.dart';
import '../../core/theme/app_theme.dart';

class MorningEnforcerPage extends ConsumerStatefulWidget {
  final VoidCallback onPassedGauntlet;

  const MorningEnforcerPage({super.key, required this.onPassedGauntlet});

  @override
  ConsumerState<MorningEnforcerPage> createState() =>
      _MorningEnforcerPageState();
}

class _MorningEnforcerPageState extends ConsumerState<MorningEnforcerPage> {
  final _peak1Controller = TextEditingController();
  final _peak2Controller = TextEditingController();

  static const Color _accent = AppTheme.accent;
  static const Color _bloodRed = AppTheme.warning;

  @override
  void dispose() {
    _peak1Controller.dispose();
    _peak2Controller.dispose();
    super.dispose();
  }

  void _submit() {
    final p1 = _peak1Controller.text.trim();
    final p2 = _peak2Controller.text.trim();

    if (p1.isEmpty || p2.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: _bloodRed,
          content: Text(
            'You cannot bypass this. Assign your peak energy.',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
      return;
    }

    final notifier = ref.read(energyEconomyProvider.notifier);
    notifier.addTask(p1, 'Peak', EnergySlot.peak1);
    notifier.addTask(p2, 'Peak', EnergySlot.peak2);

    widget.onPassedGauntlet();
  }

  void _showTodoInbox() {
    final state = ref.read(msTodoProvider);
    if (!state.isAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Connect MS To Do in the Inbox tab first.'),
          backgroundColor: _bloodRed,
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF111111),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'STAGING INBOX',
                style: TextStyle(
                  color: Colors.white54,
                  letterSpacing: 2,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Builder(
                  builder: (context) {
                    final allTasks = state.lists.expand((list) => list.tasks).toList();
                    if (allTasks.isEmpty) {
                      return const Center(
                        child: Text(
                          'Inbox is empty.',
                          style: TextStyle(color: Colors.white38),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: allTasks.length,
                      itemBuilder: (c, i) {
                        final task = allTasks[i];
                        return ListTile(
                          leading: const Icon(
                            Icons.circle_outlined,
                            color: Colors.white38,
                            size: 16,
                          ),
                          title: Text(
                            task.title,
                            style: const TextStyle(color: Colors.white),
                          ),
                          onTap: () {
                            if (_peak1Controller.text.isEmpty) {
                              _peak1Controller.text = task.title;
                            } else if (_peak2Controller.text.isEmpty) {
                              _peak2Controller.text = task.title;
                            }
                            Navigator.pop(ctx);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'THE MORNING ENFORCER',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 10,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Where is your energy going today?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      'You have two peak energy slots. If you do not assign them now, they will be stolen by distraction. Commit.',
                      style: TextStyle(
                        color: Colors.white38,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _showTodoInbox,
                    icon: const Icon(
                      Icons.cloud_download_outlined,
                      color: _accent,
                    ),
                    tooltip: 'Pull from MS To Do',
                  ),
                ],
              ),
              const SizedBox(height: 48),
              _buildTaskInput(
                'PEAK 1',
                'Your most critical, high-friction task.',
                _peak1Controller,
              ),
              const SizedBox(height: 24),
              _buildTaskInput(
                'PEAK 2',
                'The secondary priority. Still requires deep work.',
                _peak2Controller,
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _accent,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  onPressed: _submit,
                  child: const Text(
                    'COMMIT ENERGY ALLOCATION',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskInput(
    String label,
    String hint,
    TextEditingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: _accent,
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF111111),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: const Color(0xFF2A2A2A)),
          ),
          child: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.white24, fontSize: 14),
              contentPadding: const EdgeInsets.all(16),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
