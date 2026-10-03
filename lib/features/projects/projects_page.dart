import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/kairo_design_system.dart';
import '../../core/models/project.dart';
import '../../core/providers/project_dna_provider.dart';
import '../../core/providers/github_provider.dart';
import '../../core/services/github_service.dart';
import '../../Nav/smooth_page_route.dart';
import 'project_dna_page.dart';

class ProjectsPage extends ConsumerStatefulWidget {
  const ProjectsPage({super.key});

  @override
  ConsumerState<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends ConsumerState<ProjectsPage> {
  void _showGitHubRepoPickerModal(BuildContext parentContext, Function(GitHubRepoItem) onSelected) {
    showModalBottomSheet(
      context: parentContext,
      backgroundColor: KairoTheme.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(KairoTheme.radiusLg)),
        side: BorderSide(color: KairoTheme.border, width: 1),
      ),
      builder: (ctx) {
        return Consumer(
          builder: (context, ref, _) {
            final reposAsync = ref.watch(userRepositoriesProvider);
            return Padding(
              padding: EdgeInsets.only(
                left: KairoTheme.xl,
                right: KairoTheme.xl,
                top: KairoTheme.xl,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + KairoTheme.xl,
              ),
              child: SizedBox(
                height: MediaQuery.of(ctx).size.height * 0.7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.code_rounded, color: KairoTheme.observed, size: 16),
                            SizedBox(width: 8),
                            Text(
                              "SELECT GITHUB REPOSITORY",
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
                        IconButton(
                          icon: const Icon(Icons.close, color: KairoTheme.textMuted, size: 18),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Pick any of your repositories to auto-populate registration fields.",
                      style: TextStyle(color: KairoTheme.textMuted, fontSize: 10),
                    ),
                    const SizedBox(height: KairoTheme.md),
                    Expanded(
                      child: reposAsync.when(
                        loading: () => const Center(
                          child: CircularProgressIndicator(strokeWidth: 2, color: KairoTheme.textPrimary),
                        ),
                        error: (err, _) => Center(
                          child: Padding(
                            padding: const EdgeInsets.all(KairoTheme.md),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.key_off_outlined, color: KairoTheme.warning, size: 28),
                                const SizedBox(height: 8),
                                Text(
                                  err.toString().replaceAll("Exception: ", ""),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: KairoTheme.textMuted, fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                        ),
                        data: (repos) {
                          if (repos.isEmpty) {
                            return const Center(
                              child: Text(
                                "No repositories found for this account.",
                                style: TextStyle(color: KairoTheme.textMuted, fontSize: 11),
                              ),
                            );
                          }

                          return ListView.separated(
                            itemCount: repos.length,
                            separatorBuilder: (context, index) => const Divider(color: KairoTheme.border, height: 1),
                            itemBuilder: (context, index) {
                              final repo = repos[index];
                              return ListTile(
                                dense: true,
                                contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                title: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        repo.fullName,
                                        style: const TextStyle(
                                          color: KairoTheme.textPrimary,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12,
                                          fontFamily: 'monospace',
                                        ),
                                      ),
                                    ),
                                    if (repo.isPrivate)
                                      const KairoStatus(label: "PRIVATE", type: KairoStatusType.warning)
                                    else
                                      const KairoStatus(label: "PUBLIC", type: KairoStatusType.observed),
                                  ],
                                ),
                                subtitle: repo.description.isNotEmpty
                                    ? Padding(
                                        padding: const EdgeInsets.only(top: 2),
                                        child: Text(
                                          repo.description,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(color: KairoTheme.textMuted, fontSize: 10),
                                        ),
                                      )
                                    : null,
                                trailing: const Icon(Icons.arrow_forward_ios, size: 12, color: KairoTheme.textMuted),
                                onTap: () {
                                  onSelected(repo);
                                  Navigator.pop(ctx);
                                },
                              );
                            },
                          );
                        },
                      ),
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

  void _showRegisterProjectModal(BuildContext context) {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final repoCtrl = TextEditingController();
    final branchCtrl = TextEditingController(text: "main");

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
                          "REGISTER K.A.I.R.O. PROJECT",
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
                      "Only explicitly registered projects are ingested. Expects .kairo/manifest.yaml in repository root.",
                      style: TextStyle(color: KairoTheme.textMuted, fontSize: 10),
                    ),
                    const SizedBox(height: KairoTheme.md),
                    KairoButton(
                      text: "IMPORT FROM GITHUB REPOSITORIES",
                      icon: Icons.cloud_download_outlined,
                      isFullWidth: true,
                      onPressed: () {
                        _showGitHubRepoPickerModal(context, (repo) {
                          setModalState(() {
                            titleCtrl.text = repo.name;
                            descCtrl.text = repo.description;
                            repoCtrl.text = repo.fullName;
                            branchCtrl.text = repo.defaultBranch;
                          });
                        });
                      },
                    ),
                    const SizedBox(height: KairoTheme.md),
                    TextField(
                      controller: titleCtrl,
                      style: const TextStyle(color: KairoTheme.textPrimary, fontSize: 13),
                      decoration: InputDecoration(
                        labelText: "PROJECT NAME",
                        labelStyle: const TextStyle(color: KairoTheme.textMuted, fontSize: 10, fontFamily: 'monospace'),
                        hintText: "e.g. KlaudTrace",
                        hintStyle: const TextStyle(color: KairoTheme.textFaint),
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
                    labelText: "DESCRIPTION",
                    labelStyle: const TextStyle(color: KairoTheme.textMuted, fontSize: 10, fontFamily: 'monospace'),
                    hintText: "Purpose, core thesis, or architecture scope",
                    hintStyle: const TextStyle(color: KairoTheme.textFaint),
                    filled: true,
                    fillColor: KairoTheme.surfaceElevated,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(KairoTheme.radiusSm)),
                  ),
                ),
                const SizedBox(height: KairoTheme.sm),
                TextField(
                  controller: repoCtrl,
                  style: const TextStyle(color: KairoTheme.textPrimary, fontSize: 13, fontFamily: 'monospace'),
                  decoration: InputDecoration(
                    labelText: "GITHUB REPOSITORY (OWNER/REPO)",
                    labelStyle: const TextStyle(color: KairoTheme.textMuted, fontSize: 10, fontFamily: 'monospace'),
                    hintText: "e.g. org/klaudtrace or user/project",
                    hintStyle: const TextStyle(color: KairoTheme.textFaint),
                    filled: true,
                    fillColor: KairoTheme.surfaceElevated,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(KairoTheme.radiusSm)),
                  ),
                ),
                const SizedBox(height: KairoTheme.sm),
                TextField(
                  controller: branchCtrl,
                  style: const TextStyle(color: KairoTheme.textPrimary, fontSize: 13, fontFamily: 'monospace'),
                  decoration: InputDecoration(
                    labelText: "DEFAULT BRANCH",
                    labelStyle: const TextStyle(color: KairoTheme.textMuted, fontSize: 10, fontFamily: 'monospace'),
                    filled: true,
                    fillColor: KairoTheme.surfaceElevated,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(KairoTheme.radiusSm)),
                  ),
                ),
                const SizedBox(height: KairoTheme.lg),
                KairoButton(
                  text: "REGISTER & INITIATE DNA",
                  isPrimary: true,
                  isFullWidth: true,
                  onPressed: () async {
                    if (titleCtrl.text.trim().isEmpty) return;
                    final project = await ref.read(projectDnaServiceProvider).registerProject(
                      title: titleCtrl.text.trim(),
                      description: descCtrl.text.trim(),
                      repository: repoCtrl.text.trim(),
                      branch: branchCtrl.text.trim().isNotEmpty ? branchCtrl.text.trim() : 'main',
                    );

                    ref.invalidate(allProjectsProvider);
                    ref.invalidate(registeredKairoProjectsProvider);
                    if (ctx.mounted) Navigator.pop(ctx);

                    // Navigate directly to DNA page
                    if (context.mounted) {
                      Navigator.push(context, SmoothPageRoute(page: ProjectDnaPage(project: project)));
                    }
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

  @override
  Widget build(BuildContext context) {
    final projectsAsync = ref.watch(allProjectsProvider);

    return Scaffold(
      backgroundColor: KairoTheme.background,
      appBar: AppBar(
        backgroundColor: KairoTheme.surface,
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "WORK ENGINE",
              style: TextStyle(
                color: KairoTheme.textMuted,
                fontSize: 9,
                fontWeight: FontWeight.w800,
                fontFamily: 'monospace',
                letterSpacing: 1.5,
              ),
            ),
            Text(
              "PROJECTS & DNA",
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
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: KairoButton(
              text: "REGISTER",
              icon: Icons.add,
              isPrimary: true,
              onPressed: () => _showRegisterProjectModal(context),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: KairoTheme.textPrimary,
          backgroundColor: KairoTheme.surfaceElevated,
          onRefresh: () async {
            ref.invalidate(allProjectsProvider);
            ref.invalidate(registeredKairoProjectsProvider);
          },
          child: projectsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2, color: KairoTheme.textPrimary)),
            error: (e, _) => Center(child: Text("Error: $e", style: const TextStyle(color: KairoTheme.warning))),
            data: (projects) {
              if (projects.isEmpty) {
                return Center(
                  child: KairoEmptyState(
                    title: "NO REGISTERED PROJECTS",
                    description: "Explicitly register your project repository to ingest .kairo/manifest.yaml and architecture diagrams.",
                    action: KairoButton(
                      text: "REGISTER PROJECT",
                      icon: Icons.add,
                      isPrimary: true,
                      onPressed: () => _showRegisterProjectModal(context),
                    ),
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(KairoTheme.xl),
                itemCount: projects.length,
                separatorBuilder: (context, index) => const SizedBox(height: KairoTheme.md),
                itemBuilder: (ctx, index) {
                  final proj = projects[index];
                  return _buildProjectCard(proj);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildProjectCard(Project project) {
    return KairoCard(
      onTap: () {
        Navigator.push(context, SmoothPageRoute(page: ProjectDnaPage(project: project)));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  project.title.toUpperCase(),
                  style: const TextStyle(
                    color: KairoTheme.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.1,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              if (project.isRegisteredKairo)
                const KairoStatus(label: "K.A.I.R.O. DNA", type: KairoStatusType.observed)
              else
                KairoStatus(label: project.status.toUpperCase(), type: KairoStatusType.recommended),
            ],
          ),
          if (project.description.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              project.description,
              style: const TextStyle(color: KairoTheme.textSecondary, fontSize: 11, height: 1.3),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: KairoTheme.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (project.repository != null) ...[
                    const Icon(Icons.code_rounded, size: 12, color: KairoTheme.textMuted),
                    const SizedBox(width: 4),
                    Text(
                      project.repository!,
                      style: const TextStyle(color: KairoTheme.textMuted, fontSize: 10, fontFamily: 'monospace'),
                    ),
                  ],
                ],
              ),
              const Row(
                children: [
                  Text(
                    "INSPECT DNA",
                    style: TextStyle(
                      color: KairoTheme.textPrimary,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'monospace',
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward_ios_rounded, size: 10, color: KairoTheme.textPrimary),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
