import 'package:flutter/material.dart';
import '../../core/models/gita_shloka.dart';

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
