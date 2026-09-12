import 'package:flutter/material.dart';
import '../../../core/theme/kairo_design_system.dart';
import '../../../core/models/gita_shloka.dart';
import '../../../core/services/gita_service.dart';
import '../../../main.dart';

class DailyShlokaModal {
  static Future<void> show(BuildContext context) async {
    final gitaService = GitaService(isar);
    GitaShloka? shloka = await gitaService.getDailyShloka();

    // High-impact doctrine fallback if database cache is not yet seeded
    if (shloka == null) {
      shloka = GitaShloka(
        chapter: 2,
        verse: 47,
        slok: 'कर्मण्येवाधिकारस्ते मा फलेषु कदाचन।\nमा कर्मफलहेतुर्भूर्मा ते सङ्गोऽस्त्वकर्मणि॥',
        transliteration: 'karmaṇy-evādhikāras te mā phaleṣhu kadāchana\nmā karma-phala-hetur bhūr mā te saṅgo ’stvakarmaṇi',
        translation: 'You have a right to perform your prescribed duties, but you are not entitled to the fruits of your actions. Never consider yourself to be the cause of the results of your activities, nor be attached to inaction.',
        hindiTranslation: 'तुम्हारा अधिकार केवल कर्म करने में है, उसके फलों में कभी नहीं। इसलिए कर्मफल के कारण मत बनो और न ही अकर्मण्यता में तुम्हारी आसक्ति हो।',
      );
      // Trigger background cache fetch without blocking the UI
      gitaService.fetchAndCacheAllShlokas().catchError((_) => 0);
    }

    if (!context.mounted) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: KairoTheme.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(KairoTheme.radiusLg)),
        side: BorderSide(color: KairoTheme.border),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: KairoTheme.xl,
            right: KairoTheme.xl,
            top: KairoTheme.xl,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + KairoTheme.xl,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "DAILY GITA CONTEMPLATION",
                      style: TextStyle(
                        color: KairoTheme.textPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'monospace',
                        letterSpacing: 1.2,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: KairoTheme.textMuted, size: 18),
                      onPressed: () => Navigator.pop(ctx),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: KairoTheme.xs),
                KairoStatus(
                  label: "BHAGAVAD GITA // CHAPTER ${shloka!.chapter}, VERSE ${shloka.verse}",
                  type: KairoStatusType.recommended,
                ),
                const SizedBox(height: KairoTheme.lg),

                // Sanskrit Verse
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(KairoTheme.md),
                  decoration: BoxDecoration(
                    color: KairoTheme.surfaceElevated,
                    borderRadius: BorderRadius.circular(KairoTheme.radiusSm),
                    border: Border.all(color: KairoTheme.border),
                  ),
                  child: Text(
                    shloka.slok,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: KairoTheme.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      height: 1.6,
                    ),
                  ),
                ),
                const SizedBox(height: KairoTheme.md),

                // Romanized Transliteration
                Text(
                  shloka.transliteration,
                  style: const TextStyle(
                    color: KairoTheme.observed,
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                    height: 1.4,
                  ),
                ),
                const KairoDivider(verticalMargin: KairoTheme.md),

                // English Translation
                const Text(
                  "ENGLISH TRANSLATION",
                  style: TextStyle(color: KairoTheme.textMuted, fontSize: 9, fontWeight: FontWeight.bold, fontFamily: 'monospace'),
                ),
                const SizedBox(height: 4),
                Text(
                  shloka.translation,
                  style: const TextStyle(
                    color: KairoTheme.textSecondary,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: KairoTheme.md),

                // Hindi Translation
                if (shloka.hindiTranslation.isNotEmpty) ...[
                  const Text(
                    "हिंदी अनुवाद",
                    style: TextStyle(color: KairoTheme.textMuted, fontSize: 9, fontWeight: FontWeight.bold, fontFamily: 'monospace'),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    shloka.hindiTranslation,
                    style: const TextStyle(
                      color: KairoTheme.textSecondary,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: KairoTheme.lg),
                ],

                KairoButton(
                  text: "DISMISS CONTEMPLATION",
                  isPrimary: true,
                  isFullWidth: true,
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
