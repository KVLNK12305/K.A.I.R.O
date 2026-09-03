import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../energy_economy/energy_provider.dart';
import '../../energy_economy/energy_economy_page.dart';
import '../../psychosomatic/psychosomatic_provider.dart';
import 'package:kairo/Nav/smooth_page_route.dart';
import 'bento_card.dart';

class EnergyReserveBatteryWidget extends ConsumerWidget {
  const EnergyReserveBatteryWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final energyState = ref.watch(energyEconomyProvider);
    final psychoState = ref.watch(psychosomaticProvider);

    // Calculate dynamic cognitive & energy battery percentage
    final now = DateTime.now();
    final currentHour = now.hour + (now.minute / 60.0);

    // Baseline awake curve: 6 AM (100%) down to 11 PM (15%)
    double timeDrain = 0.0;
    if (currentHour >= 6.0 && currentHour <= 23.0) {
      timeDrain = (currentHour - 6.0) * 4.5; // ~76% drain across 17 hours
    } else if (currentHour > 23.0) {
      timeDrain = 80.0;
    }

    // Stress load impact from Psychosomatic scan
    double stressDrain = 0.0;
    final todayStress = psychoState.todayScan?.stressScore;
    if (todayStress != null) {
      // 0 to 100 stress score contributes up to 20% extra depletion
      stressDrain = (todayStress / 100.0) * 20.0;
    }

    // Completion momentum boost
    final totalPeaks = energyState.peak1Tasks.length + energyState.peak2Tasks.length;
    final completedPeaks = energyState.peak1Tasks.where((t) => t.isCompleted).length +
        energyState.peak2Tasks.where((t) => t.isCompleted).length;
    double completionBoost = 0.0;
    if (totalPeaks > 0) {
      completionBoost = (completedPeaks / totalPeaks) * 15.0; // up to +15% boost for executing peaks
    }

    int batteryLevel = (100.0 - timeDrain - stressDrain + completionBoost).clamp(12.0, 100.0).round();

    // Determine state branding & tone
    final Color batteryColor;
    final String stateLabel;
    final String directive;
    final IconData icon;

    if (batteryLevel >= 75) {
      batteryColor = const Color(0xFF00E676); // High Neon Green
      stateLabel = "OPTIMAL BANDWIDTH";
      directive = "Prime window for architectural focus and irreversible decisions.";
      icon = Icons.bolt_rounded;
    } else if (batteryLevel >= 45) {
      batteryColor = const Color(0xFFFFB300); // Amber Warning
      stateLabel = "MODERATE BANDWIDTH";
      directive = "Single-task execution only. Defer non-critical context switches.";
      icon = Icons.battery_charging_full_rounded;
    } else {
      batteryColor = const Color(0xFFFF3D00); // Crimson Alert
      stateLabel = "DEPLETED BANDWIDTH";
      directive = "High cognitive fatigue. Avoid making irreversible life or product decisions.";
      icon = Icons.battery_alert_rounded;
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(context, SmoothPageRoute(page: const EnergyEconomyPage()));
      },
      child: BentoCard(
        backgroundColor: const Color(0xFF141414),
        borderColor: batteryColor.withValues(alpha: 0.25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(icon, size: 16, color: batteryColor),
                    const SizedBox(width: 8),
                    Text(
                      "COGNITIVE & ENERGY RESERVE",
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 10,
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: batteryColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: batteryColor.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    "$batteryLevel%",
                    style: TextStyle(
                      color: batteryColor,
                      fontSize: 12,
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Battery visual bar
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Stack(
                children: [
                  Container(
                    height: 10,
                    width: double.infinity,
                    color: Colors.white.withValues(alpha: 0.06),
                  ),
                  FractionallySizedBox(
                    widthFactor: batteryLevel / 100.0,
                    child: Container(
                      height: 10,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            batteryColor.withValues(alpha: 0.7),
                            batteryColor,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: batteryColor.withValues(alpha: 0.4),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Directive & State
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 2),
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: batteryColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stateLabel,
                        style: TextStyle(
                          color: batteryColor,
                          fontSize: 11,
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        directive,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.75),
                          fontSize: 12,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
