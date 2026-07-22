import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/models/decision_log.dart';
import '../../core/theme/app_theme.dart';
import 'providers/decision_journal_provider.dart';

class DecisionJournalPage extends ConsumerStatefulWidget {
  const DecisionJournalPage({super.key});

  @override
  ConsumerState<DecisionJournalPage> createState() => _DecisionJournalPageState();
}

class _DecisionJournalPageState extends ConsumerState<DecisionJournalPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showNewDecisionDialog() {
    showDialog(
      context: context,
      builder: (_) => const _NewDecisionDialog(),
    );
  }

  void _showReviewDialog(DecisionLog log) {
    showDialog(
      context: context,
      builder: (_) => _ReviewDecisionDialog(log: log),
    );
  }

  Color _getVerdictColor(String verdict) {
    switch (verdict) {
      case 'Successful':
        return const Color(0xFF00E676);
      case 'Flawed Assumption':
        return const Color(0xFFFFA000);
      case 'Disastrous':
        return const Color(0xFFD32F2F);
      default:
        return Colors.blueAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(decisionJournalProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("DECISION JOURNAL", style: TextStyle(letterSpacing: 2.5, fontSize: 14, fontWeight: FontWeight.bold)),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.accent,
          labelColor: AppTheme.accent,
          unselectedLabelColor: Colors.white38,
          labelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.5),
          tabs: const [
            Tab(text: "PENDING REVIEW"),
            Tab(text: "ARCHIVED VERDICTS"),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.accent,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.add_task),
        label: const Text("LOG DECISION", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
        onPressed: _showNewDecisionDialog,
      ),
      body: state.when(
        data: (logs) {
          final pending = logs.where((l) => l.verdict == 'Pending').toList();
          final archived = logs.where((l) => l.verdict != 'Pending').toList();

          return TabBarView(
            controller: _tabController,
            children: [
              _buildLogList(pending, isPending: true),
              _buildLogList(archived, isPending: false),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: Colors.white24)),
        error: (err, _) => Center(child: Text("Error loading journal: $err", style: const TextStyle(color: Colors.redAccent))),
      ),
    );
  }

  Widget _buildLogList(List<DecisionLog> list, {required bool isPending}) {
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isPending ? Icons.pending_actions : Icons.archive_outlined, color: Colors.white24, size: 54),
            const SizedBox(height: 12),
            Text(
              isPending ? "NO PENDING DECISIONS" : "NO ARCHIVED VERDICTS",
              style: const TextStyle(color: Colors.white54, fontSize: 13, letterSpacing: 1.5, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              isPending ? "Log high-stakes assumptions today to test against reality later." : "Reviewed outcomes and bias evaluations will appear here.",
              style: const TextStyle(color: Colors.white38, fontSize: 11),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 96),
      itemCount: list.length,
      itemBuilder: (_, i) {
        final log = list[i];
        final madeStr = DateFormat('MMM d, yyyy').format(log.madeAt);
        final reviewStr = DateFormat('MMM d, yyyy').format(log.reviewDate);
        final isDue = DateTime.now().isAfter(log.reviewDate) && isPending;

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFF141414),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isPending
                  ? (isDue ? const Color(0xFFD32F2F) : Colors.white12)
                  : _getVerdictColor(log.verdict).withAlpha(120),
              width: isDue || !isPending ? 1.5 : 1.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      log.title.toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                    ),
                  ),
                  if (!isPending)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getVerdictColor(log.verdict).withAlpha(40),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: _getVerdictColor(log.verdict)),
                      ),
                      child: Text(log.verdict.toUpperCase(), style: TextStyle(color: _getVerdictColor(log.verdict), fontSize: 10, fontWeight: FontWeight.bold)),
                    )
                  else if (isDue)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: const Color(0xFFD32F2F), borderRadius: BorderRadius.circular(4)),
                      child: const Text("DUE FOR REVIEW", style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildTag("Confidence: ${log.confidenceScore}/10", Colors.amber),
                  const SizedBox(width: 8),
                  if (log.emotionalState.isNotEmpty)
                    _buildTag("Mood: ${log.emotionalState}", Colors.blueAccent),
                ],
              ),
              const SizedBox(height: 12),
              const Text("CONTEXT & PRESSURES:", style: TextStyle(color: Colors.white38, fontSize: 10, letterSpacing: 1)),
              const SizedBox(height: 2),
              Text(log.contextDescription, style: const TextStyle(color: Colors.white70, fontSize: 12, height: 1.4)),
              const SizedBox(height: 10),
              const Text("PREDICTED HYPOTHESIS:", style: TextStyle(color: Colors.white38, fontSize: 10, letterSpacing: 1)),
              const SizedBox(height: 2),
              Text(log.expectedOutcome, style: const TextStyle(color: Colors.white, fontSize: 12, fontStyle: FontStyle.italic)),
              
              if (!isPending && log.actualOutcome.isNotEmpty) ...[
                const SizedBox(height: 12),
                const Divider(color: Colors.white12),
                const SizedBox(height: 6),
                const Text("ACTUAL REALITY / POST-MORTEM:", style: TextStyle(color: Colors.white38, fontSize: 10, letterSpacing: 1)),
                const SizedBox(height: 2),
                Text(log.actualOutcome, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
              ],

              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Logged: $madeStr • Review: $reviewStr", style: const TextStyle(color: Colors.white38, fontSize: 10)),
                  if (isPending)
                    TextButton.icon(
                      style: TextButton.styleFrom(foregroundColor: AppTheme.accent),
                      icon: const Icon(Icons.balance, size: 16),
                      label: const Text("EVALUATE NOW", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                      onPressed: () => _showReviewDialog(log),
                    )
                  else
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.white24, size: 18),
                      tooltip: "Delete Log",
                      onPressed: () => ref.read(decisionJournalProvider.notifier).deleteDecision(log.id),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withAlpha(100)),
      ),
      child: Text(text, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w600)),
    );
  }
}

class _NewDecisionDialog extends ConsumerStatefulWidget {
  const _NewDecisionDialog();

  @override
  ConsumerState<_NewDecisionDialog> createState() => _NewDecisionDialogState();
}

class _NewDecisionDialogState extends ConsumerState<_NewDecisionDialog> {
  final _titleCtrl = TextEditingController();
  final _contextCtrl = TextEditingController();
  final _outcomeCtrl = TextEditingController();
  int _confidence = 6;
  String _emotion = 'Calculated';
  int _reviewDays = 30;

  final List<String> _emotions = ['Calculated', 'Anxious', 'Desperate', 'Inspired', 'Frustrated', 'Opportunistic'];

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contextCtrl.dispose();
    _outcomeCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_titleCtrl.text.trim().isEmpty || _outcomeCtrl.text.trim().isEmpty) return;
    ref.read(decisionJournalProvider.notifier).addDecision(
          title: _titleCtrl.text.trim(),
          contextDescription: _contextCtrl.text.trim(),
          expectedOutcome: _outcomeCtrl.text.trim(),
          confidenceScore: _confidence,
          emotionalState: _emotion,
          reviewDays: _reviewDays,
        );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF181818),
      title: const Text("LOG HIGH-STAKES DECISION", style: TextStyle(color: Colors.white, fontSize: 14, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleCtrl,
              style: const TextStyle(color: Colors.white, fontSize: 13),
              decoration: const InputDecoration(labelText: "Decision Title (e.g., Pivot to B2B)", labelStyle: TextStyle(color: Colors.white54, fontSize: 12)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _contextCtrl,
              maxLines: 3,
              style: const TextStyle(color: Colors.white, fontSize: 13),
              decoration: const InputDecoration(labelText: "Context & Pressures (Why make this now?)", labelStyle: TextStyle(color: Colors.white54, fontSize: 12)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _outcomeCtrl,
              maxLines: 2,
              style: const TextStyle(color: Colors.white, fontSize: 13),
              decoration: const InputDecoration(labelText: "Predicted Outcome / Hypothesis", labelStyle: TextStyle(color: Colors.white54, fontSize: 12)),
            ),
            const SizedBox(height: 16),
            Text("Confidence Score: $_confidence / 10", style: const TextStyle(color: Colors.white70, fontSize: 12)),
            Slider(
              value: _confidence.toDouble(),
              min: 1,
              max: 10,
              divisions: 9,
              activeColor: AppTheme.accent,
              onChanged: (v) => setState(() => _confidence = v.round()),
            ),
            const SizedBox(height: 8),
            const Text("Dominant Emotion:", style: TextStyle(color: Colors.white70, fontSize: 12)),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              children: _emotions.map((e) {
                final selected = _emotion == e;
                return ChoiceChip(
                  label: Text(e, style: TextStyle(fontSize: 10, color: selected ? Colors.black : Colors.white70)),
                  selected: selected,
                  selectedColor: AppTheme.accent,
                  backgroundColor: const Color(0xFF242424),
                  onSelected: (val) => setState(() => _emotion = e),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              value: _reviewDays,
              dropdownColor: const Color(0xFF242424),
              style: const TextStyle(color: Colors.white, fontSize: 12),
              decoration: const InputDecoration(labelText: "Review Due In", labelStyle: TextStyle(color: Colors.white54)),
              items: const [
                DropdownMenuItem(value: 7, child: Text("1 Week (Short loop)")),
                DropdownMenuItem(value: 14, child: Text("2 Weeks (Sprint)")),
                DropdownMenuItem(value: 30, child: Text("30 Days (Standard)")),
                DropdownMenuItem(value: 90, child: Text("90 Days (Quarterly)")),
              ],
              onChanged: (v) => setState(() => _reviewDays = v ?? 30),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCEL", style: TextStyle(color: Colors.white54))),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accent, foregroundColor: Colors.black),
          onPressed: _submit,
          child: const Text("COMMIT DECISION", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}

class _ReviewDecisionDialog extends ConsumerStatefulWidget {
  final DecisionLog log;
  const _ReviewDecisionDialog({required this.log});

  @override
  ConsumerState<_ReviewDecisionDialog> createState() => _ReviewDecisionDialogState();
}

class _ReviewDecisionDialogState extends ConsumerState<_ReviewDecisionDialog> {
  final _actualCtrl = TextEditingController();
  String _verdict = 'Successful';

  @override
  void initState() {
    super.initState();
    _actualCtrl.text = widget.log.actualOutcome;
    if (widget.log.verdict != 'Pending') _verdict = widget.log.verdict;
  }

  @override
  void dispose() {
    _actualCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_actualCtrl.text.trim().isEmpty) return;
    ref.read(decisionJournalProvider.notifier).reviewDecision(
          id: widget.log.id,
          actualOutcome: _actualCtrl.text.trim(),
          verdict: _verdict,
        );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF181818),
      title: Text("POST-MORTEM: ${widget.log.title.toUpperCase()}", style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(6)),
            child: Text("Predicted: \"${widget.log.expectedOutcome}\"", style: const TextStyle(color: Colors.white70, fontSize: 11, fontStyle: FontStyle.italic)),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _actualCtrl,
            maxLines: 4,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            decoration: const InputDecoration(
              labelText: "What actually happened vs. expectation?",
              labelStyle: TextStyle(color: Colors.white54, fontSize: 12),
            ),
          ),
          const SizedBox(height: 16),
          const Text("Final Verdict:", style: TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _verdict,
            dropdownColor: const Color(0xFF242424),
            style: const TextStyle(color: Colors.white, fontSize: 13),
            items: const [
              DropdownMenuItem(value: 'Successful', child: Text("Successful ✅ (Accurate hypothesis)")),
              DropdownMenuItem(value: 'Flawed Assumption', child: Text("Flawed Assumption ⚠️ (Wrong bias)")),
              DropdownMenuItem(value: 'Disastrous', child: Text("Disastrous ❌ (Major calculation error)")),
            ],
            onChanged: (v) => setState(() => _verdict = v ?? 'Successful'),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCEL", style: TextStyle(color: Colors.white54))),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accent, foregroundColor: Colors.black),
          onPressed: _submit,
          child: const Text("SEAL VERDICT", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
