import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

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

  Future<void> syncFromKairoNode() async {
    try {
      final appDir = await getApplicationSupportDirectory();
      final file = File('${appDir.path}/kairo_node_expenses.csv');
      
      if (!await file.exists()) return;
      
      final csvString = await file.readAsString();
      final List<List<dynamic>> rows = const CsvToListConverter(eol: '\n').convert(csvString);
      if (rows.length <= 1) return; // Only header

      double todayTotal = 0.0;
      double monthTotal = 0.0;
      
      final now = DateTime.now();
      final todayStr = DateFormat('yyyy-MM-dd').format(now);
      final monthStr = DateFormat('yyyy-MM').format(now);

      for (int i = 1; i < rows.length; i++) {
        final row = rows[i];
        if (row.length < 3) continue;

        final date = row[0].toString();
        final amountStr = row[2].toString().replaceAll(RegExp(r'[^0-9.]'), '');
        final amount = double.tryParse(amountStr) ?? 0.0;

        if (date.startsWith(todayStr)) {
          todayTotal += amount;
        }
        if (date.startsWith(monthStr)) {
          monthTotal += amount;
        }
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_todayKey, todayTotal);
      await prefs.setDouble(_monthKey, monthTotal);
      
      debugPrint("Synced from KAIRO Node: Today=\$todayTotal, Month=\$monthTotal");
    } catch (e) {
      debugPrint("Error syncing from KAIRO Node CSV: $e");
    }
  }

  Future<void> importAndParseCSV() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final csvString = await file.readAsString();
        
        final List<List<dynamic>> rows = const CsvToListConverter(eol: '\n').convert(csvString);
        if (rows.length <= 1) return; // Only header

        double todayTotal = 0.0;
        double monthTotal = 0.0;
        
        final now = DateTime.now();
        final todayStr = DateFormat('yyyy-MM-dd').format(now);
        final monthStr = DateFormat('yyyy-MM').format(now);

        // Ivy Wallet exports might have different columns depending on version, 
        // but typically date is column 0, amount is a numeric column. 
        // We'll do a generic parse similar to the node receiver.
        for (int i = 1; i < rows.length; i++) {
          final row = rows[i];
          if (row.length < 3) continue;

          final date = row[0].toString();
          // Find the first column that looks like a number for the amount, or just assume it's column 2/3
          // For Ivy Wallet, amount is usually at index 3 or 4 depending on export settings. Let's assume index 3 (Amount)
          // Let's iterate to find a numeric value just to be safe, or just use the last column if it varies
          String amountStr = "0";
          for(var item in row) {
             final s = item.toString();
             // Match basic amounts
             if(s.contains(RegExp(r'[0-9]')) && !s.contains('-') && s.length < 10) {
                 final clean = s.replaceAll(RegExp(r'[^0-9.]'), '');
                 if(double.tryParse(clean) != null && double.tryParse(clean)! > 0) {
                     amountStr = clean;
                     // In a real scenario we'd match the 'Amount' column by header.
                 }
             }
          }
          // Fallback to exactly column 3 if available and our heuristic failed
          if (amountStr == "0" && row.length > 3) {
             amountStr = row[3].toString().replaceAll(RegExp(r'[^0-9.]'), '');
          }

          final amount = double.tryParse(amountStr) ?? 0.0;

          if (date.startsWith(todayStr)) {
            todayTotal += amount;
          }
          if (date.startsWith(monthStr)) {
            monthTotal += amount;
          }
        }

        final prefs = await SharedPreferences.getInstance();
        await prefs.setDouble(_todayKey, todayTotal);
        await prefs.setDouble(_monthKey, monthTotal);
        
        debugPrint("Manually imported CSV: Today=\$todayTotal, Month=\$monthTotal");
      }
    } catch (e) {
      debugPrint("Error parsing CSV: $e");
      throw Exception("Failed to parse CSV: $e");
    }
  }

  /// Calculates the financial Cost of Delay based on hourly rate and uncompleted peak tasks.
  Future<CostOfDelayMetrics> calculateCostOfDelay({
    required double baseHourlyRate,
    required int uncompletedPeakTasks,
    double estimatedHoursPerTask = 2.0,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final todayExpense = prefs.getDouble(_todayKey) ?? 0.0;
    
    final wastedHours = uncompletedPeakTasks * estimatedHoursPerTask;
    final financialLoss = wastedHours * baseHourlyRate;
    final totalBurn = todayExpense + financialLoss;

    return CostOfDelayMetrics(
      uncompletedPeakTasks: uncompletedPeakTasks,
      baseHourlyRate: baseHourlyRate,
      wastedHours: wastedHours,
      financialLoss: financialLoss,
      todayExpense: todayExpense,
      totalEffectiveBurn: totalBurn,
    );
  }
}

class CostOfDelayMetrics {
  final int uncompletedPeakTasks;
  final double baseHourlyRate;
  final double wastedHours;
  final double financialLoss;
  final double todayExpense;
  final double totalEffectiveBurn;

  CostOfDelayMetrics({
    required this.uncompletedPeakTasks,
    required this.baseHourlyRate,
    required this.wastedHours,
    required this.financialLoss,
    required this.todayExpense,
    required this.totalEffectiveBurn,
  });
}

