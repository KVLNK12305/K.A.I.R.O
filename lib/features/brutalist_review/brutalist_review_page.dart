import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../main.dart';
import '../../core/models/brutalist_review.dart';
import '../../core/models/task.dart';
import '../../core/services/streak_service.dart';
import '../../core/services/notification_service.dart';
import '../energy_economy/energy_provider.dart';
import '../profile/providers/profile_provider.dart';
import '../dashboard/providers/task_provider.dart';
import 'brutalist_provider.dart';
import '../../core/services/delusion_filter_service.dart';
import '../../core/theme/app_theme.dart';
class BrutalistReviewPage extends ConsumerStatefulWidget {
  final bool showBackButton;
  const BrutalistReviewPage({super.key, this.showBackButton = true});

  @override
  ConsumerState<BrutalistReviewPage> createState() =>
      _BrutalistReviewPageState();
}

class _BrutalistReviewPageState extends ConsumerState<BrutalistReviewPage> {
  final _ventController = TextEditingController();
  final _highlightController = TextEditingController();
  final _cowardiceDescController = TextEditingController();
  final _costController = TextEditingController();

  CowardiceTag _selectedTag = CowardiceTag.none;
  bool _submitted = false;
  int _ventChars = 0;
  final Map<int, FailureEtiology> _taskEtiologies = {};
  final Map<int, int> _taskProgress = {};
  final Map<int, bool> _taskIntents = {};

  DelusionAnalysis _highlightDelusion = DelusionAnalysis(hasDelusion: false, phraseDetected: '', suggestedRewrite: '', severityScore: 0.0);
  DelusionAnalysis _cowardiceDelusion = DelusionAnalysis(hasDelusion: false, phraseDetected: '', suggestedRewrite: '', severityScore: 0.0);

  static const int _ventLimit = 300;
  static const Color _bloodRed = AppTheme.warning;
  static const Color _dimWhite = AppTheme.secondary;
  static const Color _surface = AppTheme.surface;
  static const Color _border = AppTheme.border;
  static const Color _restBg = AppTheme.surface;

  @override
  void initState() {
    super.initState();
    _ventController.addListener(() {
      setState(() => _ventChars = _ventController.text.length);
    });

    _highlightController.addListener(() {
      final analysis = DelusionFilterService.analyze(_highlightController.text);
      if (analysis.hasDelusion != _highlightDelusion.hasDelusion || analysis.phraseDetected != _highlightDelusion.phraseDetected) {
        setState(() => _highlightDelusion = analysis);
      }
    });

    _cowardiceDescController.addListener(() {
      final analysis = DelusionFilterService.analyze(_cowardiceDescController.text);
      if (analysis.hasDelusion != _cowardiceDelusion.hasDelusion || analysis.phraseDetected != _cowardiceDelusion.phraseDetected) {
        setState(() => _cowardiceDelusion = analysis);
      }
    });
  }

  @override
  void dispose() {
    _ventController.dispose();
    _highlightController.dispose();
    _cowardiceDescController.dispose();
    _costController.dispose();
    super.dispose();
  }

  void _prefill(BrutalistReview review) {
    if (_submitted) return;
    _ventController.text = review.vent;
    _highlightController.text = review.highlight;
    _cowardiceDescController.text = review.cowardiceDescription;
    _costController.text =
        review.futureCostLost > 0 ? review.futureCostLost.toStringAsFixed(0) : '';
    _selectedTag = review.cowardiceTag;
    _submitted = review.isCompleted;
  }

  Future<void> _submit(List<Task> unresolvedTasks) async {
    final tasksToProcess = List<Task>.from(unresolvedTasks);

    // Validate unresolved tasks — progress triage
    for (final t in tasksToProcess) {
      final progress = _taskProgress[t.id] ?? t.progressPercent;
      final intent = _taskIntents[t.id];
      final isChronic = t.carryForwardCount >= 2;

      if (progress >= 100) continue; // Will be auto-completed

      if (isChronic && intent != true) {
        if (_taskEtiologies[t.id] == null || _taskEtiologies[t.id] == FailureEtiology.none) {
          _showError('Chronic task "${t.title}" cannot be carried forward again. Assign a failure etiology or mark 100%.');
          return;
        }
      } else if (progress < 100 && intent == null) {
        _showError('Decide the fate of "${t.title}". Will you carry it forward or mark it failed?');
        return;
      } else if (intent == false) {
        if (_taskEtiologies[t.id] == null || _taskEtiologies[t.id] == FailureEtiology.none) {
          _showError('Assign a failure etiology to "${t.title}". No escape.');
          return;
        }
      }
    }

    final highlight = _highlightController.text.trim();
    if (highlight.isEmpty) {
      _showError('The highlight cannot be empty. One true sentence. Write it.');
      return;
    }
    if (_selectedTag != CowardiceTag.none &&
        _cowardiceDescController.text.trim().isEmpty) {
      _showError(
          'You selected a cowardice category. Name the exact moment. No escape.');
      return;
    }

    final cost =
        double.tryParse(_costController.text.trim()) ?? 0.0;

    // Process triage outcomes
    final energyNotifier = ref.read(energyEconomyProvider.notifier);
    final brutalistNotifier = ref.read(brutalistProvider.notifier);

    for (final t in tasksToProcess) {
      final progress = _taskProgress[t.id] ?? t.progressPercent;
      final intent = _taskIntents[t.id];
      final isChronic = t.carryForwardCount >= 2;

      if (progress >= 100) {
        // Auto-complete the task
        t.isCompleted = true;
        t.progressPercent = 100;
        t.isCarriedForward = false;
        t.isFailed = false;
        t.failureEtiology = FailureEtiology.none;
        await isar.writeTxn(() async {
          await isar.tasks.put(t);
        });
      } else if (intent == true && !isChronic) {
        // Carry forward with progress preserved
        await brutalistNotifier.carryForwardTask(t.id, progress);
      } else {
        // Mark as failed with etiology
        final etiology = _taskEtiologies[t.id] ?? FailureEtiology.taskAversive;
        await energyNotifier.failTask(t.id, etiology);
      }
    }

    // The Echo Mechanism: The vent is worthless. Destroy it.
    _ventController.clear();
    setState(() => _ventChars = 0);

    await ref.read(brutalistProvider.notifier).save(
          vent: "", // Do not save the vent
          highlight: highlight,
          cowardiceTag: _selectedTag,
          cowardiceDescription: _cowardiceDescController.text.trim(),
          futureCostLost: cost,
        );

    ref.read(taskProvider.notifier).loadAllData();

    final currentDay = await StreakService().recordDayComplete();
    NotificationService().show21DayStreakNotification(currentDay);

    setState(() => _submitted = true);

    if (mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: _bloodRed,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
          content: Text(
            cost > 0
                ? 'Your vent has been deleted. You lost \$${cost.toStringAsFixed(0)} today. Baseline updated.'
                : 'Your vent has been deleted. Review committed.',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: _bloodRed,
        content: Text(msg, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  bool _prefilled = false;

  @override
  Widget build(BuildContext context) {
    ref.listen(brutalistProvider, (previous, current) {
      if (!current.isLoading && current.todayReview != null && !_prefilled) {
        _prefill(current.todayReview!);
        _prefilled = true;
      }
    });

    final state = ref.watch(brutalistProvider);
    final profile = ref.watch(profileProvider);

    final today = DateFormat('MMMM d, yyyy').format(DateTime.now()).toUpperCase();
    final isLocked = _submitted;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        leading: widget.showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white54, size: 18),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              today,
              style: TextStyle(
                color: isLocked ? Colors.white38 : Colors.white54,
                fontSize: 10,
                letterSpacing: 2,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              isLocked ? 'REST MANDATED' : 'DAILY INTERROGATION',
              style: TextStyle(
                color: isLocked ? Colors.white60 : Colors.white,
                fontSize: 16,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white24))
          : isLocked 
              ? _buildRestModeUI() 
              : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ─── SECTION 0: UNRESOLVED TASKS ──────────────────────────
                  if (state.unresolvedTasks.isNotEmpty) ...[
                    _sectionLabel('00 — PROGRESS TRIAGE'),
                    const SizedBox(height: 4),
                    const Text(
                      'These peak tasks are unfinished. Assess your progress honestly — carry forward what\'s in-flight, confront what\'s abandoned.',
                      style: TextStyle(color: Colors.white38, fontSize: 12),
                    ),
                    const SizedBox(height: 12),
                    ...state.unresolvedTasks.map((t) => _buildTaskTriageCard(t)),
                    const SizedBox(height: 36),
                  ],

                  // ─── SECTION 1: VENT ──────────────────────────────────────
                  _sectionLabel('01 — THE VENT'),
                  const SizedBox(height: 4),
                  Text(
                    'Get it out. You have $_ventLimit characters. Then we move to truth.',
                    style: const TextStyle(color: Colors.white38, fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  _buildTextArea(
                    controller: _ventController,
                    hint: 'Everything that happened, the noise, the frustrations...',
                    maxLines: 5,
                    maxLength: _ventLimit,
                    locked: isLocked,
                    suffix: Text(
                      '$_ventChars / $_ventLimit',
                      style: TextStyle(
                        color: _ventChars >= _ventLimit ? _bloodRed : Colors.white38,
                        fontSize: 11,
                      ),
                    ),
                  ),

                  const SizedBox(height: 36),

                  // ─── SECTION 2: HIGHLIGHT ─────────────────────────────────
                  _sectionLabel('02 — THE ONE TRUE HIGHLIGHT'),
                  const SizedBox(height: 4),
                  const Text(
                    'One sentence. The single moment that actually mattered. No compound sentences.',
                    style: TextStyle(color: Colors.white38, fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  _buildTextArea(
                    controller: _highlightController,
                    hint: 'Today actually mattered because...',
                    maxLines: 2,
                    locked: isLocked,
                  ),
                  if (_highlightDelusion.hasDelusion) ...[
                    const SizedBox(height: 8),
                    _buildDelusionWarningBanner(_highlightDelusion, _highlightController),
                  ],

                  const SizedBox(height: 36),

                  // ─── SECTION 3: COWARDICE ─────────────────────────────────
                  _sectionLabel('03 — THE MOMENT OF SELF-BETRAYAL'),
                  const SizedBox(height: 4),
                  const Text(
                    'Be precise. If "None Detected" is your default answer, you are already lying.',
                    style: TextStyle(color: Colors.white38, fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  _buildCowardiceDropdown(isLocked),

                  if (_selectedTag != CowardiceTag.none) ...[
                    const SizedBox(height: 16),
                    _buildTextArea(
                      controller: _cowardiceDescController,
                      hint:
                          'Describe the exact moment you chose the easy thing over the right thing.',
                      maxLines: 4,
                      locked: isLocked,
                      accentColor: _bloodRed,
                    ),
                    if (_cowardiceDelusion.hasDelusion) ...[
                      const SizedBox(height: 8),
                      _buildDelusionWarningBanner(_cowardiceDelusion, _cowardiceDescController),
                    ],
                  ],

                  const SizedBox(height: 36),

                  // ─── SECTION 4: COST ─────────────────────────────────────
                  _sectionLabel('04 — THE \$10,000 HOUR'),
                  const SizedBox(height: 4),
                  Text(
                    'If you lost time to distraction today, how many hours were wasted? Your penalty is auto-calculated at \$${profile.baseHourlyRate.toStringAsFixed(2)}/hr. Enter 0 if you were present.',
                    style: const TextStyle(color: Colors.white38, fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  _buildCostField(isLocked, profile.baseHourlyRate),

                  const SizedBox(height: 48),

                  // ─── SUBMIT ───────────────────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _submit(state.unresolvedTasks),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _bloodRed,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: const Text(
                        'COMMIT — NO EDITS AFTER THIS',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // ─── Earned Comfort: The Dawn ─────────────────────────────────────────────

  Widget _buildRestModeUI() {
    return Container(
      width: double.infinity,
      color: _restBg,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.nights_stay_rounded, color: Colors.white38, size: 64),
          SizedBox(height: 24),
          Text(
            'THE DAY IS SEALED.',
            style: TextStyle(
              color: Colors.white60,
              fontSize: 18,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'The sin is paid for. Rest is mandated.\nNo new tasks until 05:00.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white38,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Shared Widgets ───────────────────────────────────────────────────────

  Widget _sectionLabel(String label) => Text(
        label,
        style: const TextStyle(
          color: Colors.white54,
          fontSize: 10,
          letterSpacing: 2,
          fontWeight: FontWeight.w700,
        ),
      );

  Widget _buildTaskTriageCard(Task task) {
    final labels = {
      FailureEtiology.none: 'Select Etiology...',
      FailureEtiology.miscalibratedEnergy: 'Miscalibrated Energy',
      FailureEtiology.taskAversive: 'Task Aversive',
      FailureEtiology.scopeTooLarge: 'Scope Too Large',
      FailureEtiology.protectedTimeStolen: 'Protected Time Stolen',
      FailureEtiology.didntWantItEnough: 'Didn\'t Want It Enough',
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: (_taskProgress[task.id] ?? task.progressPercent) >= 70
              ? Colors.greenAccent.withValues(alpha: 0.5)
              : ((_taskProgress[task.id] ?? task.progressPercent) >= 30
                  ? Colors.amber.withValues(alpha: 0.5)
                  : _bloodRed.withValues(alpha: 0.5)),
        ),
      ),
      child: StatefulBuilder(
        builder: (context, setLocalState) {
          final progress = _taskProgress[task.id] ?? task.progressPercent;
          final intent = _taskIntents[task.id]; // null = not decided, true = will finish, false = won't finish
          final current = _taskEtiologies[task.id] ?? FailureEtiology.none;
          final isChronic = task.carryForwardCount >= 2;

          Color tierColor;
          String tierLabel;
          if (progress >= 70) {
            tierColor = Colors.greenAccent;
            tierLabel = 'ALMOST THERE';
          } else if (progress >= 30) {
            tierColor = Colors.amber;
            tierLabel = 'IN PROGRESS';
          } else {
            tierColor = _bloodRed;
            tierLabel = 'BARELY STARTED';
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Task header
              Container(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(task.title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: tierColor.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  tierLabel,
                                  style: TextStyle(color: tierColor, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1),
                                ),
                              ),
                              if (task.isCarriedForward) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'CARRIED ×${task.carryForwardCount}',
                                    style: const TextStyle(color: Colors.orange, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Progress percentage display
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: tierColor.withValues(alpha: 0.6), width: 2),
                      ),
                      child: Center(
                        child: Text(
                          '$progress%',
                          style: TextStyle(color: tierColor, fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Progress slider
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'HOW FAR DID YOU GET?',
                      style: TextStyle(color: Colors.white38, fontSize: 9, letterSpacing: 1.5, fontWeight: FontWeight.w600),
                    ),
                    SliderTheme(
                      data: SliderThemeData(
                        activeTrackColor: tierColor,
                        inactiveTrackColor: Colors.white10,
                        thumbColor: tierColor,
                        overlayColor: tierColor.withValues(alpha: 0.2),
                        trackHeight: 4,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                      ),
                      child: Slider(
                        value: progress.toDouble(),
                        min: 0,
                        max: 100,
                        divisions: 20,
                        label: '$progress%',
                        onChanged: (val) {
                          final newProgress = val.round();
                          setLocalState(() {
                            _taskProgress[task.id] = newProgress;
                            // Reset intent when progress changes significantly
                            if (newProgress >= 100) {
                              _taskIntents[task.id] = true;
                            }
                          });
                          setState(() {});
                        },
                      ),
                    ),
                    // Progress marks
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: ['0%', '25%', '50%', '75%', '100%']
                            .map((l) => Text(l, style: const TextStyle(color: Colors.white24, fontSize: 9)))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Chronic procrastination warning
              if (isChronic)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _bloodRed.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: _bloodRed.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning_amber_rounded, color: _bloodRed, size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'This task has been carried forward ${task.carryForwardCount} times. Execute or kill it. No more extensions.',
                          style: TextStyle(color: _bloodRed, fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),

              // Intent assessment — shown when progress < 100
              if (progress < 100) ...[
                const SizedBox(height: 8),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF141414),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        progress >= 70
                            ? 'WILL YOU FINISH THIS TONIGHT?'
                            : 'BE HONEST — IS THIS GETTING DONE TODAY OR CARRIED?',
                        style: const TextStyle(color: Colors.white54, fontSize: 10, letterSpacing: 1.2, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: isChronic ? () {
                                _showError('Chronic procrastination! Executing or killing required — cannot carry forward.');
                              } : () {
                                setLocalState(() {
                                  _taskIntents[task.id] = true;
                                });
                                setState(() {});
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: intent == true && !isChronic
                                      ? Colors.greenAccent.withValues(alpha: 0.15)
                                      : Colors.white.withValues(alpha: 0.03),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: intent == true && !isChronic
                                        ? Colors.greenAccent.withValues(alpha: 0.5)
                                        : Colors.white10,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Icon(Icons.check_circle_outline,
                                        color: intent == true && !isChronic ? Colors.greenAccent : Colors.white38, size: 22),
                                    const SizedBox(height: 4),
                                    Text(
                                      isChronic ? 'BLOCKED' : 'YES — CARRY FORWARD',
                                      style: TextStyle(
                                        color: isChronic
                                            ? Colors.white24
                                            : (intent == true ? Colors.greenAccent : Colors.white38),
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setLocalState(() {
                                  _taskIntents[task.id] = false;
                                });
                                setState(() {});
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: intent == false
                                      ? _bloodRed.withValues(alpha: 0.15)
                                      : Colors.white.withValues(alpha: 0.03),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: intent == false
                                        ? _bloodRed.withValues(alpha: 0.5)
                                        : Colors.white10,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Icon(Icons.cancel_outlined,
                                        color: intent == false ? _bloodRed : Colors.white38, size: 22),
                                    const SizedBox(height: 4),
                                    Text(
                                      'NO — MARK FAILED',
                                      style: TextStyle(
                                        color: intent == false ? _bloodRed : Colors.white38,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],

              // Failure etiology dropdown — shown when intent is false OR (isChronic && intent != true)
              if (intent == false || (isChronic && intent != true)) ...[
                const SizedBox(height: 8),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF141414),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: current == FailureEtiology.none ? _bloodRed : _border,
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<FailureEtiology>(
                      isExpanded: true,
                      value: current,
                      dropdownColor: const Color(0xFF1A1A1A),
                      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white38),
                      style: TextStyle(
                        color: current == FailureEtiology.none ? _bloodRed : _dimWhite,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      onChanged: (val) {
                        setLocalState(() => _taskEtiologies[task.id] = val ?? FailureEtiology.none);
                        setState(() {});
                      },
                      items: FailureEtiology.values.map((tag) {
                        return DropdownMenuItem(
                          value: tag,
                          child: Text(labels[tag]!),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],

              // Auto-complete message for 100%
              if (progress >= 100)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.greenAccent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.greenAccent.withValues(alpha: 0.4)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.greenAccent, size: 18),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'This will be auto-marked as completed on submit.',
                          style: TextStyle(color: Colors.greenAccent, fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 12),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTextArea({
    required TextEditingController controller,
    required String hint,
    required int maxLines,
    int? maxLength,
    bool locked = false,
    Widget? suffix,
    Color accentColor = Colors.white12,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: locked ? Colors.white10 : _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TextField(
            controller: controller,
            enabled: !locked,
            maxLines: maxLines,
            maxLength: maxLength,
            style: TextStyle(
              color: locked ? Colors.white38 : _dimWhite,
              fontSize: 14,
              height: 1.6,
            ),
            decoration: InputDecoration(
              counterText: '',
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.white24, fontSize: 13),
              contentPadding: const EdgeInsets.all(16),
              border: InputBorder.none,
            ),
          ),
          if (suffix != null)
            Padding(
              padding: const EdgeInsets.only(right: 12, bottom: 8),
              child: suffix,
            ),
        ],
      ),
    );
  }

  Widget _buildCowardiceDropdown(bool locked) {
    final labels = {
      CowardiceTag.none: 'None Detected',
      CowardiceTag.avoidance: 'Avoidance',
      CowardiceTag.dishonesty: 'Dishonesty',
      CowardiceTag.mutedNeed: 'Muted Need',
      CowardiceTag.comfortSeeking: 'Comfort-Seeking',
    };

    return Container(
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: _selectedTag != CowardiceTag.none ? _bloodRed : _border,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<CowardiceTag>(
          isExpanded: true,
          value: _selectedTag,
          dropdownColor: const Color(0xFF1A1A1A),
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white38),
          style: TextStyle(
            color: _selectedTag != CowardiceTag.none ? _bloodRed : _dimWhite,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          onChanged: locked
              ? null
              : (val) => setState(() => _selectedTag = val ?? CowardiceTag.none),
          items: CowardiceTag.values.map((tag) {
            return DropdownMenuItem(
              value: tag,
              child: Text(labels[tag]!),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCostField(bool locked, double baseRate) {
    final hoursWasted = double.tryParse(_costController.text) ?? 0.0;
    final penalty = hoursWasted * baseRate;

    return Container(
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: _border),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Icon(Icons.timer_outlined, color: Colors.white54, size: 20),
          ),
          const VerticalDivider(color: Color(0xFF2A2A2A), width: 1, thickness: 1),
          Expanded(
            child: TextField(
              controller: _costController,
              enabled: !locked,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: TextStyle(
                color: locked ? Colors.white38 : _dimWhite,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                hintText: 'Hours Lost',
                hintStyle: TextStyle(color: Colors.white24, fontSize: 22),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: InputBorder.none,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: penalty > 0 ? _bloodRed.withValues(alpha: 0.1) : Colors.transparent,
              border: const Border(left: BorderSide(color: Color(0xFF2A2A2A))),
            ),
            child: Text(
              '-\$${penalty.toStringAsFixed(2)}',
              style: TextStyle(
                color: penalty > 0 ? _bloodRed : Colors.white24,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildDelusionWarningBanner(DelusionAnalysis analysis, TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: _bloodRed.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: _bloodRed.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.gavel_rounded, color: _bloodRed, size: 14),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'DELUSION FILTER: Passive phrase detected ("${analysis.phraseDetected}")',
                  style: TextStyle(
                    color: _bloodRed,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          InkWell(
            onTap: () {
              controller.text = analysis.suggestedRewrite;
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.white24),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.auto_fix_high, size: 12, color: Colors.white70),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      'CONVERT TO ACTIVE OWNERSHIP: "${analysis.suggestedRewrite}"',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

