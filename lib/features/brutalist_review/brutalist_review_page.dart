import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/models/brutalist_review.dart';
import '../../core/models/task.dart';
import '../energy_economy/energy_provider.dart';
import '../profile/providers/profile_provider.dart';
import '../profile/providers/profile_provider.dart';
import 'brutalist_provider.dart';
import '../../core/theme/app_theme.dart';
class BrutalistReviewPage extends ConsumerStatefulWidget {
  const BrutalistReviewPage({super.key});

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
    // Validate unresolved tasks
    for (final t in unresolvedTasks) {
      if (_taskEtiologies[t.id] == null || _taskEtiologies[t.id] == FailureEtiology.none) {
        _showError('You left Peak tasks unfinished. Assign a failure etiology to "${t.title}". No escape.');
        return;
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

    // Fail the tasks in the Energy Economy
    final energyNotifier = ref.read(energyEconomyProvider.notifier);
    for (final entry in _taskEtiologies.entries) {
      if (entry.value != FailureEtiology.none) {
        await energyNotifier.failTask(entry.key, entry.value);
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

    setState(() => _submitted = true);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: _bloodRed,
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

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(brutalistProvider);
    final profile = ref.watch(profileProvider);

    if (!state.isLoading && state.todayReview != null && !_submitted) {
      _prefill(state.todayReview!);
    }

    final today = DateFormat('MMMM d, yyyy').format(DateTime.now()).toUpperCase();
    final isLocked = _submitted;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white54, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
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
                    _sectionLabel('00 — THE FAILURES'),
                    const SizedBox(height: 4),
                    const Text(
                      'You assigned these peak tasks but did not complete them. Categorize your failure before proceeding.',
                      style: TextStyle(color: Colors.white38, fontSize: 12),
                    ),
                    const SizedBox(height: 12),
                    ...state.unresolvedTasks.map((t) => _buildEtiologySelector(t)),
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

  Widget _buildEtiologySelector(Task task) {
    final current = _taskEtiologies[task.id] ?? FailureEtiology.none;
    final labels = {
      FailureEtiology.none: 'Select Etiology...',
      FailureEtiology.miscalibratedEnergy: 'Miscalibrated Energy',
      FailureEtiology.taskAversive: 'Task Aversive',
      FailureEtiology.scopeTooLarge: 'Scope Too Large',
      FailureEtiology.protectedTimeStolen: 'Protected Time Stolen',
      FailureEtiology.didntWantItEnough: 'Didn\'t Want It Enough',
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: current == FailureEtiology.none ? _bloodRed : _border,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(task.title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          DropdownButtonHideUnderline(
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
              onChanged: (val) => setState(() => _taskEtiologies[task.id] = val ?? FailureEtiology.none),
              items: FailureEtiology.values.map((tag) {
                return DropdownMenuItem(
                  value: tag,
                  child: Text(labels[tag]!),
                );
              }).toList(),
            ),
          ),
        ],
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
        ],
      ),
    );
  }
}
