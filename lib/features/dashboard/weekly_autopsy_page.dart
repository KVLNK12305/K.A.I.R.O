import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../main.dart';
import '../../core/models/weekly_autopsy.dart';
import '../../core/services/weekly_autopsy_service.dart';
import '../../core/theme/app_theme.dart';
import 'providers/wakatime_provider.dart';
import 'providers/github_provider.dart';
import 'providers/finance_provider.dart';

final weeklyAutopsyListProvider = FutureProvider.autoDispose<List<WeeklyAutopsy>>((ref) async {
  return await WeeklyAutopsyService(isar).getHistoricalAutopsies();
});

class WeeklyAutopsyPage extends ConsumerStatefulWidget {
  const WeeklyAutopsyPage({super.key});

  @override
  ConsumerState<WeeklyAutopsyPage> createState() => _WeeklyAutopsyPageState();
}

class _WeeklyAutopsyPageState extends ConsumerState<WeeklyAutopsyPage> {
  bool _isGenerating = false;
  WeeklyAutopsy? _selectedAutopsy;

  @override
  void initState() {
    super.initState();
    _loadLatest();
  }

  Future<void> _loadLatest() async {
    final latest = await WeeklyAutopsyService(isar).getLatestAutopsy();
    if (mounted) {
      setState(() => _selectedAutopsy = latest);
    }
  }

  Future<void> _generateNew() async {
    setState(() => _isGenerating = true);
    try {
      final wakaStr = ref.read(wakatimeProvider).valueOrNull ?? '0';
      double wakaHours = 0.0;
      final match = RegExp(r'([0-9.]+)\s*h').firstMatch(wakaStr);
      if (match != null) {
        wakaHours = double.tryParse(match.group(1) ?? '0') ?? 0.0;
      }
      final prCount = ref.read(githubPRsProvider).valueOrNull?.length ?? 0;
      final burn = ref.read(financeMetricsProvider).valueOrNull?.monthExpense ?? 0.0;

      final result = await WeeklyAutopsyService(isar).generateOrUpdateWeeklyAutopsy(
        wakatimeHours: wakaHours,
        githubPrs: prCount,
        burnRate: burn,
      );

      ref.invalidate(weeklyAutopsyListProvider);
      if (mounted) {
        setState(() {
          _selectedAutopsy = result;
          _isGenerating = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isGenerating = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Autopsy generation failed: $e", style: const TextStyle(color: Colors.white)),
            backgroundColor: AppTheme.warning,
          ),
        );
      }
    }
  }

  Color _getScoreColor(double score) {
    if (score < 40) return const Color(0xFFD32F2F);
    if (score < 75) return const Color(0xFFFFA000);
    return const Color(0xFF00E676);
  }

  @override
  Widget build(BuildContext context) {
    final historyAsync = ref.watch(weeklyAutopsyListProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("WEEKLY AUTOPSY", style: TextStyle(letterSpacing: 2.5, fontSize: 14, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: _isGenerating
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white70))
                : const Icon(Icons.refresh, color: Colors.white70),
            tooltip: "Run New Autopsy Synthesis",
            onPressed: _isGenerating ? null : _generateNew,
          ),
        ],
      ),
      body: _selectedAutopsy == null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.gavel, color: Colors.white24, size: 64),
                    const SizedBox(height: 16),
                    const Text(
                      "NO AUTOPSY RECORD FOUND",
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Synthesize your first 7-day systemic report to calculate your composite Power Score and receive your AI critique.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white54, fontSize: 13),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accent,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      ),
                      onPressed: _isGenerating ? null : _generateNew,
                      icon: _isGenerating
                          ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                          : const Icon(Icons.bolt),
                      label: Text(_isGenerating ? "SYNTHESIZING..." : "RUN FIRST AUTOPSY", style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
                    ),
                  ],
                ),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // History Selector if more than 1
                  historyAsync.when(
                    data: (list) {
                      if (list.length <= 1) return const SizedBox.shrink();
                      return Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF151515),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<WeeklyAutopsy>(
                            value: list.any((a) => a.id == _selectedAutopsy?.id) ? list.firstWhere((a) => a.id == _selectedAutopsy?.id) : list.first,
                            dropdownColor: const Color(0xFF1F1F1F),
                            style: const TextStyle(color: Colors.white, fontSize: 13),
                            isExpanded: true,
                            items: list.map((a) {
                              final start = DateFormat('MMM d').format(a.weekStartDate);
                              final end = DateFormat('MMM d, yyyy').format(a.weekEndDate);
                              return DropdownMenuItem(
                                value: a,
                                child: Text("Week of $start – $end (Power: ${a.powerScore.toStringAsFixed(0)})"),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedAutopsy = val);
                            },
                          ),
                        ),
                      );
                    },
                    loading: () => const SizedBox.shrink(),
                    error: (_, _) => const SizedBox.shrink(),
                  ),

                  // Power Score Hero Card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF141414),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _getScoreColor(_selectedAutopsy!.powerScore).withAlpha(100), width: 1.5),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "7-DAY COMPOSITE POWER SCORE",
                          style: TextStyle(color: Colors.white54, fontSize: 11, letterSpacing: 2, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 130,
                              height: 130,
                              child: CircularProgressIndicator(
                                value: _selectedAutopsy!.powerScore / 100.0,
                                strokeWidth: 10,
                                backgroundColor: Colors.white10,
                                valueColor: AlwaysStoppedAnimation<Color>(_getScoreColor(_selectedAutopsy!.powerScore)),
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _selectedAutopsy!.powerScore.toStringAsFixed(0),
                                  style: TextStyle(
                                    color: _getScoreColor(_selectedAutopsy!.powerScore),
                                    fontSize: 38,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const Text("out of 100", style: TextStyle(color: Colors.white38, fontSize: 10)),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildMetricStat("PEAK RATE", "${(_selectedAutopsy!.peakExecutionRate * 100).toStringAsFixed(0)}%"),
                            _buildMetricStat("AVG STRESS", "${_selectedAutopsy!.averageStressScore.toStringAsFixed(0)}%"),
                            _buildMetricStat("DEEP WORK", "${_selectedAutopsy!.wakatimeTotalHours.toStringAsFixed(1)}h"),
                            _buildMetricStat("PRS LOGGED", "${_selectedAutopsy!.githubPrCount}"),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  const Text("AI BRUTALIST DIAGNOSIS", style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2)),
                  const SizedBox(height: 12),

                  _buildPillarCard(
                    title: "THE VERDICT",
                    content: _selectedAutopsy!.aiVerdict,
                    icon: Icons.gavel,
                    borderColor: Colors.blueAccent,
                  ),
                  const SizedBox(height: 14),
                  _buildPillarCard(
                    title: "SYSTEMIC ROOT CAUSE",
                    content: _selectedAutopsy!.aiRootCause,
                    icon: Icons.warning_amber_rounded,
                    borderColor: const Color(0xFFD32F2F),
                  ),
                  const SizedBox(height: 14),
                  _buildPillarCard(
                    title: "REQUIRED PIVOT NEXT WEEK",
                    content: _selectedAutopsy!.aiRequiredPivot,
                    icon: Icons.bolt,
                    borderColor: const Color(0xFF00E676),
                  ),

                  const SizedBox(height: 32),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF222222),
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white24),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: _isGenerating ? null : _generateNew,
                      icon: _isGenerating
                          ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.refresh, size: 20),
                      label: Text(_isGenerating ? "SYNTHESIZING REPORT..." : "RUN NEW SYNTHESIS NOW", style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5, fontSize: 12)),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildMetricStat(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 9, letterSpacing: 1)),
      ],
    );
  }

  Widget _buildPillarCard({required String title, required String content, required IconData icon, required Color borderColor}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: borderColor, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: borderColor, size: 18),
              const SizedBox(width: 8),
              Text(title, style: TextStyle(color: borderColor, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            content.isEmpty ? "No assessment available." : content,
            style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.4),
          ),
        ],
      ),
    );
  }
}
