import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../decision_journal/decision_journal_page.dart';
import '../../decision_journal/providers/decision_journal_provider.dart';
import '../../../Nav/smooth_page_route.dart';
import '../../../core/theme/app_theme.dart';

class DecisionJournalCardWidget extends ConsumerWidget {
  const DecisionJournalCardWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(decisionJournalProvider);

    return InkWell(
      onTap: () => Navigator.push(context, SmoothPageRoute(page: const DecisionJournalPage())),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF14141A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withAlpha(40),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.balance, color: Colors.blueAccent, size: 20),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "DECISION JOURNAL PIPELINE",
                        style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1),
                      ),
                      SizedBox(height: 2),
                      Text("High-stakes bias & outcome tracking", style: TextStyle(color: Colors.white54, fontSize: 11)),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, color: Colors.white38, size: 14),
              ],
            ),
            const SizedBox(height: 16),
            state.when(
              data: (logs) {
                final pending = logs.where((l) => l.verdict == 'Pending').toList();
                final due = pending.where((l) => DateTime.now().isAfter(l.reviewDate)).length;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStat("PENDING", "${pending.length}", Colors.white),
                    _buildStat("DUE NOW", "$due", due > 0 ? const Color(0xFFD32F2F) : Colors.white54),
                    _buildStat("EVALUATED", "${logs.length - pending.length}", AppTheme.accent),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white24)),
              error: (_, _) => const Text("Failed to load decisions", style: TextStyle(color: Colors.redAccent, fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 9, letterSpacing: 1)),
      ],
    );
  }
}
