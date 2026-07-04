import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/energy_economy/energy_provider.dart';
import '../features/brutalist_review/brutalist_provider.dart';
import '../features/energy_economy/morning_enforcer_page.dart';
import '../features/brutalist_review/brutalist_review_page.dart';
import '../features/liars_chart/liars_chart_provider.dart';
import '../features/liars_chart/liars_chart_page.dart';
import '../features/crucible/crucible_provider.dart';
import '../features/crucible/crucible_page.dart';
import 'main_scaffold.dart';

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

    // 2. Check Morning Enforcer (05:00 - 12:00)
    if (hour >= 5 && hour < 12) {
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
