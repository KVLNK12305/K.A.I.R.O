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
import 'core/models/decision_log.dart';
import 'core/models/weekly_autopsy.dart';
import 'core/models/focus_session.dart';
import 'core/models/sleep_log.dart';
import 'core/models/commitment.dart';
import 'core/models/daily_plan.dart';
import 'core/models/financial_event.dart';
import 'core/models/raw_financial_transaction.dart';
import 'core/models/account.dart';
import 'core/models/report.dart';
import 'core/models/weekly_roulette.dart';
import 'core/models/core_observation.dart';
import 'core/models/workout_session.dart';
import 'core/services/notification_service.dart';
import 'core/services/streak_service.dart';
import 'core/services/google_api_service.dart';
import 'core/services/alarm_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/services/home_widget_sync_service.dart';
import 'core/services/financial_ledger_service.dart';

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

    final prefs = await SharedPreferences.getInstance();
    final adaptiveEnabled = prefs.getBool('kairo_adaptive_alarms_enabled') ?? true;
    if (adaptiveEnabled) {
      GoogleApiService().signInSilently().then((account) async {
        if (account != null) {
          final tomorrowEvents = await GoogleApiService().fetchTomorrowEvents();
          final rec = await AlarmService().analyzeAndRecommendAlarm(tomorrowEvents);
          if (rec.hour != 6 || rec.minute != 0) {
            await NotificationService().showAdaptiveAlarmRecommendation(rec.reason);
          }
        }
      }).catchError((e) {
        debugPrint("Notice: Adaptive alarm check error: $e");
      });
    }
  } catch (e) {
    debugPrint("Notice: Notification/Streak init warning: $e");
  }

  // Load environment variables (gracefully handle missing .env in release/device builds)
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint("Notice: .env file not loaded ($e). Falling back to SharedPreferences / environment defaults.");
  }

  // 2. Find a safe, secure folder on your phone to save the database file
  final dir = await getApplicationDocumentsDirectory();

  // 3. Open the database — includes V2 schemas and legacy schemas for clean migration
  isar = await Isar.open([
    // V2 Core Schemas
    CommitmentSchema,
    DailyPlanSchema,
    FinancialEventSchema,
    RawFinancialTransactionSchema,
    AccountSchema,
    ReportSchema,
    WeeklyRouletteSchema,
    CoreObservationSchema,
    WorkoutSessionSchema,

    // Legacy schemas preserved for non-breaking migration
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
    DecisionLogSchema,
    WeeklyAutopsySchema,
    FocusSessionSchema,
    SleepLogSchema,
  ], directory: dir.path);


  // 4. Schedule situational contextual notifications based on live DB state
  NotificationService().scheduleContextualNotifications(isar).catchError((e) {
    debugPrint("Notice: Contextual notification scheduling error: $e");
  });

  // 5. Sync home screen widgets
  HomeWidgetSyncService.syncAllWidgets().catchError((e) {
    debugPrint("Notice: Initial widget sync error: $e");
  });

  // 6. Ingest pending payment notifications and migrate legacy kairo_node files if present
  final financeLedger = FinancialLedgerService(isar);
  financeLedger.migrateKairoNodeIfPresent().then((_) {}).catchError((e) {
    debugPrint("Notice: Kairo node expense migration warning: $e");
  });
  financeLedger.syncAndroidNotifications().then((_) {}).catchError((e) {
    debugPrint("Notice: Android payment notification sync warning: $e");
  });

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
