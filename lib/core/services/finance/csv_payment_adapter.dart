import 'dart:convert';
import 'package:intl/intl.dart';
import '../../models/raw_financial_transaction.dart';
import 'payment_ingestion_adapter.dart';
import 'payment_resolution_engine.dart';

class CsvPaymentAdapter implements PaymentIngestionAdapter {
  final String csvContent;
  final PaymentResolutionEngine resolutionEngine;
  @override
  final String sourceName = 'csv_import';

  CsvPaymentAdapter({
    required this.csvContent,
    required this.resolutionEngine,
  });

  @override
  Future<IngestionResult> ingest() async {
    final rows = parseCsvRows(csvContent);
    if (rows.length < 2) {
      return const IngestionResult(
        source: 'csv_import',
        totalReceived: 0,
        newPersisted: 0,
        duplicatesSkipped: 0,
        resolvedEventsCreated: 0,
        ignoredOrFailed: 0,
        errorMessages: ['CSV has insufficient rows (header + data needed)'],
      );
    }

    final headers = rows.first.map((h) => h.trim().toLowerCase()).toList();
    final colMap = _detectColumns(headers);

    if (colMap.dateIndex == -1 || (colMap.amountIndex == -1 && colMap.debitIndex == -1 && colMap.creditIndex == -1)) {
      return IngestionResult(
        source: 'csv_import',
        totalReceived: rows.length - 1,
        newPersisted: 0,
        duplicatesSkipped: 0,
        resolvedEventsCreated: 0,
        ignoredOrFailed: rows.length - 1,
        errorMessages: ['Could not detect required Date and Amount/Debit/Credit columns in CSV headers: $headers'],
      );
    }

    final rawTxns = <RawFinancialTransaction>[];
    final errors = <String>[];
    int ignored = 0;

    for (int i = 1; i < rows.length; i++) {
      final row = rows[i];
      if (row.isEmpty || (row.length == 1 && row.first.trim().isEmpty)) {
        continue;
      }

      try {
        final dateStr = _safeGet(row, colMap.dateIndex);
        final date = _parseDate(dateStr);
        if (date == null) {
          ignored++;
          continue;
        }

        double amount = 0.0;
        bool isOutflow = true;

        if (colMap.debitIndex != -1 && colMap.creditIndex != -1) {
          final debitStr = _cleanAmountString(_safeGet(row, colMap.debitIndex));
          final creditStr = _cleanAmountString(_safeGet(row, colMap.creditIndex));
          final debit = double.tryParse(debitStr) ?? 0.0;
          final credit = double.tryParse(creditStr) ?? 0.0;

          if (debit > 0) {
            amount = debit;
            isOutflow = true;
          } else if (credit > 0) {
            amount = credit;
            isOutflow = false;
          } else {
            ignored++;
            continue;
          }
        } else if (colMap.amountIndex != -1) {
          final amountStr = _cleanAmountString(_safeGet(row, colMap.amountIndex));
          final parsed = double.tryParse(amountStr);
          if (parsed == null || parsed == 0.0) {
            ignored++;
            continue;
          }

          if (parsed < 0) {
            amount = parsed.abs();
            isOutflow = true;
          } else {
            amount = parsed;
            // Check type / direction column if available
            if (colMap.typeIndex != -1) {
              final typeStr = _safeGet(row, colMap.typeIndex).toLowerCase();
              if (typeStr.contains('dr') || typeStr.contains('debit') || typeStr.contains('outflow') || typeStr.contains('expense')) {
                isOutflow = true;
              } else if (typeStr.contains('cr') || typeStr.contains('credit') || typeStr.contains('inflow') || typeStr.contains('income')) {
                isOutflow = false;
              }
            } else {
              // Default to outflow if no indicator
              isOutflow = true;
            }
          }
        }

        final rawDesc = colMap.descIndex != -1 ? _safeGet(row, colMap.descIndex) : '';
        final refNum = colMap.refIndex != -1 ? _safeGet(row, colMap.refIndex) : null;
        final cleanRef = (refNum != null && refNum.trim().isNotEmpty) ? refNum.trim() : null;

        final raw = RawFinancialTransaction()
          ..source = 'csv_import'
          ..timestamp = date
          ..amount = amount
          ..currency = 'INR'
          ..rawTitle = isOutflow ? 'Debit / Outflow' : 'Credit / Inflow'
          ..rawBody = rawDesc
          ..rawMerchant = rawDesc
          ..paymentMethod = 'CSV'
          ..referenceNumber = cleanRef
          ..ingestedAt = DateTime.now()
          ..rawPayload = jsonEncode({
            'headers': headers,
            'row': row,
          });

        rawTxns.add(raw);
      } catch (e) {
        ignored++;
        errors.add('Row $i error: $e');
      }
    }

    return await resolutionEngine.resolveBatch(
      rawTxns,
      sourceName: sourceName,
      initialIgnoredCount: ignored,
      initialErrors: errors,
    );
  }

  static List<List<String>> parseCsvRows(String content) {
    final result = <List<String>>[];
    final lines = const LineSplitter().convert(content);
    for (final line in lines) {
      if (line.trim().isEmpty) continue;
      result.add(_parseLine(line));
    }
    return result;
  }

  static List<String> _parseLine(String line) {
    final tokens = <String>[];
    final sb = StringBuffer();
    bool insideQuotes = false;

    for (int i = 0; i < line.length; i++) {
      final c = line[i];
      if (c == '"') {
        if (insideQuotes && i + 1 < line.length && line[i + 1] == '"') {
          sb.write('"');
          i++; // skip escaped quote
        } else {
          insideQuotes = !insideQuotes;
        }
      } else if (c == ',' && !insideQuotes) {
        tokens.add(sb.toString().trim());
        sb.clear();
      } else {
        sb.write(c);
      }
    }
    tokens.add(sb.toString().trim());
    return tokens;
  }

  static _ColumnMapping _detectColumns(List<String> headers) {
    int date = -1;
    int amount = -1;
    int debit = -1;
    int credit = -1;
    int desc = -1;
    int ref = -1;
    int type = -1;

    for (int i = 0; i < headers.length; i++) {
      final h = headers[i];
      if (date == -1 && (h.contains('date') || h.contains('time') || h.contains('timestamp'))) {
        date = i;
      } else if (debit == -1 && (h.contains('debit') || h.contains('withdrawal') || h.contains('dr'))) {
        debit = i;
      } else if (credit == -1 && (h.contains('credit') || h.contains('deposit') || h.contains('cr'))) {
        credit = i;
      } else if (amount == -1 && (h.contains('amount') || h.contains('amt') || h.contains('value'))) {
        amount = i;
      } else if (desc == -1 && (h.contains('narration') || h.contains('particular') || h.contains('description') || h.contains('merchant') || h.contains('remarks') || h.contains('details'))) {
        desc = i;
      } else if (ref == -1 && (h.contains('ref') || h.contains('utr') || h.contains('chq') || h.contains('txn') || h.contains('id'))) {
        ref = i;
      } else if (type == -1 && (h.contains('type') || h.contains('category') || h.contains('direction'))) {
        type = i;
      }
    }

    return _ColumnMapping(
      dateIndex: date,
      amountIndex: amount,
      debitIndex: debit,
      creditIndex: credit,
      descIndex: desc,
      refIndex: ref,
      typeIndex: type,
    );
  }

  static String _safeGet(List<String> row, int index) {
    if (index >= 0 && index < row.length) {
      return row[index];
    }
    return '';
  }

  static String _cleanAmountString(String str) {
    return str.replaceAll(RegExp(r'[₹Rs\.INR,\s]'), '').trim();
  }

  static DateTime? _parseDate(String raw) {
    final clean = raw.trim();
    if (clean.isEmpty) return null;

    final formats = [
      'yyyy-MM-dd HH:mm:ss',
      'yyyy-MM-dd',
      'dd/MM/yyyy HH:mm:ss',
      'dd/MM/yyyy',
      'dd-MM-yyyy HH:mm:ss',
      'dd-MM-yyyy',
      'dd-MMM-yyyy',
      'dd MMM yyyy',
      'MM/dd/yyyy',
      'yyyy/MM/dd',
    ];

    for (final fmt in formats) {
      try {
        return DateFormat(fmt).parseLoose(clean);
      } catch (_) {}
    }

    return DateTime.tryParse(clean);
  }
}

class _ColumnMapping {
  final int dateIndex;
  final int amountIndex;
  final int debitIndex;
  final int creditIndex;
  final int descIndex;
  final int refIndex;
  final int typeIndex;

  const _ColumnMapping({
    required this.dateIndex,
    required this.amountIndex,
    required this.debitIndex,
    required this.creditIndex,
    required this.descIndex,
    required this.refIndex,
    required this.typeIndex,
  });
}
