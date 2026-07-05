import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:isar/isar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'Nav/splash_screen.dart';
import 'core/theme/app_theme.dart';
import 'core/models/task.dart';
import 'core/models/daily_metric.dart';
import 'core/models/clothing_item.dart';
import 'core/models/brutalist_review.dart';
import 'core/models/psychosomatic_scan.dart';
import 'core/models/liar_goal.dart';
import 'core/models/crucible_state.dart';
import 'core/models/user_profile.dart';
import 'core/models/memory_edge.dart';
import 'core/models/book.dart';
import 'core/models/idea.dart';
import 'core/models/project.dart';
import 'core/models/gita_shloka.dart';
import 'core/services/notification_service.dart';
import 'core/services/streak_service.dart';

// Create a global instance of Isar so any screen can access it easily
late Isar isar;

Future<void> main() async {
  // 1. Ensure Flutter engine bindings are ready before doing async native disk tasks
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize notifications and habit streak tracking
  try {
    await NotificationService().init();
    await NotificationService().scheduleDailyNotifications();
    await StreakService().initOrCheckStreak();
  } catch (e) {
    debugPrint("Notice: Notification/Streak init warning: \$e");
  }

  // Load environment variables (gracefully handle missing .env in release/device builds)
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint("Notice: .env file not loaded (\$e). Falling back to SharedPreferences / environment defaults.");
  }

  // 2. Find a safe, secure folder on your phone to save the database file
  final dir = await getApplicationDocumentsDirectory();

  // 3. Open the database — all schemas including the new ruthless feature collections
  isar = await Isar.open([
    TaskSchema,
    DailyMetricSchema,
    ClothingItemSchema,
    BrutalistReviewSchema,
    PsychosomaticScanSchema,
    LiarGoalSchema,
    CrucibleStateSchema,
    UserProfileSchema,
    MemoryEdgeSchema,
    BookSchema,
    IdeaSchema,
    ProjectSchema,
    GitaShlokaSchema,
  ], directory: dir.path);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'K.A.I.R.O',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.brutalist,
      home: const SplashScreen(),
    );
  }
}
