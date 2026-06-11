import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'providers/auth_provider.dart';
import 'providers/profile_provider.dart';
import '../dashboard/providers/github_provider.dart';
import '../dashboard/providers/wakatime_provider.dart';
import '../dashboard/providers/finance_provider.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  late Timer _timer;
  DateTime _now = DateTime.now();

  final _identityCtrl = TextEditingController();
  final _rateCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();

  bool _isInit = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(() => _now = DateTime.now());
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      final profile = ref.read(profileProvider);
      _identityCtrl.text = profile.coreIdentity;
      _rateCtrl.text = profile.baseHourlyRate > 0 ? profile.baseHourlyRate.toStringAsFixed(2) : '';
      _ageCtrl.text = profile.age > 0 ? profile.age.toString() : '';
      _isInit = true;
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _identityCtrl.dispose();
    _rateCtrl.dispose();
    _ageCtrl.dispose();
    super.dispose();
  }

  void _saveDemographics() {
    final rate = double.tryParse(_rateCtrl.text) ?? 0.0;
    final age = int.tryParse(_ageCtrl.text) ?? 0;
    
    ref.read(profileProvider.notifier).updateDemographics(
      coreIdentity: _identityCtrl.text,
      baseHourlyRate: rate,
      age: age,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Demographics Locked In.'), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    final timeString = DateFormat('HH:mm:ss').format(_now);
    final dateString = DateFormat('EEEE, MMMM d, yyyy').format(_now);
    final user = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("USER PROFILE", style: TextStyle(letterSpacing: 2, fontSize: 12, color: Colors.white54)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Time and Date Section
            Center(
              child: Column(
                children: [
                  Text(timeString, style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w200, letterSpacing: 4, color: Colors.white)),
                  const SizedBox(height: 8),
                  Text(dateString.toUpperCase(), style: const TextStyle(color: Colors.white54, letterSpacing: 2, fontSize: 10)),
                ],
              ),
            ),
            const SizedBox(height: 48),

            const Text("DEMOGRAPHICS & HOSTILITY SEEDING", style: TextStyle(color: Colors.white54, fontSize: 10, letterSpacing: 1.5)),
            const SizedBox(height: 16),
            _buildInputField('CORE IDENTITY', 'e.g. A relentless builder', _identityCtrl),
            const SizedBox(height: 16),
            _buildInputField('BASE HOURLY RATE (\$)', 'Value of your time (e.g. 150)', _rateCtrl, keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            _buildInputField('AGE', 'Used for existential tracking', _ageCtrl, keyboardType: TextInputType.number),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2A2A2A),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: _saveDemographics,
                child: const Text('UPDATE SECURE PROFILE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1)),
              ),
            ),
            const SizedBox(height: 48),

            // Identity Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: const Color(0xFF111111), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white10)),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.white10,
                    backgroundImage: user?.photoUrl != null ? NetworkImage(user!.photoUrl!) : null,
                    child: user?.photoUrl == null ? const Icon(Icons.person, size: 24, color: Colors.white) : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user?.displayName?.toUpperCase() ?? "OFFLINE PROTOCOL", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1, color: Colors.white)),
                        const SizedBox(height: 4),
                        Text(user?.email ?? "Google Auth Disconnected", style: const TextStyle(color: Colors.white38, fontSize: 12), overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Auth Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  if (user == null) {
                    ref.read(authProvider.notifier).login();
                  } else {
                    ref.read(authProvider.notifier).logout();
                  }
                },
                icon: Icon(user == null ? Icons.login : Icons.logout, size: 18, color: Colors.white),
                label: Text(user == null ? "CONNECT GOOGLE ACCOUNT" : "DISCONNECT GOOGLE", style: const TextStyle(color: Colors.white, fontSize: 12, letterSpacing: 1)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white24),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
            const SizedBox(height: 120), // Bottom padding for navigation dock
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, String hint, TextEditingController controller, {TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 10, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white24),
            filled: true,
            fillColor: const Color(0xFF111111),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }
}
