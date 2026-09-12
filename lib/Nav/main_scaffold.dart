import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../features/today/today_page.dart';
import '../features/mirror/mirror_page.dart';
import '../features/finance/finance_page.dart';
import '../features/order/order_page.dart';
import '../features/roulette/roulette_page.dart';
import '../core/theme/kairo_design_system.dart';
import 'floating_command_dock.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;
  bool _isDockVisible = true;

  final List<Widget> _pages = const [
    TodayPage(),
    MirrorPage(),
    FinancePage(),
    OrderPage(),
    RoulettePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KairoTheme.background,
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          if (notification.direction == ScrollDirection.reverse && _isDockVisible) {
            setState(() => _isDockVisible = false);
          } else if (notification.direction == ScrollDirection.forward && !_isDockVisible) {
            setState(() => _isDockVisible = true);
          }
          return false;
        },
        child: Stack(
          children: [
            // The active page
            Positioned.fill(
              child: _pages[_currentIndex],
            ),
            
            // The floating command dock (hidden when keyboard is open or scrolling down)
            if (MediaQuery.of(context).viewInsets.bottom == 0)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOutQuart,
                left: 0,
                right: 0,
                bottom: _isDockVisible ? (MediaQuery.of(context).padding.bottom + 16) : -100,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: _isDockVisible ? 1.0 : 0.0,
                  child: Center(
                    child: FloatingCommandDock(
                      currentIndex: _currentIndex,
                      onItemSelected: (index) {
                        setState(() {
                          _currentIndex = index;
                          _isDockVisible = true;
                        });
                      },
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
