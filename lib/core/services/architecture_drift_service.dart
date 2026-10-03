import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import '../models/project.dart';
import '../models/architecture_artifact.dart';
import '../models/architecture_drift.dart';
import '../models/core_observation.dart';

class ArchitectureDriftService {
  final Isar? isar;
  ArchitectureDriftService([this.isar]);

  /// Evaluates the difference between Project Intent (manifest, planned architecture/capabilities)
  /// and Reality (implemented capabilities, observed components).
  ///
  /// CRITICAL ARCHITECTURAL PRINCIPLE:
  /// K.A.I.R.O. observes -> interprets -> proposes.
  /// The USER decides -> commits -> acts.
  /// NEVER automatically create a Task or goal from architecture drift.
  Future<List<ArchitectureDrift>> detectDrift({
    required Project project,
    List<ArchitectureArtifact>? artifacts,
    List<String> observedComponents = const [],
  }) async {
    final drifts = <ArchitectureDrift>[];

    // Load architecture artifacts for this project
    final effectiveArtifacts = artifacts ??
        (isar != null
            ? await isar!.architectureArtifacts
                .filter()
                .projectIdEqualTo(project.id)
                .findAll()
            : <ArchitectureArtifact>[]);

    // 1. Identify planned capabilities that are not yet implemented
    final implementedSet = project.implementedCapabilities.map((c) => c.toLowerCase().trim()).toSet();
    // Also include explicitly provided observed components from repository analysis
    for (final obs in observedComponents) {
      implementedSet.add(obs.toLowerCase().trim());
    }

    // 2. Analyze Architecture Diagrams for Drift
    for (final artifact in effectiveArtifacts) {
      // Look for declared nodes that match planned capabilities or are missing from observed components
      for (final planned in project.plannedCapabilities) {
        final cleanPlanned = planned.replaceAll('_', ' ').toLowerCase();

        // Check if any declared nodes in the diagram correspond to this planned capability
        final matchingNode = artifact.declaredNodes.firstWhere(
          (node) => node.toLowerCase().contains(cleanPlanned) || cleanPlanned.contains(node.toLowerCase()),
          orElse: () => '',
        );

        if (matchingNode.isNotEmpty && !implementedSet.contains(cleanPlanned)) {
          // Construct expected vs observed flow from declared edges
          final relatedEdges = artifact.declaredEdges.where(
            (edge) => edge.toLowerCase().contains(matchingNode.toLowerCase()),
          ).toList();

          String expectedFlow = relatedEdges.isNotEmpty
              ? relatedEdges.join(' → ')
              : '${artifact.projectTitle} → $matchingNode';

          // Observed flow removes the missing node
          String observedFlow = expectedFlow.replaceAll(matchingNode, '[BYPASS]').replaceAll('  ', ' ');
          if (observedFlow.contains('[BYPASS] →')) {
            observedFlow = observedFlow.replaceAll('[BYPASS] →', '').trim();
          } else {
            observedFlow = observedFlow.replaceAll('→ [BYPASS]', '').trim();
          }

          final drift = ArchitectureDrift()
            ..projectId = project.id
            ..projectTitle = project.title
            ..expected = expectedFlow
            ..observed = observedFlow.isNotEmpty ? observedFlow : '${project.title} (Direct Pipeline)'
            ..missing = matchingNode
            ..classification = 'PLANNED / NOT IMPLEMENTED'
            ..notes = 'Component "$matchingNode" declared in ${artifact.architectureType} architecture ($planned) is not yet verified in active implementation.'
            ..detectedAt = DateTime.now();

          drifts.add(drift);
        }
      }
    }

    // 3. Fallback check for planned capabilities even if not explicitly diagrammed
    if (drifts.isEmpty && project.plannedCapabilities.isNotEmpty) {
      for (final planned in project.plannedCapabilities) {
        final cleanPlanned = planned.replaceAll('_', ' ').trim();
        final drift = ArchitectureDrift()
          ..projectId = project.id
          ..projectTitle = project.title
          ..expected = '${project.title} with $cleanPlanned'
          ..observed = '${project.title} (Standard Pipeline)'
          ..missing = cleanPlanned
          ..classification = 'PLANNED / NOT IMPLEMENTED'
          ..notes = 'Capability "$cleanPlanned" is registered in .kairo/manifest.yaml as planned.'
          ..detectedAt = DateTime.now();

        drifts.add(drift);
      }
    }

    // Persist detected drifts if Isar is available
    if (isar != null) {
      await isar!.writeTxn(() async {
        await isar!.architectureDrifts
            .filter()
            .projectIdEqualTo(project.id)
            .deleteAll();

        for (final d in drifts) {
          await isar!.architectureDrifts.put(d);
        }

        // Record CoreObservation for audit trail
        if (drifts.isNotEmpty) {
          final obs = CoreObservation()
            ..timestamp = DateTime.now()
            ..type = ObservationType.gitCommitSample
            ..source = 'project_dna_drift'
            ..confidence = 100
            ..dataPayloadJson = '{"project":"${project.title}","driftsCount":${drifts.length},"missing":"${drifts.map((d) => d.missing).join(', ')}"}';
          await isar!.coreObservations.put(obs);
        }
      });
    }

    debugPrint("ArchitectureDriftService: Detected ${drifts.length} drift observations for ${project.title}. (Zero auto-tasks created)");
    return drifts;
  }

  /// Mark drift observation as acknowledged by the user.
  Future<void> acknowledgeDrift(int driftId) async {
    if (isar == null) return;
    final drift = await isar!.architectureDrifts.get(driftId);
    if (drift != null) {
      drift.isAcknowledged = true;
      await isar!.writeTxn(() async {
        await isar!.architectureDrifts.put(drift);
      });
    }
  }
}
