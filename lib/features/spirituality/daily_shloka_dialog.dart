import 'package:flutter/material.dart';
import '../../main.dart';
import '../../core/models/gita_shloka.dart';
import '../../core/services/gita_service.dart';

/// A premium modal dialog that displays the daily Bhagavad Gita shloka.
/// Designed to feel calm, spiritual, and intentional — not intrusive.
class DailyShlokaDialog extends StatelessWidget {
  final GitaShloka shloka;

  const DailyShlokaDialog({super.key, required this.shloka});

  /// Convenience method to show the dialog.
  static Future<void> show(BuildContext context, GitaShloka shloka) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black87,
      builder: (_) => DailyShlokaDialog(shloka: shloka),
    );
  }

  /// Shows the daily shloka at any time during the day on demand.
  /// If the cache is not yet ready or empty, it fetches or displays a helpful fallback.
  static Future<void> showOnDemand(BuildContext context) async {
    final gitaService = GitaService(isar);
    
    var shloka = await gitaService.getDailyShloka();
    if (shloka == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Fetching sacred verses... Please wait a moment.', style: TextStyle(color: Colors.white)),
            backgroundColor: Color(0xFF2A2A2A),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
          ),
        );
      }
      await gitaService.fetchAndCacheAllShlokas();
      shloka = await gitaService.getDailyShloka();
    }

    if (!context.mounted) return;

    if (shloka != null) {
      await show(context, shloka);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not load Shloka right now. Check internet connection and try again.', style: TextStyle(color: Colors.white)),
          backgroundColor: Color(0xFFCC2222),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompact = screenWidth < 400;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isCompact ? 16 : 24,
        vertical: 40,
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 480),
        decoration: BoxDecoration(
          color: const Color(0xFF0F0F0F),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF2A2A2A),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.amber.withValues(alpha: 0.05),
              blurRadius: 40,
              spreadRadius: 2,
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(isCompact ? 20 : 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Header ornament
                Text(
                  '॥ श्रीमद्भगवद्गीता ॥',
                  style: TextStyle(
                    color: Colors.amber.withValues(alpha: 0.6),
                    fontSize: isCompact ? 12 : 14,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                // Chapter & Verse
                Text(
                  'Chapter ${shloka.chapter}, Verse ${shloka.verse}',
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: isCompact ? 10 : 11,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 20),

                // Divider ornament
                _buildOrnamentDivider(),
                const SizedBox(height: 20),

                // Sanskrit shloka
                Text(
                  shloka.slok,
                  style: TextStyle(
                    color: Colors.amber.withValues(alpha: 0.85),
                    fontSize: isCompact ? 15 : 17,
                    height: 1.8,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // Divider ornament
                _buildOrnamentDivider(),
                const SizedBox(height: 16),

                // Transliteration
                Text(
                  shloka.transliteration,
                  style: TextStyle(
                    color: Colors.white30,
                    fontSize: isCompact ? 12 : 13,
                    fontStyle: FontStyle.italic,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // English translation
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.03),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.06),
                    ),
                  ),
                  child: Text(
                    shloka.translation,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: isCompact ? 13 : 14,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                const SizedBox(height: 24),

                // Dismiss button
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                    ),
                    child: const Text(
                      'REFLECT & CONTINUE',
                      style: TextStyle(
                        color: Colors.white38,
                        fontSize: 11,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrnamentDivider() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 0.5,
            color: Colors.amber.withValues(alpha: 0.15),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            '✦',
            style: TextStyle(
              color: Colors.amber.withValues(alpha: 0.3),
              fontSize: 10,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 0.5,
            color: Colors.amber.withValues(alpha: 0.15),
          ),
        ),
      ],
    );
  }
}

class DailyShlokaBanner extends StatelessWidget {
  const DailyShlokaBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16, bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.amber.withValues(alpha: 0.25),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withValues(alpha: 0.03),
            blurRadius: 15,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => DailyShlokaDialog.showOnDemand(context),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.auto_stories_rounded,
                    color: Colors.amber,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '॥ श्रीमद्भगवद्गीता ॥ SHLOKA OF THE DAY',
                        style: TextStyle(
                          color: Colors.amber.withValues(alpha: 0.8),
                          fontSize: 10,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Tap anytime to read & reflect on today\'s divine verse.',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white24,
                  size: 14,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
