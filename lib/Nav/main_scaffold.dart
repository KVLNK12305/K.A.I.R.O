import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../features/dashboard/command_center_page.dart';
import '../features/dashboard/inbox_page.dart';
import '../features/psychosomatic/psychosomatic_page.dart';
import '../features/liars_chart/liars_chart_page.dart';
import '../features/Coach_chat/ai_coach_chat_page.dart';
import '../features/spirituality/daily_shloka_dialog.dart';
import '../core/services/gita_service.dart';
import '../core/theme/app_theme.dart';
import '../main.dart';
import 'floating_command_dock.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;
  bool _isDockVisible = true;

  final List<Widget> _pages = [
    const CommandCenterPage(),
    const InboxPage(),
    const PsychosomaticPage(),
    const LiarsChartPage(),
    const AiCoachChatPage(),
  ];

  @override
  void initState() {
    super.initState();
    // Trigger the daily shloka check after the first frame renders
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showDailyShloka();
    });
  }

  Future<void> _showDailyShloka() async {
    final gitaService = GitaService(isar);

    // If cache is empty, start fetching in the background
    final cacheReady = await gitaService.isCacheReady();
    if (!cacheReady) {
      // Start background fetch — don't await it, let it run silently
      gitaService.fetchAndCacheAllShlokas();
    }

    // Check if we've already shown the shloka today
    final alreadyShown = await gitaService.hasShownToday();
    if (alreadyShown) return;

    // Get today's shloka from the cache
    final shloka = await gitaService.getDailyShloka();
    if (shloka == null) return; // Cache not populated yet — will show tomorrow

    // Brief delay so the dashboard loads first
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;

    await DailyShlokaDialog.show(context, shloka);
    await gitaService.markShownToday();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
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
