import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/kairo_design_system.dart';
import '../../core/services/weekly_roulette_service.dart';
import '../../core/models/report.dart';
import '../../main.dart';
import 'package:isar/isar.dart';

class RoulettePage extends ConsumerStatefulWidget {
  const RoulettePage({super.key});

  @override
  ConsumerState<RoulettePage> createState() => _RoulettePageState();
}

class _RoulettePageState extends ConsumerState<RoulettePage> {
  final TextEditingController _takeawayCtrl = TextEditingController();
  bool _isSaved = false;

  @override
  void dispose() {
    _takeawayCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rouletteAsync = ref.watch(thisWeekRouletteProvider);

    return Scaffold(
      backgroundColor: KairoTheme.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: KairoTheme.textPrimary,
          backgroundColor: KairoTheme.surfaceElevated,
          onRefresh: () async {
            ref.invalidate(thisWeekRouletteProvider);
            setState(() {});
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            slivers: [
              // System Header Bar
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(KairoTheme.xl, KairoTheme.lg, KairoTheme.xl, KairoTheme.sm),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "WEEKLY HORIZON",
                              style: TextStyle(
                                color: KairoTheme.textMuted,
                                fontSize: 10,
                                fontFamily: 'monospace',
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.5,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 2),
                            Text(
                              "5-MIN ROULETTE & REVIEW",
                              style: TextStyle(
                                color: KairoTheme.textPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.2,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8),
                      KairoStatus(label: "ZERO STREAKS", type: KairoStatusType.inferred),
                    ],
                  ),
                ),
              ),

              // Philosophy Banner
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: KairoTheme.xl, vertical: KairoTheme.xs),
                  child: KairoCard(
                    padding: const EdgeInsets.all(KairoTheme.md),
                    child: const Row(
                      children: [
                        Icon(Icons.explore_outlined, size: 16, color: KairoTheme.inferred),
                        SizedBox(width: KairoTheme.md),
                        Expanded(
                          child: Text(
                            "One curated mental model or system concept per week. No streaks, no guilt, no homework. Read only when curious.",
                            style: TextStyle(color: KairoTheme.textSecondary, fontSize: 11, height: 1.3),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Main Roulette Card
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(KairoTheme.xl, KairoTheme.sm, KairoTheme.xl, KairoTheme.sm),
                  child: rouletteAsync.when(
                    data: (item) {
                      if (_takeawayCtrl.text.isEmpty && item.userTakeaway != null) {
                        _takeawayCtrl.text = item.userTakeaway!;
                      }

                      return KairoCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                KairoStatus(label: item.category, type: KairoStatusType.observed),
                                Row(
                                  children: [
                                    const Icon(Icons.timer_outlined, size: 12, color: KairoTheme.textMuted),
                                    const SizedBox(width: 4),
                                    Text(
                                      "~5 MIN READ",
                                      style: TextStyle(
                                        color: KairoTheme.textMuted,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w800,
                                        fontFamily: 'monospace',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: KairoTheme.md),
                            Text(
                              item.topicTitle,
                              style: const TextStyle(
                                color: KairoTheme.textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: KairoTheme.sm),
                            Text(
                              item.summary,
                              style: const TextStyle(
                                color: KairoTheme.textSecondary,
                                fontSize: 12,
                                height: 1.5,
                              ),
                            ),
                            const KairoDivider(verticalMargin: KairoTheme.md),

                            // Reflection takeaway
                            const Text(
                              "OPTIONAL TAKEAWAY",
                              style: TextStyle(
                                color: KairoTheme.textMuted,
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'monospace',
                                letterSpacing: 1.1,
                              ),
                            ),
                            const SizedBox(height: KairoTheme.xs),
                            TextField(
                              controller: _takeawayCtrl,
                              maxLines: 3,
                              style: const TextStyle(color: KairoTheme.textPrimary, fontSize: 12),
                              decoration: InputDecoration(
                                hintText: "Capture a one-line insight or connection to your current systems...",
                                hintStyle: const TextStyle(color: KairoTheme.textFaint, fontSize: 11),
                                filled: true,
                                fillColor: KairoTheme.surfaceElevated,
                                contentPadding: const EdgeInsets.all(10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(KairoTheme.radiusSm),
                                  borderSide: const BorderSide(color: KairoTheme.border),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(KairoTheme.radiusSm),
                                  borderSide: const BorderSide(color: KairoTheme.border),
                                ),
                              ),
                            ),
                            const SizedBox(height: KairoTheme.md),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (item.explored || _isSaved)
                                  const Row(
                                    children: [
                                      Icon(Icons.check_circle, size: 14, color: KairoTheme.success),
                                      SizedBox(width: 4),
                                      Text(
                                        "SAVED TO ARCHIVE",
                                        style: TextStyle(
                                          color: KairoTheme.success,
                                          fontSize: 9,
                                          fontWeight: FontWeight.w800,
                                          fontFamily: 'monospace',
                                        ),
                                      ),
                                    ],
                                  )
                                else
                                  const SizedBox.shrink(),
                                KairoButton(
                                  text: "RECORD INSIGHT",
                                  isPrimary: true,
                                  onPressed: () async {
                                    await ref.read(weeklyRouletteServiceProvider).saveTakeaway(item.id, _takeawayCtrl.text);
                                    setState(() => _isSaved = true);
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text("Takeaway saved to weekly archive."),
                                          backgroundColor: KairoTheme.surfaceElevated,
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                    loading: () => const KairoCard(
                      child: SizedBox(
                        height: 180,
                        child: Center(child: CircularProgressIndicator(strokeWidth: 2, color: KairoTheme.textMuted)),
                      ),
                    ),
                    error: (err, _) => KairoCard(
                      child: Text("Error loading roulette: $err", style: const TextStyle(color: KairoTheme.warning)),
                    ),
                  ),
                ),
              ),

              // Historical Autopsy Archive Section Header
              const SliverToBoxAdapter(
                child: KairoSectionHeader(title: "HISTORICAL AUTOPSIES & DEBRIEFS"),
              ),

              // Historical Autopsy List
              FutureBuilder<List<Report>>(
                future: isar.reports.where().sortByGeneratedAtDesc().limit(10).findAll(),
                builder: (ctx, snap) {
                  final reports = snap.data ?? [];
                  if (reports.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: KairoEmptyState(
                        title: "NO ARCHIVED AUTOPSIES",
                        description: "Weekly synthesis autopsies generated from the Time mirror appear here.",
                      ),
                    );
                  }

                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final r = reports[index];
                        final dateRange = "${DateFormat('MMM d').format(r.periodStart)} – ${DateFormat('MMM d, yyyy').format(r.periodEnd)}";
                        final completionRate = r.plannedPeaks > 0 ? ((r.completedPeaks / r.plannedPeaks) * 100).toStringAsFixed(0) : "0";

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: KairoTheme.xl, vertical: 3),
                          child: KairoCard(
                            padding: const EdgeInsets.all(KairoTheme.md),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      dateRange.toUpperCase(),
                                      style: const TextStyle(
                                        color: KairoTheme.textPrimary,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                        fontFamily: 'monospace',
                                      ),
                                    ),
                                    KairoStatus(label: "$completionRate% CONVERGENCE", type: KairoStatusType.recommended),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  r.mirrorSummary,
                                  style: const TextStyle(color: KairoTheme.textSecondary, fontSize: 11, height: 1.3),
                                ),
                                if (r.rootCauseDiagnosis.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    "Diagnosis: ${r.rootCauseDiagnosis}",
                                    style: const TextStyle(color: KairoTheme.textMuted, fontSize: 10),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: reports.length,
                    ),
                  );
                },
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
    );
  }
}
