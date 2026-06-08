import 'package:flutter/material.dart';
import '../features/dashboard/dashboard_page.dart';
import '../features/Coach_chat/ai_coach_chat_page.dart';
import '../features/profile/profile_page.dart';
import '../features/wardrobe/wardrobe_page.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    DashboardPage(),
    WardrobePage(),
    AiCoachChatPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color(0xFF0A0A0A),
        indicatorColor: Colors.white10,
        selectedIndex: _selectedIndex,
        onDestinationSelected: (idx) => setState(() => _selectedIndex = idx),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined, color: Colors.white38),
            selectedIcon: Icon(Icons.dashboard, color: Colors.white),
            label: 'Plan',
          ),
          NavigationDestination(
            icon: Icon(Icons.checkroom_outlined, color: Colors.white38),
            selectedIcon: Icon(Icons.checkroom, color: Colors.white),
            label: 'Wardrobe',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline, color: Colors.white38),
            selectedIcon: Icon(Icons.chat_bubble, color: Colors.white),
            label: 'Coach',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline, color: Colors.white38),
            selectedIcon: Icon(Icons.person, color: Colors.white),
            label: 'You',
          ),
        ],
      ),
    );
  }
}
