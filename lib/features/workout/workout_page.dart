import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/kairo_design_system.dart';
import '../../core/models/workout_session.dart';
import '../../core/services/workout_service.dart';

class WorkoutPage extends ConsumerStatefulWidget {
  const WorkoutPage({super.key});

  @override
  ConsumerState<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends ConsumerState<WorkoutPage> {
  void _showLogWorkoutModal(BuildContext context, {String? defaultTitle, String? defaultSplit}) {
    final titleCtrl = TextEditingController(text: defaultTitle ?? 'Push A (Hypertrophy)');
    final durationCtrl = TextEditingController(text: '60');
    final notesCtrl = TextEditingController();
    String splitType = defaultSplit ?? 'Push';
    int rpe = 8;

    // List of exercises being logged: each has name and list of sets [{weight, reps, completed}]
    List<Map<String, dynamic>> exercises = [
      {
        'name': 'Barbell Bench Press',
        'sets': [
          {'weight': 80.0, 'reps': 8, 'done': true},
          {'weight': 80.0, 'reps': 8, 'done': true},
          {'weight': 80.0, 'reps': 7, 'done': true},
        ],
      },
      {
        'name': 'Incline Dumbbell Press',
        'sets': [
          {'weight': 28.0, 'reps': 10, 'done': true},
          {'weight': 28.0, 'reps': 9, 'done': true},
        ],
      },
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: KairoTheme.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(KairoTheme.radiusLg)),
        side: BorderSide(color: KairoTheme.border, width: 1),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (modalCtx, setModalState) {
            double calcLiveVolume() {
              double vol = 0.0;
              for (final ex in exercises) {
                final sets = ex['sets'] as List<dynamic>;
                for (final s in sets) {
                  final w = (s['weight'] as num?)?.toDouble() ?? 0.0;
                  final r = (s['reps'] as num?)?.toInt() ?? 0;
                  vol += (w * r);
                }
              }
              return vol;
            }

            return Padding(
              padding: EdgeInsets.only(
                left: KairoTheme.xl,
                right: KairoTheme.xl,
                top: KairoTheme.xl,
                bottom: MediaQuery.of(modalCtx).viewInsets.bottom + KairoTheme.xl,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "LOG WORKOUT SESSION",
                          style: TextStyle(
                            color: KairoTheme.textPrimary,
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'monospace',
                            letterSpacing: 1.2,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: KairoTheme.textMuted, size: 18),
                          onPressed: () => Navigator.pop(ctx),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    const SizedBox(height: KairoTheme.md),

                    // Session Title
                    TextField(
                      controller: titleCtrl,
                      style: const TextStyle(color: KairoTheme.textPrimary, fontSize: 13, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        labelText: "SESSION NAME",
                        labelStyle: const TextStyle(color: KairoTheme.textMuted, fontSize: 10, fontFamily: 'monospace'),
                        filled: true,
                        fillColor: KairoTheme.surfaceElevated,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(KairoTheme.radiusSm), borderSide: const BorderSide(color: KairoTheme.border)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(KairoTheme.radiusSm), borderSide: const BorderSide(color: KairoTheme.border)),
                      ),
                    ),
                    const SizedBox(height: KairoTheme.sm),

                    // Split & Duration Row
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: DropdownButtonFormField<String>(
                            initialValue: splitType,
                            dropdownColor: KairoTheme.surfaceElevated,
                            style: const TextStyle(color: KairoTheme.textPrimary, fontSize: 12, fontFamily: 'monospace'),
                            decoration: InputDecoration(
                              labelText: "SPLIT TYPE",
                              labelStyle: const TextStyle(color: KairoTheme.textMuted, fontSize: 9, fontFamily: 'monospace'),
                              filled: true,
                              fillColor: KairoTheme.surfaceElevated,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(KairoTheme.radiusSm), borderSide: const BorderSide(color: KairoTheme.border)),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(KairoTheme.radiusSm), borderSide: const BorderSide(color: KairoTheme.border)),
                            ),
                            items: ['Push', 'Pull', 'Legs', 'Upper', 'Lower', 'Full Body', 'Conditioning'].map((s) {
                              return DropdownMenuItem(value: s, child: Text(s.toUpperCase()));
                            }).toList(),
                            onChanged: (v) => setModalState(() => splitType = v ?? 'Push'),
                          ),
                        ),
                        const SizedBox(width: KairoTheme.sm),
                        Expanded(
                          child: TextField(
                            controller: durationCtrl,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: KairoTheme.textPrimary, fontSize: 12, fontFamily: 'monospace'),
                            decoration: InputDecoration(
                              labelText: "MINUTES",
                              labelStyle: const TextStyle(color: KairoTheme.textMuted, fontSize: 9, fontFamily: 'monospace'),
                              filled: true,
                              fillColor: KairoTheme.surfaceElevated,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(KairoTheme.radiusSm), borderSide: const BorderSide(color: KairoTheme.border)),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(KairoTheme.radiusSm), borderSide: const BorderSide(color: KairoTheme.border)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: KairoTheme.md),

                    // RPE Exertion Slider
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("EFFORT (RPE 1-10)", style: TextStyle(color: KairoTheme.textMuted, fontSize: 10, fontFamily: 'monospace')),
                        Text("$rpe / 10", style: const TextStyle(color: KairoTheme.recommended, fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
                      ],
                    ),
                    SliderTheme(
                      data: SliderTheme.of(modalCtx).copyWith(
                        activeTrackColor: KairoTheme.recommended,
                        thumbColor: Colors.white,
                        inactiveTrackColor: KairoTheme.border,
                      ),
                      child: Slider(
                        value: rpe.toDouble(),
                        min: 1,
                        max: 10,
                        divisions: 9,
                        onChanged: (v) => setModalState(() => rpe = v.round()),
                      ),
                    ),
                    const SizedBox(height: KairoTheme.xs),

                    // Live Tonnage Banner
                    Container(
                      padding: const EdgeInsets.all(KairoTheme.md),
                      decoration: BoxDecoration(
                        color: KairoTheme.surfaceElevated,
                        borderRadius: BorderRadius.circular(KairoTheme.radiusSm),
                        border: Border.all(color: KairoTheme.border),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("ESTIMATED TONNAGE", style: TextStyle(color: KairoTheme.textMuted, fontSize: 10, fontFamily: 'monospace', fontWeight: FontWeight.bold)),
                          Text(
                            "${calcLiveVolume().toStringAsFixed(0)} KG",
                            style: const TextStyle(color: KairoTheme.success, fontSize: 14, fontWeight: FontWeight.w900, fontFamily: 'monospace'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: KairoTheme.md),

                    // Exercises list
                    const Text("EXERCISES & SETS", style: TextStyle(color: KairoTheme.textMuted, fontSize: 10, fontFamily: 'monospace', fontWeight: FontWeight.w800)),
                    const SizedBox(height: KairoTheme.xs),
                    ...exercises.map((ex) {
                      final sets = ex['sets'] as List<dynamic>;

                      return Container(
                        margin: const EdgeInsets.only(bottom: KairoTheme.sm),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: KairoTheme.surfaceElevated,
                          borderRadius: BorderRadius.circular(KairoTheme.radiusSm),
                          border: Border.all(color: KairoTheme.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  ex['name'] as String,
                                  style: const TextStyle(color: KairoTheme.textPrimary, fontSize: 12, fontWeight: FontWeight.w800),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setModalState(() {
                                      sets.add({'weight': (sets.isNotEmpty ? sets.last['weight'] : 60.0), 'reps': 8, 'done': true});
                                    });
                                  },
                                  child: const Text("+ SET", style: TextStyle(color: KairoTheme.observed, fontSize: 10, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            ...sets.asMap().entries.map((setEntry) {
                              final sIdx = setEntry.key;
                              final s = setEntry.value;
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 2),
                                child: Row(
                                  children: [
                                    Text("SET ${sIdx + 1}", style: const TextStyle(color: KairoTheme.textMuted, fontSize: 9, fontFamily: 'monospace')),
                                    const SizedBox(width: 8),
                                    Text("${s['weight']} kg", style: const TextStyle(color: KairoTheme.textPrimary, fontSize: 11, fontFamily: 'monospace', fontWeight: FontWeight.bold)),
                                    const Text(" × ", style: TextStyle(color: KairoTheme.textMuted, fontSize: 10)),
                                    Text("${s['reps']} reps", style: const TextStyle(color: KairoTheme.textPrimary, fontSize: 11, fontFamily: 'monospace', fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      );
                    }),

                    // Add custom exercise action
                    TextButton.icon(
                      onPressed: () {
                        final exNameCtrl = TextEditingController();
                        showDialog(
                          context: modalCtx,
                          builder: (dCtx) => AlertDialog(
                            backgroundColor: KairoTheme.surface,
                            title: const Text("ADD EXERCISE", style: TextStyle(color: KairoTheme.textPrimary, fontSize: 12, fontFamily: 'monospace')),
                            content: TextField(
                              controller: exNameCtrl,
                              style: const TextStyle(color: KairoTheme.textPrimary, fontSize: 13),
                              decoration: const InputDecoration(hintText: "e.g. Overhead Barbell Press", hintStyle: TextStyle(color: KairoTheme.textFaint)),
                            ),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(dCtx), child: const Text("CANCEL")),
                              TextButton(
                                onPressed: () {
                                  if (exNameCtrl.text.trim().isNotEmpty) {
                                    setModalState(() {
                                      exercises.add({
                                        'name': exNameCtrl.text.trim(),
                                        'sets': [
                                          {'weight': 50.0, 'reps': 10, 'done': true},
                                        ],
                                      });
                                    });
                                    Navigator.pop(dCtx);
                                  }
                                },
                                child: const Text("ADD", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.add, size: 14, color: KairoTheme.observed),
                      label: const Text("ADD EXERCISE MOVEMENT", style: TextStyle(color: KairoTheme.observed, fontSize: 10, fontFamily: 'monospace', fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: KairoTheme.md),

                    // Commit Button
                    KairoButton(
                      text: "COMMIT WORKOUT TO LEDGER",
                      isPrimary: true,
                      isFullWidth: true,
                      onPressed: () async {
                        final duration = int.tryParse(durationCtrl.text.trim()) ?? 60;
                        final session = WorkoutSession()
                          ..title = titleCtrl.text.trim().isEmpty ? 'Workout Session' : titleCtrl.text.trim()
                          ..splitType = splitType
                          ..startTime = DateTime.now().subtract(Duration(minutes: duration))
                          ..endTime = DateTime.now()
                          ..durationMinutes = duration
                          ..perceivedExertion = rpe
                          ..totalVolumeKg = calcLiveVolume()
                          ..exercisesJson = exercises.map((e) => jsonEncode(e)).toList()
                          ..notes = notesCtrl.text.trim();

                        await ref.read(workoutServiceProvider).saveSession(session);
                        ref.invalidate(recentWorkoutsProvider);
                        ref.invalidate(weeklyWorkoutStatsProvider);
                        if (ctx.mounted) Navigator.pop(ctx);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final recentAsync = ref.watch(recentWorkoutsProvider);
    final statsAsync = ref.watch(weeklyWorkoutStatsProvider);

    return Scaffold(
      backgroundColor: KairoTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: KairoTheme.textPrimary, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "PHYSICAL CRUCIBLE // TRAINING LOG",
          style: TextStyle(
            letterSpacing: 1.5,
            fontSize: 12,
            fontWeight: FontWeight.w900,
            fontFamily: 'monospace',
            color: KairoTheme.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(KairoTheme.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Weekly Crucible Stats Card
            statsAsync.when(
              data: (stats) => KairoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Text(
                            "WEEKLY TRAINING LOAD",
                            style: TextStyle(color: KairoTheme.textMuted, fontSize: 10, fontWeight: FontWeight.w800, fontFamily: 'monospace'),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        KairoStatus(label: "${stats.sessionsCount}/4 SESSIONS", type: stats.sessionsCount >= 4 ? KairoStatusType.success : KairoStatusType.recommended),
                      ],
                    ),
                    const SizedBox(height: KairoTheme.md),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("TOTAL TONNAGE", style: TextStyle(color: KairoTheme.textMuted, fontSize: 8, fontFamily: 'monospace')),
                              const SizedBox(height: 2),
                              Text(
                                "${stats.totalVolumeKg.toStringAsFixed(0)} KG",
                                style: const TextStyle(color: KairoTheme.success, fontSize: 18, fontWeight: FontWeight.w900, fontFamily: 'monospace'),
                              ),
                            ],
                          ),
                        ),
                        Container(width: 1, height: 32, color: KairoTheme.border),
                        const SizedBox(width: KairoTheme.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("ACTIVE DURATION", style: TextStyle(color: KairoTheme.textMuted, fontSize: 8, fontFamily: 'monospace')),
                              const SizedBox(height: 2),
                              Text(
                                "${stats.totalMinutes} MIN",
                                style: const TextStyle(color: KairoTheme.textPrimary, fontSize: 18, fontWeight: FontWeight.w900, fontFamily: 'monospace'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
            ),
            const SizedBox(height: KairoTheme.lg),

            // 2. Action Button
            KairoButton(
              text: "START & LOG WORKOUT",
              icon: Icons.fitness_center_rounded,
              isPrimary: true,
              isFullWidth: true,
              onPressed: () => _showLogWorkoutModal(context),
            ),
            const SizedBox(height: KairoTheme.lg),

            // 3. Quick Split Templates
            const KairoSectionHeader(
              title: "SPLIT PRESETS",
              padding: EdgeInsets.only(bottom: KairoTheme.sm),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildTemplateChip("PUSH A", "Chest, Delts, Triceps", "Push"),
                  _buildTemplateChip("PULL A", "Back, Rear Delts, Biceps", "Pull"),
                  _buildTemplateChip("LEGS", "Quads, Hamstrings, Core", "Legs"),
                  _buildTemplateChip("UPPER", "Heavy Compound Upper", "Upper"),
                  _buildTemplateChip("LOWER", "Deadlift & Squat", "Lower"),
                  _buildTemplateChip("ZONE 2", "Aerobic Conditioning", "Conditioning"),
                ],
              ),
            ),
            const SizedBox(height: KairoTheme.lg),

            // 4. Historical Workout Sessions
            const KairoSectionHeader(
              title: "TRAINING HISTORY",
              padding: EdgeInsets.only(bottom: KairoTheme.sm),
            ),
            recentAsync.when(
              data: (sessions) {
                if (sessions.isEmpty) {
                  return const KairoEmptyState(
                    title: "NO TRAINING SESSIONS",
                    description: "Log your workouts to track progressive overload volume and maintain physical discipline.",
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: sessions.length,
                  itemBuilder: (ctx, index) {
                    final s = sessions[index];
                    final dateStr = DateFormat('EEEE, MMM d • h:mm a').format(s.startTime);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: KairoTheme.sm),
                      child: KairoCard(
                        padding: const EdgeInsets.all(KairoTheme.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    s.title,
                                    style: const TextStyle(color: KairoTheme.textPrimary, fontSize: 13, fontWeight: FontWeight.w800),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                KairoStatus(label: s.splitType, type: KairoStatusType.observed),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(dateStr, style: const TextStyle(color: KairoTheme.textMuted, fontSize: 10, fontFamily: 'monospace')),
                            const SizedBox(height: KairoTheme.xs),
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 6,
                              runSpacing: 2,
                              children: [
                                Text("${s.durationMinutes} min", style: const TextStyle(color: KairoTheme.textSecondary, fontSize: 11, fontFamily: 'monospace')),
                                const Text("•", style: TextStyle(color: KairoTheme.textMuted)),
                                Text("${s.totalVolumeKg.toStringAsFixed(0)} kg tonnage", style: const TextStyle(color: KairoTheme.success, fontSize: 11, fontFamily: 'monospace', fontWeight: FontWeight.bold)),
                                const Text("•", style: TextStyle(color: KairoTheme.textMuted)),
                                Text("RPE ${s.perceivedExertion}", style: const TextStyle(color: KairoTheme.recommended, fontSize: 11, fontFamily: 'monospace')),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2, color: KairoTheme.textMuted)),
              error: (err, _) => Text("Error: $err", style: const TextStyle(color: KairoTheme.warning)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTemplateChip(String name, String sub, String split) {
    return Container(
      margin: const EdgeInsets.only(right: KairoTheme.sm),
      child: InkWell(
        onTap: () => _showLogWorkoutModal(context, defaultTitle: name, defaultSplit: split),
        borderRadius: BorderRadius.circular(KairoTheme.radiusSm),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: KairoTheme.surfaceElevated,
            borderRadius: BorderRadius.circular(KairoTheme.radiusSm),
            border: Border.all(color: KairoTheme.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(color: KairoTheme.textPrimary, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
              Text(sub, style: const TextStyle(color: KairoTheme.textMuted, fontSize: 9)),
            ],
          ),
        ),
      ),
    );
  }
}
