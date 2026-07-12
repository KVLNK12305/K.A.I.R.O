import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'providers/auth_provider.dart';
import 'providers/profile_provider.dart';
import '../wardrobe/wardrobe_page.dart';
import '../../Nav/smooth_page_route.dart';
import '../../core/theme/app_theme.dart';

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
      _rateCtrl.text = profile.baseHourlyRate > 0
          ? profile.baseHourlyRate.toStringAsFixed(2)
          : '';
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

    ref
        .read(profileProvider.notifier)
        .updateDemographics(
          coreIdentity: _identityCtrl.text,
          baseHourlyRate: rate,
          age: age,
        );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Demographics Locked In.'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final timeString = DateFormat('HH:mm:ss').format(_now);
    final dateString = DateFormat('EEEE, MMMM d, yyyy').format(_now);
    final user = ref.watch(authProvider);
    final clerkUser = ref.watch(clerkAuthProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          "USER PROFILE",
          style: TextStyle(
            letterSpacing: 2,
            fontSize: 12,
            color: Colors.white54,
          ),
        ),
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
                  Text(
                    timeString,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w200,
                      letterSpacing: 4,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    dateString.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white54,
                      letterSpacing: 2,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),

            const Text(
              "DEMOGRAPHICS & HOSTILITY SEEDING",
              style: TextStyle(
                color: Colors.white54,
                fontSize: 10,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            _buildInputField(
              'CORE IDENTITY',
              'e.g. A relentless builder',
              _identityCtrl,
            ),
            const SizedBox(height: 16),
            _buildInputField(
              'BASE HOURLY RATE (\$)',
              'Value of your time (e.g. 150)',
              _rateCtrl,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            _buildInputField(
              'AGE',
              'Used for existential tracking',
              _ageCtrl,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2A2A2A),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _saveDemographics,
                child: const Text(
                  'UPDATE SECURE PROFILE',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 0, 115, 255),
                  side: const BorderSide(color: Color.fromARGB(255, 239, 239, 232)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => Navigator.push(
                  context,
                  SmoothPageRoute(page: const WardrobePage()),
                ),
                icon: const Icon(Icons.checkroom, size: 18),
                label: const Text(
                  'OPEN DIGITAL WARDROBE',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 48),

            const Text(
              "IDENTITY & GOOGLE AUTH VIA CLERK (ZERO CONFIG)",
              style: TextStyle(
                color: Colors.white54,
                fontSize: 10,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 12),

            // Identity Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF111111),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: (clerkUser != null || user != null)
                      ? const Color.fromARGB(255, 48, 58, 161).withValues(alpha: 0.5)
                      : Colors.white10,
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.white10,
                    backgroundImage: (clerkUser?.photoUrl != null || user?.photoUrl != null)
                        ? NetworkImage(clerkUser?.photoUrl ?? user!.photoUrl!)
                        : null,
                    child: (clerkUser?.photoUrl == null && user?.photoUrl == null)
                        ? const Icon(
                            Icons.person,
                            size: 24,
                            color: Colors.white,
                          )
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                clerkUser?.displayName.toUpperCase() ??
                                    user?.displayName?.toUpperCase() ??
                                    "OFFLINE PROTOCOL",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            if (clerkUser != null)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 239, 239, 229).withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: const Color.fromARGB(255, 0, 119, 255)),
                                ),
                                child: const Text(
                                  "CLERK ACTIVE",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 0, 47, 255),
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          clerkUser?.email ??
                              user?.email ??
                              "Google Auth Disconnected (Clerk Zero-Config Available)",
                          style: const TextStyle(
                            color: Colors.white38,
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Clerk Auth Button (Zero Manual Setup)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: clerkUser == null
                      ? const Color.fromARGB(255, 235, 238, 240)
                      : const Color(0xFF2A2A2A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  if (clerkUser == null) {
                    ref.read(clerkAuthProvider.notifier).signInWithGoogle(context);
                  } else {
                    ref.read(clerkAuthProvider.notifier).signOut();
                  }
                },
                icon: Icon(
                  clerkUser == null ? Icons.cloud_done_outlined : Icons.logout,
                  size: 18,
                  color: Colors.white,
                ),
                label: Text(
                  clerkUser == null
                      ? "SIGN IN WITH GOOGLE VIA CLERK (INSTANT)"
                      : "DISCONNECT CLERK GOOGLE SESSION",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Legacy manual Google Auth Button
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
                icon: Icon(
                  user == null ? Icons.login : Icons.logout,
                  size: 18,
                  color: Colors.white54,
                ),
                label: Text(
                  user == null ? "MANUAL GOOGLE SIGN-IN (LEGACY)" : "DISCONNECT LEGACY GOOGLE",
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 11,
                    letterSpacing: 1,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white12),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 120), // Bottom padding for navigation dock
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(
    String label,
    String hint,
    TextEditingController controller, {
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white38,
            fontSize: 10,
            letterSpacing: 1.5,
            fontWeight: FontWeight.bold,
          ),
        ),
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
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
