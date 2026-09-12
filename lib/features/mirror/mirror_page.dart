import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/kairo_design_system.dart';
import '../../core/services/ledger_service.dart';
import '../../core/models/daily_plan.dart';
import '../../core/models/report.dart';
import '../../core/services/weekly_autopsy_service.dart';
import '../../main.dart';
import 'package:isar/isar.dart';

class MirrorPage extends ConsumerStatefulWidget {
  const MirrorPage({super.key});

  @override
  ConsumerState<MirrorPage> createState() => _MirrorPageState();
}

class _MirrorPageState extends ConsumerState<MirrorPage> {
  bool _isGeneratingReport = false;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final weekStart = DateTime(now.year, now.month, now.day).subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));
    final weekFormat = '${DateFormat('MMM d').format(weekStart)} – ${DateFormat('MMM d, yyyy').format(weekEnd)}';

    final ledgerAsync = ref.watch(weeklyLedgerProvider);
    final plansAsync = ref.watch(weeklyPlansProvider);

    return Scaffold(
      backgroundColor: KairoTheme.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: KairoTheme.textPrimary,
          backgroundColor: KairoTheme.surfaceElevated,
          onRefresh: () async {
            ref.invalidate(weeklyLedgerProvider);
            ref.invalidate(weeklyPlansProvider);
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            slivers: [
              // System Header Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(KairoTheme.xl, KairoTheme.lg, KairoTheme.xl, KairoTheme.sm),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              weekFormat.toUpperCase(),
                              style: const TextStyle(
                                color: KairoTheme.textMuted,
                                fontSize: 10,
                                fontFamily: 'monospace',
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.5,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              "THE 168-HOUR MIRROR",
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
                      const SizedBox(width: 8),
                      const KairoStatus(label: "168H ZERO-SUM", type: KairoStatusType.recommended),
                    ],
                  ),
                ),
              ),

              // Doctrine Callout
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: KairoTheme.xl, vertical: KairoTheme.xs),
                  child: KairoCard(
                    padding: const EdgeInsets.all(KairoTheme.md),
                    child: const Row(
                      children: [
                        Icon(Icons.hourglass_bottom_rounded, size: 16, color: KairoTheme.recommended),
                        SizedBox(width: KairoTheme.md),
                        Expanded(
                          child: Text(
                            "168 Hours. Nothing more. Nothing less. Unassigned time is unobserved, never free.",
                            style: TextStyle(color: KairoTheme.textSecondary, fontSize: 11, height: 1.3),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Bandwidth Allocation Ledger Card
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(KairoTheme.xl, KairoTheme.md, KairoTheme.xl, KairoTheme.sm),
                  child: ledgerAsync.when(
                    data: (breakdown) => _buildLedgerAllocationCard(breakdown),
                    loading: () => const KairoCard(
                      child: SizedBox(
                        height: 120,
                        child: Center(child: CircularProgressIndicator(strokeWidth: 2, color: KairoTheme.textMuted)),
                      ),
                    ),
                    error: (err, _) => KairoCard(
                      child: Text("Ledger error: $err", style: const TextStyle(color: KairoTheme.warning)),
                    ),
                  ),
                ),
              ),

              // Reality vs Intention Divergence Card
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(KairoTheme.xl, KairoTheme.sm, KairoTheme.xl, KairoTheme.sm),
                  child: plansAsync.when(
                    data: (plans) => _buildDivergenceCard(plans),
                    loading: () => const SizedBox.shrink(),
                    error: (_, _) => const SizedBox.shrink(),
                  ),
                ),
              ),

              // Autopsy & Debrief Action Card
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(KairoTheme.xl, KairoTheme.sm, KairoTheme.xl, 100),
                  child: _buildAutopsyActionCard(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLedgerAllocationCard(LedgerBreakdown breakdown) {
    const total = 168.0;
    final sleepPct = (breakdown.sleepHours / total).clamp(0.0, 1.0);
    final maintPct = (breakdown.maintenanceHours / total).clamp(0.0, 1.0);
    final calPct = (breakdown.calendarHours / total).clamp(0.0, 1.0);
    final focusPct = (breakdown.observedFocusHours / total).clamp(0.0, 1.0);
    final unobsPct = (breakdown.unobservedHours / total).clamp(0.0, 1.0);

    return KairoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  "BANDWIDTH ALLOCATION",
                  style: TextStyle(
                    color: KairoTheme.textPrimary,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'monospace',
                    letterSpacing: 1.2,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "${breakdown.allocatedHours.toStringAsFixed(1)}h / 168.0h",
                style: const TextStyle(
                  color: KairoTheme.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
          const SizedBox(height: KairoTheme.md),

          // Sharp Segmented Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(KairoTheme.radiusSm),
            child: SizedBox(
              height: 14,
              child: Row(
                children: [
                  if (sleepPct > 0)
                    Expanded(
                      flex: (sleepPct * 1000).toInt(),
                      child: Container(color: const Color(0xFF3F51B5)),
                    ),
                  if (maintPct > 0)
                    Expanded(
                      flex: (maintPct * 1000).toInt(),
                      child: Container(color: const Color(0xFF546E7A)),
                    ),
                  if (calPct > 0)
                    Expanded(
                      flex: (calPct * 1000).toInt(),
                      child: Container(color: KairoTheme.recommended),
                    ),
                  if (focusPct > 0)
                    Expanded(
                      flex: (focusPct * 1000).toInt(),
                      child: Container(color: KairoTheme.observed),
                    ),
                  if (unobsPct > 0)
                    Expanded(
                      flex: (unobsPct * 1000).toInt(),
                      child: Container(color: KairoTheme.surfaceElevated),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: KairoTheme.md),

          // Legend Items
          Wrap(
            spacing: KairoTheme.md,
            runSpacing: KairoTheme.sm,
            children: [
              _buildLegendPill("Sleep", "${breakdown.sleepHours.toStringAsFixed(1)}h", const Color(0xFF3F51B5)),
              _buildLegendPill("Maintenance", "${breakdown.maintenanceHours.toStringAsFixed(1)}h", const Color(0xFF546E7A)),
              _buildLegendPill("Calendar", "${breakdown.calendarHours.toStringAsFixed(1)}h", KairoTheme.recommended),
              _buildLegendPill("Focus Work", "${breakdown.observedFocusHours.toStringAsFixed(1)}h", KairoTheme.observed),
              _buildLegendPill("Unobserved", "${breakdown.unobservedHours.toStringAsFixed(1)}h", KairoTheme.textMuted),
            ],
          ),
          const KairoDivider(verticalMargin: KairoTheme.md),

          // 3-Column Tabular Sub-Metrics
          Row(
            children: [
              Expanded(
                child: _buildAllocationColumn(
                  label: "BIOLOGICAL FLOOR",
                  value: "${(breakdown.sleepHours + breakdown.maintenanceHours).toStringAsFixed(0)}h",
                  subtitle: "Fixed baseline",
                  accentColor: KairoTheme.textPrimary,
                ),
              ),
              Container(width: 1, height: 36, color: KairoTheme.border),
              Expanded(
                child: _buildAllocationColumn(
                  label: "OBSERVED FOCUS",
                  value: "${breakdown.observedFocusHours.toStringAsFixed(1)}h",
                  subtitle: "Verified telemetry",
                  accentColor: KairoTheme.observed,
                ),
              ),
              Container(width: 1, height: 36, color: KairoTheme.border),
              Expanded(
                child: _buildAllocationColumn(
                  label: "UNASSIGNED",
                  value: "${breakdown.unobservedHours.toStringAsFixed(0)}h",
                  subtitle: "Discretionary margin",
                  accentColor: KairoTheme.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendPill(String title, String hours, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          "$title: ",
          style: const TextStyle(color: KairoTheme.textMuted, fontSize: 10),
        ),
        Text(
          hours,
          style: const TextStyle(color: KairoTheme.textPrimary, fontSize: 10, fontWeight: FontWeight.bold, fontFamily: 'monospace'),
        ),
      ],
    );
  }

  Widget _buildAllocationColumn({
    required String label,
    required String value,
    required String subtitle,
    required Color accentColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: KairoTheme.textMuted,
              fontSize: 8,
              fontWeight: FontWeight.w800,
              fontFamily: 'monospace',
              letterSpacing: 0.6,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: TextStyle(
                color: accentColor,
                fontSize: 16,
                fontWeight: FontWeight.w900,
                fontFamily: 'monospace',
              ),
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(color: KairoTheme.textFaint, fontSize: 9),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildDivergenceCard(List<DailyPlan> plans) {
    int totalPlanned = 0;
    int completed = 0;

    for (final p in plans) {
      if (p.peak1Title.isNotEmpty) {
        totalPlanned++;
        if (p.peak1Completed) completed++;
      }
      if (p.peak2Title.isNotEmpty) {
        totalPlanned++;
        if (p.peak2Completed) completed++;
      }
    }

    final double completionRate = totalPlanned == 0 ? 0.0 : (completed / totalPlanned) * 100;

    return KairoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  "REALITY VS. INTENTION",
                  style: TextStyle(
                    color: KairoTheme.textPrimary,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'monospace',
                    letterSpacing: 1.2,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              KairoStatus(
                label: "${completionRate.toStringAsFixed(0)}% CONVERGENCE",
                type: completionRate >= 70 ? KairoStatusType.success : KairoStatusType.recommended,
              ),
            ],
          ),
          const SizedBox(height: KairoTheme.sm),
          Text(
            "$completed of $totalPlanned planned daily peaks reached verifiable completion this week.",
            style: const TextStyle(color: KairoTheme.textSecondary, fontSize: 12, height: 1.4),
          ),
          const SizedBox(height: KairoTheme.md),
          Container(
            padding: const EdgeInsets.all(KairoTheme.md),
            decoration: BoxDecoration(
              color: KairoTheme.surfaceElevated,
              borderRadius: BorderRadius.circular(KairoTheme.radiusSm),
              border: Border.all(color: KairoTheme.border),
            ),
            child: Row(
              children: [
                const Icon(Icons.psychology_outlined, size: 16, color: KairoTheme.observed),
                const SizedBox(width: KairoTheme.sm),
                Expanded(
                  child: Text(
                    completionRate < 50
                        ? "Divergence signal: High cognitive load scheduled without sufficient protected blocks."
                        : "Alignment stable: Peak velocity is matching allocated bandwidth.",
                    style: const TextStyle(color: KairoTheme.textSecondary, fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAutopsyActionCard() {
    return KairoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "WEEKLY AUTOPSY & SYNTHESIS",
                style: TextStyle(
                  color: KairoTheme.textPrimary,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'monospace',
                  letterSpacing: 1.2,
                ),
              ),
              Icon(Icons.analytics_outlined, size: 16, color: KairoTheme.textMuted),
            ],
          ),
          const SizedBox(height: KairoTheme.xs),
          const Text(
            "An objective debrief of the past 168 hours. No shaming, no emotional manipulation—just honest divergence telemetry and adjustment suggestions.",
            style: TextStyle(color: KairoTheme.textSecondary, fontSize: 12, height: 1.3),
          ),
          const SizedBox(height: KairoTheme.lg),
          KairoButton(
            text: _isGeneratingReport ? "SYNTHESIZING..." : "RUN WEEKLY AUTOPSY REPORT",
            isPrimary: false,
            isFullWidth: true,
            isLoading: _isGeneratingReport,
            onPressed: _isGeneratingReport ? null : () => _generateAutopsy(),
          ),
        ],
      ),
    );
  }

  Future<void> _generateAutopsy() async {
    setState(() => _isGeneratingReport = true);
    try {
      final now = DateTime.now();
      final weekStart = DateTime(now.year, now.month, now.day).subtract(Duration(days: now.weekday - 1));
      final weekEnd = weekStart.add(const Duration(days: 7));

      final ledger = await ref.read(weeklyLedgerProvider.future);
      final plans = await ref.read(weeklyPlansProvider.future);

      int totalPlanned = 0;
      int completed = 0;
      for (final p in plans) {
        if (p.peak1Title.isNotEmpty) {
          totalPlanned++;
          if (p.peak1Completed) completed++;
        }
        if (p.peak2Title.isNotEmpty) {
          totalPlanned++;
          if (p.peak2Completed) completed++;
        }
      }

      final autopsyService = WeeklyAutopsyService(isar);
      final weeklyAutopsy = await autopsyService.generateOrUpdateWeeklyAutopsy(
        wakatimeHours: ledger.observedFocusHours,
        githubPrs: 0,
        burnRate: 0.0,
      );

      final report = Report()
        ..type = ReportType.weekly
        ..periodStart = weekStart
        ..periodEnd = weekEnd
        ..plannedPeaks = totalPlanned
        ..completedPeaks = completed
        ..observedFocusHours = ledger.observedFocusHours
        ..observedCalendarHours = ledger.calendarHours
        ..observedScreenTimeHours = ledger.screenTimeHours
        ..mirrorSummary = weeklyAutopsy.aiVerdict
        ..rootCauseDiagnosis = weeklyAutopsy.aiRootCause
        ..recommendedAction = weeklyAutopsy.aiRequiredPivot
        ..generatedAt = DateTime.now();

      await isar.writeTxn(() async {
        await isar.reports.put(report);
      });

      if (!mounted) return;

      showModalBottomSheet(
        context: context,
        backgroundColor: KairoTheme.surface,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(KairoTheme.radiusLg)),
          side: BorderSide(color: KairoTheme.border),
        ),
        builder: (ctx) {
          return Padding(
            padding: const EdgeInsets.all(KairoTheme.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "WEEKLY AUTOPSY DEBRIEF",
                      style: TextStyle(
                        color: KairoTheme.textPrimary,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'monospace',
                        letterSpacing: 1.2,
                        fontSize: 13,
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
                const SizedBox(height: KairoTheme.sm),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: KairoTheme.recommended.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(KairoTheme.radiusSm),
                        border: Border.all(color: KairoTheme.recommended.withValues(alpha: 0.4)),
                      ),
                      child: Text(
                        "POWER SCORE: ${weeklyAutopsy.powerScore.toStringAsFixed(0)}/100",
                        style: const TextStyle(
                          color: KairoTheme.recommended,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                    const SizedBox(width: KairoTheme.sm),
                    Text(
                      "$completed/$totalPlanned Peaks • ${ledger.observedFocusHours.toStringAsFixed(1)}h Deep Work",
                      style: const TextStyle(color: KairoTheme.textMuted, fontSize: 10, fontFamily: 'monospace'),
                    ),
                  ],
                ),
                const SizedBox(height: KairoTheme.md),
                Text(report.mirrorSummary, style: const TextStyle(color: KairoTheme.textPrimary, fontSize: 13, height: 1.4)),
                const SizedBox(height: KairoTheme.md),
                const Text("DIAGNOSIS:", style: TextStyle(color: KairoTheme.recommended, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.1, fontFamily: 'monospace')),
                const SizedBox(height: 4),
                Text(report.rootCauseDiagnosis, style: const TextStyle(color: KairoTheme.textSecondary, fontSize: 12, height: 1.3)),
                const SizedBox(height: KairoTheme.md),
                const Text("RECOMMENDED ACTION:", style: TextStyle(color: KairoTheme.success, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.1, fontFamily: 'monospace')),
                const SizedBox(height: 4),
                Text(report.recommendedAction, style: const TextStyle(color: KairoTheme.textSecondary, fontSize: 12, height: 1.3)),
                const SizedBox(height: KairoTheme.xl),
                KairoButton(
                  text: "DISMISS",
                  isPrimary: true,
                  isFullWidth: true,
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
          );
        },
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Autopsy failed: $e"), backgroundColor: KairoTheme.warning),
        );
      }
    } finally {
      if (mounted) setState(() => _isGeneratingReport = false);
    }
  }
}

// Simple weekly provider for plans
final weeklyPlansProvider = FutureProvider<List<DailyPlan>>((ref) async {
  final now = DateTime.now();
  final weekStart = DateTime(now.year, now.month, now.day).subtract(Duration(days: now.weekday - 1));
  return await isar.dailyPlans.filter().dateGreaterThan(weekStart.subtract(const Duration(seconds: 1))).findAll();
});
