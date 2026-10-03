import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/kairo_design_system.dart';
import '../../core/models/commitment.dart';
import '../../core/models/idea.dart';
import '../../core/models/decision_log.dart';
import '../../core/services/order_service.dart';
import '../../Nav/smooth_page_route.dart';
import '../projects/projects_page.dart';
import '../needs/needs_page.dart';
import '../../main.dart';
import 'package:isar/isar.dart';

class OrderPage extends ConsumerStatefulWidget {
  const OrderPage({super.key});

  @override
  ConsumerState<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends ConsumerState<OrderPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showNewCommitmentModal(BuildContext context) {
    final titleCtrl = TextEditingController();
    final whyCtrl = TextEditingController();
    final outcomeCtrl = TextEditingController();
    final failureCtrl = TextEditingController();
    DateTime targetDeadline = DateTime.now().add(const Duration(days: 30));

    showModalBottomSheet(
      context: context,
      backgroundColor: KairoTheme.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(KairoTheme.radiusLg)),
        side: BorderSide(color: KairoTheme.border, width: 1),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (modalCtx, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: KairoTheme.xl,
                right: KairoTheme.xl,
                top: KairoTheme.xl,
                bottom: MediaQuery.of(modalCtx).viewInsets.bottom + KairoTheme.xl,
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
                          "FORGE HIGH-STAKES COMMITMENT",
                          style: TextStyle(
                            color: KairoTheme.textPrimary,
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'monospace',
                            letterSpacing: 1.2,
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
                    const SizedBox(height: KairoTheme.md),
                    TextField(
                      controller: titleCtrl,
                      style: const TextStyle(color: KairoTheme.textPrimary, fontSize: 13),
                      decoration: InputDecoration(
                        labelText: "COMMITMENT TITLE",
                        labelStyle: const TextStyle(color: KairoTheme.textMuted, fontSize: 10, fontFamily: 'monospace'),
                        hintText: "e.g. Ship V2 Production Bundle",
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
                      ),
                    ),
                    const SizedBox(height: KairoTheme.sm),
                    TextField(
                      controller: whyCtrl,
                      style: const TextStyle(color: KairoTheme.textPrimary, fontSize: 13),
                      decoration: InputDecoration(
                        labelText: "WHY IT MATTERS",
                        labelStyle: const TextStyle(color: KairoTheme.textMuted, fontSize: 10, fontFamily: 'monospace'),
                        hintText: "Core thesis driving this investment of attention",
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
                      ),
                    ),
                    const SizedBox(height: KairoTheme.sm),
                    TextField(
                      controller: outcomeCtrl,
                      style: const TextStyle(color: KairoTheme.textPrimary, fontSize: 13),
                      decoration: InputDecoration(
                        labelText: "VERIFIABLE OUTCOME TEST",
                        labelStyle: const TextStyle(color: KairoTheme.textMuted, fontSize: 10, fontFamily: 'monospace'),
                        hintText: "Binary test: How do we know it is definitively done?",
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
                      ),
                    ),
                    const SizedBox(height: KairoTheme.sm),
                    TextField(
                      controller: failureCtrl,
                      style: const TextStyle(color: KairoTheme.textPrimary, fontSize: 13),
                      decoration: InputDecoration(
                        labelText: "CONSEQUENCE OF FAILURE",
                        labelStyle: const TextStyle(color: KairoTheme.textMuted, fontSize: 10, fontFamily: 'monospace'),
                        hintText: "What opportunity cost or setback occurs if dropped?",
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
                      ),
                    ),
                    const SizedBox(height: KairoTheme.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("TARGET DEADLINE", style: TextStyle(color: KairoTheme.textMuted, fontSize: 10, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
                        TextButton(
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: modalCtx,
                              initialDate: targetDeadline,
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(const Duration(days: 365)),
                            );
                            if (picked != null) {
                              setModalState(() => targetDeadline = picked);
                            }
                          },
                          child: Text(
                            DateFormat('MMM d, yyyy').format(targetDeadline),
                            style: const TextStyle(color: KairoTheme.recommended, fontWeight: FontWeight.bold, fontFamily: 'monospace'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: KairoTheme.lg),
                    KairoButton(
                      text: "LOCK IN COMMITMENT",
                      isPrimary: true,
                      isFullWidth: true,
                      onPressed: () async {
                        if (titleCtrl.text.trim().isEmpty) return;
                        final commitment = Commitment()
                          ..title = titleCtrl.text.trim()
                          ..whyItMatters = whyCtrl.text.trim()
                          ..desiredOutcome = outcomeCtrl.text.trim()
                          ..failureConsequence = failureCtrl.text.trim()
                          ..targetDeadline = targetDeadline
                          ..status = CommitmentStatus.active;

                        await isar.writeTxn(() async {
                          await isar.commitments.put(commitment);
                        });

                        ref.invalidate(orderDiagnosticsProvider);
                        setState(() {});
                        if (ctx.mounted) Navigator.pop(ctx);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showParkIdeaModal(BuildContext context) {
    final titleCtrl = TextEditingController();
    final reasonCtrl = TextEditingController(text: "No active commitment requires this yet.");

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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "PARK SPECULATIVE IDEA",
                    style: TextStyle(
                      color: KairoTheme.textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'monospace',
                      letterSpacing: 1.2,
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
                "Prevent attention drift: Park this concept until WIP limit frees up.",
                style: TextStyle(color: KairoTheme.textSecondary, fontSize: 11),
              ),
              const SizedBox(height: KairoTheme.md),
              TextField(
                controller: titleCtrl,
                style: const TextStyle(color: KairoTheme.textPrimary, fontSize: 13),
                decoration: InputDecoration(
                  labelText: "IDEA / FEATURE CONCEPT",
                  labelStyle: const TextStyle(color: KairoTheme.textMuted, fontSize: 10, fontFamily: 'monospace'),
                  hintText: "e.g. Offline sync via Bluetooth Mesh",
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
                ),
              ),
              const SizedBox(height: KairoTheme.sm),
              TextField(
                controller: reasonCtrl,
                style: const TextStyle(color: KairoTheme.textPrimary, fontSize: 13),
                decoration: InputDecoration(
                  labelText: "PARKING REASON",
                  labelStyle: const TextStyle(color: KairoTheme.textMuted, fontSize: 10, fontFamily: 'monospace'),
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
                ),
              ),
              const SizedBox(height: KairoTheme.lg),
              KairoButton(
                text: "PARK IN LOT",
                isPrimary: true,
                isFullWidth: true,
                onPressed: () async {
                  if (titleCtrl.text.trim().isEmpty) return;
                  await ref.read(orderServiceProvider).parkIdea(
                    title: titleCtrl.text.trim(),
                    reason: reasonCtrl.text.trim(),
                  );
                  ref.invalidate(orderDiagnosticsProvider);
                  setState(() {});
                  if (ctx.mounted) Navigator.pop(ctx);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final diagAsync = ref.watch(orderDiagnosticsProvider);

    return Scaffold(
      backgroundColor: KairoTheme.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: KairoTheme.textPrimary,
          backgroundColor: KairoTheme.surfaceElevated,
          onRefresh: () async {
            ref.invalidate(orderDiagnosticsProvider);
            setState(() {});
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // System Header Bar
              Padding(
                padding: const EdgeInsets.fromLTRB(KairoTheme.xl, KairoTheme.lg, KairoTheme.xl, KairoTheme.sm),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "SYSTEM ORDER & FOCUS",
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
                            "COMMITMENT GUARD",
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
                    const SizedBox(width: KairoTheme.sm),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip: "Projects & Architecture DNA",
                          icon: const Icon(Icons.hub_outlined, color: KairoTheme.textSecondary, size: 20),
                          onPressed: () => Navigator.push(context, SmoothPageRoute(page: const ProjectsPage())),
                        ),
                        IconButton(
                          tooltip: "Needs Decision Matrix",
                          icon: const Icon(Icons.inventory_2_outlined, color: KairoTheme.textSecondary, size: 20),
                          onPressed: () => Navigator.push(context, SmoothPageRoute(page: const NeedsPage())),
                        ),
                        const SizedBox(width: 4),
                        KairoButton(
                          text: "FORGE",
                          icon: Icons.add,
                          isPrimary: true,
                          onPressed: () => _showNewCommitmentModal(context),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // WIP Diagnostic Alert Card
              diagAsync.when(
                data: (diag) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: KairoTheme.xl, vertical: KairoTheme.xs),
                  child: KairoCard(
                    borderColor: diag.isFragmented ? KairoTheme.recommended.withValues(alpha: 0.5) : KairoTheme.border,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                diag.isFragmented ? "ATTENTION FRAGMENTATION DETECTED" : "OPTIMAL WIP DISCIPLINE",
                                style: TextStyle(
                                  color: diag.isFragmented ? KairoTheme.recommended : KairoTheme.success,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.1,
                                  fontFamily: 'monospace',
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 6),
                            KairoStatus(
                              label: diag.isFragmented ? "LIMIT BREACH" : "DISCIPLINED",
                              type: diag.isFragmented ? KairoStatusType.recommended : KairoStatusType.success,
                            ),
                          ],
                        ),
                        const SizedBox(height: KairoTheme.xs),
                        Text(diag.recommendation, style: const TextStyle(color: KairoTheme.textSecondary, fontSize: 11, height: 1.3)),
                        const SizedBox(height: KairoTheme.md),
                        Row(
                          children: [
                            _buildStatTag(
                              "WIP PROJECTS",
                              "${diag.activeProjectsCount} / 3",
                              diag.activeProjectsCount > 3 ? KairoTheme.recommended : KairoTheme.textPrimary,
                              onTap: () => Navigator.push(context, SmoothPageRoute(page: const ProjectsPage())),
                            ),
                            const SizedBox(width: KairoTheme.lg),
                            _buildStatTag("COMMITMENTS", "${diag.openCommitmentsCount}", KairoTheme.textPrimary),
                            const SizedBox(width: KairoTheme.lg),
                            _buildStatTag("PARKED IDEAS", "${diag.parkedIdeasCount}", KairoTheme.textMuted),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
              ),

              // Tab Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: KairoTheme.xl, vertical: KairoTheme.xs),
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: KairoTheme.textPrimary,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: KairoTheme.textPrimary,
                  unselectedLabelColor: KairoTheme.textMuted,
                  labelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.1, fontFamily: 'monospace'),
                  tabs: const [
                    Tab(text: "COMMITMENTS"),
                    Tab(text: "PARKING LOT"),
                    Tab(text: "DECISION LOGS"),
                  ],
                ),
              ),

              // Tab Views
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildCommitmentsTab(),
                    _buildParkingLotTab(),
                    _buildDecisionLogsTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatTag(String label, String value, Color valColor, {VoidCallback? onTap}) {
    final col = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: KairoTheme.textMuted, fontSize: 8, fontWeight: FontWeight.w800, fontFamily: 'monospace')),
        const SizedBox(height: 2),
        Text(value, style: TextStyle(color: valColor, fontSize: 13, fontWeight: FontWeight.w900, fontFamily: 'monospace')),
      ],
    );
    if (onTap != null) {
      return InkWell(onTap: onTap, child: col);
    }
    return col;
  }

  Widget _buildCommitmentsTab() {
    return FutureBuilder<List<Commitment>>(
      future: isar.commitments.where().sortByTargetDeadline().findAll(),
      builder: (ctx, snap) {
        final list = snap.data ?? [];
        if (list.isEmpty) {
          return Center(
            child: KairoEmptyState(
              title: "NO ACTIVE COMMITMENTS",
              description: "Forge a high-stakes commitment to establish focus bounds.",
              action: KairoButton(
                text: "FORGE COMMITMENT",
                onPressed: () => _showNewCommitmentModal(context),
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(KairoTheme.xl, KairoTheme.sm, KairoTheme.xl, 100),
          itemCount: list.length,
          itemBuilder: (context, index) {
            final c = list[index];
            final daysLeft = c.targetDeadline.difference(DateTime.now()).inDays;
            final isCompleted = c.status == CommitmentStatus.completed;

            return Padding(
              padding: const EdgeInsets.only(bottom: KairoTheme.sm),
              child: KairoCard(
                borderColor: isCompleted ? KairoTheme.success.withValues(alpha: 0.3) : KairoTheme.border,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            c.title,
                            style: TextStyle(
                              color: isCompleted ? KairoTheme.textMuted : KairoTheme.textPrimary,
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              decoration: isCompleted ? TextDecoration.lineThrough : null,
                            ),
                          ),
                        ),
                        KairoStatus(
                          label: isCompleted ? "COMPLETED" : (daysLeft < 0 ? "OVERDUE" : "$daysLeft D LEFT"),
                          type: isCompleted
                              ? KairoStatusType.success
                              : (daysLeft < 7 ? KairoStatusType.warning : KairoStatusType.observed),
                        ),
                      ],
                    ),
                    if (c.whyItMatters.isNotEmpty) ...[
                      const SizedBox(height: KairoTheme.xs),
                      Text(c.whyItMatters, style: const TextStyle(color: KairoTheme.textSecondary, fontSize: 11)),
                    ],
                    if (c.desiredOutcome.isNotEmpty) ...[
                      const SizedBox(height: KairoTheme.xs),
                      Row(
                        children: [
                          const Text("OUTCOME: ", style: TextStyle(color: KairoTheme.success, fontSize: 9, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
                          Expanded(
                            child: Text(
                              c.desiredOutcome,
                              style: const TextStyle(color: KairoTheme.textMuted, fontSize: 10, fontFamily: 'monospace'),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (!isCompleted) ...[
                      const SizedBox(height: KairoTheme.sm),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              c.status = CommitmentStatus.completed;
                              c.completedAt = DateTime.now();
                              await isar.writeTxn(() async {
                                await isar.commitments.put(c);
                              });
                              ref.invalidate(orderDiagnosticsProvider);
                              setState(() {});
                            },
                            child: const Text(
                              "MARK COMPLETE",
                              style: TextStyle(
                                color: KairoTheme.success,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'monospace',
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildParkingLotTab() {
    return FutureBuilder<List<Idea>>(
      future: isar.ideas.filter().statusEqualTo('Parked').sortByCreatedAtDesc().findAll(),
      builder: (ctx, snap) {
        final ideas = snap.data ?? [];
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(KairoTheme.xl, KairoTheme.sm, KairoTheme.xl, KairoTheme.sm),
              child: KairoButton(
                text: "PARK A SPECULATIVE IDEA",
                icon: Icons.archive_outlined,
                isPrimary: false,
                isFullWidth: true,
                onPressed: () => _showParkIdeaModal(context),
              ),
            ),
            Expanded(
              child: ideas.isEmpty
                  ? const Center(
                      child: KairoEmptyState(
                        title: "PARKING LOT EMPTY",
                        description: "Speculative ideas are safely parked here so active work remains unfragmented.",
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(KairoTheme.xl, 0, KairoTheme.xl, 100),
                      itemCount: ideas.length,
                      itemBuilder: (context, index) {
                        final idea = ideas[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: KairoTheme.sm),
                          child: KairoCard(
                            padding: const EdgeInsets.all(KairoTheme.md),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  idea.title,
                                  style: const TextStyle(color: KairoTheme.textPrimary, fontSize: 12, fontWeight: FontWeight.w800),
                                ),
                                const SizedBox(height: KairoTheme.xs),
                                Text(
                                  "Reason: ${idea.parkingReason}",
                                  style: const TextStyle(color: KairoTheme.textMuted, fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDecisionLogsTab() {
    return FutureBuilder<List<DecisionLog>>(
      future: isar.decisionLogs.where().sortByMadeAtDesc().findAll(),
      builder: (ctx, snap) {
        final logs = snap.data ?? [];
        if (logs.isEmpty) {
          return const Center(
            child: KairoEmptyState(
              title: "NO DECISION LOGS",
              description: "Audit high-impact strategic decisions and verify subsequent reality against original hypotheses.",
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(KairoTheme.xl, KairoTheme.sm, KairoTheme.xl, 100),
          itemCount: logs.length,
          itemBuilder: (context, index) {
            final log = logs[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: KairoTheme.sm),
              child: KairoCard(
                padding: const EdgeInsets.all(KairoTheme.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            log.title,
                            style: const TextStyle(color: KairoTheme.textPrimary, fontSize: 12, fontWeight: FontWeight.w800),
                          ),
                        ),
                        KairoStatus(
                          label: log.verdict.toUpperCase(),
                          type: log.verdict == 'Successful' ? KairoStatusType.success : KairoStatusType.recommended,
                        ),
                      ],
                    ),
                    if (log.expectedOutcome.isNotEmpty) ...[
                      const SizedBox(height: KairoTheme.xs),
                      Text("Hypothesis: ${log.expectedOutcome}", style: const TextStyle(color: KairoTheme.textMuted, fontSize: 11)),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
