import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import '../../models/raw_financial_transaction.dart';
import 'payment_ingestion_adapter.dart';
import 'payment_resolution_engine.dart';

class KairoNodeMigrator implements PaymentIngestionAdapter {
  final PaymentResolutionEngine resolutionEngine;
  @override
  final String sourceName = 'kairo_node';

  KairoNodeMigrator(this.resolutionEngine);

  @override
  Future<IngestionResult> ingest() async {
    final candidateDirs = <Directory>[];
    try {
      final docDir = await getApplicationDocumentsDirectory();
      candidateDirs.add(docDir);
      // Also check parent or files directory on Android
      final parent = docDir.parent;
      final filesDir = Directory('${parent.path}/files');
      if (filesDir.existsSync()) {
        candidateDirs.add(filesDir);
      }
    } catch (_) {}

    File? legacyFile;
    for (final dir in candidateDirs) {
      final f = File('${dir.path}/kairo_node_expenses.csv');
      if (f.existsSync()) {
        legacyFile = f;
        break;
      }
    }

    if (legacyFile == null || !legacyFile.existsSync()) {
      return const IngestionResult(
        source: 'kairo_node',
        totalReceived: 0,
        newPersisted: 0,
        duplicatesSkipped: 0,
        resolvedEventsCreated: 0,
        ignoredOrFailed: 0,
      );
    }

    final rawTxns = <RawFinancialTransaction>[];
    final lines = await legacyFile.readAsLines();
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.isEmpty || line.toLowerCase().startsWith('date,type,amount')) {
        continue;
      }

      final parts = line.split(',');
      if (parts.length >= 3) {
        final dateStr = parts[0].trim();
        final catStr = parts[1].trim();
        final amtStr = parts[2].trim();

        DateTime date;
        try {
          date = dateFormat.parseLoose(dateStr);
        } catch (_) {
          date = DateTime.tryParse(dateStr) ?? DateTime.now();
        }

        final amount = double.tryParse(amtStr) ?? 0.0;
        if (amount > 0) {
          final raw = RawFinancialTransaction()
            ..source = 'kairo_node'
            ..timestamp = date
            ..amount = amount
            ..currency = 'INR'
            ..rawTitle = 'Node Expense ($catStr)'
            ..rawBody = line
            ..rawMerchant = catStr
            ..paymentMethod = 'NODE_INTENT'
            ..ingestedAt = DateTime.now()
            ..rawPayload = line;

          rawTxns.add(raw);
        }
      }
    }

    final result = await resolutionEngine.resolveBatch(rawTxns, sourceName: sourceName);

    // After successful migration, safely rename to avoid re-reading
    try {
      final migratedTarget = File('${legacyFile.path}.migrated');
      if (migratedTarget.existsSync()) {
        migratedTarget.deleteSync();
      }
      await legacyFile.rename(migratedTarget.path);
    } catch (_) {
      // If rename fails, clear contents
      try {
        await legacyFile.writeAsString('');
      } catch (_) {}
    }

    return result;
  }
}
