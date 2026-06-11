import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'providers/command_center_provider.dart';
import 'providers/finance_provider.dart';
import 'providers/github_provider.dart';
import 'providers/wakatime_provider.dart';
import 'settings_page.dart';

class CommandCenterPage extends ConsumerStatefulWidget {
  const CommandCenterPage({super.key});

  @override
  ConsumerState<CommandCenterPage> createState() => _CommandCenterPageState();
}

class _CommandCenterPageState extends ConsumerState<CommandCenterPage> {
  late TextEditingController _scratchpadController;

  @override
  void initState() {
    super.initState();
    _scratchpadController = TextEditingController();
  }

  @override
  void dispose() {
    _scratchpadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scratchpadState = ref.watch(commandCenterProvider);
    final githubState = ref.watch(githubPRsProvider);
    final wakatimeState = ref.watch(wakatimeProvider);
    final financeState = ref.watch(financeMetricsProvider);
    final today = DateFormat('MMMM d, yyyy').format(DateTime.now());

    // Sync the controller with the loaded state once
    scratchpadState.whenData((content) {
      if (_scratchpadController.text != content && _scratchpadController.text.isEmpty && content.isNotEmpty) {
         _scratchpadController.text = content;
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    today.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings_outlined, color: Colors.white54, size: 20),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage()));
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // THE OBJECTIVE
              TextField(
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  hintText: "What is the main objective today?",
                  hintStyle: TextStyle(
                    color: Colors.white.withValues(alpha: 0.2),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  border: InputBorder.none,
                ),
                maxLines: null,
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(height: 40),
              
              // THE SCRATCHPAD
              const Text(
                "SCRATCHPAD",
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 10,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                constraints: const BoxConstraints(minHeight: 150),
                child: scratchpadState.isLoading
                    ? const Center(child: CircularProgressIndicator(color: Colors.white24))
                    : TextField(
                        controller: _scratchpadController,
                        onChanged: (val) {
                          ref.read(commandCenterProvider.notifier).updateNotes(val);
                        },
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          height: 1.5,
                          fontFamily: 'monospace', // Gives it that terminal/markdown feel
                        ),
                        decoration: InputDecoration(
                          hintText: "Brain dump, scratchpad, notes...",
                          hintStyle: TextStyle(
                            color: Colors.white.withValues(alpha: 0.2),
                          ),
                          border: InputBorder.none,
                        ),
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                      ),
              ),

              const SizedBox(height: 32),

              // METRICS (WAKATIME)
              const Text(
                "DEEP WORK METRICS",
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 10,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              wakatimeState.when(
                data: (hours) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: _buildMetricItem(Icons.code, "Coding Today", hours),
                ),
                loading: () => const CircularProgressIndicator(color: Colors.white24),
                error: (err, stack) => Text("WakaTime Error: ${err.toString().replaceAll('Exception: ', '')}", style: const TextStyle(color: Colors.redAccent, fontSize: 12)),
              ),
              financeState.when(
                data: (metrics) => Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: _buildMetricItem(Icons.attach_money, "Burn Rate Today", "\$${metrics.todayExpense.toStringAsFixed(2)}"),
                    ),
                    _buildMetricItem(Icons.account_balance_wallet, "Burn Rate This Month", "\$${metrics.monthExpense.toStringAsFixed(2)}"),
                  ],
                ),
                loading: () => const SizedBox.shrink(),
                error: (err, stack) => const SizedBox.shrink(),
              ),
              const SizedBox(height: 32),
              
              // GITHUB MOCK
              const Text(
                "ACTIVE PULL REQUESTS",
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 10,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              githubState.when(
                data: (prs) {
                  if (prs.isEmpty) {
                    return const Text("No active PRs. You're all caught up!", style: TextStyle(color: Colors.white38, fontSize: 12));
                  }
                  return Column(
                    children: prs.map((pr) {
                      final timeAgo = DateTime.now().difference(pr.createdAt).inDays;
                      final timeString = timeAgo == 0 ? "today" : "$timeAgo days ago";
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: _buildMockGitHubItem("${pr.repoName} / ${pr.title}", "#${pr.number} • Opened $timeString"),
                      );
                    }).toList(),
                  );
                },
                loading: () => const CircularProgressIndicator(color: Colors.white24),
                error: (err, stack) => Text("Error loading PRs: ${err.toString().replaceAll('Exception: ', '')}", style: const TextStyle(color: Colors.redAccent, fontSize: 12)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMockGitHubItem(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          const Icon(Icons.merge_type, color: Colors.greenAccent, size: 16),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white38, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem(IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.purpleAccent, size: 16),
              const SizedBox(width: 12),
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
            ],
          ),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
