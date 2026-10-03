import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import '../models/need.dart';
import '../models/task.dart';
import '../models/project.dart';

class NeedsSummary {
  final int totalActive;
  final double estimatedTotalCost;
  final Need? highestUrgency;
  final Need? largestPlannedPurchase;
  final int deferredCount;

  const NeedsSummary({
    required this.totalActive,
    required this.estimatedTotalCost,
    this.highestUrgency,
    this.largestPlannedPurchase,
    required this.deferredCount,
  });

  /// Formatted non-coercive editorial review text.
  /// Strictly follows: K.A.I.R.O. observes -> interprets -> proposes.
  /// The user decides. Never "BUY THIS NOW".
  String get editorialSummary {
    if (totalActive == 0) {
      return "Zero active needs recorded. No unresolved equipment or tooling requirements.";
    }
    final buffer = StringBuffer();
    buffer.writeln("These are your unresolved needs:");
    buffer.writeln("• $totalActive active needs");
    if (estimatedTotalCost > 0) {
      buffer.writeln("• ₹${estimatedTotalCost.toStringAsFixed(0)} estimated allocation");
    }
    if (highestUrgency != null) {
      buffer.writeln("• Highest urgency: ${highestUrgency!.title}");
    }
    if (largestPlannedPurchase != null && (largestPlannedPurchase!.estimatedCost ?? 0) > 0) {
      buffer.writeln("• Largest purchase: ${largestPlannedPurchase!.title} (₹${largestPlannedPurchase!.estimatedCost!.toStringAsFixed(0)})");
    }
    if (deferredCount > 0) {
      buffer.writeln("• $deferredCount deferred");
    }
    buffer.write("The user decides if and when to act.");
    return buffer.toString();
  }
}

class NeedService {
  final Isar? isar;
  NeedService([this.isar]);

  /// Fetch all needs with optional filtering.
  Future<List<Need>> getNeeds({
    NeedStatus? status,
    NeedType? type,
    String? category,
    NeedUrgency? urgency,
  }) async {
    if (isar == null) return [];
    var query = isar!.needs.where();
    final all = await query.sortByCreatedAtDesc().findAll();

    return all.where((n) {
      if (status != null && n.status != status) return false;
      if (type != null && n.type != type) return false;
      if (category != null && category.isNotEmpty && category != 'All' && n.category != category) return false;
      if (urgency != null && n.urgency != urgency) return false;
      return true;
    }).toList();
  }

  /// Create a new Need.
  /// IMPORTANT: Needs NEVER affect daily tasks, today's schedule, streaks, or accountability.
  Future<Need> createNeed({
    required String title,
    String description = '',
    String category = 'Tech',
    NeedType type = NeedType.buy,
    NeedStatus status = NeedStatus.considering,
    NeedUrgency urgency = NeedUrgency.medium,
    NeedPriority priority = NeedPriority.medium,
    double? estimatedCost,
    double? targetBudget,
    DateTime? targetDate,
    String reason = '',
    String replacementFor = '',
    String currentSolution = '',
    String researchNotes = '',
    List<String> links = const [],
    String? externalId,
    String? externalSource,
    bool isExternal = false,
  }) async {
    final need = Need()
      ..title = title.trim()
      ..description = description.trim()
      ..category = category.trim()
      ..type = type
      ..status = status
      ..urgency = urgency
      ..priority = priority
      ..estimatedCost = estimatedCost
      ..targetBudget = targetBudget
      ..targetDate = targetDate
      ..reason = reason.trim()
      ..replacementFor = replacementFor.trim()
      ..currentSolution = currentSolution.trim()
      ..researchNotes = researchNotes.trim()
      ..links = List.from(links)
      ..externalId = externalId
      ..externalSource = externalSource
      ..isExternal = isExternal
      ..createdAt = DateTime.now()
      ..updatedAt = DateTime.now();

    if (isar != null) {
      await isar!.writeTxn(() async {
        await isar!.needs.put(need);
      });
    }

    debugPrint("Created Need: [${need.title}] (Status: ${need.status.name})");
    return need;
  }

  /// Update an existing Need.
  Future<void> updateNeed(Need need) async {
    need.updatedAt = DateTime.now();
    if (isar != null) {
      await isar!.writeTxn(() async {
        await isar!.needs.put(need);
      });
    }
  }

  /// Delete a Need.
  Future<void> deleteNeed(int id) async {
    if (isar != null) {
      await isar!.writeTxn(() async {
        await isar!.needs.delete(id);
      });
    }
  }

  /// Generate decision support summary.
  Future<NeedsSummary> getNeedsSummary([List<Need>? sourceNeeds]) async {
    final all = sourceNeeds ??
        (isar != null ? await isar!.needs.where().findAll() : <Need>[]);

    final activeNeeds = all.where((n) =>
      n.status != NeedStatus.bought &&
      n.status != NeedStatus.dropped
    ).toList();

    double totalCost = 0.0;
    Need? highestUrgency;
    Need? largestPurchase;
    int deferredCount = 0;

    for (final need in activeNeeds) {
      if (need.status == NeedStatus.deferred) {
        deferredCount++;
      }
      if (need.estimatedCost != null) {
        totalCost += need.estimatedCost!;
      }
      if (highestUrgency == null || need.urgency.index > highestUrgency.urgency.index) {
        highestUrgency = need;
      }
      if (largestPurchase == null || (need.estimatedCost ?? 0) > (largestPurchase.estimatedCost ?? 0)) {
        largestPurchase = need;
      }
    }

    return NeedsSummary(
      totalActive: activeNeeds.length,
      estimatedTotalCost: totalCost,
      highestUrgency: highestUrgency,
      largestPlannedPurchase: largestPurchase,
      deferredCount: deferredCount,
    );
  }

  /// Explicitly promotes a Need into an actionable Task in the execution system.
  ///
  /// CRITICAL RULE: A Need only becomes an actionable Task when the USER explicitly promotes it.
  /// Never automatic.
  Future<Task> promoteToTask({
    required int needId,
    required String taskTitle,
    String? category,
    EnergySlot energySlot = EnergySlot.unassigned,
    Need? mockNeed,
    void Function(Task task)? onTaskCreated,
  }) async {
    final need = mockNeed ?? (isar != null ? await isar!.needs.get(needId) : null);
    if (need == null) throw Exception("Need not found");

    final task = Task(
      taskTitle.trim().isNotEmpty ? taskTitle.trim() : need.title,
      category ?? need.category,
    )
      ..energySlot = energySlot
      ..createdAt = DateTime.now();

    if (isar != null) {
      await isar!.writeTxn(() async {
        await isar!.tasks.put(task);

        // Update Need status and link notes
        need.decision = 'Promoted to Task: "${task.title}" on ${DateTime.now().toIso8601String().split('T').first}';
        need.status = NeedStatus.researching;
        need.updatedAt = DateTime.now();
        await isar!.needs.put(need);
      });
    } else {
      need.decision = 'Promoted to Task: "${task.title}" on ${DateTime.now().toIso8601String().split('T').first}';
      need.status = NeedStatus.researching;
      need.updatedAt = DateTime.now();
      onTaskCreated?.call(task);
    }

    debugPrint("Explicitly promoted Need [${need.title}] -> Task [${task.title}]");
    return task;
  }

  /// Explicitly promotes a Need into a Project in the Order system.
  Future<Project> promoteToProject({
    required int needId,
    required String projectTitle,
    required String description,
    Need? mockNeed,
    void Function(Project project)? onProjectCreated,
  }) async {
    final need = mockNeed ?? (isar != null ? await isar!.needs.get(needId) : null);
    if (need == null) throw Exception("Need not found");

    final project = Project(
      title: projectTitle.trim().isNotEmpty ? projectTitle.trim() : need.title,
      description: description.trim().isNotEmpty ? description.trim() : need.description,
      status: 'Active',
    );

    if (isar != null) {
      await isar!.writeTxn(() async {
        await isar!.projects.put(project);

        need.decision = 'Promoted to Project: "${project.title}" on ${DateTime.now().toIso8601String().split('T').first}';
        need.status = NeedStatus.researching;
        need.updatedAt = DateTime.now();
        await isar!.needs.put(need);
      });
    } else {
      need.decision = 'Promoted to Project: "${project.title}" on ${DateTime.now().toIso8601String().split('T').first}';
      need.status = NeedStatus.researching;
      need.updatedAt = DateTime.now();
      onProjectCreated?.call(project);
    }

    debugPrint("Explicitly promoted Need [${need.title}] -> Project [${project.title}]");
    return project;
  }
}
