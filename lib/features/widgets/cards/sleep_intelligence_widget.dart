import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/sleep_intelligence_service.dart';
import '../../../main.dart';

class SleepIntelligenceWidget extends ConsumerStatefulWidget {
  const SleepIntelligenceWidget({super.key});

  @override
  ConsumerState<SleepIntelligenceWidget> createState() => _SleepIntelligenceWidgetState();
}

class _SleepIntelligenceWidgetState extends ConsumerState<SleepIntelligenceWidget> {
  double _hours = 7.0;
  int _quality = 3;
  bool _isLogging = false;

  @override
  Widget build(BuildContext context) {
    final reportAsync = ref.watch(sleepIntelligenceProvider);
    final todayLogAsync = ref.watch(todaySleepLogProvider);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(Icons.bedtime_rounded, color: Colors.indigoAccent.shade100, size: 16),
                    const SizedBox(width: 6),
                    const Expanded(
                      child: Text(
                        'SLEEP & RECOVERY INTELLIGENCE',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 9,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              todayLogAsync.when(
                data: (log) => log != null
                    ? FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00E676).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFF00E676).withValues(alpha: 0.4)),
                          ),
                          child: Text(
                            'LOGGED: ${log.hoursSlept}h (Q${log.qualityRating})',
                            style: const TextStyle(color: Color(0xFF00E676), fontSize: 8, fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Correlation report summary
          reportAsync.when(
            data: (report) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildMetricBox(
                        'AVG SLEEP',
                        '${report.averageHoursSlept.toStringAsFixed(1)}h',
                        report.averageHoursSlept < 6.5 ? Colors.redAccent : const Color(0xFF00E676),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: _buildMetricBox(
                        'QUALITY INDEX',
                        '${report.averageQuality.toStringAsFixed(1)} / 5',
                        Colors.indigoAccent.shade100,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: _buildMetricBox(
                        'TARGET BED',
                        report.recommendedBedTime,
                        Colors.amber,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0E0E12),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.indigoAccent.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.auto_awesome, color: Colors.indigoAccent.shade100, size: 16),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          report.correlationInsight,
                          style: const TextStyle(color: Colors.white70, fontSize: 11, height: 1.4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            loading: () => const Center(child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator(strokeWidth: 2))),
            error: (e, _) => Text('Error loading recovery insight: $e', style: const TextStyle(color: Colors.redAccent, fontSize: 11)),
          ),

          const SizedBox(height: 16),

          // Quick Log Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'QUICK LOG LAST NIGHT:',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (_isLogging)
                TextButton(
                  onPressed: () => setState(() => _isLogging = false),
                  child: const Text('HIDE', style: TextStyle(color: Colors.white38, fontSize: 10)),
                )
              else
                TextButton(
                  onPressed: () => setState(() => _isLogging = true),
                  child: const Text('+ REC DATA', style: TextStyle(color: Colors.indigoAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
            ],
          ),

          if (_isLogging) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Hours: ', style: TextStyle(color: Colors.white54, fontSize: 11)),
                const SizedBox(width: 8),
                Expanded(
                  child: Slider(
                    value: _hours,
                    min: 3.0,
                    max: 12.0,
                    divisions: 18,
                    label: '${_hours.toStringAsFixed(1)}h',
                    activeColor: Colors.indigoAccent.shade100,
                    onChanged: (v) => setState(() => _hours = v),
                  ),
                ),
                Text('${_hours.toStringAsFixed(1)}h', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
            Row(
              children: [
                const Text('Quality: ', style: TextStyle(color: Colors.white54, fontSize: 11)),
                const SizedBox(width: 8),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [1, 2, 3, 4, 5].map((q) {
                      final isSelected = _quality == q;
                      return InkWell(
                        onTap: () => setState(() => _quality = q),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.indigoAccent.shade100 : Colors.white10,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '$q',
                            style: TextStyle(
                              color: isSelected ? Colors.black : Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final service = SleepIntelligenceService(isar);
                  await service.logSleep(
                    date: DateTime.now(),
                    hours: _hours,
                    quality: _quality,
                  );
                  ref.invalidate(sleepIntelligenceProvider);
                  ref.invalidate(todaySleepLogProvider);
                  if (context.mounted) {
                    setState(() => _isLogging = false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Logged ${_hours.toStringAsFixed(1)}h sleep (Quality: $_quality/5)', style: const TextStyle(color: Colors.white)),
                        backgroundColor: const Color(0xFF141414),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.check, color: Colors.black, size: 16),
                label: const Text('RECORD SLEEP METRICS', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigoAccent.shade100,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMetricBox(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF0B0B0E),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(value, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(label, style: const TextStyle(color: Colors.white38, fontSize: 8, letterSpacing: 0.5, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
