import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../models/weekly_roulette.dart';
import 'ai_service.dart';
import '../../main.dart';

class WeeklyRouletteService {
  final Isar isar;
  final AiService _ai;

  WeeklyRouletteService(this.isar, this._ai);

  /// Returns this week's roulette topic.
  /// If one already exists in the database for this week, returns it.
  /// Otherwise, generates a fresh topic via the LLM and persists it.
  Future<WeeklyRoulette> getThisWeekRoulette() async {
    final now = DateTime.now();
    final weekStart = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: now.weekday - 1));

    // Check if we already have a topic for this week
    var current = await isar.weeklyRoulettes
        .filter()
        .assignedDateGreaterThan(weekStart.subtract(const Duration(seconds: 1)))
        .findFirst();

    if (current != null) return current;

    // No topic this week — generate one via LLM
    current = await _generateTopicFromLLM(weekStart);

    await isar.writeTxn(() async {
      await isar.weeklyRoulettes.put(current!);
    });

    return current;
  }

  /// Calls the LLM to produce a fresh, unique discussion topic.
  /// Returns a populated WeeklyRoulette. On LLM failure, falls back to a
  /// deterministic seed topic so the user is never left with an empty screen.
  Future<WeeklyRoulette> _generateTopicFromLLM(DateTime weekStart) async {
    // Build a week-specific seed so the fallback prompt is deterministic
    final weekNumber = weekStart.millisecondsSinceEpoch ~/ (1000 * 60 * 60 * 24 * 7);

    try {
      final response = await _ai.chat([
        {
          'role': 'system',
          'content': '''You are a knowledge curator for a personal growth app. Your job is to generate ONE fascinating, intellectually stimulating topic for a 5-minute discussion/reading session.

Rules:
- Pick a RANDOM domain from: systems architecture, distributed systems, philosophy of technology, behavioral economics, cognitive science, stoic philosophy, game theory, information theory, evolutionary biology, compiler design, cryptography, mathematical logic, neuroscience, history of science, epistemology.
- The topic must be specific and deep, not generic (e.g. "How B-trees power database indexing" not "Databases").
- Provide a 2-3 sentence summary that gives the reader a concrete mental model or insight they can immediately apply.
- Respond ONLY with valid JSON, no markdown, no extra text.

JSON format:
{"title": "...", "category": "...", "summary": "..."}'''
        },
        {
          'role': 'user',
          'content': 'Generate a unique discussion topic for week #$weekNumber. Make it genuinely surprising and intellectually dense.'
        },
      ]);

      final parsed = _parseTopicJson(response);
      if (parsed != null) {
        return WeeklyRoulette()
          ..topicTitle = parsed['title']!
          ..category = parsed['category']!
          ..summary = parsed['summary']!
          ..assignedDate = weekStart;
      }

      // JSON parsing failed but we got a response — use it as raw summary
      debugPrint('Roulette: LLM returned non-JSON, using raw response as summary.');
      return WeeklyRoulette()
        ..topicTitle = 'AI-Generated Insight'
        ..category = 'Uncategorized'
        ..summary = response.length > 500 ? response.substring(0, 500) : response
        ..assignedDate = weekStart;
    } on AiServiceException catch (e) {
      debugPrint('Roulette: LLM call failed ($e). Falling back to seed topic.');
      return _buildFallbackTopic(weekNumber, weekStart);
    } catch (e) {
      debugPrint('Roulette: Unexpected error during LLM topic generation ($e). Falling back.');
      return _buildFallbackTopic(weekNumber, weekStart);
    }
  }

  /// Parses the LLM JSON response. Returns null if parsing fails.
  Map<String, String>? _parseTopicJson(String raw) {
    try {
      // Strip markdown code fences if the LLM wraps the JSON
      var cleaned = raw.trim();
      if (cleaned.startsWith('```')) {
        cleaned = cleaned.replaceFirst(RegExp(r'^```(?:json)?\s*'), '');
        cleaned = cleaned.replaceFirst(RegExp(r'```\s*$'), '');
        cleaned = cleaned.trim();
      }

      final json = jsonDecode(cleaned) as Map<String, dynamic>;
      final title = json['title']?.toString();
      final category = json['category']?.toString();
      final summary = json['summary']?.toString();

      if (title != null && title.isNotEmpty &&
          category != null && category.isNotEmpty &&
          summary != null && summary.isNotEmpty) {
        return {'title': title, 'category': category, 'summary': summary};
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Deterministic fallback when the LLM is unreachable. Uses week number
  /// to rotate through a minimal set of seed topics so each offline week
  /// still gets a distinct topic. These are NOT mocks — they are genuine
  /// intellectual prompts, just not AI-personalized.
  WeeklyRoulette _buildFallbackTopic(int weekNumber, DateTime weekStart) {
    // A small rotation of genuine deep-dive topics for offline resilience.
    // This is the absolute minimum — the LLM path is the primary source.
    final seeds = [
      ('How B-Trees Power Every Database Index', 'Computer Science',
       'B-trees maintain sorted data with O(log n) lookups by keeping nodes aligned to disk pages. Every SQL WHERE clause and MongoDB query you run is ultimately a B-tree traversal. Understanding this explains why index design dominates database performance.'),
      ('Kahneman\'s Two Systems: Fast & Slow Thinking', 'Cognitive Science',
       'System 1 is automatic, intuitive, and error-prone; System 2 is deliberate, logical, and lazy. Most "bad decisions" happen when System 1 handles problems that require System 2. Recognizing which system is active is the first step to better judgment.'),
      ('Shannon\'s Information Entropy', 'Information Theory',
       'Claude Shannon proved that the information content of a message equals the surprise it delivers. A coin flip carries 1 bit; a loaded die carries less. This single insight built modern compression, cryptography, and machine learning from the ground up.'),
    ];

    final idx = weekNumber % seeds.length;
    final (title, category, summary) = seeds[idx];

    return WeeklyRoulette()
      ..topicTitle = title
      ..category = category
      ..summary = summary
      ..assignedDate = weekStart;
  }

  /// Saves the user's takeaway note for a roulette topic.
  Future<void> saveTakeaway(int id, String? takeaway) async {
    final item = await isar.weeklyRoulettes.get(id);
    if (item != null) {
      item.explored = true;
      item.userTakeaway = takeaway?.trim();
      await isar.writeTxn(() async {
        await isar.weeklyRoulettes.put(item);
      });
    }
  }
}

final weeklyRouletteServiceProvider = Provider<WeeklyRouletteService>((ref) {
  return WeeklyRouletteService(isar, AiService());
});

final thisWeekRouletteProvider = FutureProvider<WeeklyRoulette>((ref) async {
  final service = ref.watch(weeklyRouletteServiceProvider);
  return await service.getThisWeekRoulette();
});
