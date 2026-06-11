import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FinanceMetrics {
  final double todayExpense;
  final double monthExpense;

  FinanceMetrics({required this.todayExpense, required this.monthExpense});
}

class FinanceService {
  static const _todayKey = 'ivy_today_expense';
  static const _monthKey = 'ivy_month_expense';

  Future<FinanceMetrics> getCachedMetrics() async {
    final prefs = await SharedPreferences.getInstance();
    final today = prefs.getDouble(_todayKey) ?? 0.0;
    final month = prefs.getDouble(_monthKey) ?? 0.0;
    return FinanceMetrics(todayExpense: today, monthExpense: month);
  }

  Future<void> importAndParseCSV() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final csvString = await file.readAsString();
        
        final List<List<dynamic>> rows = const CsvToListConverter(eol: '\n').convert(csvString);
        if (rows.isEmpty) return;

        final headers = rows.first.map((e) => e.toString().toLowerCase()).toList();
        
        // Find indices
        int typeIdx = headers.indexWhere((h) => h.contains('type'));
        int amountIdx = headers.indexWhere((h) => h.contains('amount'));
        int dateIdx = headers.indexWhere((h) => h.contains('date'));

        // Fallback indices if header names differ slightly
        if (typeIdx == -1) typeIdx = 0; // Guessing based on typical formats
        if (amountIdx == -1) amountIdx = 4;
        if (dateIdx == -1) dateIdx = 1;

        double todayTotal = 0.0;
        double monthTotal = 0.0;
        
        final now = DateTime.now();
        final todayStr = DateFormat('yyyy-MM-dd').format(now);
        final monthStr = DateFormat('yyyy-MM').format(now);

        for (int i = 1; i < rows.length; i++) {
          final row = rows[i];
          if (row.length <= amountIdx || row.length <= dateIdx || row.length <= typeIdx) continue;

          final type = row[typeIdx].toString().toLowerCase();
          if (!type.contains('expense')) continue; // Only count expenses

          final date = row[dateIdx].toString(); // Assuming format contains yyyy-MM-dd
          final amountStr = row[amountIdx].toString().replaceAll(RegExp(r'[^0-9.]'), '');
          final amount = double.tryParse(amountStr) ?? 0.0;

          if (date.startsWith(todayStr) || date.contains(todayStr)) {
            todayTotal += amount;
          }
          if (date.startsWith(monthStr) || date.contains(monthStr)) {
            monthTotal += amount;
          }
        }

        // Cache the results
        final prefs = await SharedPreferences.getInstance();
        await prefs.setDouble(_todayKey, todayTotal);
        await prefs.setDouble(_monthKey, monthTotal);
        
        debugPrint("Parsed Ivy Wallet: Today=\$todayTotal, Month=\$monthTotal");
      }
    } catch (e) {
      debugPrint("Error parsing Ivy Wallet CSV: $e");
      rethrow;
    }
  }
}
