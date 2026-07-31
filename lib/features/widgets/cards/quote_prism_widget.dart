import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../../core/theme/app_theme.dart';
import '../../../main.dart';
import '../../../core/models/gita_shloka.dart';

/// Provider that fetches a list of cached shlokas from Isar.
final quoteListProvider = FutureProvider<List<GitaShloka>>((ref) async {
  final shlokas = await isar.gitaShlokas.where().findAll();
  if (shlokas.isNotEmpty) return shlokas;

  // Fallback default if cache hasn't populated yet
  return [
    GitaShloka(
      chapter: 2,
      verse: 47,
      slok: 'कर्मण्येवाधिकारस्ते मा फलेषु कदाचन।\nमा कर्मफलहेतुर्भूर्मा ते सङ्गोऽस्त्वकर्मणि॥',
      transliteration: 'karmaṇy-evādhikāras te mā phaleṣu kadācana\nmā karma-phala-hetur bhūr mā te saṅgo ’stv akarmaṇi',
      translation: 'You have a right to perform your prescribed duties, but you are not entitled to the fruits of your actions. Never consider yourself to be the cause of the results of your activities, nor be attached to inaction.',
      hindiTranslation: 'तुम्हारा अधिकार केवल कर्म करने में है, फलों में कभी नहीं।',
    )
  ];
});

/// "Quote Prism" — A luxury frosted glass widget that rotates through
/// Bhagavad Gita shlokas with animated prismatic refraction light effects on its edges.
class QuotePrismWidget extends ConsumerStatefulWidget {
  const QuotePrismWidget({super.key});

  @override
  ConsumerState<QuotePrismWidget> createState() => _QuotePrismWidgetState();
}

class _QuotePrismWidgetState extends ConsumerState<QuotePrismWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _prismController;
  int _currentIndex = 0;
  Timer? _rotateTimer;

  @override
  void initState() {
    super.initState();
    _prismController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _rotateTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      _nextQuote();
    });
  }

  void _nextQuote() {
    final shlokas = ref.read(quoteListProvider).valueOrNull;
    if (shlokas != null && shlokas.length > 1) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % shlokas.length;
      });
    }
  }

  @override
  void dispose() {
    _prismController.dispose();
    _rotateTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quotesAsync = ref.watch(quoteListProvider);

    return GestureDetector(
      onTap: _nextQuote,
      child: AnimatedBuilder(
        animation: _prismController,
        builder: (context, _) {
          return Container(
            padding: const EdgeInsets.all(1.5), // Prismatic border width
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: SweepGradient(
                center: Alignment.center,
                startAngle: 0.0,
                endAngle: math.pi * 2,
                transform: GradientRotation(_prismController.value * math.pi * 2),
                colors: const [
                  Color(0xFFFF6B6B),
                  Color(0xFFFFE66D),
                  Color(0xFF4ECDC4),
                  Color(0xFF45B7D1),
                  Color(0xFFDDA0DD),
                  Color(0xFFFF6B6B),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF8B5CF6).withValues(alpha: 0.2),
                  blurRadius: 20,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.cardWhite,
              borderRadius: BorderRadius.circular(18.5),
            ),
            child: quotesAsync.when(
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(color: AppTheme.inkBlack, strokeWidth: 2),
                  ),
                ),
              ),
              error: (_, _) => const Center(
                child: Text('—', style: TextStyle(color: AppTheme.inkBlack)),
              ),
              data: (shlokas) {
                if (shlokas.isEmpty) return const SizedBox();
                final quote = shlokas[_currentIndex % shlokas.length];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Row(
                            children: [
                              Icon(
                                Icons.auto_awesome_rounded,
                                color: AppTheme.inkBlack,
                                size: 16,
                              ),
                              SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  'QUOTE PRISM • WISDOM',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: AppTheme.inkBlack,
                                    fontSize: 10,
                                    letterSpacing: 1.5,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppTheme.inkBlack,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'CH ${quote.chapter}:${quote.verse}',
                            style: const TextStyle(
                              color: AppTheme.pastelAmber,
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'monospace',
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                        const SizedBox(height: 14),

                        // Sanskrit verse
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 600),
                          child: Text(
                            quote.slok,
                            key: ValueKey(quote.slok),
                            style: const TextStyle(
                              color: AppTheme.inkBlack,
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(height: 0.5, color: Colors.black.withValues(alpha: 0.1)),
                        const SizedBox(height: 12),

                        // English translation
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 600),
                          child: Text(
                            '"${quote.translation}"',
                            key: ValueKey(quote.translation),
                            style: TextStyle(
                              color: AppTheme.inkBlack.withValues(alpha: 0.8),
                              fontSize: 12,
                              height: 1.5,
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Hint
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'TAP TO ROTATE',
                            style: TextStyle(
                              color: AppTheme.inkBlack.withValues(alpha: 0.4),
                              fontSize: 8,
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            );
          },
        ),
      );
  }
}
