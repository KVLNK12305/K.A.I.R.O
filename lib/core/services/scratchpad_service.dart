import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';

final scratchpadServiceProvider = Provider<ScratchpadService>((ref) {
  return ScratchpadService();
});

class ScratchpadService {
  Future<File> _getTodayFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final kairoDir = Directory('${directory.path}/KAIRO/notes');
    
    if (!await kairoDir.exists()) {
      await kairoDir.create(recursive: true);
    }

    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return File('${kairoDir.path}/$today.md');
  }

  Future<String> readTodayNotes() async {
    try {
      final file = await _getTodayFile();
      if (await file.exists()) {
        return await file.readAsString();
      }
      return '';
    } catch (e) {
      debugPrint("Error reading scratchpad: $e");
      return '';
    }
  }

  Future<void> saveTodayNotes(String content) async {
    try {
      final file = await _getTodayFile();
      await file.writeAsString(content);
    } catch (e) {
      debugPrint("Error saving scratchpad: $e");
    }
  }
}
