import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'bento_card.dart';
import 'package:isar/isar.dart';
import '../../../core/services/wakatime_service.dart';
import '../../../core/services/finance_service.dart';
import '../../../core/services/weekly_autopsy_service.dart';
import '../../../main.dart';
import '../../../core/models/task.dart';
import '../../../core/models/crucible_state.dart';
import '../../../core/theme/app_theme.dart';
import '../../crucible/crucible_page.dart';
import '../../profile/providers/profile_provider.dart';

class CostOfDelayWidget extends ConsumerStatefulWidget {
  const CostOfDelayWidget({super.key});

  @override
  ConsumerState<CostOfDelayWidget> createState() => _CostOfDelayWidgetState();
}

class _CostOfDelayWidgetState extends ConsumerState<CostOfDelayWidget> {
  PreMortemForecast? _preMortem;
  WakaTimeTelemetry? _wakaTime;
  CostOfDelayMetrics? _costOfDelay;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadTelemetry();
  }

  Future<void> _loadTelemetry() async {
    try {
      final profile = ref.read(profileProvider);
      final hourlyRate = profile.baseHourlyRate > 0 ? profile.baseHourlyRate : 50.0;

      final autopsyService = WeeklyAutopsyService(isar);
      final preMortem = await autopsyService.generatePreMortemForecast();

      final wakaService = WakaTimeService();
      final wakaTime = await wakaService.fetchCodingSessionTelemetry();

      final allTasks = await isar.tasks.where().findAll();
      final uncompletedPeakCount = allTasks
          .where((t) =>
              (t.energySlot == EnergySlot.peak1 || t.energySlot == EnergySlot.peak2) &&
              !t.isCompleted)
          .length;

      final financeService = FinanceService();
      final costOfDelay = await financeService.calculateCostOfDelay(
        baseHourlyRate: hourlyRate,
        uncompletedPeakTasks: uncompletedPeakCount,
      );

      if (mounted) {
        setState(() {
          _preMortem = preMortem;
          _wakaTime = wakaTime;
          _costOfDelay = costOfDelay;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.border),
        ),
        child: const Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white24),
          ),
        ),
      );
    }

    final isRisk = _preMortem?.isCriticalRisk ?? false;
    final forecastScore = _preMortem?.predictedSundayScore ?? 50.0;
    final loss = _costOfDelay?.financialLoss ?? 0.0;
    final uncompletedCount = _costOfDelay?.uncompletedPeakTasks ?? 0;
    final isStagnant = _wakaTime?.isStagnantDebugging ?? false;

    return BentoCard(
      borderColor: isRisk ? AppTheme.warning.withValues(alpha: 0.6) : Colors.white.withValues(alpha: 0.08),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      isRisk ? Icons.warning_amber_rounded : Icons.trending_up_rounded,
                      color: isRisk ? AppTheme.warning : const Color(0xFF00E676),
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'TELEMETRY & COST OF DELAY',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isRisk ? AppTheme.warning : Colors.white70,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: (isRisk ? AppTheme.warning : const Color(0xFF00E676)).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  isRisk ? 'PRE-MORTEM RISK' : 'ON TRACK',
                  style: TextStyle(
                    color: isRisk ? AppTheme.warning : const Color(0xFF00E676),
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Metrics Grid
          Row(
            children: [
              // Predicted Power Score
              Expanded(
                child: _buildMetricTile(
                  title: 'PREDICTED SCORE',
                  value: '${forecastScore.toStringAsFixed(0)}/100',
                  subtitle: 'Sun Forecast',
                  accentColor: isRisk ? AppTheme.warning : const Color(0xFF00E676),
                ),
              ),
              const SizedBox(width: 12),
              // Financial Cost of Delay
              Expanded(
                child: _buildMetricTile(
                  title: 'COST OF DELAY',
                  value: '\$${loss.toStringAsFixed(0)}',
                  subtitle: '$uncompletedCount Peak Tasks Open',
                  accentColor: loss > 0 ? AppTheme.warning : Colors.white70,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // WakaTime Stagnation Indicator
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isStagnant
                  ? AppTheme.warning.withValues(alpha: 0.1)
                  : Colors.white.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isStagnant
                    ? AppTheme.warning.withValues(alpha: 0.3)
                    : Colors.white10,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isStagnant ? Icons.bug_report_rounded : Icons.code_rounded,
                  color: isStagnant ? AppTheme.warning : Colors.white54,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _wakaTime?.stagnationWarning ?? 'Loading WakaTime telemetry...',
                    style: TextStyle(
                      color: isStagnant ? AppTheme.warning : Colors.white60,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Action Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () async {
                var crucible = await isar.crucibleStates.get(1);
                crucible ??= CrucibleState();
                if (context.mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CruciblePage(crucibleState: crucible!)),
                  );
                }
              },
              icon: const Icon(Icons.bolt_rounded, size: 16, color: Colors.white),
              label: const Text(
                'ENTER CRUCIBLE LOCKDOWN',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: isRisk ? AppTheme.warning.withValues(alpha: 0.6) : Colors.white24,
                ),
                padding: const EdgeInsets.symmetric(vertical: 10),
                backgroundColor: isRisk ? AppTheme.warning.withValues(alpha: 0.15) : Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile({
    required String title,
    required String value,
    required String subtitle,
    required Color accentColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 9,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: accentColor,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white54, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
