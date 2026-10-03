import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/kairo_design_system.dart';
import '../../core/models/project.dart';
import '../../core/models/task.dart';
import '../../core/models/architecture_drift.dart';
import '../../core/models/architecture_artifact.dart';
import '../../core/providers/project_dna_provider.dart';
import '../../core/providers/github_provider.dart';
import 'widgets/mermaid_viewer.dart';
import 'widgets/architecture_drift_card.dart';
import '../../main.dart';

class ProjectDnaPage extends ConsumerStatefulWidget {
  final Project project;

  const ProjectDnaPage({super.key, required this.project});

  @override
  ConsumerState<ProjectDnaPage> createState() => _ProjectDnaPageState();
}

class _ProjectDnaPageState extends ConsumerState<ProjectDnaPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isSyncing = false;
  late Project _project;

  @override
  void initState() {
    super.initState();
    _project = widget.project;
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _triggerSync() async {
    setState(() => _isSyncing = true);
    try {
      final updated = await ref.read(projectDnaServiceProvider).syncProjectDna(
        project: _project,
      );
      if (mounted) {
        setState(() {
          _project = updated;
          _isSyncing = false;
        });
        ref.invalidate(projectArtifactsProvider(_project.id));
        ref.invalidate(projectDriftsProvider(_project.id));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Project DNA synchronized for ${_project.title}"),
            backgroundColor: KairoTheme.surfaceElevated,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSyncing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("DNA Sync notice: $e"),
            backgroundColor: KairoTheme.warning.withValues(alpha: 0.8),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _showAddMermaidSnippetModal([ArchitectureArtifact? existing]) {
    String selectedType = existing?.architectureType ?? 'system';
    final pathCtrl = TextEditingController(text: existing?.sourcePath ?? 'inline/snippet');
    final snippetCtrl = TextEditingController(
      text: existing?.rawMermaid ??
          '''graph LR
    Client[Client App] --> API[Backend API]
    API --> DB[(Database)]''',
    );
    bool isCommittingToGitHub = false;

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
                      children: [
                        const Icon(Icons.code, color: KairoTheme.recommended, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          existing == null ? "INGEST MERMAID SNIPPET" : "EDIT MERMAID SNIPPET",
                          style: const TextStyle(
                            color: KairoTheme.textPrimary,
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'monospace',
                            letterSpacing: 1.1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Directly paste or edit Mermaid diagram code. Save locally or commit back to GitHub.",
                      style: TextStyle(color: KairoTheme.textMuted, fontSize: 10),
                    ),
                    const SizedBox(height: KairoTheme.md),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: selectedType,
                            dropdownColor: KairoTheme.surfaceElevated,
                            decoration: InputDecoration(
                              labelText: "DIAGRAM TYPE",
                              labelStyle: const TextStyle(color: KairoTheme.textMuted, fontSize: 10, fontFamily: 'monospace'),
                              filled: true,
                              fillColor: KairoTheme.surfaceElevated,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(KairoTheme.radiusSm)),
                            ),
                            items: const [
                              DropdownMenuItem(value: 'system', child: Text('System (system.mmd)', style: TextStyle(color: KairoTheme.textPrimary, fontSize: 12, fontFamily: 'monospace'))),
                              DropdownMenuItem(value: 'data_flow', child: Text('Data Flow (data-flow.mmd)', style: TextStyle(color: KairoTheme.textPrimary, fontSize: 12, fontFamily: 'monospace'))),
                              DropdownMenuItem(value: 'deployment', child: Text('Deployment (deployment.mmd)', style: TextStyle(color: KairoTheme.textPrimary, fontSize: 12, fontFamily: 'monospace'))),
                              DropdownMenuItem(value: 'roadmap', child: Text('Roadmap (roadmap.mmd)', style: TextStyle(color: KairoTheme.textPrimary, fontSize: 12, fontFamily: 'monospace'))),
                            ],
                            onChanged: (val) {
                              if (val != null) setModalState(() => selectedType = val);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: KairoTheme.sm),
                    TextField(
                      controller: pathCtrl,
                      style: const TextStyle(color: KairoTheme.textPrimary, fontSize: 12, fontFamily: 'monospace'),
                      decoration: InputDecoration(
                        labelText: "SOURCE IDENTIFIER / PATH",
                        labelStyle: const TextStyle(color: KairoTheme.textMuted, fontSize: 10, fontFamily: 'monospace'),
                        filled: true,
                        fillColor: KairoTheme.surfaceElevated,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(KairoTheme.radiusSm)),
                      ),
                    ),
                    const SizedBox(height: KairoTheme.sm),
                    TextField(
                      controller: snippetCtrl,
                      maxLines: 8,
                      style: const TextStyle(color: KairoTheme.textPrimary, fontSize: 12, fontFamily: 'monospace'),
                      decoration: InputDecoration(
                        labelText: "MERMAID CODE SNIPPET",
                        labelStyle: const TextStyle(color: KairoTheme.textMuted, fontSize: 10, fontFamily: 'monospace'),
                        filled: true,
                        fillColor: KairoTheme.surfaceElevated,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(KairoTheme.radiusSm)),
                      ),
                    ),
                    const SizedBox(height: KairoTheme.lg),
                    Row(
                      children: [
                        Expanded(
                          child: KairoButton(
                            text: existing == null ? "INGEST LOCALLY" : "UPDATE LOCALLY",
                            isPrimary: true,
                            isFullWidth: true,
                            onPressed: () async {
                              if (snippetCtrl.text.trim().isEmpty) return;

                              await ref.read(mermaidIngestionServiceProvider).ingestArtifact(
                                projectId: _project.id,
                                projectTitle: _project.title,
                                architectureType: selectedType,
                                sourcePath: pathCtrl.text.trim().isEmpty ? 'inline/snippet' : pathCtrl.text.trim(),
                                rawMermaid: snippetCtrl.text.trim(),
                              );

                              await ref.read(architectureDriftServiceProvider).detectDrift(project: _project);
                              ref.invalidate(projectArtifactsProvider(_project.id));
                              ref.invalidate(projectDriftsProvider(_project.id));

                              if (ctx.mounted) Navigator.pop(ctx);
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Mermaid diagram snippet ingested successfully."),
                                    backgroundColor: KairoTheme.surfaceElevated,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        if (_project.repository != null && _project.repository!.contains('/')) ...[
                          const SizedBox(width: 8),
                          Expanded(
                            child: isCommittingToGitHub
                                ? const Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: KairoTheme.textPrimary)))
                                : KairoButton(
                                    text: "COMMIT TO GH",
                                    icon: Icons.cloud_upload_outlined,
                                    isFullWidth: true,
                                    onPressed: () async {
                                      if (snippetCtrl.text.trim().isEmpty) return;
                                      setModalState(() => isCommittingToGitHub = true);

                                      try {
                                        final targetPath = pathCtrl.text.trim().startsWith('inline') || pathCtrl.text.trim().isEmpty
                                            ? '.kairo/architecture/$selectedType.mmd'
                                            : pathCtrl.text.trim();

                                        await ref.read(githubServiceProvider).commitFileContent(
                                          repo: _project.repository!,
                                          branch: _project.branch,
                                          path: targetPath,
                                          content: snippetCtrl.text.trim(),
                                          commitMessage: "docs(architecture): update $selectedType mermaid diagram via K.A.I.R.O.",
                                        );

                                        // Also ingest locally
                                        await ref.read(mermaidIngestionServiceProvider).ingestArtifact(
                                          projectId: _project.id,
                                          projectTitle: _project.title,
                                          architectureType: selectedType,
                                          sourcePath: targetPath,
                                          rawMermaid: snippetCtrl.text.trim(),
                                        );

                                        await ref.read(architectureDriftServiceProvider).detectDrift(project: _project);
                                        ref.invalidate(projectArtifactsProvider(_project.id));
                                        ref.invalidate(projectDriftsProvider(_project.id));

                                        if (ctx.mounted) Navigator.pop(ctx);
                                        if (mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text("Pushed $targetPath to ${_project.repository}"),
                                              backgroundColor: KairoTheme.surfaceElevated,
                                              behavior: SnackBarBehavior.floating,
                                            ),
                                          );
                                        }
                                      } catch (err) {
                                        setModalState(() => isCommittingToGitHub = false);
                                        if (mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text("GitHub Push failed: $err"),
                                              backgroundColor: KairoTheme.warning,
                                              behavior: SnackBarBehavior.floating,
                                            ),
                                          );
                                        }
                                      }
                                    },
                                  ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            );
          },        );
      },
    );
  }

  void _showCreateTaskFromDriftModal(ArchitectureDrift drift) {
    final titleCtrl = TextEditingController(text: "Implement ${drift.missing} for ${_project.title}");
    final catCtrl = TextEditingController(text: "Engineering");
    EnergySlot selectedSlot = EnergySlot.peak1;

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
                  const Row(
                    children: [
                      Icon(Icons.add_task_rounded, color: KairoTheme.recommended, size: 16),
                      SizedBox(width: 8),
                      Text(
                        "PROPOSE TASK FROM ARCHITECTURE DRIFT",
                        style: TextStyle(
                          color: KairoTheme.textPrimary,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'monospace',
                          letterSpacing: 1.1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Explicit user commitment. K.A.I.R.O. will only add this task upon your explicit submission.",
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
                      const SizedBox(width: KairoTheme.md),
                      DropdownButton<EnergySlot>(
                        value: selectedSlot,
                        dropdownColor: KairoTheme.surfaceElevated,
                        underline: const SizedBox.shrink(),
                        items: EnergySlot.values.map((slot) {
                          return DropdownMenuItem(
                            value: slot,
                            child: Text(
                              slot.name.toUpperCase(),
                              style: const TextStyle(color: KairoTheme.textPrimary, fontSize: 11, fontFamily: 'monospace'),
                            ),
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
                    text: "COMMIT TASK TO TODAY/EXECUTION",
                    isPrimary: true,
                    isFullWidth: true,
                    onPressed: () async {
                      if (titleCtrl.text.trim().isEmpty) return;
                      final task = Task(titleCtrl.text.trim(), catCtrl.text.trim())
                        ..energySlot = selectedSlot
                        ..createdAt = DateTime.now();

                      await isar.writeTxn(() async {
                        await isar.tasks.put(task);
                      });

                      // Mark drift acknowledged
                      await ref.read(architectureDriftServiceProvider).acknowledgeDrift(drift.id);
                      ref.invalidate(projectDriftsProvider(_project.id));

                      if (ctx.mounted) Navigator.pop(ctx);
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Task created and entered into execution system."),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KairoTheme.background,
      appBar: AppBar(
        backgroundColor: KairoTheme.surface,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "PROJECT DNA",
              style: TextStyle(
                color: KairoTheme.textMuted,
                fontSize: 9,
                fontWeight: FontWeight.w800,
                fontFamily: 'monospace',
                letterSpacing: 1.5,
              ),
            ),
            Text(
              _project.title.toUpperCase(),
              style: const TextStyle(
                color: KairoTheme.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
        actions: [
          if (_isSyncing)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Center(child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: KairoTheme.textPrimary))),
            )
          else
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: KairoButton(
                text: "SYNC DNA",
                icon: Icons.sync,
                onPressed: _triggerSync,
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Metadata Banner
            Container(
              padding: const EdgeInsets.symmetric(horizontal: KairoTheme.xl, vertical: KairoTheme.md),
              decoration: const BoxDecoration(
                color: KairoTheme.surface,
                border: Border(bottom: BorderSide(color: KairoTheme.border, width: 1)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (_project.repository != null) ...[
                              const Icon(Icons.code_rounded, size: 12, color: KairoTheme.observed),
                              const SizedBox(width: 4),
                              Text(
                                _project.repository!,
                                style: const TextStyle(color: KairoTheme.textSecondary, fontSize: 11, fontFamily: 'monospace'),
                              ),
                              const SizedBox(width: 8),
                            ],
                            if (_project.manifestVersion != null)
                              KairoStatus(label: "v${_project.manifestVersion}", type: KairoStatusType.observed),
                          ],
                        ),
                        if (_project.lastSyncedAt != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            "Synced ${DateFormat('MMM d, HH:mm').format(_project.lastSyncedAt!)}",
                            style: const TextStyle(color: KairoTheme.textMuted, fontSize: 9, fontFamily: 'monospace'),
                          ),
                        ],
                      ],
                    ),
                  ),
                  KairoStatus(label: _project.status.toUpperCase(), type: KairoStatusType.success),
                ],
              ),
            ),

            // Tab bar
            Container(
              color: KairoTheme.surface,
              child: TabBar(
                controller: _tabController,
                indicatorColor: KairoTheme.textPrimary,
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: KairoTheme.textPrimary,
                unselectedLabelColor: KairoTheme.textMuted,
                labelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.1, fontFamily: 'monospace'),
                isScrollable: true,
                tabs: const [
                  Tab(text: "CAPABILITIES"),
                  Tab(text: "ARCHITECTURE"),
                  Tab(text: "INTENT VS REALITY"),
                  Tab(text: "DECISIONS"),
                ],
              ),
            ),

            // Tab Views
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildCapabilitiesTab(),
                  _buildArchitectureTab(),
                  _buildDriftTab(),
                  _buildDecisionsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCapabilitiesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(KairoTheme.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Constraints
          if (_project.constraints.isNotEmpty) ...[
            const KairoSectionHeader(title: "PROJECT CONSTRAINTS", padding: EdgeInsets.zero),
            const SizedBox(height: KairoTheme.xs),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: _project.constraints.map((c) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: KairoTheme.surfaceElevated,
                    borderRadius: BorderRadius.circular(KairoTheme.radiusSm),
                    border: Border.all(color: KairoTheme.border),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.lock_outline, size: 11, color: KairoTheme.textMuted),
                      const SizedBox(width: 4),
                      Text(c, style: const TextStyle(color: KairoTheme.textSecondary, fontSize: 10, fontFamily: 'monospace')),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: KairoTheme.lg),
          ],

          // Capabilities Breakdown
          _buildCapabilitySection("IMPLEMENTED CAPABILITIES", _project.implementedCapabilities, KairoStatusType.success, Icons.check_circle_outline),
          const SizedBox(height: KairoTheme.md),
          _buildCapabilitySection("PARTIAL CAPABILITIES", _project.partialCapabilities, KairoStatusType.recommended, Icons.timelapse),
          const SizedBox(height: KairoTheme.md),
          _buildCapabilitySection("PLANNED CAPABILITIES", _project.plannedCapabilities, KairoStatusType.observed, Icons.flag_outlined),
          const SizedBox(height: KairoTheme.md),
          _buildCapabilitySection("BLOCKED CAPABILITIES", _project.blockedCapabilities, KairoStatusType.warning, Icons.block),
        ],
      ),
    );
  }

  Widget _buildCapabilitySection(String title, List<String> items, KairoStatusType statusType, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: KairoTheme.sectionHeader),
            KairoStatus(label: "${items.length}", type: statusType),
          ],
        ),
        const SizedBox(height: KairoTheme.xs),
        if (items.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Text("None registered in manifest.", style: TextStyle(color: KairoTheme.textFaint, fontSize: 11)),
          )
        else
          Column(
            children: items.map((item) {
              return Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: KairoTheme.surfaceElevated,
                  borderRadius: BorderRadius.circular(KairoTheme.radiusSm),
                  border: Border.all(color: KairoTheme.border),
                ),
                child: Row(
                  children: [
                    Icon(icon, size: 13, color: KairoTheme.textMuted),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item,
                        style: const TextStyle(color: KairoTheme.textPrimary, fontSize: 11, fontFamily: 'monospace'),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildArchitectureTab() {
    final artifactsAsync = ref.watch(projectArtifactsProvider(_project.id));

    return artifactsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2, color: KairoTheme.textPrimary)),
      error: (e, _) => Center(child: Text("Error: $e", style: const TextStyle(color: KairoTheme.warning))),
      data: (artifacts) {
        if (artifacts.isEmpty) {
          return Center(
            child: KairoEmptyState(
              title: "NO ARCHITECTURE ARTIFACTS",
              description: "Ingest .mmd files (.kairo/architecture/), sync DNA, or paste a Mermaid code snippet directly.",
              action: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  KairoButton(
                    text: "PASTE SNIPPET",
                    icon: Icons.code,
                    isPrimary: true,
                    onPressed: () => _showAddMermaidSnippetModal(),
                  ),
                  const SizedBox(width: 8),
                  KairoButton(
                    text: "SYNC DNA",
                    icon: Icons.sync,
                    onPressed: _triggerSync,
                  ),
                ],
              ),
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(KairoTheme.xl),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("REGISTERED DIAGRAMS", style: KairoTheme.sectionHeader),
                KairoButton(
                  text: "PASTE SNIPPET",
                  icon: Icons.add,
                  onPressed: () => _showAddMermaidSnippetModal(),
                ),
              ],
            ),
            const SizedBox(height: KairoTheme.md),
            ...artifacts.map((art) {
              final parsed = ref.read(mermaidIngestionServiceProvider).parseMermaid(art.rawMermaid);
              return Padding(
                padding: const EdgeInsets.only(bottom: KairoTheme.lg),
                child: KairoCard(
                  child: MermaidViewer(
                    artifact: art,
                    parsed: parsed,
                    onEdit: () => _showAddMermaidSnippetModal(art),
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }

  Widget _buildDriftTab() {
    final driftsAsync = ref.watch(projectDriftsProvider(_project.id));

    return driftsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2, color: KairoTheme.textPrimary)),
      error: (e, _) => Center(child: Text("Error: $e", style: const TextStyle(color: KairoTheme.warning))),
      data: (drifts) {
        if (drifts.isEmpty) {
          return const Center(
            child: KairoEmptyState(
              title: "ZERO ARCHITECTURE DRIFT",
              description: "Declared intent matches verified implementation reality.",
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(KairoTheme.xl),
          itemCount: drifts.length,
          separatorBuilder: (context, index) => const SizedBox(height: KairoTheme.md),
          itemBuilder: (ctx, index) {
            final drift = drifts[index];
            return ArchitectureDriftCard(
              drift: drift,
              onAcknowledge: () async {
                await ref.read(architectureDriftServiceProvider).acknowledgeDrift(drift.id);
                ref.invalidate(projectDriftsProvider(_project.id));
              },
              onPromoteToTask: () => _showCreateTaskFromDriftModal(drift),
            );
          },
        );
      },
    );
  }

  Widget _buildDecisionsTab() {
    final decisions = _project.decisionsMarkdown;
    if (decisions == null || decisions.trim().isEmpty) {
      return Center(
        child: KairoEmptyState(
          title: "NO DECISIONS LOGGED",
          description: "Optional .kairo/decisions.md not found in project repository.",
          action: KairoButton(
            text: "SYNC DNA",
            icon: Icons.sync,
            onPressed: _triggerSync,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(KairoTheme.xl),
      child: KairoCard(
        child: SelectableText(
          decisions,
          style: const TextStyle(
            color: KairoTheme.textPrimary,
            fontSize: 12,
            fontFamily: 'monospace',
            height: 1.4,
          ),
        ),
      ),
    );
  }
}
