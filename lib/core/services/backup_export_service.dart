import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
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
        'version': '2.0.0-ASCENSION',
        'exportedAt': DateTime.now().toIso8601String(),
      },
      'tasks': tasks.map((t) => {
        'id': t.id,
        'title': t.title,
        'isCompleted': t.isCompleted,
        'isFailed': t.isFailed,
        'failureEtiology': t.failureEtiology.name,
        'createdAt': t.createdAt.toIso8601String(),
      }).toList(),
      'liarGoals': goals.map((g) => {
        'id': g.id,
        'title': g.title,
        'leadLabel': g.leadMetricLabel,
        'lagLabel': g.lagMetricLabel,
        'leadHistory': g.leadHistory,
        'lagHistory': g.lagHistory,
        'active': g.liarsChartActive,
      }).toList(),
      'scans': scans.map((s) => {
        'id': s.id,
        'date': s.date.toIso8601String(),
        'stressScore': s.stressScore,
        'contextLabel': s.contextLabel,
      }).toList(),
      'decisions': decisions.map((d) => {
        'id': d.id,
        'title': d.title,
        'confidence': d.confidenceScore,
        'verdict': d.verdict,
        'expectedOutcome': d.expectedOutcome,
      }).toList(),
      'memoryEdges': edges.map((e) => {
        'id': e.id,
        'source': '${e.sourceCollection}:${e.sourceId} (${e.sourceTitle})',
        'target': '${e.targetCollection}:${e.targetId} (${e.targetTitle})',
        'relation': e.relationType,
      }).toList(),
      'focusSessions': focus.map((f) => {
        'id': f.id,
        'title': f.title,
        'durationMinutes': f.actualDurationMinutes,
        'distractions': f.distractionCount,
        'date': f.startTime.toIso8601String(),
      }).toList(),
      'sleepLogs': sleep.map((s) => {
        'id': s.id,
        'date': s.date.toIso8601String(),
        'hours': s.hoursSlept,
        'quality': s.qualityRating,
      }).toList(),
    };

    final dir = await getApplicationDocumentsDirectory();
    final filename = 'kairo_system_backup_${DateTime.now().millisecondsSinceEpoch}.json';
    final file = File('${dir.path}/$filename');
    await file.writeAsString(const JsonEncoder.withIndent('  ').convert(dataMap));
    return file;
  }

  Future<File> exportSystemDossierPdf() async {
    final dossier = await KairoContextService(isar).buildSystemicDossier();
    final promptText = dossier.toFormattedPromptContext();

    final document = PdfDocument();
    final page = document.pages.add();
    final font = PdfStandardFont(PdfFontFamily.courier, 10);

    // Draw header & content
    page.graphics.drawString(
      "K.A.I.R.O. EXECUTIVE ASCENSION DOSSIER\nGenerated: ${DateTime.now().toLocal()}\n\n$promptText",
      font,
      bounds: Rect.fromLTWH(0, 0, page.getClientSize().width, page.getClientSize().height),
      format: PdfStringFormat(lineSpacing: 4),
    );

    final bytes = document.saveSync();
    document.dispose();

    final dir = await getApplicationDocumentsDirectory();
    final filename = 'kairo_executive_dossier_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }
}
