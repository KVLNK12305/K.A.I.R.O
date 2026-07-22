import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/task.dart';
import '../../core/services/focus_timer_service.dart';
import '../../core/theme/app_theme.dart';
import 'energy_provider.dart';

class EnergyEconomyPage extends ConsumerStatefulWidget {
  const EnergyEconomyPage({super.key});

  @override
  ConsumerState<EnergyEconomyPage> createState() => _EnergyEconomyPageState();
}

class _EnergyEconomyPageState extends ConsumerState<EnergyEconomyPage> {
  final _titleController = TextEditingController();
  final _categoryController = TextEditingController(text: 'General');
  EnergySlot _selectedNewSlot = EnergySlot.unassigned;

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _showAddTaskDialog(BuildContext context, {EnergySlot? initialSlot}) {
    if (initialSlot != null) _selectedNewSlot = initialSlot;
    _titleController.clear();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: const Color(0xFF161616),
            insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            actionsOverflowButtonSpacing: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: AppTheme.warning.withValues(alpha: 0.3)),
            ),
            title: const Text(
              "ALLOCATE ENERGY SLOT",
              style: TextStyle(
                color: AppTheme.warning,
                fontSize: 12,
                fontFamily: 'monospace',
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.85,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _titleController,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: "Task title...",
                        hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.25)),
                        filled: true,
                        fillColor: const Color(0xFF222222),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text("Slot Assignment:", style: TextStyle(color: Colors.white70, fontSize: 11)),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<EnergySlot>(
                      value: _selectedNewSlot,
                      isExpanded: true,
                      dropdownColor: const Color(0xFF222222),
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFF222222),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      ),
                      items: const [
                        DropdownMenuItem(value: EnergySlot.peak1, child: Text("⚡ PEAK 1 (Primary High Friction)", overflow: TextOverflow.ellipsis)),
                        DropdownMenuItem(value: EnergySlot.peak2, child: Text("⚡ PEAK 2 (Secondary Priority)", overflow: TextOverflow.ellipsis)),
                        DropdownMenuItem(value: EnergySlot.recovery, child: Text("🌱 RECOVERY (Low Cognitive Load)", overflow: TextOverflow.ellipsis)),
                        DropdownMenuItem(value: EnergySlot.unassigned, child: Text("📦 UNASSIGNED (Staging Buffer)", overflow: TextOverflow.ellipsis)),
                      ],
                      onChanged: (val) {
                        if (val != null) setDialogState(() => _selectedNewSlot = val);
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text("CANCEL", style: TextStyle(color: Colors.white54)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.warning,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      final title = _titleController.text.trim();
                      if (title.isNotEmpty) {
                        ref.read(energyEconomyProvider.notifier).addTask(title, _categoryController.text.trim(), _selectedNewSlot);
                        Navigator.pop(ctx);
                      }
                    },
                    child: const Text("COMMIT TASK", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  void _showMoveDialog(BuildContext context, Task task) {
    EnergySlot targetSlot = task.energySlot;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: const Color(0xFF161616),
            insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            actionsOverflowButtonSpacing: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
            ),
            title: const Text(
              "RE-ALLOCATE SLOT",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontFamily: 'monospace',
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.85,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: const TextStyle(color: AppTheme.warning, fontSize: 14, fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<EnergySlot>(
                      value: targetSlot,
                      isExpanded: true,
                      dropdownColor: const Color(0xFF222222),
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFF222222),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      ),
                      items: const [
                        DropdownMenuItem(value: EnergySlot.peak1, child: Text("⚡ PEAK 1", overflow: TextOverflow.ellipsis)),
                        DropdownMenuItem(value: EnergySlot.peak2, child: Text("⚡ PEAK 2", overflow: TextOverflow.ellipsis)),
                        DropdownMenuItem(value: EnergySlot.recovery, child: Text("🌱 RECOVERY", overflow: TextOverflow.ellipsis)),
                        DropdownMenuItem(value: EnergySlot.unassigned, child: Text("📦 UNASSIGNED", overflow: TextOverflow.ellipsis)),
                      ],
                      onChanged: (val) {
                        if (val != null) setDialogState(() => targetSlot = val);
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("CANCEL", style: TextStyle(color: Colors.white54))),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accent, foregroundColor: Colors.black),
                onPressed: () {
                  ref.read(energyEconomyProvider.notifier).moveTask(task.id, targetSlot);
                  Navigator.pop(ctx);
                },
                child: const Text("MOVE", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showFailDialog(BuildContext context, Task task) {
    FailureEtiology selectedEtiology = FailureEtiology.miscalibratedEnergy;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: const Color(0xFF161616),
            insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            actionsOverflowButtonSpacing: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.redAccent.withValues(alpha: 0.3)),
            ),
            title: const Text(
              "CLASSIFY FAILURE ETIOLOGY",
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 12,
                fontFamily: 'monospace',
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.85,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(task.title, style: const TextStyle(color: Colors.white, fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<FailureEtiology>(
                      value: selectedEtiology,
                      isExpanded: true,
                      dropdownColor: const Color(0xFF222222),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFF222222),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      ),
                      items: const [
                        DropdownMenuItem(value: FailureEtiology.miscalibratedEnergy, child: Text("Miscalibrated Energy / Miscalculation", overflow: TextOverflow.ellipsis)),
                        DropdownMenuItem(value: FailureEtiology.taskAversive, child: Text("Task Aversive / Procrastination", overflow: TextOverflow.ellipsis)),
                        DropdownMenuItem(value: FailureEtiology.scopeTooLarge, child: Text("Scope Too Large", overflow: TextOverflow.ellipsis)),
                        DropdownMenuItem(value: FailureEtiology.protectedTimeStolen, child: Text("Protected Time Stolen / Interruption", overflow: TextOverflow.ellipsis)),
                        DropdownMenuItem(value: FailureEtiology.didntWantItEnough, child: Text("Didn't Want It Enough", overflow: TextOverflow.ellipsis)),
                      ],
                      onChanged: (val) {
                        if (val != null) setDialogState(() => selectedEtiology = val);
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("CANCEL", style: TextStyle(color: Colors.white54))),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
                onPressed: () {
                  ref.read(energyEconomyProvider.notifier).failTask(task.id, selectedEtiology);
                  Navigator.pop(ctx);
                },
                child: const Text("LOG FAILURE", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(energyEconomyProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const FittedBox(
          fit: BoxFit.scaleDown,
          child: Text("ENERGY ECONOMY • LEDGER", style: TextStyle(fontSize: 12, letterSpacing: 2, color: Colors.white54, fontFamily: 'monospace')),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: AppTheme.warning),
            tooltip: "Allocate Task",
            onPressed: () => _showAddTaskDialog(context),
          ),
        ],
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.warning))
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                if (state.recoveryBlocked) ...[
                  Container(
                    padding: const EdgeInsets.all(14),
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.redAccent.withValues(alpha: 0.4)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.warning_rounded, color: Colors.redAccent, size: 20),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "RECOVERY BLOCKED: Active cowardice/leak logged today. Complete your Peak commitments before accessing low-load tasks.",
                            style: TextStyle(color: Colors.white70, fontSize: 11, height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                _buildSlotSection("⚡ PEAK 1 • PRIMARY ANCHOR", state.peak1Tasks, EnergySlot.peak1, AppTheme.warning),
                const SizedBox(height: 20),
                _buildSlotSection("⚡ PEAK 2 • SECONDARY DEEP WORK", state.peak2Tasks, EnergySlot.peak2, const Color(0xFF6C63FF)),
                const SizedBox(height: 20),
                _buildSlotSection("🌱 RECOVERY • LOW COGNITIVE LOAD", state.recoveryTasks, EnergySlot.recovery, const Color(0xFF00E676)),
                const SizedBox(height: 20),
                _buildSlotSection("📦 UNASSIGNED • STAGING BUFFER", state.unassignedTasks, EnergySlot.unassigned, Colors.white54),
              ],
            ),
    );
  }

  Widget _buildSlotSection(String title, List<Task> tasks, EnergySlot slot, Color accentColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: accentColor,
                    fontSize: 11,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () => _showAddTaskDialog(context, initialSlot: slot),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, size: 12, color: accentColor),
                      const SizedBox(width: 4),
                      Text("ADD", style: TextStyle(color: accentColor, fontSize: 9, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (tasks.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              alignment: Alignment.center,
              child: Text(
                "Slot is currently vacant",
                style: TextStyle(color: Colors.white.withValues(alpha: 0.25), fontSize: 11, fontFamily: 'monospace'),
              ),
            )
          else
            Column(
              children: tasks.map((task) => _buildTaskItem(task, accentColor)).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildTaskItem(Task task, Color accentColor) {
    final isDone = task.isCompleted;
    final isFailed = task.isFailed;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDone
              ? const Color(0xFF00E676).withValues(alpha: 0.3)
              : isFailed
                  ? Colors.redAccent.withValues(alpha: 0.3)
                  : Colors.white.withValues(alpha: 0.05),
        ),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              if (!isDone) {
                ref.read(energyEconomyProvider.notifier).completeTask(task.id);
              }
            },
            borderRadius: BorderRadius.circular(12),
            child: Icon(
              isDone
                  ? Icons.check_circle_rounded
                  : isFailed
                      ? Icons.cancel_rounded
                      : Icons.circle_outlined,
              size: 20,
              color: isDone
                  ? const Color(0xFF00E676)
                  : isFailed
                      ? Colors.redAccent
                      : accentColor,
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
                    color: isDone || isFailed ? Colors.white38 : Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    decoration: isDone || isFailed ? TextDecoration.lineThrough : null,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (task.category.isNotEmpty && task.category != 'Peak') ...[
                  const SizedBox(height: 2),
                  Text(task.category, style: const TextStyle(color: Colors.white38, fontSize: 10), maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isDone && !isFailed) ...[
                Tooltip(
                  message: "Start Focus Session",
                  child: IconButton(
                    icon: const Icon(Icons.timer_outlined, size: 16, color: Colors.amber),
                    onPressed: () {
                      ref.read(focusTimerProvider.notifier).startSession(task.title, peakTaskId: task.id.toString());
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Focus timer started for: ${task.title}"),
                          backgroundColor: Colors.amber,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(6),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.drive_file_move_outline, size: 16, color: Colors.white54),
                  tooltip: "Move Slot",
                  onPressed: () => _showMoveDialog(context, task),
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.all(6),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 16, color: Colors.redAccent),
                  tooltip: "Log Failure / Leak",
                  onPressed: () => _showFailDialog(context, task),
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.all(6),
                ),
              ] else ...[
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, size: 16, color: Colors.white24),
                  tooltip: "Delete",
                  onPressed: () => ref.read(energyEconomyProvider.notifier).deleteTask(task.id),
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.all(6),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
