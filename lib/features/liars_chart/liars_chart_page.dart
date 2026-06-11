import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/liar_goal.dart';
import 'liars_chart_provider.dart';

class LiarsChartPage extends ConsumerStatefulWidget {
  final bool isForced;
  const LiarsChartPage({super.key, this.isForced = false});

  @override
  ConsumerState<LiarsChartPage> createState() => _LiarsChartPageState();
}

class _LiarsChartPageState extends ConsumerState<LiarsChartPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _titleAnim;
  late Animation<Color?> _titleColorAnim;

  static const Color _accent = Color(0xFFFFBB00);
  static const Color _lie = Color(0xFFCC2222);

  @override
  void initState() {
    super.initState();
    _titleAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _titleColorAnim = ColorTween(begin: _lie, end: const Color(0xFFFF6666))
        .animate(_titleAnim);
  }

  @override
  void dispose() {
    _titleAnim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(liarsChartProvider);
    final anyLying = state.goals.any((g) => g.liarsChartActive);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: !widget.isForced,
        leading: widget.isForced ? null : IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white54, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: AnimatedBuilder(
          animation: _titleColorAnim,
          builder: (context, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'GOAL TRACKING',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 10,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  anyLying ? 'THE LIAR\'S CHART' : 'THE HONEST CHART',
                  style: TextStyle(
                    color: anyLying ? _titleColorAnim.value : Colors.white,
                    fontSize: 16,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white54),
            onPressed: () => _showAddGoalSheet(context),
          ),
        ],
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white24))
          : state.goals.isEmpty
              ? _buildEmptyState()
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
                  itemCount: state.goals.length,
                  separatorBuilder: (_, _x) => const SizedBox(height: 24),
                  itemBuilder: (context, i) {
                    return _buildGoalCard(state.goals[i]);
                  },
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.show_chart, color: Colors.white24, size: 48),
            const SizedBox(height: 16),
            const Text(
              'No goals yet. All goals are lies\nuntil the data proves otherwise.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white38, fontSize: 14, height: 1.6),
            ),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: () => _showAddGoalSheet(context),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white24),
              ),
              child: const Text(
                'ADD YOUR FIRST GOAL',
                style: TextStyle(color: Colors.white54, letterSpacing: 1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalCard(LiarGoal goal) {
    final isLying = goal.liarsChartActive;
    final borderColor = isLying ? _lie : Colors.white12;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor, width: isLying ? 1.5 : 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── HEADER ───────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        goal.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (isLying)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: _lie.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Text(
                            goal.isLeadFlat() ? 'LEAD METRIC FLAT — YOU\'RE NOT DOING THE WORK' : 'LEVER DISCONNECTED — PIVOT NOW',
                            style: const TextStyle(
                              color: _lie,
                              fontSize: 9,
                              letterSpacing: 1,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Colors.white38, size: 18),
                  color: const Color(0xFF1A1A1A),
                  onSelected: (val) {
                    if (val == 'log') _showLogSheet(context, goal);
                    if (val == 'delete') ref.read(liarsChartProvider.notifier).deleteGoal(goal.id);
                    if (val == 'webhook') _triggerWebhook(goal);
                  },
                  itemBuilder: (_) => [
                    const PopupMenuItem(value: 'log', child: Text('Log Metrics', style: TextStyle(color: Colors.white70))),
                    if (isLying)
                      const PopupMenuItem(value: 'webhook', child: Text('Send Accountability Alert', style: TextStyle(color: Color(0xFFCC2222)))),
                    const PopupMenuItem(value: 'delete', child: Text('Delete Goal', style: TextStyle(color: Colors.white38))),
                  ],
                ),
              ],
            ),
          ),

          // ─── METRIC LABELS ─────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _metricChip(
                    label: 'LEAD',
                    value: goal.leadMetricLabel,
                    unit: goal.leadUnit,
                    color: _accent),
                const SizedBox(width: 8),
                _metricChip(
                    label: 'LAG',
                    value: goal.lagMetricLabel,
                    unit: goal.lagUnit,
                    color: Colors.white38),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ─── DUAL AXIS CHART ───────────────────────────────────────────
          if (goal.leadHistory.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: _buildDualChart(goal),
            )
          else
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                'No data yet. Log your first cycle to start the chart.',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.25), fontSize: 12),
              ),
            ),

          // ─── LIAR ALERT ───────────────────────────────────────────────
          if (isLying)
            Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF1A0000),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: _lie.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    goal.isLeverDisconnected()
                        ? '"Your lever isn\'t connected to the gear. Stop doing more of what doesn\'t work. Pivot immediately."'
                        : '"Your lead metric is flat. The story you tell yourself about hustle is not reflected in the data."',
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 12, height: 1.6, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => _triggerWebhook(goal),
                    child: const Text(
                      'SEND ACCOUNTABILITY ALERT →',
                      style: TextStyle(
                        color: _lie,
                        fontSize: 10,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _metricChip({
    required String label,
    required String value,
    required String unit,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                  color: color, fontSize: 9, letterSpacing: 1.5, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              unit,
              style: const TextStyle(color: Colors.white38, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDualChart(LiarGoal goal) {
    final cycles = goal.leadHistory.length;
    if (cycles == 0) return const SizedBox.shrink();

    final maxLead = goal.leadHistory.reduce((a, b) => a > b ? a : b);
    final maxLag = goal.lagHistory.isNotEmpty
        ? goal.lagHistory.reduce((a, b) => a > b ? a : b)
        : 1.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(cycles, (i) {
            final leadFrac = maxLead > 0 ? goal.leadHistory[i] / maxLead : 0.0;
            final lagFrac = (i < goal.lagHistory.length && maxLag > 0)
                ? goal.lagHistory[i] / maxLag
                : 0.0;

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Lead bar
                    Container(
                      height: 60 * leadFrac,
                      decoration: BoxDecoration(
                        color: _accent.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 2),
                    // Lag bar
                    Container(
                      height: 60 * lagFrac,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${i + 1}',
                      style: const TextStyle(color: Colors.white24, fontSize: 9),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(width: 8, height: 8, color: _accent),
            const SizedBox(width: 6),
            Text(goal.leadMetricLabel,
                style: const TextStyle(color: Colors.white54, fontSize: 10)),
            const SizedBox(width: 16),
            Container(width: 8, height: 8, color: Colors.white24),
            const SizedBox(width: 6),
            Text(goal.lagMetricLabel,
                style: const TextStyle(color: Colors.white38, fontSize: 10)),
          ],
        ),
      ],
    );
  }

  void _triggerWebhook(LiarGoal goal) async {
    final contact = goal.accountabilityContact.isNotEmpty
        ? goal.accountabilityContact
        : 'your accountability partner';

    final message =
        '[K.A.I.R.O LIAR\'S CHART]\n\nI am failing my goal "${goal.title}".\n'
        'Lead metric ("${goal.leadMetricLabel}") is ${goal.isLeadFlat() ? 'FLAT' : 'not moving the needle'}.\n\n'
        'I am avoiding the work. Hold me to this.';

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF111111),
        title: const Text('ACCOUNTABILITY ALERT',
            style: TextStyle(
                color: Color(0xFFCC2222),
                fontSize: 14,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w800)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Send this to $contact:',
              style: const TextStyle(color: Colors.white54, fontSize: 12),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.white12),
              ),
              child: Text(
                message,
                style: const TextStyle(color: Colors.white70, fontSize: 12, height: 1.5),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: message));
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Color(0xFFCC2222),
                  content: Text('Message copied. Now send it. No excuses.',
                      style: TextStyle(color: Colors.white)),
                ),
              );
            },
            child: const Text('COPY & SEND',
                style: TextStyle(
                    color: Color(0xFFCC2222),
                    letterSpacing: 1,
                    fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }

  void _showAddGoalSheet(BuildContext context) {
    final titleCtrl = TextEditingController();
    final leadLabelCtrl = TextEditingController();
    final lagLabelCtrl = TextEditingController();
    final leadUnitCtrl = TextEditingController();
    final lagUnitCtrl = TextEditingController();
    final contactCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF111111),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
            24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('NEW GOAL',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5)),
              const SizedBox(height: 4),
              const Text(
                  'All goals are lies until the data proves otherwise.',
                  style: TextStyle(color: Colors.white38, fontSize: 12)),
              const SizedBox(height: 20),
              _sheetField(titleCtrl, 'Goal Title', 'e.g., Land first client'),
              const SizedBox(height: 12),
              _sheetField(leadLabelCtrl, 'Lead Metric (your action)',
                  'e.g., Cold emails sent'),
              const SizedBox(height: 8),
              _sheetField(leadUnitCtrl, 'Lead Unit', 'e.g., emails'),
              const SizedBox(height: 12),
              _sheetField(lagLabelCtrl, 'Lag Metric (the outcome you want)',
                  'e.g., Revenue'),
              const SizedBox(height: 8),
              _sheetField(lagUnitCtrl, 'Lag Unit', 'e.g., USD'),
              const SizedBox(height: 12),
              _sheetField(contactCtrl, 'Accountability Contact',
                  'e.g., john@example.com or @johnhandle'),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _accent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                  ),
                  onPressed: () {
                    if (titleCtrl.text.isEmpty ||
                        leadLabelCtrl.text.isEmpty ||
                        lagLabelCtrl.text.isEmpty) {
                      return;
                    }
                    final goal = LiarGoal()
                      ..title = titleCtrl.text.trim()
                      ..leadMetricLabel = leadLabelCtrl.text.trim()
                      ..lagMetricLabel = lagLabelCtrl.text.trim()
                      ..leadUnit = leadUnitCtrl.text.trim()
                      ..lagUnit = lagUnitCtrl.text.trim()
                      ..accountabilityContact = contactCtrl.text.trim();
                    ref.read(liarsChartProvider.notifier).addGoal(goal);
                    Navigator.pop(ctx);
                  },
                  child: const Text('CREATE GOAL',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogSheet(BuildContext context, LiarGoal goal) {
    final leadCtrl = TextEditingController();
    final lagCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF111111),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
            24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('LOG CYCLE — ${goal.title.toUpperCase()}',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1)),
            const SizedBox(height: 20),
            _sheetField(leadCtrl, '${goal.leadMetricLabel} (${goal.leadUnit})',
                'Enter the number'),
            const SizedBox(height: 12),
            _sheetField(lagCtrl, '${goal.lagMetricLabel} (${goal.lagUnit})',
                'Enter the number'),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _accent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                ),
                onPressed: () {
                  final lead = double.tryParse(leadCtrl.text) ?? 0;
                  final lag = double.tryParse(lagCtrl.text) ?? 0;
                  ref.read(liarsChartProvider.notifier).logMetrics(
                        goalId: goal.id,
                        leadValue: lead,
                        lagValue: lag,
                      );
                  Navigator.pop(ctx);
                },
                child: const Text('LOG CYCLE',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sheetField(
      TextEditingController ctrl, String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(),
            style: const TextStyle(
                color: Colors.white54,
                fontSize: 10,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.white12),
          ),
          child: TextField(
            controller: ctrl,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.white24, fontSize: 13),
              contentPadding: const EdgeInsets.all(14),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
