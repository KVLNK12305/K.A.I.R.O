import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/kairo_design_system.dart';
import '../../core/models/need.dart';
import '../../core/models/task.dart';
import '../../core/providers/needs_provider.dart';

class NeedsPage extends ConsumerStatefulWidget {
  const NeedsPage({super.key});

  @override
  ConsumerState<NeedsPage> createState() => _NeedsPageState();
}

class _NeedsPageState extends ConsumerState<NeedsPage> {
  bool _isSyncingTodo = false;
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _syncMicrosoftTodo() async {
    setState(() => _isSyncingTodo = true);
    try {
      final synced = await ref.read(microsoftTodoServiceProvider).syncNeedsFromMicrosoftTodo();
      ref.invalidate(filteredNeedsProvider);
      ref.invalidate(needsSummaryProvider);
      if (mounted) {
        setState(() => _isSyncingTodo = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              synced.isEmpty
                  ? "Microsoft To Do synced. No new needs found in 'K.A.I.R.O. — NEEDS'."
                  : "Ingested ${synced.length} new items into Needs Inbox (0 tasks created).",
            ),
            backgroundColor: KairoTheme.surfaceElevated,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSyncingTodo = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Sync notice: $e"),
            backgroundColor: KairoTheme.surfaceElevated,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _showAddNeedModal(BuildContext context) {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final catCtrl = TextEditingController(text: "Gear");
    final costCtrl = TextEditingController();
    final currentSolCtrl = TextEditingController();
    final replaceCtrl = TextEditingController();
    final reasonCtrl = TextEditingController();
    final notesCtrl = TextEditingController();

    NeedType selectedType = NeedType.buy;
    NeedUrgency selectedUrgency = NeedUrgency.medium;
    NeedStatus selectedStatus = NeedStatus.considering;

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
                          "REGISTER NEED (DECISION SUPPORT)",
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
                    const SizedBox(height: 4),
                    const Text(
                      "Needs do not affect daily execution, streaks, or today's task score.",
                      style: TextStyle(color: KairoTheme.textMuted, fontSize: 10),
                    ),
                    const SizedBox(height: KairoTheme.md),
                    TextField(
                      controller: titleCtrl,
                      style: const TextStyle(color: KairoTheme.textPrimary, fontSize: 13),
                      decoration: InputDecoration(
                        labelText: "NEED TITLE",
                        labelStyle: const TextStyle(color: KairoTheme.textMuted, fontSize: 10, fontFamily: 'monospace'),
                        hintText: "e.g. 12–13 inch tablet + stylus",
                        hintStyle: const TextStyle(color: KairoTheme.textFaint),
                        filled: true,
                        fillColor: KairoTheme.surfaceElevated,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(KairoTheme.radiusSm)),
                      ),
                    ),
                    const SizedBox(height: KairoTheme.sm),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<NeedType>(
                            initialValue: selectedType,
                            dropdownColor: KairoTheme.surfaceElevated,
                            decoration: InputDecoration(
                              labelText: "TYPE",
                              labelStyle: const TextStyle(color: KairoTheme.textMuted, fontSize: 10, fontFamily: 'monospace'),
                              filled: true,
                              fillColor: KairoTheme.surfaceElevated,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(KairoTheme.radiusSm)),
                            ),
                            items: NeedType.values.map((t) => DropdownMenuItem(value: t, child: Text(t.name.toUpperCase(), style: const TextStyle(color: KairoTheme.textPrimary, fontSize: 11, fontFamily: 'monospace')))).toList(),
                            onChanged: (val) {
                              if (val != null) setModalState(() => selectedType = val);
                            },
                          ),
                        ),
                        const SizedBox(width: KairoTheme.sm),
                        Expanded(
                          child: DropdownButtonFormField<NeedUrgency>(
                            initialValue: selectedUrgency,
                            dropdownColor: KairoTheme.surfaceElevated,
                            decoration: InputDecoration(
                              labelText: "URGENCY",
                              labelStyle: const TextStyle(color: KairoTheme.textMuted, fontSize: 10, fontFamily: 'monospace'),
                              filled: true,
                              fillColor: KairoTheme.surfaceElevated,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(KairoTheme.radiusSm)),
                            ),
                            items: NeedUrgency.values.map((u) => DropdownMenuItem(value: u, child: Text(u.name.toUpperCase(), style: const TextStyle(color: KairoTheme.textPrimary, fontSize: 11, fontFamily: 'monospace')))).toList(),
                            onChanged: (val) {
                              if (val != null) setModalState(() => selectedUrgency = val);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: KairoTheme.sm),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: costCtrl,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: KairoTheme.textPrimary, fontSize: 13, fontFamily: 'monospace'),
                            decoration: InputDecoration(
                              labelText: "ESTIMATED COST (₹)",
                              labelStyle: const TextStyle(color: KairoTheme.textMuted, fontSize: 10, fontFamily: 'monospace'),
                              hintText: "Optional",
                              hintStyle: const TextStyle(color: KairoTheme.textFaint),
                              filled: true,
                              fillColor: KairoTheme.surfaceElevated,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(KairoTheme.radiusSm)),
                            ),
                          ),
                        ),
                        const SizedBox(width: KairoTheme.sm),
                        Expanded(
                          child: TextField(
                            controller: catCtrl,
                            style: const TextStyle(color: KairoTheme.textPrimary, fontSize: 13),
                            decoration: InputDecoration(
                              labelText: "CATEGORY",
                              labelStyle: const TextStyle(color: KairoTheme.textMuted, fontSize: 10, fontFamily: 'monospace'),
                              hintText: "Tech, Gear, Home...",
                              hintStyle: const TextStyle(color: KairoTheme.textFaint),
                              filled: true,
                              fillColor: KairoTheme.surfaceElevated,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(KairoTheme.radiusSm)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: KairoTheme.sm),
                    TextField(
                      controller: currentSolCtrl,
                      style: const TextStyle(color: KairoTheme.textPrimary, fontSize: 13),
                      decoration: InputDecoration(
                        labelText: "CURRENT SOLUTION",
                        labelStyle: const TextStyle(color: KairoTheme.textMuted, fontSize: 10, fontFamily: 'monospace'),
                        hintText: "e.g. Laptop + phone / None / Old headphones",
                        hintStyle: const TextStyle(color: KairoTheme.textFaint),
                        filled: true,
                        fillColor: KairoTheme.surfaceElevated,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(KairoTheme.radiusSm)),
                      ),
                    ),
                    const SizedBox(height: KairoTheme.sm),
                    TextField(
                      controller: replaceCtrl,
                      style: const TextStyle(color: KairoTheme.textPrimary, fontSize: 13),
                      decoration: InputDecoration(
                        labelText: "REPLACEMENT FOR (OPTIONAL)",
                        labelStyle: const TextStyle(color: KairoTheme.textMuted, fontSize: 10, fontFamily: 'monospace'),
                        hintText: "Item being retired or upgraded",
                        hintStyle: const TextStyle(color: KairoTheme.textFaint),
                        filled: true,
                        fillColor: KairoTheme.surfaceElevated,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(KairoTheme.radiusSm)),
                      ),
                    ),
                    const SizedBox(height: KairoTheme.sm),
                    TextField(
                      controller: reasonCtrl,
                      style: const TextStyle(color: KairoTheme.textPrimary, fontSize: 13),
                      decoration: InputDecoration(
                        labelText: "REASON / CORE THESIS",
                        labelStyle: const TextStyle(color: KairoTheme.textMuted, fontSize: 10, fontFamily: 'monospace'),
                        hintText: "Why is this required or desired?",
                        hintStyle: const TextStyle(color: KairoTheme.textFaint),
                        filled: true,
                        fillColor: KairoTheme.surfaceElevated,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(KairoTheme.radiusSm)),
                      ),
                    ),
                    const SizedBox(height: KairoTheme.sm),
                    TextField(
                      controller: notesCtrl,
                      style: const TextStyle(color: KairoTheme.textPrimary, fontSize: 13),
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: "RESEARCH NOTES",
                        labelStyle: const TextStyle(color: KairoTheme.textMuted, fontSize: 10, fontFamily: 'monospace'),
                        hintText: "Specs, trade-offs, shortlist candidate links",
                        hintStyle: const TextStyle(color: KairoTheme.textFaint),
                        filled: true,
                        fillColor: KairoTheme.surfaceElevated,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(KairoTheme.radiusSm)),
                      ),
                    ),
                    const SizedBox(height: KairoTheme.lg),
                    KairoButton(
                      text: "SAVE TO NEEDS TABLE",
                      isPrimary: true,
                      isFullWidth: true,
                      onPressed: () async {
                        if (titleCtrl.text.trim().isEmpty) return;
                        final cost = double.tryParse(costCtrl.text.trim());

                        await ref.read(needServiceProvider).createNeed(
                          title: titleCtrl.text.trim(),
                          description: descCtrl.text.trim(),
                          category: catCtrl.text.trim().isNotEmpty ? catCtrl.text.trim() : 'Tech',
                          type: selectedType,
                          urgency: selectedUrgency,
                          status: selectedStatus,
                          estimatedCost: cost,
                          currentSolution: currentSolCtrl.text.trim(),
                          replacementFor: replaceCtrl.text.trim(),
                          reason: reasonCtrl.text.trim(),
                          researchNotes: notesCtrl.text.trim(),
                        );

                        ref.invalidate(filteredNeedsProvider);
                        ref.invalidate(needsSummaryProvider);
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

  void _showNeedDetailAndDecisionModal(BuildContext context, Need need) {
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
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            need.title.toUpperCase(),
                            style: const TextStyle(
                              color: KairoTheme.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.1,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: KairoTheme.textMuted, size: 18),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                    const SizedBox(height: KairoTheme.xs),

                    // Badges
                    Row(
                      children: [
                        KairoStatus(label: need.type.name.toUpperCase(), type: KairoStatusType.observed),
                        const SizedBox(width: 6),
                        KairoStatus(label: need.urgency.name.toUpperCase(), type: KairoStatusType.recommended),
                        const SizedBox(width: 6),
                        KairoStatus(label: need.status.name.toUpperCase(), type: KairoStatusType.success),
                        if (need.isExternal) ...[
                          const SizedBox(width: 6),
                          const KairoStatus(label: "MS TO DO", type: KairoStatusType.observed),
                        ],
                      ],
                    ),
                    const SizedBox(height: KairoTheme.md),

                    // Attributes
                    if (need.estimatedCost != null)
                      _buildAttrRow("Estimated Cost:", "₹${need.estimatedCost!.toStringAsFixed(0)}"),
                    if (need.currentSolution.isNotEmpty)
                      _buildAttrRow("Current Solution:", need.currentSolution),
                    if (need.replacementFor.isNotEmpty)
                      _buildAttrRow("Replacement For:", need.replacementFor),
                    if (need.category.isNotEmpty)
                      _buildAttrRow("Category:", need.category),
                    if (need.reason.isNotEmpty)
                      _buildAttrRow("Reason:", need.reason),
                    if (need.researchNotes.isNotEmpty)
                      _buildAttrRow("Research Notes:", need.researchNotes),
                    if (need.decision.isNotEmpty)
                      _buildAttrRow("Recorded Decision:", need.decision),

                    const SizedBox(height: KairoTheme.lg),
                    const Text(
                      "USER DECISION & AGENCY",
                      style: TextStyle(
                        color: KairoTheme.textMuted,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'monospace',
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Choose how to handle this Need. It will never automatically enter daily tasks without explicit promotion.",
                      style: TextStyle(color: KairoTheme.textMuted, fontSize: 10),
                    ),
                    const SizedBox(height: KairoTheme.md),

                    // Decision Actions
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        KairoButton(
                          text: "KEEP AS NEED",
                          onPressed: () => Navigator.pop(ctx),
                        ),
                        KairoButton(
                          text: "RESEARCH",
                          onPressed: () async {
                            need.status = NeedStatus.researching;
                            await ref.read(needServiceProvider).updateNeed(need);
                            ref.invalidate(filteredNeedsProvider);
                            ref.invalidate(needsSummaryProvider);
                            if (ctx.mounted) Navigator.pop(ctx);
                          },
                        ),
                        KairoButton(
                          text: "CREATE TASK",
                          isPrimary: true,
                          icon: Icons.arrow_upward_rounded,
                          onPressed: () {
                            Navigator.pop(ctx);
                            _showPromoteToTaskModal(context, need);
                          },
                        ),
                        KairoButton(
                          text: "CREATE PROJECT",
                          icon: Icons.shield_outlined,
                          onPressed: () {
                            Navigator.pop(ctx);
                            _showPromoteToProjectModal(context, need);
                          },
                        ),
                        KairoButton(
                          text: "READY",
                          onPressed: () async {
                            need.status = NeedStatus.ready;
                            await ref.read(needServiceProvider).updateNeed(need);
                            ref.invalidate(filteredNeedsProvider);
                            ref.invalidate(needsSummaryProvider);
                            if (ctx.mounted) Navigator.pop(ctx);
                          },
                        ),
                        KairoButton(
                          text: "DEFER",
                          onPressed: () async {
                            need.status = NeedStatus.deferred;
                            await ref.read(needServiceProvider).updateNeed(need);
                            ref.invalidate(filteredNeedsProvider);
                            ref.invalidate(needsSummaryProvider);
                            if (ctx.mounted) Navigator.pop(ctx);
                          },
                        ),
                        KairoButton(
                          text: "DROP",
                          onPressed: () async {
                            need.status = NeedStatus.dropped;
                            await ref.read(needServiceProvider).updateNeed(need);
                            ref.invalidate(filteredNeedsProvider);
                            ref.invalidate(needsSummaryProvider);
                            if (ctx.mounted) Navigator.pop(ctx);
                          },
                        ),
                      ],
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

  void _showPromoteToTaskModal(BuildContext context, Need need) {
    final titleCtrl = TextEditingController(text: "Compare & evaluate ${need.title}");
    final catCtrl = TextEditingController(text: need.category);
    EnergySlot selectedSlot = EnergySlot.recovery;

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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "PROMOTE NEED TO EXECUTABLE TASK",
                    style: TextStyle(
                      color: KairoTheme.textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'monospace',
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "This task will be added to the execution system. The Need will remain linked.",
                    style: TextStyle(color: KairoTheme.textMuted, fontSize: 10),
                  ),
                  const SizedBox(height: KairoTheme.md),
                  TextField(
                    controller: titleCtrl,
                    style: const TextStyle(color: KairoTheme.textPrimary, fontSize: 13),
                    decoration: InputDecoration(
                      labelText: "TASK TITLE",
                      labelStyle: const TextStyle(color: KairoTheme.textMuted, fontSize: 10, fontFamily: 'monospace'),
                      filled: true,
                      fillColor: KairoTheme.surfaceElevated,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(KairoTheme.radiusSm)),
                    ),
                  ),
                  const SizedBox(height: KairoTheme.sm),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: catCtrl,
                          style: const TextStyle(color: KairoTheme.textPrimary, fontSize: 13),
                          decoration: InputDecoration(
                            labelText: "CATEGORY",
                            labelStyle: const TextStyle(color: KairoTheme.textMuted, fontSize: 10, fontFamily: 'monospace'),
                            filled: true,
                            fillColor: KairoTheme.surfaceElevated,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(KairoTheme.radiusSm)),
                          ),
                        ),
                      ),
                      const SizedBox(width: KairoTheme.sm),
                      DropdownButton<EnergySlot>(
                        value: selectedSlot,
                        dropdownColor: KairoTheme.surfaceElevated,
                        underline: const SizedBox.shrink(),
                        items: EnergySlot.values.map((s) {
                          return DropdownMenuItem(
                            value: s,
                            child: Text(s.name.toUpperCase(), style: const TextStyle(color: KairoTheme.textPrimary, fontSize: 11, fontFamily: 'monospace')),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setModalState(() => selectedSlot = val);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: KairoTheme.lg),
                  KairoButton(
                    text: "COMMIT TASK",
                    isPrimary: true,
                    isFullWidth: true,
                    onPressed: () async {
                      if (titleCtrl.text.trim().isEmpty) return;
                      await ref.read(needServiceProvider).promoteToTask(
                        needId: need.id,
                        taskTitle: titleCtrl.text.trim(),
                        category: catCtrl.text.trim(),
                        energySlot: selectedSlot,
                      );
                      ref.invalidate(filteredNeedsProvider);
                      ref.invalidate(needsSummaryProvider);
                      if (ctx.mounted) Navigator.pop(ctx);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Need '${need.title}' promoted to Task '${titleCtrl.text.trim()}'."),
                            backgroundColor: KairoTheme.surfaceElevated,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showPromoteToProjectModal(BuildContext context, Need need) {
    final titleCtrl = TextEditingController(text: need.title);
    final descCtrl = TextEditingController(text: need.reason.isNotEmpty ? need.reason : need.description);

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
              const Text(
                "PROMOTE NEED TO PROJECT",
                style: TextStyle(
                  color: KairoTheme.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'monospace',
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "Creates an active project in the Order WIP system.",
                style: TextStyle(color: KairoTheme.textMuted, fontSize: 10),
              ),
              const SizedBox(height: KairoTheme.md),
              TextField(
                controller: titleCtrl,
                style: const TextStyle(color: KairoTheme.textPrimary, fontSize: 13),
                decoration: InputDecoration(
                  labelText: "PROJECT TITLE",
                  labelStyle: const TextStyle(color: KairoTheme.textMuted, fontSize: 10, fontFamily: 'monospace'),
                  filled: true,
                  fillColor: KairoTheme.surfaceElevated,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(KairoTheme.radiusSm)),
                ),
              ),
              const SizedBox(height: KairoTheme.sm),
              TextField(
                controller: descCtrl,
                style: const TextStyle(color: KairoTheme.textPrimary, fontSize: 13),
                decoration: InputDecoration(
                  labelText: "PROJECT DESCRIPTION",
                  labelStyle: const TextStyle(color: KairoTheme.textMuted, fontSize: 10, fontFamily: 'monospace'),
                  filled: true,
                  fillColor: KairoTheme.surfaceElevated,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(KairoTheme.radiusSm)),
                ),
              ),
              const SizedBox(height: KairoTheme.lg),
              KairoButton(
                text: "CREATE PROJECT",
                isPrimary: true,
                isFullWidth: true,
                onPressed: () async {
                  if (titleCtrl.text.trim().isEmpty) return;
                  await ref.read(needServiceProvider).promoteToProject(
                    needId: need.id,
                    projectTitle: titleCtrl.text.trim(),
                    description: descCtrl.text.trim(),
                  );
                  ref.invalidate(filteredNeedsProvider);
                  ref.invalidate(needsSummaryProvider);
                  if (ctx.mounted) Navigator.pop(ctx);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Need '${need.title}' promoted to Project '${titleCtrl.text.trim()}'."),
                        backgroundColor: KairoTheme.surfaceElevated,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAttrRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: const TextStyle(color: KairoTheme.textMuted, fontSize: 11, fontFamily: 'monospace', fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: KairoTheme.textPrimary, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final summaryAsync = ref.watch(needsSummaryProvider);
    final needsAsync = ref.watch(filteredNeedsProvider);
    final filter = ref.watch(needsFilterProvider);

    return Scaffold(
      backgroundColor: KairoTheme.background,
      appBar: AppBar(
        backgroundColor: KairoTheme.surface,
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "DECISION SUPPORT MATRIX",
              style: TextStyle(
                color: KairoTheme.textMuted,
                fontSize: 9,
                fontWeight: FontWeight.w800,
                fontFamily: 'monospace',
                letterSpacing: 1.5,
              ),
            ),
            Text(
              "NEEDS",
              style: TextStyle(
                color: KairoTheme.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: "Sync from Microsoft To Do (K.A.I.R.O. — NEEDS)",
            icon: _isSyncingTodo
                ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: KairoTheme.textPrimary))
                : const Icon(Icons.sync, color: KairoTheme.textSecondary, size: 20),
            onPressed: _isSyncingTodo ? null : _syncMicrosoftTodo,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: KairoButton(
              text: "ADD NEED",
              icon: Icons.add,
              isPrimary: true,
              onPressed: () => _showAddNeedModal(context),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ─── Decision Support Summary Banner ───
            summaryAsync.when(
              data: (summary) => Padding(
                padding: const EdgeInsets.fromLTRB(KairoTheme.xl, KairoTheme.md, KairoTheme.xl, KairoTheme.xs),
                child: KairoCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.inventory_2_outlined, size: 14, color: KairoTheme.observed),
                              SizedBox(width: 6),
                              Text(
                                "UNRESOLVED NEEDS SUMMARY",
                                style: TextStyle(
                                  color: KairoTheme.textMuted,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'monospace',
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                          KairoStatus(
                            label: "${summary.totalActive} ACTIVE",
                            type: KairoStatusType.observed,
                          ),
                        ],
                      ),
                      const SizedBox(height: KairoTheme.sm),
                      Row(
                        children: [
                          if (summary.estimatedTotalCost > 0) ...[
                            _buildSummaryStat("ESTIMATED TOTAL", "₹${summary.estimatedTotalCost.toStringAsFixed(0)}"),
                            const SizedBox(width: KairoTheme.lg),
                          ],
                          if (summary.highestUrgency != null) ...[
                            Expanded(
                              child: _buildSummaryStat("HIGHEST URGENCY", summary.highestUrgency!.title),
                            ),
                            const SizedBox(width: KairoTheme.md),
                          ],
                          if (summary.deferredCount > 0)
                            _buildSummaryStat("DEFERRED", "${summary.deferredCount}"),
                        ],
                      ),
                      const SizedBox(height: KairoTheme.sm),
                      const Text(
                        "These are your unresolved needs. The user decides if and when to act.",
                        style: TextStyle(
                          color: KairoTheme.textMuted,
                          fontSize: 10,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              loading: () => const SizedBox.shrink(),
              error: (err, stack) => const SizedBox.shrink(),
            ),

            // ─── Filter & Search Bar ───
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: KairoTheme.xl, vertical: KairoTheme.xs),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchCtrl,
                      style: const TextStyle(color: KairoTheme.textPrimary, fontSize: 12),
                      decoration: InputDecoration(
                        hintText: "Search needs, current solutions, tags...",
                        hintStyle: const TextStyle(color: KairoTheme.textFaint, fontSize: 11),
                        prefixIcon: const Icon(Icons.search, size: 16, color: KairoTheme.textMuted),
                        filled: true,
                        fillColor: KairoTheme.surfaceElevated,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(KairoTheme.radiusSm),
                          borderSide: const BorderSide(color: KairoTheme.border),
                        ),
                      ),
                      onChanged: (val) {
                        ref.read(needsFilterProvider.notifier).state = filter.copyWith(searchQuery: val);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  PopupMenuButton<NeedUrgency?>(
                    tooltip: "Filter by Urgency",
                    color: KairoTheme.surfaceElevated,
                    icon: Icon(
                      Icons.filter_list,
                      color: filter.urgency != null ? KairoTheme.recommended : KairoTheme.textMuted,
                      size: 20,
                    ),
                    onSelected: (val) {
                      ref.read(needsFilterProvider.notifier).state = filter.copyWith(urgency: () => val);
                    },
                    itemBuilder: (ctx) => [
                      const PopupMenuItem(value: null, child: Text("All Urgencies", style: TextStyle(color: KairoTheme.textPrimary, fontSize: 11))),
                      ...NeedUrgency.values.map((u) => PopupMenuItem(value: u, child: Text(u.name.toUpperCase(), style: const TextStyle(color: KairoTheme.textPrimary, fontSize: 11)))),
                    ],
                  ),
                  PopupMenuButton<NeedType?>(
                    tooltip: "Filter by Type",
                    color: KairoTheme.surfaceElevated,
                    icon: Icon(
                      Icons.category_outlined,
                      color: filter.type != null ? KairoTheme.recommended : KairoTheme.textMuted,
                      size: 20,
                    ),
                    onSelected: (val) {
                      ref.read(needsFilterProvider.notifier).state = filter.copyWith(type: () => val);
                    },
                    itemBuilder: (ctx) => [
                      const PopupMenuItem(value: null, child: Text("All Types", style: TextStyle(color: KairoTheme.textPrimary, fontSize: 11))),
                      ...NeedType.values.map((t) => PopupMenuItem(value: t, child: Text(t.name.toUpperCase(), style: const TextStyle(color: KairoTheme.textPrimary, fontSize: 11)))),
                    ],
                  ),
                ],
              ),
            ),

            // ─── Needs Decision Table Header ───
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: KairoTheme.xl, vertical: 4),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: KairoTheme.surfaceElevated,
                  borderRadius: BorderRadius.circular(KairoTheme.radiusSm),
                  border: Border.all(color: KairoTheme.border),
                ),
                child: const Row(
                  children: [
                    Expanded(flex: 3, child: Text("NEED", style: TextStyle(color: KairoTheme.textMuted, fontSize: 9, fontWeight: FontWeight.bold, fontFamily: 'monospace'))),
                    Expanded(flex: 2, child: Text("TYPE", style: TextStyle(color: KairoTheme.textMuted, fontSize: 9, fontWeight: FontWeight.bold, fontFamily: 'monospace'))),
                    Expanded(flex: 2, child: Text("COST", style: TextStyle(color: KairoTheme.textMuted, fontSize: 9, fontWeight: FontWeight.bold, fontFamily: 'monospace'))),
                    Expanded(flex: 2, child: Text("URGENCY", style: TextStyle(color: KairoTheme.textMuted, fontSize: 9, fontWeight: FontWeight.bold, fontFamily: 'monospace'))),
                    Expanded(flex: 2, child: Text("STATUS", style: TextStyle(color: KairoTheme.textMuted, fontSize: 9, fontWeight: FontWeight.bold, fontFamily: 'monospace'))),
                  ],
                ),
              ),
            ),

            // ─── Table Rows List ───
            Expanded(
              child: RefreshIndicator(
                color: KairoTheme.textPrimary,
                backgroundColor: KairoTheme.surfaceElevated,
                onRefresh: () async {
                  ref.invalidate(filteredNeedsProvider);
                  ref.invalidate(needsSummaryProvider);
                },
                child: needsAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2, color: KairoTheme.textPrimary)),
                  error: (e, _) => Center(child: Text("Error: $e", style: const TextStyle(color: KairoTheme.warning))),
                  data: (needs) {
                    if (needs.isEmpty) {
                      return Center(
                        child: KairoEmptyState(
                          title: "NO NEEDS RECORDED",
                          description: "Capture equipment, tooling, or gear requirements. Needs do not affect daily execution.",
                          action: KairoButton(
                            text: "REGISTER NEED",
                            icon: Icons.add,
                            isPrimary: true,
                            onPressed: () => _showAddNeedModal(context),
                          ),
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: KairoTheme.xl, vertical: 4),
                      itemCount: needs.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 4),
                      itemBuilder: (ctx, index) {
                        final need = needs[index];
                        return _buildNeedTableRow(need);
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: KairoTheme.textMuted, fontSize: 8, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
        const SizedBox(height: 1),
        Text(
          value,
          style: const TextStyle(color: KairoTheme.textPrimary, fontSize: 13, fontWeight: FontWeight.w900, fontFamily: 'monospace'),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildNeedTableRow(Need need) {
    final costStr = need.estimatedCost != null ? "₹${need.estimatedCost!.toStringAsFixed(0)}" : "—";

    return InkWell(
      onTap: () => _showNeedDetailAndDecisionModal(context, need),
      borderRadius: BorderRadius.circular(KairoTheme.radiusSm),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: KairoTheme.surface,
          borderRadius: BorderRadius.circular(KairoTheme.radiusSm),
          border: Border.all(color: KairoTheme.border),
        ),
        child: Row(
          children: [
            // Title & Current Solution
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    need.title,
                    style: const TextStyle(
                      color: KairoTheme.textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (need.currentSolution.isNotEmpty)
                    Text(
                      "Sol: ${need.currentSolution}",
                      style: const TextStyle(color: KairoTheme.textMuted, fontSize: 9),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),

            // Type
            Expanded(
              flex: 2,
              child: Text(
                need.type.name.toUpperCase(),
                style: const TextStyle(
                  color: KairoTheme.textSecondary,
                  fontSize: 10,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Cost
            Expanded(
              flex: 2,
              child: Text(
                costStr,
                style: const TextStyle(
                  color: KairoTheme.textPrimary,
                  fontSize: 11,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // Urgency
            Expanded(
              flex: 2,
              child: Text(
                need.urgency.name.toUpperCase(),
                style: TextStyle(
                  color: need.urgency == NeedUrgency.urgent || need.urgency == NeedUrgency.high
                      ? KairoTheme.recommended
                      : KairoTheme.textMuted,
                  fontSize: 10,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Status
            Expanded(
              flex: 2,
              child: Text(
                need.status.name.toUpperCase(),
                style: TextStyle(
                  color: need.status == NeedStatus.ready
                      ? KairoTheme.success
                      : need.status == NeedStatus.researching
                          ? KairoTheme.observed
                          : KairoTheme.textMuted,
                  fontSize: 9,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
