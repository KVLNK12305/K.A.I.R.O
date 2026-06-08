import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'providers/auth_provider.dart';
import 'package:intl/intl.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  late Timer _timer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _now = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timeString = DateFormat('HH:mm:ss').format(_now);
    final dateString = DateFormat('EEEE, MMMM d, yyyy').format(_now);

    final user = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("COMMAND CENTER", style: TextStyle(letterSpacing: 2, fontSize: 14)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
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
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    dateString.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white54,
                      letterSpacing: 2,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Identity Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(10),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white10),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white24,
                    backgroundImage: user?.photoUrl != null ? NetworkImage(user!.photoUrl!) : null,
                    child: user?.photoUrl == null ? const Icon(Icons.person, size: 30, color: Colors.white) : null,
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user?.displayName?.toUpperCase() ?? "KUSHAL", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 2)),
                        const SizedBox(height: 4),
                        Text(user?.email ?? "Cybersecurity / Developer", style: const TextStyle(color: Colors.white54, fontSize: 12), overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 15),

            // Auth Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  if (user == null) {
                    ref.read(authProvider.notifier).login();
                  } else {
                    ref.read(authProvider.notifier).logout();
                  }
                },
                icon: Icon(user == null ? Icons.login : Icons.logout, size: 18),
                label: Text(user == null ? "CONNECT GOOGLE ACCOUNT" : "DISCONNECT GOOGLE"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: user == null ? Colors.blue.withAlpha(50) : Colors.red.withAlpha(50),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Metrics Section (Placeholder for Isar data)
            const Text("SYSTEM METRICS (TODAY)", style: TextStyle(color: Colors.white54, letterSpacing: 1, fontSize: 12)),
            const SizedBox(height: 15),
            _buildMetricTile(Icons.code, "Commits Pushed", "0", Colors.blue),
            _buildMetricTile(Icons.book, "Study Hours", "0.0", Colors.purple),
            _buildMetricTile(Icons.attach_money, "Expenses Logged", "0", Colors.green),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricTile(IconData icon, String label, String value, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.white10),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 12),
              Text(label, style: const TextStyle(color: Colors.white)),
            ],
          ),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }
}
