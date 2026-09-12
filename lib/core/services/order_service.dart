import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../models/project.dart';
import '../models/idea.dart';
import '../models/commitment.dart';
import '../models/decision_log.dart';
import '../../main.dart';

class OrderDiagnostics {
  final int activeProjectsCount;
  final int openCommitmentsCount;
  final int parkedIdeasCount;
  final int pendingDecisionsCount;
  final bool isFragmented;
  final String recommendation;

  const OrderDiagnostics({
    required this.activeProjectsCount,
    required this.openCommitmentsCount,
    required this.parkedIdeasCount,
    required this.pendingDecisionsCount,
    required this.isFragmented,
    required this.recommendation,
  });
}

class OrderService {
  final Isar isar;
  OrderService(this.isar);

  static const int maxActiveProjects = 3;

  Future<OrderDiagnostics> getDiagnostics() async {
    final allProjects = await isar.projects.where().findAll();
    final activeProjects = allProjects.where((p) => p.status.toLowerCase() == 'active').length;

    final allCommitments = await isar.commitments.where().findAll();
    final activeCommitments = allCommitments.where((c) => c.status == CommitmentStatus.active).length;

    final allIdeas = await isar.ideas.where().findAll();
    final parkedIdeas = allIdeas.where((i) => i.status == 'Parked').length;

    final allDecisions = await isar.decisionLogs.where().findAll();
    final pendingDecisions = allDecisions.where((d) => d.verdict == 'Pending').length;

    final isFragmented = activeProjects > maxActiveProjects || activeCommitments > 4;

    String rec = 'Structural alignment stable. Focus execution on committed Peaks.';
    if (activeProjects > maxActiveProjects) {
      rec = 'ORDER ALERT: $activeProjects active projects exceeds optimal WIP limit ($maxActiveProjects). Park secondary projects to preserve velocity.';
    } else if (activeCommitments > 4) {
      rec = 'COMMITMENT DRAG: $activeCommitments active high-stakes goals. Narrow focus to top 2 priorities.';
    }

    return OrderDiagnostics(
      activeProjectsCount: activeProjects,
      openCommitmentsCount: activeCommitments,
      parkedIdeasCount: parkedIdeas,
      pendingDecisionsCount: pendingDecisions,
      isFragmented: isFragmented,
      recommendation: rec,
    );
  }

  Future<Idea> parkIdea({required String title, String content = '', String reason = 'No active commitment requires this yet.'}) async {
    final idea = Idea(
      title: title.trim(),
      content: content.trim(),
      status: 'Parked',
      parkingReason: reason.trim(),
      reviewAfter: DateTime.now().add(const Duration(days: 7)),
    );

    await isar.writeTxn(() async {
      await isar.ideas.put(idea);
    });

    return idea;
  }
}

final orderServiceProvider = Provider<OrderService>((ref) {
  return OrderService(isar);
});

final orderDiagnosticsProvider = FutureProvider<OrderDiagnostics>((ref) async {
  final service = ref.watch(orderServiceProvider);
  return await service.getDiagnostics();
});
