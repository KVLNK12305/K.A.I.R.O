import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/kairo_design_system.dart';
import '../../core/models/daily_plan.dart';
import '../../core/models/task.dart';
import '../../core/services/daily_plan_service.dart';
import '../../core/services/financial_ledger_service.dart';
import '../../core/services/wellbeing_service.dart';
import '../../core/providers/wakatime_provider.dart';
import '../profile/profile_page.dart';
import '../workout/workout_page.dart';
import '../needs/needs_page.dart';
import 'widgets/daily_shloka_modal.dart';
import '../../Nav/smooth_page_route.dart';

class TodayPage extends ConsumerStatefulWidget {
  const TodayPage({super.key});

  @override
  ConsumerState<TodayPage> createState() => _TodayPageState();
}

class _TodayPageState extends ConsumerState<TodayPage> {
  double _screenTimeHours = 0.0;
  bool _hasUsagePerm = false;
  bool _dndActive = false;

  @override
  void initState() {
    super.initState();
    _loadTelemetry();
  }

  Future<void> _loadTelemetry() async {
    final hasPerm = await WellbeingService.checkUsagePermission();
    if (mounted) setState(() => _hasUsagePerm = hasPerm);
    if (hasPerm) {
      final hours = await WellbeingService.getDailyScreenTime();
      if (mounted) setState(() => _screenTimeHours = hours);
    }
    final dnd = await WellbeingService.checkDndPermission();
    if (mounted) setState(() => _dndActive = dnd);
  }

  void _showSetPeaksDialog(BuildContext context, DailyPlan? existing) {
    final p1TitleCtrl = TextEditingController(text: existing?.peak1Title ?? '');
    final p1OutcomeCtrl = TextEditingController(text: existing?.peak1Outcome ?? '');
    final p2TitleCtrl = TextEditingController(text: existing?.peak2Title ?? '');
    final p2OutcomeCtrl = TextEditingController(text: existing?.peak2Outcome ?? '');

    showModalBottomSheet(
      context: context,
      backgroundColor: KairoTheme.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(KairoTheme.radiusLg)),
        side: BorderSide(color: KairoTheme.border, width: 1),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: KairoTheme.xl,
            right: KairoTheme.xl,
            top: KairoTheme.xl,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + KairoTheme.xl,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "CALIBRATE 2 PEAKS",
                      style: TextStyle(
                        color: KairoTheme.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                        fontFamily: 'monospace',
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
                const SizedBox(height: KairoTheme.xs),
                const Text(
                  "Define the two non-negotiable outcomes that claim today's cognitive bandwidth.",
                  style: TextStyle(color: KairoTheme.textSecondary, fontSize: 12),
                ),
                const SizedBox(height: KairoTheme.lg),

                // PEAK 01
                const Row(
                  children: [
                    Text(
                      "01 // PRIMARY FOCUS",
                      style: TextStyle(
                        color: KairoTheme.recommended,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'monospace',
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: KairoTheme.xs),
                TextField(
                  controller: p1TitleCtrl,
                  style: const TextStyle(color: KairoTheme.textPrimary, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: "Intent: e.g. Finish Core Engine Architecture",
                    hintStyle: const TextStyle(color: KairoTheme.textFaint),
                    filled: true,
                    fillColor: KairoTheme.surfaceElevated,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(KairoTheme.radiusSm),
                      borderSide: const BorderSide(color: KairoTheme.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(KairoTheme.radiusSm),
                      borderSide: const BorderSide(color: KairoTheme.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(KairoTheme.radiusSm),
                      borderSide: const BorderSide(color: KairoTheme.borderActive),
                    ),
                  ),
                ),
                const SizedBox(height: KairoTheme.sm),
                TextField(
                  controller: p1OutcomeCtrl,
                  style: const TextStyle(color: KairoTheme.textSecondary, fontSize: 12),
                  decoration: InputDecoration(
                    hintText: "Verifiable test: e.g. All 14 tests pass on CI",
                    hintStyle: const TextStyle(color: KairoTheme.textFaint),
                    filled: true,
                    fillColor: KairoTheme.surfaceElevated,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(KairoTheme.radiusSm),
                      borderSide: const BorderSide(color: KairoTheme.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(KairoTheme.radiusSm),
                      borderSide: const BorderSide(color: KairoTheme.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(KairoTheme.radiusSm),
                      borderSide: const BorderSide(color: KairoTheme.borderActive),
                    ),
                  ),
                ),
                const SizedBox(height: KairoTheme.lg),

                // PEAK 02
                const Row(
                  children: [
                    Text(
                      "02 // SECONDARY FOCUS",
                      style: TextStyle(
                        color: KairoTheme.observed,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'monospace',
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: KairoTheme.xs),
                TextField(
                  controller: p2TitleCtrl,
                  style: const TextStyle(color: KairoTheme.textPrimary, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: "Intent: e.g. Review & Merge Pull Requests",
                    hintStyle: const TextStyle(color: KairoTheme.textFaint),
                    filled: true,
                    fillColor: KairoTheme.surfaceElevated,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(KairoTheme.radiusSm),
                      borderSide: const BorderSide(color: KairoTheme.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(KairoTheme.radiusSm),
                      borderSide: const BorderSide(color: KairoTheme.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(KairoTheme.radiusSm),
                      borderSide: const BorderSide(color: KairoTheme.borderActive),
                    ),
                  ),
                ),
                const SizedBox(height: KairoTheme.sm),
                TextField(
                  controller: p2OutcomeCtrl,
                  style: const TextStyle(color: KairoTheme.textSecondary, fontSize: 12),
                  decoration: InputDecoration(
                    hintText: "Verifiable test: e.g. 0 open review blockers",
                    hintStyle: const TextStyle(color: KairoTheme.textFaint),
                    filled: true,
                    fillColor: KairoTheme.surfaceElevated,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(KairoTheme.radiusSm),
                      borderSide: const BorderSide(color: KairoTheme.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(KairoTheme.radiusSm),
                      borderSide: const BorderSide(color: KairoTheme.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(KairoTheme.radiusSm),
                      borderSide: const BorderSide(color: KairoTheme.borderActive),
                    ),
                  ),
                ),
                const SizedBox(height: KairoTheme.xl),

                KairoButton(
                  text: "LOCK IN TODAY'S BLUEPRINT",
                  isPrimary: true,
                  onPressed: () async {
                    if (p1TitleCtrl.text.trim().isEmpty || p2TitleCtrl.text.trim().isEmpty) return;
                    await ref.read(dailyPlanServiceProvider).setTodayPeaks(
                      peak1Title: p1TitleCtrl.text.trim(),
                      peak1Outcome: p1OutcomeCtrl.text.trim(),
                      peak2Title: p2TitleCtrl.text.trim(),
                      peak2Outcome: p2OutcomeCtrl.text.trim(),
                    );
                    ref.invalidate(todayPlanProvider);
                    if (ctx.mounted) Navigator.pop(ctx);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _startFocusMode(String peakTitle) async {
    final hasDnd = await WellbeingService.checkDndPermission();
    if (hasDnd) {
      await WellbeingService.setFocusMode(true);
      setState(() => _dndActive = true);
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("DND Active • Focused on: $peakTitle"),
          backgroundColor: KairoTheme.surfaceElevated,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateStr = DateFormat('EEEE, MMMM d').format(now).toUpperCase();
    final planAsync = ref.watch(todayPlanProvider);
    final openTasks = ref.watch(openTasksProvider).valueOrNull ?? const <Task>[];
    final financeAsync = ref.watch(financialOverviewProvider);
    final wakatimeAsync = ref.watch(wakatimeProvider);

    return Scaffold(
      backgroundColor: KairoTheme.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: KairoTheme.textPrimary,
          backgroundColor: KairoTheme.surfaceElevated,
          onRefresh: () async {
            ref.invalidate(todayPlanProvider);
            ref.invalidate(openTasksProvider);
            ref.invalidate(financialOverviewProvider);
            ref.invalidate(wakatimeProvider);
            await _loadTelemetry();
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
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              dateStr,
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
                              "COMMAND CENTER",
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
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_dndActive)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: KairoTheme.success.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(KairoTheme.radiusSm),
                                border: Border.all(color: KairoTheme.success.withValues(alpha: 0.4)),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.do_not_disturb_on_total_silence, color: KairoTheme.success, size: 11),
                                  SizedBox(width: 4),
                                  Text(
                                    "DND ENGAGED",
                                    style: TextStyle(
                                      color: KairoTheme.success,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: 'monospace',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          IconButton(
                            tooltip: "Needs Decision Matrix",
                            icon: const Icon(Icons.inventory_2_outlined, color: KairoTheme.textSecondary, size: 20),
                            onPressed: () {
                              Navigator.push(context, SmoothPageRoute(page: const NeedsPage()))
                                  .then((_) => ref.invalidate(openTasksProvider));
                            },
                          ),
                          IconButton(
                            tooltip: "Operator Profile & Settings",
                            icon: const Icon(Icons.person_outline_rounded, color: KairoTheme.textSecondary, size: 20),
                            onPressed: () {
                              Navigator.push(context, SmoothPageRoute(page: const ProfilePage()));
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // SECTION: WHAT MATTERS (TWO PEAKS)
              SliverToBoxAdapter(
                child: planAsync.when(
                  loading: () => const Padding(
                    padding: EdgeInsets.all(KairoTheme.xl),
                    child: Center(child: CircularProgressIndicator(strokeWidth: 2, color: KairoTheme.textMuted)),
                  ),
                  error: (err, _) => Padding(
                    padding: const EdgeInsets.all(KairoTheme.xl),
                    child: Text("Error: $err", style: const TextStyle(color: KairoTheme.warning)),
                  ),
                  data: (plan) {
                    final hasPlan = plan != null && (plan.peak1Title.isNotEmpty || plan.peak2Title.isNotEmpty);
                    if (!hasPlan) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: KairoTheme.xl, vertical: KairoTheme.sm),
                        child: KairoCard(
                          borderColor: KairoTheme.recommended.withValues(alpha: 0.3),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.bolt_rounded, color: KairoTheme.recommended, size: 16),
                                  SizedBox(width: 8),
                                  Text(
                                    "INTENTION VACUUM",
                                    style: TextStyle(
                                      color: KairoTheme.recommended,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: 'monospace',
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: KairoTheme.sm),
                              const Text(
                                "No primary Peaks set for today. A day without concrete intention is surrendered to external entropy.",
                                style: TextStyle(color: KairoTheme.textSecondary, fontSize: 12, height: 1.4),
                              ),
                              const SizedBox(height: KairoTheme.md),
                              KairoButton(
                                text: "CALIBRATE TODAY'S 2 PEAKS",
                                icon: Icons.add_task_rounded,
                                isPrimary: true,
                                onPressed: () => _showSetPeaksDialog(context, plan),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        KairoSectionHeader(
                          title: "TODAY'S 2 PEAKS",
                          trailing: GestureDetector(
                            onTap: () => _showSetPeaksDialog(context, plan),
                            child: const Text(
                              "EDIT",
                              style: TextStyle(
                                color: KairoTheme.textMuted,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'monospace',
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: KairoTheme.xl),
                          child: Column(
                            children: [
                              _buildPeakCard(
                                peakNumber: "01",
                                title: plan.peak1Title,
                                outcome: plan.peak1Outcome,
                                isDone: plan.peak1Completed,
                                accentColor: KairoTheme.recommended,
                                onToggle: () async {
                                  await ref.read(dailyPlanServiceProvider).togglePeak(peakNumber: 1);
                                  ref.invalidate(todayPlanProvider);
                                },
                                onStartFocus: () => _startFocusMode(plan.peak1Title),
                              ),
                              const SizedBox(height: KairoTheme.sm),
                              _buildPeakCard(
                                peakNumber: "02",
                                title: plan.peak2Title,
                                outcome: plan.peak2Outcome,
                                isDone: plan.peak2Completed,
                                accentColor: KairoTheme.observed,
                                onToggle: () async {
                                  await ref.read(dailyPlanServiceProvider).togglePeak(peakNumber: 2);
                                  ref.invalidate(todayPlanProvider);
                                },
                                onStartFocus: () => _startFocusMode(plan.peak2Title),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              // SECTION: COMMITTED TASKS (promoted from Needs / Project DNA drift)
              if (openTasks.isNotEmpty)
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      KairoSectionHeader(
                        title: "COMMITTED TASKS",
                        trailing: KairoStatus(label: "${openTasks.length} OPEN", type: KairoStatusType.muted),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: KairoTheme.xl),
                        child: Column(
                          children: [
                            for (final task in openTasks) ...[
                              _buildTaskRow(task),
                              const SizedBox(height: KairoTheme.sm),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              // SECTION: OBSERVED REALITY TELEMETRY
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const KairoSectionHeader(title: "OBSERVED TELEMETRY"),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: KairoTheme.xl),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              // Screen Time
                              Expanded(
                                child: KairoCard(
                                  padding: const EdgeInsets.all(KairoTheme.md),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              "SCREEN TIME",
                                              style: TextStyle(
                                                color: KairoTheme.textMuted,
                                                fontSize: 9,
                                                fontWeight: FontWeight.w800,
                                                fontFamily: 'monospace',
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          SizedBox(width: 4),
                                          KairoStatus(label: "OBSERVED", type: KairoStatusType.observed),
                                        ],
                                      ),
                                      const SizedBox(height: KairoTheme.sm),
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          _hasUsagePerm ? "${_screenTimeHours.toStringAsFixed(1)}h" : "[NO ACCESS]",
                                          style: const TextStyle(
                                            color: KairoTheme.textPrimary,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w900,
                                            fontFamily: 'monospace',
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        _hasUsagePerm ? "Android UsageStats" : "Tap Profile to grant",
                                        style: const TextStyle(color: KairoTheme.textMuted, fontSize: 10),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: KairoTheme.sm),
                              // Focus Work (WakaTime)
                              Expanded(
                                child: wakatimeAsync.when(
                                  loading: () => const KairoCard(
                                    padding: EdgeInsets.all(KairoTheme.md),
                                    child: Center(child: CircularProgressIndicator(strokeWidth: 1.5, color: KairoTheme.textMuted)),
                                  ),
                                  error: (_, _) => KairoCard(
                                    padding: const EdgeInsets.all(KairoTheme.md),
                                    onTap: () => Navigator.push(context, SmoothPageRoute(page: const ProfilePage())),
                                    child: const Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                "DEEP WORK",
                                                style: TextStyle(
                                                  color: KairoTheme.textMuted,
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.w800,
                                                  fontFamily: 'monospace',
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            SizedBox(width: 4),
                                            KairoStatus(label: "OFFLINE", type: KairoStatusType.warning),
                                          ],
                                        ),
                                        SizedBox(height: KairoTheme.sm),
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "[NOT SET]",
                                            style: TextStyle(
                                              color: KairoTheme.textMuted,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w900,
                                              fontFamily: 'monospace',
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 2),
                                        Text("Tap to add API key", style: TextStyle(color: KairoTheme.textMuted, fontSize: 10)),
                                      ],
                                    ),
                                  ),
                                  data: (timeStr) => KairoCard(
                                    padding: const EdgeInsets.all(KairoTheme.md),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                "DEEP WORK",
                                                style: TextStyle(
                                                  color: KairoTheme.textMuted,
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.w800,
                                                  fontFamily: 'monospace',
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            SizedBox(width: 4),
                                            KairoStatus(label: "WAKATIME", type: KairoStatusType.observed),
                                          ],
                                        ),
                                        const SizedBox(height: KairoTheme.sm),
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            timeStr,
                                            style: const TextStyle(
                                              color: KairoTheme.observed,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w900,
                                              fontFamily: 'monospace',
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        const Text("Active IDE telemetry", style: TextStyle(color: KairoTheme.textMuted, fontSize: 10)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: KairoTheme.sm),
                          Row(
                            children: [
                              // Today's Outflow Burn
                              Expanded(
                                child: financeAsync.when(
                                  loading: () => const KairoCard(
                                    padding: EdgeInsets.all(KairoTheme.md),
                                    child: Center(child: CircularProgressIndicator(strokeWidth: 1.5, color: KairoTheme.textMuted)),
                                  ),
                                  error: (_, _) => _buildMetricCard("TODAY OUTFLOW", "₹0", "Ledger Offline", KairoTheme.textPrimary),
                                  data: (f) => _buildMetricCard("TODAY OUTFLOW", "₹${f.todayBurn.toStringAsFixed(0)}", "Capital Outflow", KairoTheme.warning),
                                ),
                              ),
                              const SizedBox(width: KairoTheme.sm),
                              // Weekly Spend
                              Expanded(
                                child: financeAsync.when(
                                  loading: () => const KairoCard(
                                    padding: EdgeInsets.all(KairoTheme.md),
                                    child: Center(child: CircularProgressIndicator(strokeWidth: 1.5, color: KairoTheme.textMuted)),
                                  ),
                                  error: (_, _) => _buildMetricCard("WEEK SPEND", "₹0", "Ledger Offline", KairoTheme.textPrimary),
                                  data: (f) => _buildMetricCard("WEEK SPEND", "₹${f.weekBurn.toStringAsFixed(0)}", "Current Week", KairoTheme.textPrimary),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // SECTION: DAILY GITA CONTEMPLATION
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: KairoTheme.xl, vertical: KairoTheme.xs),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(KairoTheme.radiusMd),
                    onTap: () => DailyShlokaModal.show(context),
                    child: Container(
                      padding: const EdgeInsets.all(KairoTheme.md),
                      decoration: BoxDecoration(
                        color: KairoTheme.surface,
                        borderRadius: BorderRadius.circular(KairoTheme.radiusMd),
                        border: Border.all(color: KairoTheme.border),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: KairoTheme.surfaceElevated,
                              borderRadius: BorderRadius.circular(KairoTheme.radiusSm),
                              border: Border.all(color: KairoTheme.border),
                            ),
                            child: const Icon(Icons.auto_stories_rounded, color: KairoTheme.recommended, size: 18),
                          ),
                          const SizedBox(width: KairoTheme.md),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "BHAGAVAD GITA DOCTRINE",
                                        style: TextStyle(
                                          color: KairoTheme.textPrimary,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w900,
                                          fontFamily: 'monospace',
                                          letterSpacing: 1.1,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    KairoStatus(label: "DAILY SHLOKA", type: KairoStatusType.recommended),
                                  ],
                                ),
                                SizedBox(height: 3),
                                Text(
                                  "कर्मण्येवाधिकारस्ते मा फलेषु कदाचन... Anchor attention to duty without attachment to fruit.",
                                  style: TextStyle(color: KairoTheme.textSecondary, fontSize: 11, height: 1.3),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: KairoTheme.xs),
                          const Icon(Icons.chevron_right, color: KairoTheme.textMuted, size: 18),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // SECTION: PHYSICAL TRAINING CRUCIBLE
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: KairoTheme.xl, vertical: KairoTheme.sm),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(KairoTheme.radiusMd),
                    onTap: () => Navigator.push(context, SmoothPageRoute(page: const WorkoutPage())),
                    child: Container(
                      padding: const EdgeInsets.all(KairoTheme.md),
                      decoration: BoxDecoration(
                        color: KairoTheme.surface,
                        borderRadius: BorderRadius.circular(KairoTheme.radiusMd),
                        border: Border.all(color: KairoTheme.border),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: KairoTheme.surfaceElevated,
                              borderRadius: BorderRadius.circular(KairoTheme.radiusSm),
                              border: Border.all(color: KairoTheme.border),
                            ),
                            child: const Icon(Icons.fitness_center_rounded, color: KairoTheme.observed, size: 18),
                          ),
                          const SizedBox(width: KairoTheme.md),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "PHYSICAL TRAINING CRUCIBLE",
                                        style: TextStyle(
                                          color: KairoTheme.textPrimary,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w900,
                                          fontFamily: 'monospace',
                                          letterSpacing: 1.1,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    KairoStatus(label: "OVERLOAD", type: KairoStatusType.observed),
                                  ],
                                ),
                                SizedBox(height: 3),
                                Text(
                                  "Track progressive overload, set tonnage, RPE & recovery on the 168-Hour Ledger.",
                                  style: TextStyle(color: KairoTheme.textSecondary, fontSize: 11, height: 1.3),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: KairoTheme.xs),
                          const Icon(Icons.chevron_right, color: KairoTheme.textMuted, size: 18),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // SECTION: OPERATIONAL GUIDANCE
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(KairoTheme.xl, KairoTheme.xl, KairoTheme.xl, 100),
                  child: KairoCard(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.compass_calibration_outlined, color: KairoTheme.recommended, size: 18),
                        const SizedBox(width: KairoTheme.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "ANALYTICAL GUIDANCE",
                                style: TextStyle(
                                  color: KairoTheme.recommended,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'monospace',
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(height: KairoTheme.xs),
                              Text(
                                _screenTimeHours > 4.0
                                    ? "Displacement signal: Screen time is high (${_screenTimeHours.toStringAsFixed(1)}h). Protect your remaining cognitive reserve for Peak execution."
                                    : "Telemetry indicates steady momentum. Execute committed Peaks before taking on speculative or unobserved tasks.",
                                style: const TextStyle(
                                  color: KairoTheme.textSecondary,
                                  fontSize: 12,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskRow(Task task) {
    final slotLabel = switch (task.energySlot) {
      EnergySlot.peak1 => "PEAK 1",
      EnergySlot.peak2 => "PEAK 2",
      EnergySlot.recovery => "RECOVERY",
      EnergySlot.unassigned => null,
    };

    return KairoCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: const TextStyle(
                    color: KairoTheme.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (task.category.isNotEmpty || slotLabel != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    [if (slotLabel != null) slotLabel, if (task.category.isNotEmpty) task.category.toUpperCase()].join("  //  "),
                    style: const TextStyle(
                      color: KairoTheme.textMuted,
                      fontSize: 10,
                      fontFamily: 'monospace',
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            tooltip: "Mark complete",
            icon: const Icon(Icons.radio_button_unchecked_rounded, color: KairoTheme.textMuted, size: 20),
            onPressed: () async {
              await ref.read(dailyPlanServiceProvider).setTaskCompleted(task.id, true);
              ref.invalidate(openTasksProvider);
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Completed: ${task.title}"),
                  backgroundColor: KairoTheme.surfaceElevated,
                  behavior: SnackBarBehavior.floating,
                  action: SnackBarAction(
                    label: "UNDO",
                    onPressed: () async {
                      await ref.read(dailyPlanServiceProvider).setTaskCompleted(task.id, false);
                      ref.invalidate(openTasksProvider);
                    },
                  ),
                ),
              );
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildPeakCard({
    required String peakNumber,
    required String title,
    required String outcome,
    required bool isDone,
    required Color accentColor,
    required VoidCallback onToggle,
    required VoidCallback onStartFocus,
  }) {
    return KairoCard(
      borderColor: isDone ? KairoTheme.border : accentColor.withValues(alpha: 0.35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isDone ? KairoTheme.surfaceElevated : accentColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(KairoTheme.radiusSm),
                  border: Border.all(color: isDone ? KairoTheme.border : accentColor.withValues(alpha: 0.5)),
                ),
                child: Text(
                  peakNumber,
                  style: TextStyle(
                    color: isDone ? KairoTheme.textMuted : accentColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: isDone ? KairoTheme.textMuted : KairoTheme.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    decoration: isDone ? TextDecoration.lineThrough : null,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: Icon(
                  isDone ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                  color: isDone ? KairoTheme.success : KairoTheme.textMuted,
                  size: 20,
                ),
                onPressed: onToggle,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          if (outcome.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              "TARGET: $outcome",
              style: TextStyle(
                color: isDone ? KairoTheme.textFaint : KairoTheme.textMuted,
                fontSize: 11,
                fontFamily: 'monospace',
              ),
            ),
          ],
          if (!isDone) ...[
            const SizedBox(height: KairoTheme.md),
            Row(
              children: [
                GestureDetector(
                  onTap: onStartFocus,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(KairoTheme.radiusSm),
                      border: Border.all(color: accentColor.withValues(alpha: 0.4)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.play_arrow_rounded, color: accentColor, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          "START FOCUS (DND)",
                          style: TextStyle(
                            color: accentColor,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'monospace',
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMetricCard(String label, String value, String sub, Color valColor) {
    return KairoCard(
      padding: const EdgeInsets.all(KairoTheme.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: KairoTheme.textMuted,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'monospace',
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              const KairoStatus(label: "LEDGER", type: KairoStatusType.observed),
            ],
          ),
          const SizedBox(height: KairoTheme.sm),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: TextStyle(
                color: valColor,
                fontSize: 18,
                fontWeight: FontWeight.w900,
                fontFamily: 'monospace',
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(sub, style: const TextStyle(color: KairoTheme.textMuted, fontSize: 10), overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
