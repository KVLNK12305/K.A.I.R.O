import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'flip_panel.dart';
import 'flip_clock_themes.dart';
import 'full_screen_flip_clock_page.dart';
import '../providers/widget_preferences_provider.dart';

/// A premium 3D flip clock with split-flap mechanical animation,
/// theme switching, and date/AM-PM display.
class FlipClockWidget extends ConsumerStatefulWidget {
  final bool isFullScreen;
  const FlipClockWidget({super.key, this.isFullScreen = false});

  @override
  ConsumerState<FlipClockWidget> createState() => _FlipClockWidgetState();
}

class _FlipClockWidgetState extends ConsumerState<FlipClockWidget>
    with TickerProviderStateMixin {
  late Timer _timer;
  DateTime _now = DateTime.now();

  // Theme transition
  late AnimationController _themeTransitionController;
  late Animation<double> _themeOpacity;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      final newNow = DateTime.now();
      if (newNow.second != _now.second) {
        setState(() => _now = newNow);
      }
    });

    _themeTransitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _themeOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _themeTransitionController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _themeTransitionController.dispose();
    super.dispose();
  }

  void _cycleTheme() {
    final prefs = ref.read(widgetPreferencesProvider);
    final nextIndex = (prefs.clockThemeIndex + 1) % FlipClockThemes.all.length;

    _themeTransitionController.forward().then((_) {
      ref.read(widgetPreferencesProvider.notifier).setThemeIndex(nextIndex);
      _themeTransitionController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    final prefs = ref.watch(widgetPreferencesProvider);
    final theme = FlipClockThemes.all[prefs.clockThemeIndex.clamp(0, FlipClockThemes.all.length - 1)];

    final is24 = prefs.is24Hour;
    final showSec = prefs.showSeconds;

    int hour = _now.hour;
    String amPm = '';
    if (!is24) {
      amPm = hour >= 12 ? 'PM' : 'AM';
      hour = hour % 12;
      if (hour == 0) hour = 12;
    }

    final h1 = (hour ~/ 10).toString();
    final h2 = (hour % 10).toString();
    final m1 = (_now.minute ~/ 10).toString();
    final m2 = (_now.minute % 10).toString();
    final s1 = (_now.second ~/ 10).toString();
    final s2 = (_now.second % 10).toString();

    final dateStr = DateFormat('EEEE, MMMM d').format(_now);

    final cardW = widget.isFullScreen ? 80.0 : 52.0;
    final cardH = widget.isFullScreen ? 116.0 : 72.0;
    final secW = widget.isFullScreen ? 56.0 : 40.0;
    final secH = widget.isFullScreen ? 80.0 : 56.0;

    return GestureDetector(
      onTap: !widget.isFullScreen
          ? () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const FullScreenFlipClockPage(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                ),
              );
            }
          : null,
      onDoubleTap: _cycleTheme,
      onLongPress: () {
        ref.read(widgetPreferencesProvider.notifier).toggle24Hour();
      },
      child: AnimatedBuilder(
        animation: _themeOpacity,
        builder: (context, _) {
          return Opacity(
            opacity: (1.0 - _themeOpacity.value * 0.5).clamp(0.5, 1.0),
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: widget.isFullScreen ? 40 : 28,
                horizontal: widget.isFullScreen ? 32 : 20,
              ),
              decoration: BoxDecoration(
                color: widget.isFullScreen
                    ? Colors.transparent
                    : theme.backgroundAccent.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(24),
                border: widget.isFullScreen
                    ? null
                    : Border.all(
                        color: theme.reflectionColor.withValues(alpha: 0.08),
                        width: 0.5,
                      ),
                boxShadow: widget.isFullScreen
                    ? []
                    : [
                        BoxShadow(
                          color: theme.glowColor.withValues(alpha: theme.glowIntensity * 0.3),
                          blurRadius: 40,
                          spreadRadius: 0,
                        ),
                      ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ═══ THEME NAME ═══
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      theme.name.toUpperCase(),
                      key: ValueKey(theme.name),
                      style: TextStyle(
                        color: theme.dateTextColor.withValues(alpha: 0.5),
                        fontSize: widget.isFullScreen ? 11 : 9,
                        letterSpacing: 3,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(height: widget.isFullScreen ? 24 : 16),

                  // ═══ CLOCK DIGITS ═══
                  FittedBox(
                    fit: widget.isFullScreen ? BoxFit.contain : BoxFit.scaleDown,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Hours
                        FlipPanel(digit: h1, theme: theme, width: cardW, height: cardH),
                        const SizedBox(width: 4),
                        FlipPanel(digit: h2, theme: theme, width: cardW, height: cardH),

                        // Colon separator
                        _buildColon(theme),

                        // Minutes
                        FlipPanel(digit: m1, theme: theme, width: cardW, height: cardH),
                        const SizedBox(width: 4),
                        FlipPanel(digit: m2, theme: theme, width: cardW, height: cardH),

                        // Seconds (optional)
                        if (showSec) ...[
                          _buildColon(theme),
                          FlipPanel(
                            digit: s1,
                            theme: theme,
                            width: secW,
                            height: secH,
                          ),
                          const SizedBox(width: 3),
                          FlipPanel(
                            digit: s2,
                            theme: theme,
                            width: secW,
                            height: secH,
                          ),
                        ],

                        // AM/PM
                        if (!is24) ...[
                          const SizedBox(width: 10),
                          _buildAmPm(amPm, theme),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // ═══ DATE ═══
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: Text(
                      dateStr.toUpperCase(),
                      key: ValueKey(dateStr),
                      style: TextStyle(
                        color: theme.dateTextColor,
                        fontSize: 11,
                        letterSpacing: 2.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // ═══ HINT ═══
                  Text(
                    'DOUBLE TAP TO SWITCH THEME  •  HOLD FOR 24H',
                    style: TextStyle(
                      color: theme.dateTextColor.withValues(alpha: 0.3),
                      fontSize: 7,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildColon(FlipClockThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.isFullScreen ? 10 : 6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _ColonDot(theme: theme, now: _now, isFullScreen: widget.isFullScreen),
          SizedBox(height: widget.isFullScreen ? 24 : 14),
          _ColonDot(theme: theme, now: _now, isFullScreen: widget.isFullScreen),
        ],
      ),
    );
  }

  Widget _buildAmPm(String amPm, FlipClockThemeData theme) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.3),
            end: Offset.zero,
          ).animate(animation),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      child: Container(
        key: ValueKey(amPm),
        padding: EdgeInsets.symmetric(
          horizontal: widget.isFullScreen ? 14 : 8,
          vertical: widget.isFullScreen ? 10 : 6,
        ),
        decoration: BoxDecoration(
          color: theme.cardColor.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(widget.isFullScreen ? 10 : 6),
          border: Border.all(
            color: theme.reflectionColor.withValues(alpha: 0.2),
            width: 0.5,
          ),
        ),
        child: Text(
          amPm,
          style: TextStyle(
            color: theme.textColor,
            fontSize: widget.isFullScreen ? 16 : 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }
}

/// An animated colon dot that pulses with each second.
class _ColonDot extends StatelessWidget {
  final FlipClockThemeData theme;
  final DateTime now;
  final bool isFullScreen;

  const _ColonDot({
    required this.theme,
    required this.now,
    this.isFullScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    final isEvenSecond = now.second % 2 == 0;
    final dotSize = isFullScreen ? 12.0 : 6.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      width: dotSize,
      height: dotSize,
      decoration: BoxDecoration(
        color: theme.textColor.withValues(alpha: isEvenSecond ? 0.9 : 0.25),
        shape: BoxShape.circle,
        boxShadow: isEvenSecond
            ? [
                BoxShadow(
                  color: theme.glowColor.withValues(alpha: theme.glowIntensity),
                  blurRadius: isFullScreen ? 14 : 8,
                  spreadRadius: isFullScreen ? 2 : 1,
                ),
              ]
            : [],
      ),
    );
  }
}
