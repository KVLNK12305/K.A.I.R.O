import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../../core/models/psychosomatic_scan.dart';
import 'psychosomatic_provider.dart';
import '../../core/theme/app_theme.dart';
class PsychosomaticPage extends ConsumerStatefulWidget {
  const PsychosomaticPage({super.key});

  @override
  ConsumerState<PsychosomaticPage> createState() => _PsychosomaticPageState();
}

class _PsychosomaticPageState extends ConsumerState<PsychosomaticPage> {
  final Map<String, int> _sliders = {
    'Muscle Tension': 50,
    'Head / Stomach': 50,
    'Breath Depth': 50,
    'Jaw Clench': 50,
    'Posture': 50,
    'Energy Level': 50,
    'Skin Reaction': 50,
  };

  // Which sliders are "positive" (higher = better)
  static const _positiveIndicators = {'Breath Depth', 'Posture', 'Energy Level'};

  final _contextController = TextEditingController();
  bool _submitted = false;
  
  bool _isStandingDown = false;
  int _standDownSecondsRemaining = 120;
  Timer? _standDownTimer;

  static const Color _accent = AppTheme.accent;
  static const Color _stressHigh = AppTheme.warning;
  static const Color _stressMid = AppTheme.secondary;
  static const Color _stressLow = AppTheme.success;

  @override
  void dispose() {
    _contextController.dispose();
    _standDownTimer?.cancel();
    super.dispose();
  }

  double get _stressScore {
    final stressMapped = _sliders.entries.map((e) {
      return _positiveIndicators.contains(e.key) ? 100 - e.value : e.value;
    });
    final total = stressMapped.reduce((a, b) => a + b);
    return total / _sliders.length;
  }

  Color _stressColor(double score) {
    if (score >= 70) return _stressHigh;
    if (score >= 45) return _stressMid;
    return _stressLow;
  }

  Future<void> _submit() async {
    final score = _stressScore;
    final breathDepth = _sliders['Breath Depth']!;
    
    // Stand Down Logic: High stress + shallow breath
    if (score >= 70 && breathDepth < 40 && !_isStandingDown) {
      setState(() {
        _isStandingDown = true;
        _standDownSecondsRemaining = 120;
      });
      _standDownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_standDownSecondsRemaining <= 1) {
          timer.cancel();
          setState(() {
            _isStandingDown = false;
            _standDownSecondsRemaining = 120;
          });
          _executeSave();
        } else {
          setState(() {
            _standDownSecondsRemaining--;
          });
        }
      });
      return; // Do not save until timer finishes
    }

    await _executeSave();
  }

  Future<void> _executeSave() async {
    await ref.read(psychosomaticProvider.notifier).saveScan(
          muscleTension: _sliders['Muscle Tension']!,
          headStomachDisturbance: _sliders['Head / Stomach']!,
          breathDepth: _sliders['Breath Depth']!,
          jawClench: _sliders['Jaw Clench']!,
          posture: _sliders['Posture']!,
          energyLevel: _sliders['Energy Level']!,
          skinReaction: _sliders['Skin Reaction']!,
          contextLabel: _contextController.text.trim(),
        );
    setState(() => _submitted = true);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(psychosomaticProvider);

    if (state.isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF000000),
        body: Center(child: CircularProgressIndicator(color: Colors.white24)),
      );
    }

    // Pre-fill from today's scan if it exists
    if (state.todayScan != null && !_submitted) {
      final s = state.todayScan!;
      _sliders['Muscle Tension'] = s.muscleTension;
      _sliders['Head / Stomach'] = s.headStomachDisturbance;
      _sliders['Breath Depth'] = s.breathDepth;
      _sliders['Jaw Clench'] = s.jawClench;
      _sliders['Posture'] = s.posture;
      _sliders['Energy Level'] = s.energyLevel;
      _sliders['Skin Reaction'] = s.skinReaction;
      if (_contextController.text.isEmpty) {
        _contextController.text = s.contextLabel;
      }
    }

    final score = _stressScore;
    final color = _stressColor(score);
    final isLocked = state.todayScan != null;

    if (_isStandingDown) {
      return Scaffold(
        backgroundColor: _stressHigh,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.black, size: 64),
              const SizedBox(height: 24),
              const Text(
                'SEVERE DISREGULATION DETECTED',
                style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 2),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 48),
                child: Text(
                  'Your body is in a state of high stress and your breathing is shallow. The system is locked. Stand down and breathe. You cannot escape this.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black87, fontSize: 14, height: 1.5),
                ),
              ),
              const SizedBox(height: 48),
              Text(
                '$_standDownSecondsRemaining',
                style: const TextStyle(color: Colors.black, fontSize: 72, fontWeight: FontWeight.w900),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'BODY SCAN',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 10,
                letterSpacing: 2,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'PSYCHOSOMATIC DASHBOARD',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ─── ALERT BANNER ─────────────────────────────────────────────
            if (state.activeAlert != null) _buildAlert(state.activeAlert!),

            // ─── STRESS SCORE RING ─────────────────────────────────────────
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Column(
                  children: [
                    SizedBox(
                      width: 140,
                      height: 140,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CircularProgressIndicator(
                            value: score / 100,
                            strokeWidth: 10,
                            backgroundColor: Colors.white10,
                            valueColor: AlwaysStoppedAnimation<Color>(color),
                          ),
                          Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  score.toStringAsFixed(0),
                                  style: TextStyle(
                                    color: color,
                                    fontSize: 36,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                Text(
                                  score >= 70
                                      ? 'HIGH STRESS'
                                      : score >= 45
                                          ? 'MODERATE'
                                          : 'REGULATED',
                                  style: TextStyle(
                                    color: color.withValues(alpha: 0.7),
                                    fontSize: 9,
                                    letterSpacing: 1.5,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ─── SLIDERS ──────────────────────────────────────────────────
            ..._sliders.entries.map((entry) {
              return _buildSlider(
                label: entry.key,
                value: entry.value,
                isPositive: _positiveIndicators.contains(entry.key),
                locked: isLocked,
                onChanged: (v) => setState(() => _sliders[entry.key] = v),
              );
            }),

            const SizedBox(height: 28),

            // ─── CONTEXT LABEL ────────────────────────────────────────────
            const Text(
              'CONTEXT (OPTIONAL)',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 10,
                letterSpacing: 2,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Tag this scan to a meeting, person, or event for correlation analysis.',
              style: TextStyle(color: Colors.white38, fontSize: 12),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF111111),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFF2A2A2A)),
              ),
              child: TextField(
                controller: _contextController,
                enabled: !isLocked,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
                decoration: const InputDecoration(
                  hintText: 'e.g., "Call with client X", "Product review meeting"',
                  hintStyle: TextStyle(color: Colors.white24, fontSize: 13),
                  contentPadding: EdgeInsets.all(16),
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 36),

            // ─── HISTORY BARS ─────────────────────────────────────────────
            if (state.history.length > 1) _buildHistoryChart(state.history),

            const SizedBox(height: 36),

            // ─── SUBMIT ───────────────────────────────────────────────────
            if (!isLocked)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _accent,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: const Text(
                    'RECORD BODY STATE',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              )
            else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white10),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'SCAN RECORDED FOR TODAY.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white24,
                    fontSize: 11,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlert(CorrelationAlert alert) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A0A0A),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFCC2222).withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_rounded, color: Color(0xFFCC2222), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'CORRELATION DETECTED',
                  style: TextStyle(
                    color: Color(0xFFCC2222),
                    fontSize: 10,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  alert.message,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlider({
    required String label,
    required int value,
    required bool isPositive,
    required bool locked,
    required ValueChanged<int> onChanged,
  }) {
    // For positive indicators, stress is low when value is high
    final stressValue = isPositive ? 100 - value : value;
    final Color trackColor = stressValue >= 70
        ? _stressHigh
        : stressValue >= 45
            ? _stressMid
            : _stressLow;

    final String valLabel = isPositive
        ? (value >= 70 ? 'Good' : value >= 40 ? 'Fair' : 'Low')
        : (value >= 70 ? 'High' : value >= 40 ? 'Moderate' : 'Low');

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 10,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '$valLabel ($value)',
                style: TextStyle(
                  color: trackColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
              activeTrackColor: trackColor,
              inactiveTrackColor: Colors.white10,
              thumbColor: trackColor,
              overlayColor: trackColor.withValues(alpha: 0.15),
            ),
            child: Slider(
              min: 0,
              max: 100,
              value: value.toDouble(),
              onChanged: locked ? null : (v) => onChanged(v.round()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryChart(List<PsychosomaticScan> history) {
    // Filter out any items whose date is uninitialized (guard against Isar late init)
    final recent = history
        .where((s) => s.date.year > 2000)
        .take(14)
        .toList()
        .reversed
        .toList();
    if (recent.isEmpty) return const SizedBox.shrink();
    const maxScore = 100.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '14-DAY STRESS TREND',
          style: TextStyle(
            color: Colors.white54,
            fontSize: 10,
            letterSpacing: 2,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 80,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: recent.map((scan) {
              final score = scan.stressScore;
              final color = _stressColor(score);
              final fraction = score / maxScore;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Tooltip(
                    message:
                        '${scan.date.month}/${scan.date.day}: ${score.toStringAsFixed(0)}%',
                    child: Container(
                      height: 80 * fraction,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
