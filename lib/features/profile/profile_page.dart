import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/auth_provider.dart';
import 'providers/profile_provider.dart';
import '../../core/theme/kairo_design_system.dart';
import '../../core/services/wellbeing_service.dart';
import '../../core/services/backup_export_service.dart';
import '../../core/providers/wakatime_provider.dart';
import '../../core/providers/github_provider.dart';
import '../wardrobe/wardrobe_page.dart';
import '../workout/workout_page.dart';
import '../projects/projects_page.dart';
import '../needs/needs_page.dart';
import '../../Nav/smooth_page_route.dart';
import '../../main.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  late Timer _timer;
  DateTime _now = DateTime.now();

  final _identityCtrl = TextEditingController();
  final _rateCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  final _wakatimeKeyCtrl = TextEditingController();
  final _githubTokenCtrl = TextEditingController();
  final _groqApiKeyCtrl = TextEditingController();
  final _msTodoTokenCtrl = TextEditingController();

  bool _isInit = false;
  bool _hasUsagePerm = false;
  bool _hasDndPerm = false;
  bool _isExporting = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(() => _now = DateTime.now());
    });
    _loadTelemetryConfigs();
  }

  Future<void> _loadTelemetryConfigs() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _wakatimeKeyCtrl.text = prefs.getString('wakatime_key') ?? '';
        _githubTokenCtrl.text = prefs.getString('github_token') ?? '';
        _groqApiKeyCtrl.text = prefs.getString('groq_api_key') ?? '';
        _msTodoTokenCtrl.text = prefs.getString('ms_todo_token') ?? '';
      });
    }
    final usage = await WellbeingService.checkUsagePermission();
    final dnd = await WellbeingService.checkDndPermission();
    if (mounted) {
      setState(() {
        _hasUsagePerm = usage;
        _hasDndPerm = dnd;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      final profile = ref.read(profileProvider);
      _identityCtrl.text = profile.coreIdentity;
      _rateCtrl.text = profile.baseHourlyRate > 0 ? profile.baseHourlyRate.toStringAsFixed(2) : '';
      _ageCtrl.text = profile.age > 0 ? profile.age.toString() : '';
      _isInit = true;
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _identityCtrl.dispose();
    _rateCtrl.dispose();
    _ageCtrl.dispose();
    _wakatimeKeyCtrl.dispose();
    _githubTokenCtrl.dispose();
    _groqApiKeyCtrl.dispose();
    _msTodoTokenCtrl.dispose();
    super.dispose();
  }

  void _saveDemographics() {
    final rate = double.tryParse(_rateCtrl.text.trim()) ?? 0.0;
    final age = int.tryParse(_ageCtrl.text.trim()) ?? 0;

    ref.read(profileProvider.notifier).updateDemographics(
      coreIdentity: _identityCtrl.text.trim(),
      baseHourlyRate: rate,
      age: age,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Operator Demographics Updated.'),
        backgroundColor: KairoTheme.surfaceElevated,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _saveWakaTimeKey() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('wakatime_key', _wakatimeKeyCtrl.text.trim());
    ref.invalidate(wakatimeProvider);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('WakaTime API Key Saved.'),
          backgroundColor: KairoTheme.surfaceElevated,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _saveGitHubToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('github_token', _githubTokenCtrl.text.trim());
    ref.invalidate(githubPRsProvider);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('GitHub Personal Access Token Saved.'),
          backgroundColor: KairoTheme.surfaceElevated,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _saveGroqApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('groq_api_key', _groqApiKeyCtrl.text.trim());
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Groq AI API Key Saved.'),
          backgroundColor: KairoTheme.surfaceElevated,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _saveMsTodoToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('ms_todo_token', _msTodoTokenCtrl.text.trim());
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Microsoft To Do Token Saved.'),
          backgroundColor: KairoTheme.surfaceElevated,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _exportBackup(bool isMarkdown) async {
    setState(() => _isExporting = true);
    try {
      final exportService = BackupExportService(isar);
      final file = isMarkdown
          ? await exportService.exportSystemDossierMarkdown()
          : await exportService.exportFullSystemJson();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Export saved: ${file.path.split('/').last}"),
            backgroundColor: KairoTheme.surfaceElevated,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Export failed: $e"),
            backgroundColor: KairoTheme.warning,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final timeString = DateFormat('HH:mm:ss').format(_now);
    final dateString = DateFormat('EEEE, MMMM d, yyyy').format(_now);
    final user = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: KairoTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: KairoTheme.textPrimary, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "OPERATOR DOSSIER & CONFIG",
          style: TextStyle(
            letterSpacing: 1.5,
            fontSize: 12,
            fontWeight: FontWeight.w900,
            fontFamily: 'monospace',
            color: KairoTheme.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(KairoTheme.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Digital Clock & Epoch Banner
            KairoCard(
              child: Center(
                child: Column(
                  children: [
                    Text(
                      timeString,
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                        fontFamily: 'monospace',
                        color: KairoTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: KairoTheme.xs),
                    Text(
                      dateString.toUpperCase(),
                      style: const TextStyle(
                        color: KairoTheme.textMuted,
                        letterSpacing: 1.5,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: KairoTheme.lg),

            // 2. Operator Identity & Core Demographics
            KairoSectionHeader(
              title: "OPERATOR DEMOGRAPHICS",
              padding: const EdgeInsets.only(bottom: KairoTheme.sm),
            ),
            KairoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextInput(
                    label: "CORE OPERATOR IDENTITY",
                    hint: "e.g. Systems Architect & Relentless Builder",
                    controller: _identityCtrl,
                  ),
                  const SizedBox(height: KairoTheme.md),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextInput(
                          label: "BASE HOURLY RATE (\$)",
                          hint: "e.g. 150",
                          controller: _rateCtrl,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: KairoTheme.md),
                      Expanded(
                        child: _buildTextInput(
                          label: "AGE (CHRONO)",
                          hint: "e.g. 24",
                          controller: _ageCtrl,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: KairoTheme.lg),
                  KairoButton(
                    text: "LOCK DEMOGRAPHICS",
                    isPrimary: true,
                    onPressed: _saveDemographics,
                  ),
                ],
              ),
            ),
            const SizedBox(height: KairoTheme.lg),

            // 3. Telemetry Integrations & Device Access
            KairoSectionHeader(
              title: "TELEMETRY & HARDWARE PERMISSIONS",
              padding: const EdgeInsets.only(bottom: KairoTheme.sm),
            ),
            KairoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Android Screen Time (Usage Access)
                  _buildPermissionTile(
                    title: "ANDROID USAGE STATS",
                    subtitle: "Observed device screen time & displacement tracking",
                    isGranted: _hasUsagePerm,
                    onAction: () async {
                      await WellbeingService.requestUsagePermission();
                      final perm = await WellbeingService.checkUsagePermission();
                      setState(() => _hasUsagePerm = perm);
                    },
                  ),
                  const KairoDivider(margin: EdgeInsets.symmetric(vertical: KairoTheme.md)),

                  // Android DND Policy
                  _buildPermissionTile(
                    title: "DO NOT DISTURB ACCESS",
                    subtitle: "Auto-suppress notification interrupts during Peak focus",
                    isGranted: _hasDndPerm,
                    onAction: () async {
                      await WellbeingService.requestDndPermission();
                      final perm = await WellbeingService.checkDndPermission();
                      setState(() => _hasDndPerm = perm);
                    },
                  ),
                  const KairoDivider(margin: EdgeInsets.symmetric(vertical: KairoTheme.md)),

                  // Google Calendar & Tasks Sync
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "GOOGLE CALENDAR & TASKS",
                              style: TextStyle(
                                color: KairoTheme.textPrimary,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'monospace',
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              user != null ? "Connected: ${user.email}" : "Sign in to sync calendar load",
                              style: const TextStyle(color: KairoTheme.textMuted, fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                      KairoButton(
                        text: user != null ? "DISCONNECT" : "CONNECT",
                        onPressed: () {
                          if (user == null) {
                            ref.read(authProvider.notifier).login();
                          } else {
                            ref.read(authProvider.notifier).logout();
                          }
                        },
                      ),
                    ],
                  ),
                  const KairoDivider(margin: EdgeInsets.symmetric(vertical: KairoTheme.md)),

                  // WakaTime API Key
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "WAKATIME API KEY",
                            style: TextStyle(
                              color: KairoTheme.textPrimary,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'monospace',
                            ),
                          ),
                          KairoStatus(label: "IDE TELEMETRY", type: KairoStatusType.observed),
                        ],
                      ),
                      const SizedBox(height: KairoTheme.xs),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _wakatimeKeyCtrl,
                              obscureText: true,
                              style: const TextStyle(color: KairoTheme.textPrimary, fontSize: 12, fontFamily: 'monospace'),
                              decoration: InputDecoration(
                                hintText: "waka_xxxxxxxx-xxxx...",
                                hintStyle: const TextStyle(color: KairoTheme.textFaint),
                                filled: true,
                                fillColor: KairoTheme.surfaceElevated,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(KairoTheme.radiusSm),
                                  borderSide: const BorderSide(color: KairoTheme.border),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: KairoTheme.sm),
                          KairoButton(text: "SAVE", onPressed: _saveWakaTimeKey),
                        ],
                      ),
                    ],
                  ),
                  const KairoDivider(margin: EdgeInsets.symmetric(vertical: KairoTheme.md)),

                  // GitHub Personal Access Token
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "GITHUB PERSONAL ACCESS TOKEN",
                            style: TextStyle(
                              color: KairoTheme.textPrimary,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'monospace',
                            ),
                          ),
                          KairoStatus(label: "PRS & WORK", type: KairoStatusType.observed),
                        ],
                      ),
                      const SizedBox(height: KairoTheme.xs),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _githubTokenCtrl,
                              obscureText: true,
                              style: const TextStyle(color: KairoTheme.textPrimary, fontSize: 12, fontFamily: 'monospace'),
                              decoration: InputDecoration(
                                hintText: "ghp_xxxxxxxxxxxx...",
                                hintStyle: const TextStyle(color: KairoTheme.textFaint),
                                filled: true,
                                fillColor: KairoTheme.surfaceElevated,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(KairoTheme.radiusSm),
                                  borderSide: const BorderSide(color: KairoTheme.border),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: KairoTheme.sm),
                          KairoButton(text: "SAVE", onPressed: _saveGitHubToken),
                        ],
                      ),
                    ],
                  ),
                  const KairoDivider(margin: EdgeInsets.symmetric(vertical: KairoTheme.md)),

                  // Groq AI API Key
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "GROQ AI INFERENCE API KEY",
                              style: TextStyle(
                                color: KairoTheme.textPrimary,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'monospace',
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          KairoStatus(label: "AI AUTOPSY", type: KairoStatusType.recommended),
                        ],
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        "Used for weekly autopsy synthesis, pattern recognition, and root cause diagnosis via fast inference (Llama 3.3 / Qwen 2.5). Zero data sold.",
                        style: TextStyle(color: KairoTheme.textMuted, fontSize: 10, height: 1.3),
                      ),
                      const SizedBox(height: KairoTheme.xs),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _groqApiKeyCtrl,
                              obscureText: true,
                              style: const TextStyle(color: KairoTheme.textPrimary, fontSize: 12, fontFamily: 'monospace'),
                              decoration: InputDecoration(
                                hintText: "gsk_xxxxxxxxxxxx...",
                                hintStyle: const TextStyle(color: KairoTheme.textFaint),
                                filled: true,
                                fillColor: KairoTheme.surfaceElevated,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(KairoTheme.radiusSm),
                                  borderSide: const BorderSide(color: KairoTheme.border),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: KairoTheme.sm),
                          KairoButton(text: "SAVE", onPressed: _saveGroqApiKey),
                        ],
                      ),
                    ],
                  ),
                  const KairoDivider(margin: EdgeInsets.symmetric(vertical: KairoTheme.md)),

                  // Microsoft To Do Integration
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "MICROSOFT TO DO (NEEDS INBOX)",
                              style: TextStyle(
                                color: KairoTheme.textPrimary,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'monospace',
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          KairoStatus(label: "K.A.I.R.O. — NEEDS", type: KairoStatusType.observed),
                        ],
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        "Optional external capture inbox. Ingests items from dedicated 'K.A.I.R.O. — NEEDS' list into Needs. Zero automatic tasks created.",
                        style: TextStyle(color: KairoTheme.textMuted, fontSize: 10, height: 1.3),
                      ),
                      const SizedBox(height: KairoTheme.xs),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _msTodoTokenCtrl,
                              obscureText: true,
                              style: const TextStyle(color: KairoTheme.textPrimary, fontSize: 12, fontFamily: 'monospace'),
                              decoration: InputDecoration(
                                hintText: "Bearer token or Graph PAT...",
                                hintStyle: const TextStyle(color: KairoTheme.textFaint),
                                filled: true,
                                fillColor: KairoTheme.surfaceElevated,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(KairoTheme.radiusSm),
                                  borderSide: const BorderSide(color: KairoTheme.border),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: KairoTheme.sm),
                          KairoButton(text: "SAVE", onPressed: _saveMsTodoToken),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: KairoTheme.lg),

            // 4. Operator Extensions
            const KairoSectionHeader(
              title: "OPERATOR EXTENSIONS",
              padding: EdgeInsets.only(bottom: KairoTheme.sm),
            ),
            KairoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Secondary cognitive-load reducers, architectural control plane, and decision systems.",
                    style: TextStyle(color: KairoTheme.textSecondary, fontSize: 12, height: 1.4),
                  ),
                  const SizedBox(height: KairoTheme.md),
                  Row(
                    children: [
                      Expanded(
                        child: KairoButton(
                          text: "PROJECTS & DNA",
                          icon: Icons.hub_outlined,
                          onPressed: () {
                            Navigator.push(context, SmoothPageRoute(page: const ProjectsPage()));
                          },
                        ),
                      ),
                      const SizedBox(width: KairoTheme.sm),
                      Expanded(
                        child: KairoButton(
                          text: "NEEDS MATRIX",
                          icon: Icons.inventory_2_outlined,
                          onPressed: () {
                            Navigator.push(context, SmoothPageRoute(page: const NeedsPage()));
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: KairoTheme.sm),
                  Row(
                    children: [
                      Expanded(
                        child: KairoButton(
                          text: "CAPSULE WARDROBE",
                          icon: Icons.checkroom_outlined,
                          onPressed: () {
                            Navigator.push(context, SmoothPageRoute(page: const WardrobePage()));
                          },
                        ),
                      ),
                      const SizedBox(width: KairoTheme.sm),
                      Expanded(
                        child: KairoButton(
                          text: "WORKOUT TRACKER",
                          icon: Icons.fitness_center_rounded,
                          onPressed: () {
                            Navigator.push(context, SmoothPageRoute(page: const WorkoutPage()));
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: KairoTheme.lg),

            // 4. Sovereign Data Backups & Dossier Export
            KairoSectionHeader(
              title: "SOVEREIGN DATA EXPORT",
              padding: const EdgeInsets.only(bottom: KairoTheme.sm),
            ),
            KairoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "All data lives exclusively in local Isar storage on this device. Export full snapshots in standard open formats anytime.",
                    style: TextStyle(color: KairoTheme.textSecondary, fontSize: 12, height: 1.4),
                  ),
                  const SizedBox(height: KairoTheme.md),
                  Row(
                    children: [
                      Expanded(
                        child: KairoButton(
                          text: _isExporting ? "EXPORTING..." : "EXPORT JSON",
                          icon: Icons.data_object_rounded,
                          onPressed: _isExporting ? () {} : () => _exportBackup(false),
                        ),
                      ),
                      const SizedBox(width: KairoTheme.sm),
                      Expanded(
                        child: KairoButton(
                          text: _isExporting ? "EXPORTING..." : "EXPORT MARKDOWN",
                          icon: Icons.article_outlined,
                          onPressed: _isExporting ? () {} : () => _exportBackup(true),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildTextInput({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: KairoTheme.textMuted,
            fontSize: 9,
            letterSpacing: 1.2,
            fontFamily: 'monospace',
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: KairoTheme.xs),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(color: KairoTheme.textPrimary, fontSize: 13, fontWeight: FontWeight.w700),
          decoration: InputDecoration(
            hintText: hint,
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
      ],
    );
  }

  Widget _buildPermissionTile({
    required String title,
    required String subtitle,
    required bool isGranted,
    required VoidCallback onAction,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: KairoTheme.textPrimary,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'monospace',
                ),
              ),
              const SizedBox(height: 2),
              Text(subtitle, style: const TextStyle(color: KairoTheme.textMuted, fontSize: 10)),
            ],
          ),
        ),
        const SizedBox(width: KairoTheme.sm),
        isGranted
            ? const KairoStatus(label: "GRANTED", type: KairoStatusType.success)
            : KairoButton(text: "GRANT", onPressed: onAction),
      ],
    );
  }
}
