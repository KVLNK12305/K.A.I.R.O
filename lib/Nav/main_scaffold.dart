import 'package:flutter/material.dart';
import '../features/dashboard/command_center_page.dart';
import '../features/dashboard/inbox_page.dart';
import '../features/psychosomatic/psychosomatic_page.dart';
import '../features/liars_chart/liars_chart_page.dart';
import 'floating_command_dock.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    CommandCenterPage(),
    InboxPage(),
    PsychosomaticPage(),
    LiarsChartPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // The active page
          Positioned.fill(
            child: _pages[_currentIndex],
          ),
          
          // The floating command dock
          Positioned(
            left: 0,
            right: 0,
            bottom: 32, // Floating above the bottom edge
            child: Center(
              child: FloatingCommandDock(
                currentIndex: _currentIndex,
                onItemSelected: (index) {
                  setState(() => _currentIndex = index);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

