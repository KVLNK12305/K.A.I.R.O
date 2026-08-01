import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/services/finance_service.dart';
import '../../core/services/alarm_service.dart';
import '../../core/services/google_api_service.dart';
import '../../core/services/streak_service.dart';
import '../../core/services/notification_service.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/time_audit_service.dart';
import 'providers/github_provider.dart';
import 'providers/wakatime_provider.dart';
import '../crucible/crucible_provider.dart';
import '../../core/services/backup_export_service.dart';
import '../../main.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  final _githubTokenCtrl = TextEditingController();
  final _wakatimeKeyCtrl = TextEditingController();
  final _azureClientIdCtrl = TextEditingController();
  final _openAiKeyCtrl = TextEditingController();
  bool _isLoading = true;
  int _currentStreakDay = 1;
  double _sleepHoursPerNight = 7.0;
  bool _adaptiveAlarmsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadKeys();
    _loadStreak();
    _loadAuditSettings();
  }

  Future<void> _loadAuditSettings() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _sleepHoursPerNight = prefs.getDouble('kairo_sleep_hours_per_night') ?? 7.0;
        _adaptiveAlarmsEnabled = prefs.getBool('kairo_adaptive_alarms_enabled') ?? true;
      });
    }
  }

  Future<void> _loadStreak() async {
    final day = await StreakService().getDayNumber();
    if (mounted) setState(() => _currentStreakDay = day);
  }

  Future<void> _loadKeys() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _githubTokenCtrl.text = prefs.getString('github_token') ?? '';
      _wakatimeKeyCtrl.text = prefs.getString('wakatime_key') ?? '';
      _azureClientIdCtrl.text = prefs.getString('azure_client_id') ?? '';
      _openAiKeyCtrl.text = prefs.getString('openai_key') ?? '';
      _isLoading = false;
    });
  }

  Future<void> _saveKeys() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('github_token', _githubTokenCtrl.text.trim());
    await prefs.setString('wakatime_key', _wakatimeKeyCtrl.text.trim());
    await prefs.setString('azure_client_id', _azureClientIdCtrl.text.trim());
    await prefs.setString('openai_key', _openAiKeyCtrl.text.trim());
    
    // Invalidate the providers so they re-fetch using the new keys
    ref.invalidate(githubPRsProvider);
    ref.invalidate(wakatimeProvider);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("API Keys saved successfully!"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _githubTokenCtrl.dispose();
    _wakatimeKeyCtrl.dispose();
    _azureClientIdCtrl.dispose();
    _openAiKeyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("SYSTEM CONFIG", style: TextStyle(fontSize: 12, letterSpacing: 2, color: Colors.white54)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: Colors.white24))
        : ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const Text(
                "DISCIPLINE ENGINE • ENFORCEMENT",
                style: TextStyle(color: AppTheme.warning, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF141414),
                  border: Border.all(color: AppTheme.warning.withValues(alpha: 0.4)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("21-DAY NEUROLOGICAL REWIRING", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                          SizedBox(height: 4),
                          Text("Daily checkpoint streak status", style: TextStyle(color: Colors.white54, fontSize: 10), overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "DAY $_currentStreakDay / 21",
                      style: const TextStyle(color: AppTheme.warning, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        await AlarmService().setMorningAlarm();
                      },
                      icon: const Icon(Icons.alarm, color: Colors.white, size: 16),
                      label: const FittedBox(fit: BoxFit.scaleDown, child: Text("06:00 ALARM", style: TextStyle(color: Colors.white, fontSize: 11, letterSpacing: 0.5))),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        await AlarmService().setEveningAlarm();
                      },
                      icon: const Icon(Icons.alarm_add, color: Colors.white, size: 16),
                      label: const FittedBox(fit: BoxFit.scaleDown, child: Text("18:00 ALARM", style: TextStyle(color: Colors.white, fontSize: 11, letterSpacing: 0.5))),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final success = await GoogleApiService().createKairoRitualBlocks();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(success ? "5 Daily Ritual Blocks synced to Google Calendar!" : "Failed to sync. Make sure you are signed in to Google."),
                          backgroundColor: success ? Colors.green : AppTheme.warning,
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.calendar_month, color: Colors.white, size: 16),
                  label: const FittedBox(fit: BoxFit.scaleDown, child: Text("SYNC 5 RITUAL BLOCKS TO GOOGLE CALENDAR", style: TextStyle(color: Colors.white, fontSize: 11, letterSpacing: 0.5))),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    NotificationService().showInstantNotification("🔥 Discipline Engine Active", "Push notification channel verified. Do not break your streak.");
                  },
                  icon: const Icon(Icons.notifications_active, color: Colors.white, size: 16),
                  label: const FittedBox(fit: BoxFit.scaleDown, child: Text("TEST PUSH NOTIFICATION CHANNEL", style: TextStyle(color: Colors.white, fontSize: 11, letterSpacing: 0.5))),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Divider(color: Colors.white10),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(child: Text("SLEEP BASELINE (${_sleepHoursPerNight.toStringAsFixed(1)}h / NIGHT)", style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
                  const SizedBox(width: 8),
                  Text("WEEKLY: ${(_sleepHoursPerNight * 7).toStringAsFixed(0)}h", style: const TextStyle(color: AppTheme.warning, fontSize: 11)),
                ],
              ),
              Slider(
                value: _sleepHoursPerNight,
                min: 5.0,
                max: 9.0,
                divisions: 8,
                activeColor: AppTheme.warning,
                inactiveColor: Colors.white12,
                label: "${_sleepHoursPerNight.toStringAsFixed(1)} hours",
                onChanged: (val) {
                  setState(() => _sleepHoursPerNight = val);
                },
                onChangeEnd: (val) async {
                  await TimeAuditService().setSleepBaseline(val);
                },
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                activeThumbColor: AppTheme.warning,
                title: const Text("ADAPTIVE ALARM SCHEDULING", style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                subtitle: const Text("Auto-recommend morning alarm shifts based on Google Calendar commitments.", style: TextStyle(color: Colors.white54, fontSize: 10)),
                value: _adaptiveAlarmsEnabled,
                onChanged: (val) async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('kairo_adaptive_alarms_enabled', val);
                  setState(() => _adaptiveAlarmsEnabled = val);
                },
              ),
              const SizedBox(height: 32),
              const Divider(color: AppTheme.border),
              const SizedBox(height: 24),
              const Text("API CONFIGURATIONS", style: TextStyle(color: Colors.white, fontSize: 14, letterSpacing: 2, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              const Text(
                "GITHUB INTEGRATION",
                style: TextStyle(color: Colors.white54, fontSize: 10, letterSpacing: 1.5),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _githubTokenCtrl,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  hintText: "Enter GitHub PAT (repo scope)",
                  hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.2)),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 32),

              const Text(
                "WAKATIME INTEGRATION",
                style: TextStyle(color: Colors.white54, fontSize: 10, letterSpacing: 1.5),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _wakatimeKeyCtrl,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  hintText: "Enter WakaTime API Key",
                  hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.2)),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 32),

              const Text(
                "MICROSOFT AZURE (TO DO)",
                style: TextStyle(color: Colors.white54, fontSize: 10, letterSpacing: 1.5),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _azureClientIdCtrl,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  hintText: "Enter Azure App Client ID",
                  hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.2)),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.05),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 32),

              const Text(
                "OPENAI / CUSTOM LLM KEY (OPTIONAL)",
                style: TextStyle(color: Colors.white54, fontSize: 10, letterSpacing: 1.5),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _openAiKeyCtrl,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  hintText: "Enter custom API Key (for future fallback)",
                  hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.2)),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.05),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 48),

              const Text(
                "FINANCIAL AWARENESS",
                style: TextStyle(color: Colors.white54, fontSize: 10, letterSpacing: 1.5),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    try {
                      await FinanceService().syncFromKairoNode();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Synced with K.A.I.R.O Node!"), backgroundColor: Colors.green));
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red));
                      }
                    }
                  },
                  icon: const Icon(Icons.sync, color: Colors.white),
                  label: const Text("SYNC K.A.I.R.O NODE", style: TextStyle(color: Colors.white, letterSpacing: 1)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(height: 48),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveKeys,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text("SAVE CONFIGURATION", style: TextStyle(letterSpacing: 1, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 32),
              const Divider(color: AppTheme.border),
              const SizedBox(height: 16),
              const Text(
                "SYSTEM BACKUP & DOSSIER EXPORT",
                style: TextStyle(color: Colors.white54, fontSize: 10, letterSpacing: 1.5, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        try {
                          final file = await BackupExportService(isar).exportFullSystemJson();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("System JSON Exported: ${file.path.split('/').last}"),
                                backgroundColor: const Color(0xFF00E676),
                              ),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Export error: $e"), backgroundColor: Colors.red));
                          }
                        }
                      },
                      icon: const Icon(Icons.data_object, color: Color(0xFF00E676), size: 16),
                      label: const Text("JSON BACKUP", style: TextStyle(color: Color(0xFF00E676), fontSize: 11, fontWeight: FontWeight.bold)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: const Color(0xFF00E676).withValues(alpha: 0.4)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        try {
                          final file = await BackupExportService(isar).exportSystemDossierPdf();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Executive PDF Created: ${file.path.split('/').last}"),
                                backgroundColor: Colors.indigoAccent,
                              ),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("PDF error: $e"), backgroundColor: Colors.red));
                          }
                        }
                      },
                      icon: const Icon(Icons.picture_as_pdf, color: Colors.indigoAccent, size: 16),
                      label: const Text("PDF DOSSIER", style: TextStyle(color: Colors.indigoAccent, fontSize: 11, fontWeight: FontWeight.bold)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: Colors.indigoAccent.withValues(alpha: 0.4)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              const Divider(color: AppTheme.border),
              const SizedBox(height: 16),
              const Text(
                "DANGER ZONE • SYSTEM OVERRIDES",
                style: TextStyle(color: AppTheme.warning, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    ref.read(crucibleProvider.notifier).triggerManual("MANUAL CONFRONTATION TEST");
                    Navigator.pop(context); // Go back to gatekeeper which will catch the active crucible!
                  },
                  icon: const Icon(Icons.warning_amber_rounded, color: AppTheme.warning, size: 18),
                  label: const Text("TRIGGER CRUCIBLE BANKRUPTCY (TEST)", style: TextStyle(color: AppTheme.warning, fontWeight: FontWeight.bold, letterSpacing: 1)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: AppTheme.warning),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            ],
          ),
    );
  }
}
