import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../main.dart';
import '../models/project.dart';
import '../models/architecture_artifact.dart';
import '../models/architecture_drift.dart';
import '../services/project_dna_service.dart';
import '../services/mermaid_ingestion_service.dart';
import '../services/architecture_drift_service.dart';

final mermaidIngestionServiceProvider = Provider<MermaidIngestionService>((ref) {
  return MermaidIngestionService(isar);
});

final architectureDriftServiceProvider = Provider<ArchitectureDriftService>((ref) {
  return ArchitectureDriftService(isar);
});

final projectDnaServiceProvider = Provider<ProjectDnaService>((ref) {
  return ProjectDnaService(isar);
});

final allProjectsProvider = FutureProvider<List<Project>>((ref) async {
  return await isar.projects.where().sortByCreatedAtDesc().findAll();
});

final registeredKairoProjectsProvider = FutureProvider<List<Project>>((ref) async {
  return await isar.projects
      .filter()
      .isRegisteredKairoEqualTo(true)
      .sortByCreatedAtDesc()
      .findAll();
});

final projectArtifactsProvider = FutureProvider.family<List<ArchitectureArtifact>, int>((ref, projectId) async {
  return await isar.architectureArtifacts
      .filter()
      .projectIdEqualTo(projectId)
      .sortByLastSyncedAtDesc()
      .findAll();
});

final projectDriftsProvider = FutureProvider.family<List<ArchitectureDrift>, int>((ref, projectId) async {
  return await isar.architectureDrifts
      .filter()
      .projectIdEqualTo(projectId)
      .sortByDetectedAtDesc()
      .findAll();
});
