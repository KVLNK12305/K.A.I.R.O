import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'flip_clock_widget.dart';
import 'flip_clock_themes.dart';
import '../providers/widget_preferences_provider.dart';

/// Full-screen, rotatable (both 3D tilt and 90°/270° orientation) view
/// of the 3D Split-Flap Mechanical Flip Clock.
class FullScreenFlipClockPage extends ConsumerStatefulWidget {
  const FullScreenFlipClockPage({super.key});

  @override
  ConsumerState<FullScreenFlipClockPage> createState() => _FullScreenFlipClockPageState();
}

class _FullScreenFlipClockPageState extends ConsumerState<FullScreenFlipClockPage>
    with SingleTickerProviderStateMixin {
  // 3D Tilt angles from pan/drag gesture
  double _angleX = 0.0;
  double _angleY = 0.0;

  // 90-degree screen rotation turns (0 = portrait, 1 = landscape right, 2 = upside down, 3 = landscape left)
  int _rotationTurns = 0;

  // Auto-hide overlay
  bool _showOverlay = true;
  Timer? _hideTimer;

  // Optional auto-orbit
  bool _isAutoOrbiting = false;
  late AnimationController _orbitController;

  @override
  void initState() {
    super.initState();
    // Hide status bar/navigation bar for true immersive full screen
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    _orbitController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..addListener(() {
        if (_isAutoOrbiting) {
          setState(() {
            _angleY = math.sin(_orbitController.value * 2 * math.pi) * 0.4;
            _angleX = math.cos(_orbitController.value * 2 * math.pi) * 0.15;
          });
        }
      });

    _startHideTimer();
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(milliseconds: 3500), () {
      if (mounted && _showOverlay) {
        setState(() => _showOverlay = false);
      }
    });
  }

  void _onUserInteraction() {
    if (!_showOverlay) {
      setState(() => _showOverlay = true);
    }
    _startHideTimer();
  }

  void _rotateScreen90() {
    setState(() {
      _rotationTurns = (_rotationTurns + 1) % 4;
    });
    _onUserInteraction();
  }

  void _reset3DTilt() {
    setState(() {
      _angleX = 0.0;
      _angleY = 0.0;
      _isAutoOrbiting = false;
      _orbitController.stop();
    });
    _onUserInteraction();
  }

  void _toggleAutoOrbit() {
    setState(() {
      _isAutoOrbiting = !_isAutoOrbiting;
      if (_isAutoOrbiting) {
        _orbitController.repeat();
      } else {
        _orbitController.stop();
      }
    });
    _onUserInteraction();
  }

  @override
  void dispose() {
    // Restore system UI on exit
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _hideTimer?.cancel();
    _orbitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prefs = ref.watch(widgetPreferencesProvider);
    final theme = FlipClockThemes.all[prefs.clockThemeIndex];

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _onUserInteraction,
        onPanUpdate: (details) {
          _onUserInteraction();
          if (_isAutoOrbiting) {
            _isAutoOrbiting = false;
            _orbitController.stop();
          }
          setState(() {
            _angleY += details.delta.dx * 0.01;
            _angleX -= details.delta.dy * 0.01;
            _angleX = _angleX.clamp(-math.pi / 3, math.pi / 3);
          });
        },
        child: Stack(
          children: [
            // Ambient glow background matching clock theme
            Positioned.fill(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      theme.glowColor.withValues(alpha: theme.glowIntensity * 0.25),
                      Colors.black,
                    ],
                    radius: 1.2,
                  ),
                ),
              ),
            ),

            // ═══ THE ROTATABLE FLIP CLOCK ═══
            Center(
              child: AnimatedRotation(
                turns: _rotationTurns * 0.25,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOutCubic,
                child: Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.0015) // perspective
                    ..rotateX(_angleX)
                    ..rotateY(_angleY),
                  alignment: Alignment.center,
                  child: const Padding(
                    padding: EdgeInsets.all(24.0),
                    child: FlipClockWidget(isFullScreen: true),
                  ),
                ),
              ),
            ),

            // ═══ OVERLAY CONTROLS BAR ═══
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              top: _showOverlay ? 0 : -100,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF16161C).withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white12, width: 0.5),
                  ),
                  child: Row(
                    children: [
                      // Back to Deck
                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: Colors.white, size: 22),
                        onPressed: () => Navigator.of(context).pop(),
                        tooltip: 'Exit Full Screen',
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'FULL SCREEN CLOCK',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 10,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Spacer(),

                      // Rotate 90 degrees button (for bedside/desk orientation)
                      IconButton(
                        icon: const Icon(Icons.rotate_90_degrees_cw_outlined, color: Colors.white, size: 20),
                        onPressed: _rotateScreen90,
                        tooltip: 'Rotate 90° (Landscape/Portrait)',
                      ),

                      // Toggle 3D auto orbit
                      IconButton(
                        icon: Icon(
                          Icons.view_in_ar_rounded,
                          color: _isAutoOrbiting ? const Color(0xFF00E676) : Colors.white70,
                          size: 20,
                        ),
                        onPressed: _toggleAutoOrbit,
                        tooltip: _isAutoOrbiting ? 'Stop Auto Orbit' : 'Start 3D Auto Orbit',
                      ),

                      // Reset 3D tilt
                      if (_angleX != 0.0 || _angleY != 0.0)
                        IconButton(
                          icon: const Icon(Icons.restart_alt_rounded, color: Colors.white70, size: 20),
                          onPressed: _reset3DTilt,
                          tooltip: 'Reset Tilt Angle',
                        ),

                      // Cycle Theme
                      IconButton(
                        icon: const Icon(Icons.palette_outlined, color: Colors.white, size: 20),
                        onPressed: () {
                          _onUserInteraction();
                          final nextIdx = (prefs.clockThemeIndex + 1) % FlipClockThemes.all.length;
                          ref.read(widgetPreferencesProvider.notifier).setThemeIndex(nextIdx);
                        },
                        tooltip: 'Cycle Theme (${theme.name})',
                      ),

                      // 12/24 Hour toggle
                      IconButton(
                        icon: Icon(
                          prefs.is24Hour ? Icons.schedule_rounded : Icons.access_time_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () {
                          _onUserInteraction();
                          ref.read(widgetPreferencesProvider.notifier).toggle24Hour();
                        },
                        tooltip: prefs.is24Hour ? '24-Hour (Tap for 12h)' : '12-Hour (Tap for 24h)',
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Hint text at bottom right when overlay visible
            if (_showOverlay)
              Positioned(
                bottom: 24,
                right: 24,
                child: SafeArea(
                  child: Text(
                    'DRAG TO TILT IN 3D • TAP OR OVERLAY BUTTON TO ROTATE 90°',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.3),
                      fontSize: 8,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
