import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/services/streak_service.dart';
import '../core/theme/app_theme.dart';
import '../features/energy_economy/energy_provider.dart';
import '../features/brutalist_review/brutalist_provider.dart';
import '../features/energy_economy/morning_enforcer_page.dart';
import '../features/brutalist_review/brutalist_review_page.dart';
import '../features/liars_chart/liars_chart_provider.dart';
import '../features/liars_chart/liars_chart_page.dart';
import '../features/crucible/crucible_provider.dart';
import '../features/crucible/crucible_page.dart';
import 'main_scaffold.dart';

final streakBrokenProvider = FutureProvider.autoDispose<bool>((ref) async {
  await StreakService().initOrCheckStreak();
  return await StreakService().isStreakBroken();
});

class Gatekeeper extends ConsumerWidget {
  const Gatekeeper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final hour = now.hour;

    // 0. The Crucible / Bankruptcy Protocol Lockdown (Highest Priority Override)
    final crucible = ref.watch(crucibleProvider);
    if (crucible.isActive) {
      return CruciblePage(crucibleState: crucible);
    }

    // 0.5 Check 21-Day Habit Streak Integrity
    final streakBrokenAsync = ref.watch(streakBrokenProvider);
    if (streakBrokenAsync.valueOrNull == true) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.broken_image, color: AppTheme.warning, size: 64),
                const SizedBox(height: 24),
                const Text(
                  "STREAK BROKEN",
                  style: TextStyle(color: AppTheme.warning, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2),
                ),
                const SizedBox(height: 16),
                const Text(
                  "You missed yesterday's discipline checkpoint.\nYour 21-day neurobiological rewiring chain has collapsed to Day 0.\n\nConfront your failure and restart the gauntlet.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await StreakService().resetStreak();
                      ref.invalidate(streakBrokenProvider);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.warning,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text("RESTART 21-DAY STREAK", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // 1. Check Evening Interrogation (18:00 - 23:59)
    if (hour >= 18) {
      final needsReview = ref.watch(brutalistProvider.select(
        (s) => !s.isLoading && s.todayReview?.isCompleted != true,
      ));
      if (needsReview) {
        // Force Brutalist Review
        return const Scaffold(
          backgroundColor: Colors.black,
          body: BrutalistReviewPage(showBackButton: false),
        );
      }
    }

    // 2. Check Morning Enforcer (05:00 - 18:00)
    if (hour >= 5 && hour < 18) {
      final needsMorningEnforcement = ref.watch(energyEconomyProvider.select(
        (s) => !s.isLoading && !s.hasAssignedPeaksToday,
      ));
      if (needsMorningEnforcement) {
        return MorningEnforcerPage(
          onPassedGauntlet: () {},
        );
      }
    }

    // 3. Weekly Liar's Confrontation (Sunday)
    if (now.weekday == DateTime.sunday) {
      final needsLiarsConfrontation = ref.watch(liarsChartProvider.select(
        (s) => !s.isLoading && s.goals.any((g) => g.liarsChartActive),
      ));
      if (needsLiarsConfrontation) {
        return const Scaffold(
          backgroundColor: Colors.black,
          body: LiarsChartPage(isForced: true),
        );
      }
    }

    // If gauntlet passed, allow entry to the Command Center
    return const MainScaffold();
  }
}
