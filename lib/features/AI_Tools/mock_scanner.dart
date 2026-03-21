import 'dart:async';
import 'package:flutter/material.dart';

class MockScannerPage extends StatefulWidget {
  final String title;
  final Color accent;

  const MockScannerPage({
    super.key,
    required this.title,
    required this.accent,
  });

  @override
  State<MockScannerPage> createState() => _MockScannerPageState();
}

class _MockScannerPageState extends State<MockScannerPage> {
  bool _scanning = false;
  bool _ready = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(widget.title),
      ),
      body: _ready ? _buildResult() : _buildCameraView(),
    );
  }

  Widget _buildCameraView() {
    return GestureDetector(
      onTap: () {
        setState(() => _scanning = true);
        Timer(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              _scanning = false;
              _ready = true;
            });
          }
        });
      },
      child: Stack(
        children: [
          Container(color: const Color(0xFF111111)),
          Center(
            child: _scanning
                ? const CircularProgressIndicator(color: Colors.white)
                : const Icon(Icons.camera_alt, size: 80, color: Colors.white12),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 100),
              child: Text(
                _scanning ? "AI ANALYZING..." : "TAP SCREEN TO SCAN",
                style: TextStyle(
                  color: _scanning ? Colors.white : Colors.white38,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResult() {
    String result = "Analysis Complete.";

    if (widget.title.contains("Physique")) {
      result = "Body Fat: ~15%\nSymmetry: Good\nWeak Point: Upper Chest";
    } else if (widget.title.contains("Posture")) {
      result = "Neck Tilt: 12° Forward\nShoulders: Rounded\nFix: Face Pulls";
    } else if (widget.title.contains("Food")) {
      result = "Calories: 450\nProtein: 24g\nGrade: A-";
    } else if (widget.title.contains("Outfit")) {
      result = "Fit: Slightly Loose\nColor Match: 90%\nStyle: Clean Casual";
    }

    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, size: 80, color: widget.accent),
          const SizedBox(height: 20),
          const Text(
            "ANALYSIS COMPLETE",
            style: TextStyle(color: Colors.white, fontSize: 20, letterSpacing: 1),
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(26),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white.withAlpha(26),),
            ),
            child: Text(
              result,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 16, height: 1.6),
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
            child: const Text("SAVE TO LOG"),
          ),
        ],
      ),
    );
  }
}
