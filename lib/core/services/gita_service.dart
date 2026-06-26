import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/gita_shloka.dart';

/// Service responsible for fetching, caching, and serving daily Bhagavad Gita shlokas.
class GitaService {
  final Isar isar;

  /// Verse counts per chapter (1-indexed, chapter 1 has 47 verses, etc.)
  static const List<int> _versesPerChapter = [
    47, 72, 43, 42, 29, 47, 30, 28, 34, 42,
    55, 20, 35, 27, 20, 24, 28, 78,
  ];

  static const String _baseUrl = 'https://vedicscriptures.github.io';
  static const String _lastShownDateKey = 'kairo_daily_shloka_last_shown';

  GitaService(this.isar);

  /// Returns true if the local Isar cache has all 700 shlokas.
  Future<bool> isCacheReady() async {
    final count = await isar.gitaShlokas.count();
    return count >= 700;
  }

  /// Fetches all 700 shlokas from the Vedic Scriptures API and caches them in Isar.
  /// This runs only when the cache is empty or incomplete.
  /// Returns the number of shlokas cached.
  Future<int> fetchAndCacheAllShlokas() async {
    final existingCount = await isar.gitaShlokas.count();
    if (existingCount >= 700) return existingCount;

    int cached = 0;

    for (int chapter = 1; chapter <= 18; chapter++) {
      final verseCount = _versesPerChapter[chapter - 1];

      for (int verse = 1; verse <= verseCount; verse++) {
        try {
          // Check if this specific verse already exists
          final existing = await isar.gitaShlokas
              .filter()
              .chapterEqualTo(chapter)
              .and()
              .verseEqualTo(verse)
              .findFirst();

          if (existing != null) {
            cached++;
            continue;
          }

          final response = await http.get(
            Uri.parse('$_baseUrl/slok/$chapter/$verse'),
          );

          if (response.statusCode == 200) {
            final data = jsonDecode(response.body);

            final shloka = GitaShloka(
              chapter: chapter,
              verse: verse,
              slok: data['slok'] ?? '',
              transliteration: data['transliteration'] ?? '',
              translation: data['siva']?['et'] ?? data['purohit']?['et'] ?? '',
              hindiTranslation: data['tej']?['ht'] ?? '',
            );

            await isar.writeTxn(() async {
              await isar.gitaShlokas.put(shloka);
            });

            cached++;
          }

          // Small delay to be respectful to the API
          await Future.delayed(const Duration(milliseconds: 50));
        } catch (e) {
          // Skip failed verses and continue — partial cache is better than none
          continue;
        }
      }
    }

    return cached;
  }

  /// Returns today's shloka using deterministic day-of-year selection.
  /// Returns null if the cache is empty.
  Future<GitaShloka?> getDailyShloka() async {
    final count = await isar.gitaShlokas.count();
    if (count == 0) return null;

    // Deterministic: same shloka for the entire calendar day
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    final index = dayOfYear % count;

    final allShlokas = await isar.gitaShlokas
        .where()
        .offset(index)
        .limit(1)
        .findAll();

    return allShlokas.isNotEmpty ? allShlokas.first : null;
  }

  /// Returns true if the daily shloka popup has already been shown today.
  Future<bool> hasShownToday() async {
    final prefs = await SharedPreferences.getInstance();
    final lastShown = prefs.getString(_lastShownDateKey);
    final today = DateTime.now().toIso8601String().substring(0, 10); // YYYY-MM-DD
    return lastShown == today;
  }

  /// Marks today's shloka as shown.
  Future<void> markShownToday() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    await prefs.setString(_lastShownDateKey, today);
  }
}
