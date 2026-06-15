import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/services/finance_service.dart';
import 'providers/github_provider.dart';
import 'providers/wakatime_provider.dart';

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

  @override
  void initState() {
    super.initState();
    _loadKeys();
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
      backgroundColor: const Color(0xFF0A0A0A),
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
                "OPENAI (AI COACH)",
                style: TextStyle(color: Colors.white54, fontSize: 10, letterSpacing: 1.5),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _openAiKeyCtrl,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  hintText: "Enter OpenAI API Key",
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
                      await FinanceService().importAndParseCSV();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Ivy Wallet CSV Parsed!"), backgroundColor: Colors.green));
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red));
                      }
                    }
                  },
                  icon: const Icon(Icons.upload_file, color: Colors.white),
                  label: const Text("IMPORT IVY WALLET CSV", style: TextStyle(color: Colors.white, letterSpacing: 1)),
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
            ],
          ),
    );
  }
}
