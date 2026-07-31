import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'providers/auth_provider.dart';
import 'providers/profile_provider.dart';
import '../wardrobe/wardrobe_page.dart';
import '../../Nav/smooth_page_route.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/cards/bento_card.dart';
import '../widgets/cards/discipline_heatmap_widget.dart';

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
        elevation: 0,
        title: const Text(
          "SYSTEM PROFILE",
          style: TextStyle(
            letterSpacing: 2,
            fontSize: 12,
            fontWeight: FontWeight.w900,
            color: AppTheme.cardWhite,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Time & Date Clock Banner (Pastel Blue Bento Card)
            BentoCard(
              backgroundColor: AppTheme.pastelBlue,
              borderColor: Colors.black.withValues(alpha: 0.12),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      timeString,
                      style: const TextStyle(
                        fontSize: 44,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                        fontFamily: 'monospace',
                        color: AppTheme.inkBlack,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dateString.toUpperCase(),
                      style: TextStyle(
                        color: AppTheme.inkBlack.withValues(alpha: 0.7),
                        letterSpacing: 2,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 2. Identity & Clerk Auth Card (Pastel Pink Bento Card)
            BentoCard(
              backgroundColor: AppTheme.pastelPink,
              borderColor: Colors.black.withValues(alpha: 0.12),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: AppTheme.inkBlack,
                    backgroundImage: (clerkUser?.photoUrl != null || user?.photoUrl != null)
                        ? NetworkImage(clerkUser?.photoUrl ?? user!.photoUrl!)
                        : null,
                    child: (clerkUser?.photoUrl == null && user?.photoUrl == null)
                        ? const Icon(
                            Icons.person_rounded,
                            size: 26,
                            color: AppTheme.pastelPink,
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
                                    "OFFLINE OPERATOR",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1,
                                  color: AppTheme.inkBlack,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (clerkUser != null)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppTheme.inkBlack,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  "CLERK VERIFIED",
                                  style: TextStyle(
                                    color: AppTheme.pastelAmber,
                                    fontSize: 8,
                                    fontWeight: FontWeight.w900,
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
                              "Zero-Config Local Auth • Tap below to connect Cloud",
                          style: TextStyle(
                            color: AppTheme.inkBlack.withValues(alpha: 0.7),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
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

            // 3. Discipline Heatmap Section
            const DisciplineHeatmapWidget(),
            const SizedBox(height: 20),

            // 4. Demographics & Hostility Seeding (Pastel Amber Bento Card)
            BentoCard(
              backgroundColor: AppTheme.pastelAmber,
              borderColor: Colors.black.withValues(alpha: 0.12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "DEMOGRAPHICS & HOSTILITY SEEDING",
                        style: TextStyle(
                          color: AppTheme.inkBlack,
                          fontSize: 10,
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                        ),
                      ),
                      Icon(Icons.shield_outlined, size: 14, color: AppTheme.inkBlack),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _buildInputField(
                    'CORE IDENTITY',
                    'e.g. A relentless builder',
                    _identityCtrl,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildInputField(
                          'BASE HOURLY RATE (\$)',
                          'Value (e.g. 150)',
                          _rateCtrl,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInputField(
                          'AGE',
                          'Existential Tracking',
                          _ageCtrl,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.coralRed,
                        foregroundColor: AppTheme.cardWhite,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _saveDemographics,
                      child: const Text(
                        'UPDATE SECURE PROFILE',
                        style: TextStyle(
                          color: AppTheme.cardWhite,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 5. Digital Wardrobe & External Auth Actions
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppTheme.pastelGreen,
                  foregroundColor: AppTheme.inkBlack,
                  side: BorderSide(color: Colors.black.withValues(alpha: 0.15)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Navigator.push(
                  context,
                  SmoothPageRoute(page: const WardrobePage()),
                ),
                icon: const Icon(Icons.checkroom_rounded, size: 18, color: AppTheme.inkBlack),
                label: const Text(
                  'OPEN DIGITAL WARDROBE',
                  style: TextStyle(
                    color: AppTheme.inkBlack,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 6. Identity & Auth Service Actions (Clerk / Google)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.cardWhite,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "CLOUD SERVICES & IDENTITY SYNC",
                    style: TextStyle(
                      color: AppTheme.inkBlack,
                      fontSize: 10,
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.inkBlack,
                        foregroundColor: AppTheme.cardWhite,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
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
                        color: AppTheme.cardWhite,
                      ),
                      label: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          clerkUser == null
                              ? "SIGN IN WITH GOOGLE VIA CLERK"
                              : "DISCONNECT CLERK SESSION",
                          style: const TextStyle(
                            color: AppTheme.cardWhite,
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
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
                        user == null ? Icons.calendar_month_outlined : Icons.check_circle_outline,
                        size: 18,
                        color: user == null ? AppTheme.coralRed : const Color(0xFF2E7D32),
                      ),
                      label: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          user == null
                              ? "CONNECT GOOGLE CALENDAR & TASKS"
                              : "CONNECTED: ${user.email} (DISCONNECT)",
                          style: TextStyle(
                            color: user == null ? AppTheme.coralRed : const Color(0xFF2E7D32),
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: user == null
                              ? AppTheme.coralRed.withValues(alpha: 0.4)
                              : const Color(0xFF2E7D32).withValues(alpha: 0.4),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
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
            color: AppTheme.inkBlack,
            fontSize: 9,
            letterSpacing: 1.2,
            fontFamily: 'monospace',
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(
            color: AppTheme.inkBlack,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: AppTheme.inkBlack.withValues(alpha: 0.4),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.6),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.1)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppTheme.inkBlack, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
