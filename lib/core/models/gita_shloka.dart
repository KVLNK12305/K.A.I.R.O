import 'package:isar/isar.dart';

part 'gita_shloka.g.dart';

/// A single verse (shloka) from the Bhagavad Gita, cached locally for offline access.
@collection
class GitaShloka {
  Id id = Isar.autoIncrement;

  /// Chapter number (1–18)
  @Index()
  late int chapter;

  /// Verse number within the chapter
  late int verse;

  /// Original Sanskrit text
  late String slok;

  /// Romanized transliteration
  late String transliteration;

  /// English translation (Swami Sivananda)
  late String translation;

  /// Hindi translation (Swami Tejomayananda)
  late String hindiTranslation;

  GitaShloka({
    required this.chapter,
    required this.verse,
    required this.slok,
    required this.transliteration,
    required this.translation,
    required this.hindiTranslation,
  });

  GitaShloka.empty();
}
