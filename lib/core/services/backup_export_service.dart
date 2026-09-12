import 'dart:convert';
import 'dart:io';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'kairo_context_service.dart';
import '../models/task.dart';
import '../models/liar_goal.dart';
import '../models/psychosomatic_scan.dart';
import '../models/decision_log.dart';
import '../models/memory_edge.dart';
import '../models/focus_session.dart';
import '../models/sleep_log.dart';

class BackupExportService {
  final Isar isar;
  BackupExportService(this.isar);

  Future<File> exportFullSystemJson() async {
    final tasks = await isar.tasks.where().findAll();
    final goals = await isar.liarGoals.where().findAll();
    final scans = await isar.psychosomaticScans.where().findAll();
    final decisions = await isar.decisionLogs.where().findAll();
    final edges = await isar.memoryEdges.where().findAll();
    final focus = await isar.focusSessions.where().findAll();
    final sleep = await isar.sleepLogs.where().findAll();

    final dataMap = {
      'metadata': {
        'version': '2.0.0-V2',
        'exportedAt': DateTime.now().toIso8601String(),
      },
      'tasks': tasks.map((t) => {
        'id': t.id,
        'title': t.title,
        'isCompleted': t.isCompleted,
        'isFailed': t.isFailed,
        'createdAt': t.createdAt.toIso8601String(),
      }).toList(),
      'liarGoals': goals.map((g) => {
        'id': g.id,
        'title': g.title,
        'leadLabel': g.leadMetricLabel,
        'lagLabel': g.lagMetricLabel,
        'leadHistory': g.leadHistory,
        'lagHistory': g.lagHistory,
      }).toList(),
      'scans': scans.map((s) => {
        'id': s.id,
        'date': s.date.toIso8601String(),
        'stressScore': s.stressScore,
      }).toList(),
      'decisions': decisions.map((d) => {
        'id': d.id,
        'title': d.title,
        'confidence': d.confidenceScore,
        'verdict': d.verdict,
        'expectedOutcome': d.expectedOutcome,
      }).toList(),
      'focusSessions': focus.map((f) => {
        'id': f.id,
        'title': f.title,
        'durationMinutes': f.actualDurationMinutes,
        'date': f.startTime.toIso8601String(),
      }).toList(),
      'sleepLogs': sleep.map((s) => {
        'id': s.id,
        'date': s.date.toIso8601String(),
        'hours': s.hoursSlept,
      }).toList(),
      'memoryEdges': edges.map((e) => {
        'id': e.id,
        'sourceId': e.sourceId,
        'sourceCollection': e.sourceCollection,
        'targetCollection': e.targetCollection,
      }).toList(),
    };

    final dir = await getApplicationDocumentsDirectory();
    final filename = 'kairo_system_backup_${DateTime.now().millisecondsSinceEpoch}.json';
    final file = File('${dir.path}/$filename');
    await file.writeAsString(const JsonEncoder.withIndent('  ').convert(dataMap));
    return file;
  }

  Future<File> exportSystemDossierMarkdown() async {
    final dossier = await KairoContextService(isar).buildSystemicDossier();
    final text = dossier.toFormattedPromptContext();

    final dir = await getApplicationDocumentsDirectory();
    final filename = 'kairo_dossier_${DateTime.now().millisecondsSinceEpoch}.md';
    final file = File('${dir.path}/$filename');
    await file.writeAsString(text);
    return file;
  }
}

