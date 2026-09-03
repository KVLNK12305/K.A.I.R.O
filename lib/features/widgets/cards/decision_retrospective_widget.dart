import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/models/decision_log.dart';
import '../../decision_journal/providers/decision_journal_provider.dart';
import '../../decision_journal/decision_journal_page.dart';
import 'package:kairo/Nav/smooth_page_route.dart';
import 'bento_card.dart';

class DecisionRetrospectiveWidget extends ConsumerWidget {
  const DecisionRetrospectiveWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final decisionsAsync = ref.watch(decisionJournalProvider);

    return decisionsAsync.when(
      data: (decisions) {
        final now = DateTime.now();
        final overdue = decisions.where((d) => d.verdict == 'Pending' && d.reviewDate.isBefore(now)).toList();

        if (overdue.isEmpty) {
          return const SizedBox.shrink();
        }

        final targetDecision = overdue.first;
        final daysAgo = now.difference(targetDecision.madeAt).inDays;

        return BentoCard(
          backgroundColor: const Color(0xFF1E1408),
          borderColor: const Color(0xFFFFB300).withValues(alpha: 0.4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.history_toggle_off_rounded, size: 16, color: Color(0xFFFFB300)),
                      const SizedBox(width: 8),
                      Text(
                        "PREDICTION RETROSPECTIVE DUE",
                        style: TextStyle(
                          color: const Color(0xFFFFB300).withValues(alpha: 0.9),
                          fontSize: 10,
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                  if (overdue.length > 1)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFB300).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "+${overdue.length - 1} more",
                        style: const TextStyle(
                          color: Color(0xFFFFB300),
                          fontSize: 10,
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                targetDecision.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Logged $daysAgo days ago • Confidence: ${targetDecision.confidenceScore}/10",
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 11,
                  fontFamily: 'monospace',
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.psychology_outlined, size: 14, color: Colors.amber),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Hypothesis: \"${targetDecision.expectedOutcome}\"",
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFB300),
                        foregroundColor: Colors.black,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () => _showReviewDialog(context, ref, targetDecision),
                      icon: const Icon(Icons.check_circle_outline_rounded, size: 16),
                      label: const Text(
                        "Evaluate Prediction",
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    tooltip: "Open Decision Journal",
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: 0.05),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      Navigator.push(context, SmoothPageRoute(page: const DecisionJournalPage()));
                    },
                    icon: const Icon(Icons.arrow_forward_rounded, size: 16, color: Colors.white70),
                  ),
                ],
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (err, stack) => const SizedBox.shrink(),
    );
  }

  void _showReviewDialog(BuildContext context, WidgetRef ref, DecisionLog decision) {
    final outcomeController = TextEditingController();
    String selectedVerdict = 'Successful';

    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          return AlertDialog(
            backgroundColor: const Color(0xFF181818),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
            ),
            title: Text(
              "Evaluate: ${decision.title}",
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "You predicted:\n\"${decision.expectedOutcome}\"",
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "VERDICT",
                    style: TextStyle(color: Colors.white54, fontSize: 10, fontFamily: 'monospace', fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: ['Successful', 'Flawed Assumption', 'Disastrous'].map((v) {
                      final isSelected = selectedVerdict == v;
                      Color c = Colors.green;
                      if (v == 'Flawed Assumption') c = Colors.amber;
                      if (v == 'Disastrous') c = Colors.red;

                      return ChoiceChip(
                        label: Text(v, style: TextStyle(fontSize: 11, color: isSelected ? Colors.black : Colors.white70, fontWeight: FontWeight.bold)),
                        selected: isSelected,
                        selectedColor: c,
                        backgroundColor: const Color(0xFF222222),
                        onSelected: (val) {
                          if (val) setModalState(() => selectedVerdict = v);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "WHAT ACTUALLY HAPPENED?",
                    style: TextStyle(color: Colors.white54, fontSize: 10, fontFamily: 'monospace', fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: outcomeController,
                    maxLines: 3,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    decoration: InputDecoration(
                      hintText: "State the objective facts without excuses...",
                      hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3), fontSize: 12),
                      filled: true,
                      fillColor: const Color(0xFF222222),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogCtx),
                child: const Text("Cancel", style: TextStyle(color: Colors.white54)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.cyan,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () async {
                  final outcome = outcomeController.text.trim();
                  if (outcome.isEmpty) return;

                  await ref.read(decisionJournalProvider.notifier).reviewDecision(
                    id: decision.id,
                    actualOutcome: outcome,
                    verdict: selectedVerdict,
                  );

                  if (context.mounted) {
                    Navigator.pop(dialogCtx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text("Prediction outcome recorded. Honesty loop closed.", style: TextStyle(color: Colors.black)),
                        backgroundColor: AppTheme.cyan,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                child: const Text("Save Evaluation", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          );
        },
      ),
    );
  }
}
