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

    return Scaffold(
      backgroundColor: AppTheme.background,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        onPressed: () => _showQuickActionSheet(context),
        child: const Icon(Icons.bolt_rounded, size: 24, color: AppTheme.warning),
      ),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // TOP HUD BAR
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Row(
                  children: [
                    // System status pill
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF141414),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Color(0xFF00E676),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'SYSTEM ONLINE',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                              fontFamily: 'monospace',
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    // Sleek Action Group
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF141414),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildNavIcon(Icons.account_tree_outlined, 'Memory Graph', () {
                            Navigator.push(
                              context,
                              SmoothPageRoute(
                                page: const MemoryGraphView(
                                  initialCollection: 'Global',
                                  initialId: 0,
                                  initialTitle: 'Global Hub',
                                ),
                              ),
                            );
                          }),
                          _buildNavIcon(Icons.checkroom_outlined, 'Wardrobe Check', () {
                            Navigator.push(context, SmoothPageRoute(page: const WardrobePage()));
                          }),
                          _buildNavIcon(Icons.auto_stories_outlined, 'Daily Shloka', () {
                            DailyShlokaDialog.showOnDemand(context);
                          }, color: Colors.amber),
                          _buildNavIcon(Icons.settings_outlined, 'System Config', () {
                            Navigator.push(context, SmoothPageRoute(page: const SettingsPage()));
                          }),
                          _buildNavIcon(Icons.person_outline_rounded, 'System Profile', () {
                            Navigator.push(context, SmoothPageRoute(page: const ProfilePage()));
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // MAIN CONTENT BODY
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 8),

                  // HUD QUICK STATUS ROW (Autopsy & Shloka side-by-side)
                  Row(
                    children: [
                      Expanded(
                        child: _buildHudTile(
                          icon: Icons.gavel_rounded,
                          iconColor: Colors.amber,
                          title: "WEEKLY AUTOPSY",
                          subtitle: "Systemic 7-Day Critique",
                          onTap: () => Navigator.push(context, SmoothPageRoute(page: const WeeklyAutopsyPage())),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildHudTile(
                          icon: Icons.auto_stories_rounded,
                          iconColor: const Color(0xFF4DB6AC),
                          title: "DAILY SHLOKA",
                          subtitle: "Gita Wisdom Check",
                          onTap: () => DailyShlokaDialog.showOnDemand(context),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // 168-HOUR BANDWIDTH CARD (Sleek Linear/Notion style)
                  _build168HourCard(context, ref),

                  const SizedBox(height: 24),

                  // PRIMARY WORKSPACE: THE OBJECTIVE
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFF141414),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "PRIMARY ANCHOR • TODAY'S OBJECTIVE",
                              style: TextStyle(
                                color: AppTheme.warning,
                                fontSize: 10,
                                fontFamily: 'monospace',
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                            Icon(Icons.adjust_rounded, size: 14, color: AppTheme.warning.withValues(alpha: 0.7)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _objectiveController,
                          onChanged: (val) {
                            ref.read(objectiveProvider.notifier).updateObjective(val);
                          },
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.3,
                            height: 1.3,
                          ),
                          decoration: InputDecoration(
                            hintText: "Define your single non-negotiable objective today...",
                            hintStyle: TextStyle(
                              color: Colors.white.withValues(alpha: 0.25),
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // WORKSPACE: TERMINAL SCRATCHPAD
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFF111111),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "TERMINAL SCRATCHPAD • BRAIN DUMP",
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 10,
                                fontFamily: 'monospace',
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                            if (scratchpadState is AsyncLoading)
                              const SizedBox(
                                width: 12,
                                height: 12,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white38),
                              )
                            else
                              const Icon(Icons.code_rounded, size: 14, color: Colors.white38),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          constraints: const BoxConstraints(minHeight: 110),
                          child: TextField(
                            controller: _scratchpadController,
                            onChanged: (val) {
                              ref.read(commandCenterProvider.notifier).updateNotes(val);
                            },
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              height: 1.6,
                              fontFamily: 'monospace',
                            ),
                            decoration: InputDecoration(
                              hintText: "// Quick notes, draft assumptions, architecture scribbles...",
                              hintStyle: TextStyle(
                                color: Colors.white.withValues(alpha: 0.2),
                                fontFamily: 'monospace',
                                fontSize: 13,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // METRICS HUD (2-Column Grid for Deep Work & Burn Rate)
                  const Text(
                    "REAL-TIME OUTPUT & BURN RATE",
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 10,
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: wakatimeState.when(
                          data: (hours) => _buildMetricCard(
                            Icons.terminal_rounded,
                            "WakaTime Today",
                            hours,
                            const Color(0xFF64B5F6),
                          ),
                          loading: () => _buildLoadingCard("WakaTime Today"),
                          error: (err, stack) => _buildMetricCard(Icons.error_outline, "WakaTime Today", "Offline", Colors.redAccent),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: financeState.when(
                          data: (metrics) => _buildMetricCard(
                            Icons.attach_money_rounded,
                            "Today's Expense",
                            "\$${metrics.todayExpense.toStringAsFixed(2)}",
                            const Color(0xFF81C784),
                          ),
                          loading: () => _buildLoadingCard("Today's Expense"),
                          error: (err, stack) => _buildMetricCard(Icons.account_balance_wallet_outlined, "Today's Expense", "N/A", Colors.white38),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ACTIVE PULL REQUESTS DECK
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "ACTIVE PULL REQUESTS",
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 10,
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      Icon(Icons.merge_type_rounded, size: 14, color: Colors.white.withValues(alpha: 0.3)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  githubState.when(
                    data: (prs) {
                      if (prs.isEmpty) {
                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF141414),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            "Zero open PRs • All execution pipelines clear",
                            style: TextStyle(color: Colors.white38, fontSize: 12, fontFamily: 'monospace'),
                          ),
                        );
                      }
                      return Column(
                        children: prs.map((pr) {
                          final timeAgo = DateTime.now().difference(pr.createdAt).inDays;
                          final timeString = timeAgo == 0 ? "today" : "$timeAgo days ago";
                          return _buildGitHubTile(pr.repoName, pr.title, "#${pr.number} • Opened $timeString");
                        }).toList(),
                      );
                    },
                    loading: () => const Center(child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white24))),
                    error: (err, stack) => Text("Error loading PRs: ${err.toString().replaceAll('Exception: ', '')}", style: const TextStyle(color: Colors.redAccent, fontSize: 12)),
                  ),

                  const SizedBox(height: 110), // Bottom padding for dock
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, String tooltip, VoidCallback onTap, {Color color = Colors.white54}) {
    return Material(
      color: Colors.transparent,
      child: Tooltip(
        message: tooltip,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Icon(icon, size: 16, color: color),
          ),
        ),
      ),
    );
  }

  Widget _buildHudTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF141414),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.white54, fontSize: 10),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(IconData icon, String title, String value, Color accentColor) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: accentColor),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: -0.5),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingCard(String title) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.w600)),
          const SizedBox(height: 14),
          const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white24)),
        ],
      ),
    );
  }

  Widget _buildGitHubTile(String repo, String title, String meta) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(Icons.call_merge_rounded, color: Color(0xFF00E676), size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$repo / $title",
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  meta,
                  style: const TextStyle(color: Colors.white38, fontSize: 10, fontFamily: 'monospace'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _build168HourCard(BuildContext context, WidgetRef ref) {
    final auditAsync = ref.watch(timeAuditProvider);

    return auditAsync.when(
      loading: () => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF141414),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
        ),
        alignment: Alignment.center,
        child: const CircularProgressIndicator(color: Colors.white24, strokeWidth: 2),
      ),
      error: (e, st) => const SizedBox.shrink(),
      data: (audit) {
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF141414),
            border: Border.all(
              color: _is168Expanded ? AppTheme.warning.withValues(alpha: 0.5) : Colors.white.withValues(alpha: 0.08),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header & Quick Segmented Bar
              InkWell(
                onTap: () => setState(() => _is168Expanded = !_is168Expanded),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.timer_outlined, color: AppTheme.warning, size: 16),
                              const SizedBox(width: 8),
                              Text(
                                "168h WEEKLY LEDGER • ${audit.freeHours.toStringAsFixed(1)}h FREE",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontFamily: 'monospace',
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            _is168Expanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                            color: Colors.white54,
                            size: 18,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Sleek Segmented bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: SizedBox(
                          height: 8,
                          child: Row(
                            children: [
                              Expanded(
                                flex: (audit.sleepHours * 10).toInt().clamp(1, 1680),
                                child: Container(color: const Color(0xFF1E88E5)),
                              ),
                              Expanded(
                                flex: (audit.calendarHours * 10).toInt().clamp(1, 1680),
                                child: Container(color: const Color(0xFF757575)),
                              ),
                              Expanded(
                                flex: (audit.peakWorkHours * 10).toInt().clamp(1, 1680),
                                child: Container(color: AppTheme.warning),
                              ),
                              if (audit.customRecurringHours > 0)
                                Expanded(
                                  flex: (audit.customRecurringHours * 10).toInt().clamp(1, 1680),
                                  child: Container(color: const Color(0xFF8E24AA)),
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
                    ],
                  ),
                ),
              ),

              // Expanded Breakdown & Action Buttons
              if (_is168Expanded) ...[
                const Divider(color: Color(0xFF222222), height: 1),
                Padding(
                  padding: const EdgeInsets.all(16),
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
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 14,
                        runSpacing: 8,
                        children: [
                          _buildLegendItem("Sleep", "${audit.sleepHours.toStringAsFixed(0)}h", const Color(0xFF1E88E5)),
                          _buildLegendItem("Calendar", "${audit.calendarHours.toStringAsFixed(1)}h", const Color(0xFF757575)),
                          _buildLegendItem("Peak Work", "${audit.peakWorkHours.toStringAsFixed(1)}h", AppTheme.warning),
                          if (audit.customRecurringHours > 0)
                            _buildLegendItem("Recurring/Classes", "${audit.customRecurringHours.toStringAsFixed(1)}h", const Color(0xFF8E24AA)),
                          if (audit.urgentHours > 0)
                            _buildLegendItem("Urgent", "${audit.urgentHours.toStringAsFixed(1)}h", const Color(0xFFE53935)),
                          _buildLegendItem("Free", "${audit.freeHours.toStringAsFixed(1)}h", const Color(0xFF43A047)),
                        ],
                      ),
                      if (audit.customRecurringBlocks.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        const Text(
                          "FIXED RECURRING COMMITMENTS (CLASSES / LABS / COMMUTE / GYM):",
                          style: TextStyle(color: Colors.white54, fontSize: 9, fontFamily: 'monospace', fontWeight: FontWeight.bold, letterSpacing: 1),
                        ),
                        const SizedBox(height: 8),
                        ...audit.customRecurringBlocks.map((block) => Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.03),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Color(block.colorHex).withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(color: Color(block.colorHex), shape: BoxShape.circle),
                                    ),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        "${block.title} (${block.category})",
                                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("${block.hoursPerWeek.toStringAsFixed(1)}h/wk", style: TextStyle(color: Color(block.colorHex), fontSize: 11, fontWeight: FontWeight.bold)),
                                  const SizedBox(width: 12),
                                  InkWell(
                                    onTap: () => _showCustomBlockModal(context, ref, existing: block),
                                    child: const Icon(Icons.edit_outlined, color: Colors.white54, size: 14),
                                  ),
                                  const SizedBox(width: 10),
                                  InkWell(
                                    onTap: () async {
                                      await TimeAuditService().deleteCustomRecurringBlock(block.id);
                                      ref.invalidate(timeAuditProvider);
                                    },
                                    child: const Icon(Icons.delete_outline_rounded, color: Color(0xFFE53935), size: 14),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )),
                      ],
                      const SizedBox(height: 16),
                      // Sleek Action Button Row
                      Row(
                        children: [
                          Expanded(
                            child: _buildActionBtn(
                              label: "+ RECURRING",
                              icon: Icons.class_outlined,
                              color: const Color(0xFF8E24AA),
                              onTap: () => _showCustomBlockModal(context, ref),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildActionBtn(
                              label: "+ URGENT",
                              icon: Icons.notification_important_outlined,
                              color: const Color(0xFFE53935),
                              onTap: () => _showUrgentOverrideModal(context, ref),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildActionBtn(
                              label: "ADAPT ALARM",
                              icon: Icons.alarm_on_outlined,
                              color: AppTheme.warning,
                              onTap: () async {
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

  Widget _buildActionBtn({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: color, size: 14),
      label: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.5),
        ),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        side: BorderSide(color: color.withValues(alpha: 0.4)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildLegendItem(String label, String val, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text("$label: $val", style: const TextStyle(color: Colors.white70, fontSize: 11, fontFamily: 'monospace')),
      ],
    );
  }

  void _showUrgentOverrideModal(BuildContext context, WidgetRef ref) {
    final titleCtrl = TextEditingController();
    final hoursCtrl = TextEditingController(text: "2.0");

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF161616),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Text(
          "LOG URGENT OVERRIDE",
          style: TextStyle(color: Colors.white, fontSize: 13, fontFamily: 'monospace', fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: const InputDecoration(
                labelText: "Task / Emergency Title",
                labelStyle: TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: hoursCtrl,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: "Hours Required",
                labelStyle: TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("CANCEL", style: TextStyle(color: Colors.white54, fontSize: 11)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE53935), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            onPressed: () async {
              final title = titleCtrl.text.trim().isEmpty ? "Urgent Crisis" : titleCtrl.text.trim();
              final hours = double.tryParse(hoursCtrl.text.trim()) ?? 2.0;
              await TimeAuditService().addUrgentOverride(title, hours);
              ref.invalidate(timeAuditProvider);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text("DEDUCT BANDWIDTH", style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showCustomBlockModal(BuildContext context, WidgetRef ref, {CustomRecurringBlock? existing}) {
    final titleCtrl = TextEditingController(text: existing?.title ?? "");
    final hoursCtrl = TextEditingController(text: existing != null ? existing.hoursPerWeek.toString() : "5.0");
    String category = existing?.category ?? 'Classes / Lectures';
    int colorHex = existing?.colorHex ?? 0xFF8E24AA;

    final categories = ['Classes / Lectures', 'Physical / Training', 'Commute', 'Admin / Chores', 'Other'];
    final colors = [0xFF8E24AA, 0xFF00ACC1, 0xFFFB8C00, 0xFF43A047, 0xFFE53935, 0xFF1E88E5];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFF161616),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: Text(
            existing != null ? "EDIT RECURRING COMMITMENT" : "LOG RECURRING COMMITMENT",
            style: const TextStyle(color: Colors.white, fontSize: 13, fontFamily: 'monospace', fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: titleCtrl,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: const InputDecoration(
                    labelText: "Commitment Name (e.g. CS101 Lecture, Gym)",
                    labelStyle: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: hoursCtrl,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: "Total Hours Per Week",
                    labelStyle: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ),
                const SizedBox(height: 16),
                const Text("Category:", style: TextStyle(color: Colors.white70, fontSize: 11)),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  initialValue: category,
                  dropdownColor: const Color(0xFF242424),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    border: OutlineInputBorder(),
                  ),
                  items: categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
                  onChanged: (val) {
                    if (val != null) setDialogState(() => category = val);
                  },
                ),
                const SizedBox(height: 16),
                const Text("Color Tag:", style: TextStyle(color: Colors.white70, fontSize: 11)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: colors.map((c) => InkWell(
                    onTap: () => setDialogState(() => colorHex = c),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Color(c),
                        shape: BoxShape.circle,
                        border: Border.all(color: colorHex == c ? Colors.white : Colors.transparent, width: 2.5),
                      ),
                    ),
                  )).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("CANCEL", style: TextStyle(color: Colors.white54, fontSize: 11)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Color(colorHex), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              onPressed: () async {
                final title = titleCtrl.text.trim().isEmpty ? "Recurring Block" : titleCtrl.text.trim();
                final hours = double.tryParse(hoursCtrl.text.trim()) ?? 5.0;
                if (existing != null) {
                  await TimeAuditService().updateCustomRecurringBlock(existing.id, title, hours, category, colorHex);
                } else {
                  await TimeAuditService().addCustomRecurringBlock(title, hours, category, colorHex);
                }
                ref.invalidate(timeAuditProvider);
                if (ctx.mounted) Navigator.pop(ctx);
              },
              child: Text(
                existing != null ? "UPDATE LEDGER" : "LOCK INTO LEDGER",
                style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showQuickActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Color(0xFF141414),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            border: Border(top: BorderSide(color: Color(0xFF282828))),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'QUICK ACTION COMMAND PALETTE',
                      style: TextStyle(color: Colors.white54, fontSize: 10, fontFamily: 'monospace', letterSpacing: 1.5, fontWeight: FontWeight.bold),
                    ),
                    InkWell(
                      onTap: () => Navigator.pop(ctx),
                      child: const Icon(Icons.close_rounded, size: 18, color: Colors.white38),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildPaletteOption(
                  icon: Icons.flash_off_rounded,
                  iconColor: const Color(0xFFE53935),
                  title: 'Log Energy Leak',
                  subtitle: 'Capture cognitive friction or physical energy drain right now',
                  onTap: () async {
                    await ref.read(energyEconomyProvider.notifier).logEnergyLeak();
                    if (ctx.mounted) Navigator.pop(ctx);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Leak captured. Categorize tonight.'), backgroundColor: Color(0xFF2A2A2A), behavior: SnackBarBehavior.floating),
                      );
                    }
                  },
                ),
                const SizedBox(height: 10),
                _buildPaletteOption(
                  icon: Icons.favorite_border_rounded,
                  iconColor: const Color(0xFFBA68C8),
                  title: 'Quick Somatic Scan',
                  subtitle: 'Record instant muscle tension & stress baseline checkpoint',
                  onTap: () async {
                    await ref.read(psychosomaticProvider.notifier).saveScan(
                          muscleTension: 80,
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
                        const SnackBar(content: Text('Symptom captured.'), backgroundColor: Color(0xFF2A2A2A), behavior: SnackBarBehavior.floating),
                      );
                    }
                  },
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPaletteOption({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 3),
                  Text(subtitle, style: const TextStyle(color: Colors.white54, fontSize: 11)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white24, size: 14),
          ],
        ),
      ),
    );
  }
}
