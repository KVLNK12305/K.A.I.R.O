import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/command_center_provider.dart';
import 'providers/objective_provider.dart';
import 'providers/finance_provider.dart';
import 'providers/github_provider.dart';
import 'providers/wakatime_provider.dart';
import '../energy_economy/energy_provider.dart';
import '../energy_economy/providers/time_audit_provider.dart';
import '../../core/services/time_audit_service.dart';
import '../../core/services/alarm_service.dart';
import '../../core/services/google_api_service.dart';
import '../psychosomatic/psychosomatic_provider.dart';
import '../profile/profile_page.dart';
import '../wardrobe/wardrobe_page.dart';
import 'settings_page.dart';
import 'memory_graph_view.dart';
import 'weekly_autopsy_page.dart';
import '../spirituality/daily_shloka_dialog.dart';
import '../../Nav/smooth_page_route.dart';
import '../../core/theme/app_theme.dart';

class CommandCenterPage extends ConsumerStatefulWidget {
  const CommandCenterPage({super.key});

  @override
  ConsumerState<CommandCenterPage> createState() => _CommandCenterPageState();
}

class _CommandCenterPageState extends ConsumerState<CommandCenterPage> {
  late TextEditingController _scratchpadController;
  late TextEditingController _objectiveController;
  bool _scratchpadSynced = false;
  bool _objectiveSynced = false;
  bool _is168Expanded = false;

  @override
  void initState() {
    super.initState();
    _scratchpadController = TextEditingController();
    _objectiveController = TextEditingController();
  }

  @override
  void dispose() {
    _scratchpadController.dispose();
    _objectiveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scratchpadState = ref.watch(commandCenterProvider);
    ref.watch(objectiveProvider);
    final githubState = ref.watch(githubPRsProvider);
    final wakatimeState = ref.watch(wakatimeProvider);
    final financeState = ref.watch(financeMetricsProvider);

    ref.listen(commandCenterProvider, (previous, current) {
      if (current is AsyncData<String> && !_scratchpadSynced) {
        _scratchpadController.text = current.value;
        _scratchpadSynced = true;
      }
    });

    ref.listen(objectiveProvider, (previous, current) {
      if (current is AsyncData<String> && !_objectiveSynced) {
        _objectiveController.text = current.value;
        _objectiveSynced = true;
      }
    });

    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth < 360 ? 16.0 : 24.0;

    return Scaffold(
      backgroundColor: AppTheme.background,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 85.0,
        ), // Clear the bottom navigation dock
        child: FloatingActionButton(
          backgroundColor: Colors.white10,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          onPressed: () => _showDropOverlay(context),
          child: const Icon(Icons.add, color: Colors.white54),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: horizontalPadding,
            right: horizontalPadding,
            top: 16.0,
            bottom: 110.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // System Status Header
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.greenAccent,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'K.A.I.R.O. SYSTEM ONLINE',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 10,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w700,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 4),
                  SizedBox(
                    width: 36,
                    height: 36,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(
                        Icons.account_tree,
                        color: Colors.white38,
                        size: 18,
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        SmoothPageRoute(
                          page: const MemoryGraphView(
                            initialCollection: 'Global',
                            initialId: 0,
                            initialTitle: 'Global Hub',
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 36,
                    height: 36,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(
                        Icons.settings,
                        color: Colors.white38,
                        size: 18,
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        SmoothPageRoute(page: const SettingsPage()),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 36,
                    height: 36,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(
                        Icons.person,
                        color: Colors.white38,
                        size: 18,
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        SmoothPageRoute(page: const ProfilePage()),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 36,
                    height: 36,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      tooltip: 'Bhagavad Gita Shloka of the Day',
                      icon: const Icon(
                        Icons.auto_stories_rounded,
                        color: Colors.amber,
                        size: 18,
                      ),
                      onPressed: () => DailyShlokaDialog.showOnDemand(context),
                    ),
                  ),
                  SizedBox(
                    width: 36,
                    height: 36,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(
                        Icons.checkroom,
                        color: Colors.white38,
                        size: 18,
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        SmoothPageRoute(page: const WardrobePage()),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // DAILY SHLOKA BANNER
              const DailyShlokaBanner(),
              const SizedBox(height: 16),

              // WEEKLY AUTOPSY BANNER
              _buildWeeklyAutopsyBanner(context),

              // 168-HOUR BANDWIDTH CARD
              _build168HourCard(context, ref),

              // THE OBJECTIVE — now persisted
              TextField(
                controller: _objectiveController,
                onChanged: (val) {
                  ref.read(objectiveProvider.notifier).updateObjective(val);
                },
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
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white24),
                      )
                    : TextField(
                        controller: _scratchpadController,
                        onChanged: (val) {
                          ref
                              .read(commandCenterProvider.notifier)
                              .updateNotes(val);
                        },
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          height: 1.5,
                          fontFamily:
                              'monospace', // Gives it that terminal/markdown feel
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
                loading: () =>
                    const CircularProgressIndicator(color: Colors.white24),
                error: (err, stack) => Text(
                  "WakaTime Error: ${err.toString().replaceAll('Exception: ', '')}",
                  style: const TextStyle(color: Colors.redAccent, fontSize: 12),
                ),
              ),
              financeState.when(
                data: (metrics) => Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: _buildMetricItem(
                        Icons.attach_money,
                        "Burn Rate Today",
                        "\$${metrics.todayExpense.toStringAsFixed(2)}",
                      ),
                    ),
                    _buildMetricItem(
                      Icons.account_balance_wallet,
                      "Burn Rate This Month",
                      "\$${metrics.monthExpense.toStringAsFixed(2)}",
                    ),
                  ],
                ),
                loading: () => const SizedBox.shrink(),
                error: (err, stack) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: _buildMetricItem(
                    Icons.warning_amber_rounded,
                    "Finance data unavailable",
                    "—",
                  ),
                ),
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
                    return const Text(
                      "No active PRs. You're all caught up!",
                      style: TextStyle(color: Colors.white38, fontSize: 12),
                    );
                  }
                  return Column(
                    children: prs.map((pr) {
                      final timeAgo = DateTime.now()
                          .difference(pr.createdAt)
                          .inDays;
                      final timeString = timeAgo == 0
                          ? "today"
                          : "$timeAgo days ago";
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: _buildMockGitHubItem(
                          "${pr.repoName} / ${pr.title}",
                          "#${pr.number} • Opened $timeString",
                        ),
                      );
                    }).toList(),
                  );
                },
                loading: () =>
                    const CircularProgressIndicator(color: Colors.white24),
                error: (err, stack) => Text(
                  "Error loading PRs: ${err.toString().replaceAll('Exception: ', '')}",
                  style: const TextStyle(color: Colors.redAccent, fontSize: 12),
                ),
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
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
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
        children: [
          Icon(icon, color: Colors.purpleAccent, size: 16),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _showDropOverlay(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Color(0xEE0A0A0A), // Translucent black
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'QUICK CAPTURE',
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 10,
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(
                        0xFFCC2222,
                      ).withValues(alpha: 0.1),
                      foregroundColor: const Color(0xFFCC2222),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(Icons.flash_off_rounded),
                    label: const Text(
                      'LOG ENERGY LEAK',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    onPressed: () async {
                      await ref
                          .read(energyEconomyProvider.notifier)
                          .logEnergyLeak();
                      if (ctx.mounted) Navigator.pop(ctx);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Leak captured. Categorize tonight.',
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Color(0xFF2A2A2A),
                            behavior: SnackBarBehavior.floating,
                            duration: Duration(seconds: 3),
                          ),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(
                        0xFF7B5CFA,
                      ).withValues(alpha: 0.1),
                      foregroundColor: const Color(0xFF7B5CFA),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(Icons.favorite_border),
                    label: const Text(
                      'LOG SYMPTOM (QUICK)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    onPressed: () async {
                      await ref
                          .read(psychosomaticProvider.notifier)
                          .saveScan(
                            muscleTension:
                                80, // Default high values for quick capture
                            headStomachDisturbance: 80,
                            breathDepth: 20,
                            jawClench: 80,
                            posture: 20,
                            energyLevel: 30,
                            skinReaction: 50,
                            contextLabel: 'Quick Capture',
                          );
                      if (ctx.mounted) Navigator.pop(ctx);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Symptom captured.',
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Color(0xFF2A2A2A),
                            behavior: SnackBarBehavior.floating,
                            duration: Duration(seconds: 3),
                          ),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildWeeklyAutopsyBanner(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(context, SmoothPageRoute(page: const WeeklyAutopsyPage())),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF161616),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF2A2A2A)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF222222),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.gavel, color: Colors.amber, size: 20),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "WEEKLY AUTOPSY — SYSTEMIC CRITIQUE",
                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "Synthesize your 7-day Power Score & brutalist AI verdict.",
                    style: TextStyle(color: Colors.white54, fontSize: 11),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white38, size: 14),
          ],
        ),
      ),
    );
  }

  Widget _build168HourCard(BuildContext context, WidgetRef ref) {
    final auditAsync = ref.watch(timeAuditProvider);

    return auditAsync.when(
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: CircularProgressIndicator(color: Colors.white24, strokeWidth: 2),
        ),
      ),
      error: (e, st) => const SizedBox.shrink(),
      data: (audit) {
        return Container(
          margin: const EdgeInsets.only(bottom: 24),
          decoration: BoxDecoration(
            color: const Color(0xFF141414),
            border: Border.all(
              color: _is168Expanded
                  ? AppTheme.warning.withValues(alpha: 0.5)
                  : AppTheme.border,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () => setState(() => _is168Expanded = !_is168Expanded),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(
                              Icons.timer_outlined,
                              color: AppTheme.warning,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                "168h WEEKLY LEDGER • ${audit.freeHours.toStringAsFixed(1)}h FREE",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        _is168Expanded ? Icons.expand_less : Icons.expand_more,
                        color: Colors.white54,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
              if (_is168Expanded) ...[
                const Divider(color: AppTheme.border, height: 1),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        audit.brutalAssessment,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          height: 1.4,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Segmented bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: SizedBox(
                          height: 12,
                          child: Row(
                            children: [
                              Expanded(
                                flex: (audit.sleepHours * 10).toInt().clamp(1, 1680),
                                child: Container(color: const Color(0xFF1E88E5)),
                              ),
                              Expanded(
                                flex: (audit.calendarHours * 10).toInt().clamp(1, 1680),
                                child: Container(color: Colors.grey.shade700),
                              ),
                              Expanded(
                                flex: (audit.peakWorkHours * 10).toInt().clamp(1, 1680),
                                child: Container(color: AppTheme.warning),
                              ),
                              if (audit.urgentHours > 0)
                                Expanded(
                                  flex: (audit.urgentHours * 10).toInt().clamp(1, 1680),
                                  child: Container(color: const Color(0xFFE53935)),
                                ),
                              Expanded(
                                flex: (audit.freeHours * 10).toInt().clamp(1, 1680),
                                child: Container(color: const Color(0xFF43A047)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 12,
                        runSpacing: 8,
                        children: [
                          _buildLegendItem("Sleep", "${audit.sleepHours.toStringAsFixed(0)}h", const Color(0xFF1E88E5)),
                          _buildLegendItem("Calendar", "${audit.calendarHours.toStringAsFixed(1)}h", Colors.grey.shade700),
                          _buildLegendItem("Peak Work", "${audit.peakWorkHours.toStringAsFixed(1)}h", AppTheme.warning),
                          if (audit.urgentHours > 0)
                            _buildLegendItem("Urgent", "${audit.urgentHours.toStringAsFixed(1)}h", const Color(0xFFE53935)),
                          _buildLegendItem("Free", "${audit.freeHours.toStringAsFixed(1)}h", const Color(0xFF43A047)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => _showUrgentOverrideModal(context, ref),
                              icon: const Icon(Icons.notification_important, color: Color(0xFFE53935), size: 14),
                              label: const FittedBox(fit: BoxFit.scaleDown, child: Text("+ URGENT", style: TextStyle(color: Colors.white, fontSize: 10, letterSpacing: 0.5))),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                side: BorderSide(color: const Color(0xFFE53935).withValues(alpha: 0.4)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () async {
                                final events = await GoogleApiService().fetchTomorrowEvents();
                                final rec = await AlarmService().analyzeAndRecommendAlarm(events);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(rec.reason),
                                      backgroundColor: const Color(0xFF2A2A2A),
                                      action: SnackBarAction(
                                        label: "SET ALARM",
                                        textColor: AppTheme.warning,
                                        onPressed: () => AlarmService().setMorningAlarm(hour: rec.hour, minute: rec.minute),
                                      ),
                                    ),
                                  );
                                }
                              },
                              icon: const Icon(Icons.alarm_on, color: AppTheme.warning, size: 14),
                              label: const FittedBox(fit: BoxFit.scaleDown, child: Text("ADAPT ALARM", style: TextStyle(color: Colors.white, fontSize: 10, letterSpacing: 0.5))),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                side: BorderSide(color: AppTheme.warning.withValues(alpha: 0.4)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildLegendItem(String label, String val, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          "$label: $val",
          style: const TextStyle(color: Colors.white70, fontSize: 10),
        ),
      ],
    );
  }

  void _showUrgentOverrideModal(BuildContext context, WidgetRef ref) {
    final titleCtrl = TextEditingController();
    final hoursCtrl = TextEditingController(text: "2.0");

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF141414),
        title: const Text(
          "LOG URGENT OVERRIDE",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            letterSpacing: 1.5,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: const InputDecoration(
                labelText: "Task / Crisis Title",
                labelStyle: TextStyle(color: Colors.white54),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: hoursCtrl,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: "Hours Required",
                labelStyle: TextStyle(color: Colors.white54),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("CANCEL", style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE53935)),
            onPressed: () async {
              final title = titleCtrl.text.trim().isEmpty ? "Urgent Crisis" : titleCtrl.text.trim();
              final hours = double.tryParse(hoursCtrl.text.trim()) ?? 2.0;
              await TimeAuditService().addUrgentOverride(title, hours);
              ref.invalidate(timeAuditProvider);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text(
              "DEDUCT BANDWIDTH",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
