package com.kairo.app

import android.app.AppOpsManager
import android.app.NotificationManager
import android.app.usage.UsageStatsManager
import android.content.Context
import android.content.Intent
import android.os.Process
import android.provider.Settings
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.Calendar

class WellbeingChannel(private val context: Context, flutterEngine: FlutterEngine) {
    private val channelName = "com.kairo.app/wellbeing"
    private val channel: MethodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
    private val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
    private val appOps = context.getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
    private val usageStatsManager = context.getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager

    init {
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "checkDndPermission" -> {
                    val granted = notificationManager.isNotificationPolicyAccessGranted
                    result.success(granted)
                }
                "requestDndPermission" -> {
                    if (!notificationManager.isNotificationPolicyAccessGranted) {
                        val intent = Intent(Settings.ACTION_NOTIFICATION_POLICY_ACCESS_SETTINGS)
                        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                        context.startActivity(intent)
                        result.success(true)
                    } else {
                        result.success(false)
                    }
                }
                "setFocusMode" -> {
                    val enabled = call.argument<Boolean>("enabled") ?: false
                    try {
                        if (notificationManager.isNotificationPolicyAccessGranted) {
                            if (enabled) {
                                notificationManager.setInterruptionFilter(NotificationManager.INTERRUPTION_FILTER_PRIORITY)
                            } else {
                                notificationManager.setInterruptionFilter(NotificationManager.INTERRUPTION_FILTER_ALL)
                            }
                            result.success(true)
                        } else {
                            result.error("PERMISSION_DENIED", "Notification Policy Access not granted", null)
                        }
                    } catch (e: Exception) {
                        result.error("ERROR", e.message, null)
                    }
                }
                "checkUsagePermission" -> {
                    val mode = appOps.checkOpNoThrow(
                        AppOpsManager.OPSTR_GET_USAGE_STATS,
                        Process.myUid(),
                        context.packageName
                    )
                    result.success(mode == AppOpsManager.MODE_ALLOWED)
                }
                "requestUsagePermission" -> {
                    val intent = Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS)
                    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    context.startActivity(intent)
                    result.success(true)
                }
                "getDailyScreenTime" -> {
                    try {
                        val calendar = Calendar.getInstance()
                        calendar.set(Calendar.HOUR_OF_DAY, 0)
                        calendar.set(Calendar.MINUTE, 0)
                        calendar.set(Calendar.SECOND, 0)
                        calendar.set(Calendar.MILLISECOND, 0)
                        val startTime = calendar.timeInMillis
                        val endTime = System.currentTimeMillis()

                        val stats = usageStatsManager.queryUsageStats(
                            UsageStatsManager.INTERVAL_DAILY,
                            startTime,
                            endTime
                        )

                        var totalForegroundTime = 0L
                        if (stats != null) {
                            for (usageStats in stats) {
                                totalForegroundTime += usageStats.totalTimeInForeground
                            }
                        }
                        
                        val hours = totalForegroundTime.toDouble() / (1000.0 * 60.0 * 60.0)
                        result.success(hours)
                    } catch (e: Exception) {
                        result.error("ERROR", "Failed to fetch screen time: ${e.message}", null)
                    }
                }
                "getScreenTimeSince" -> {
                    try {
                        val startTime = (call.argument<Number>("startMillis") ?: 0L).toLong()
                        val endTime = System.currentTimeMillis()

                        val stats = usageStatsManager.queryUsageStats(
                            UsageStatsManager.INTERVAL_DAILY,
                            startTime,
                            endTime
                        )

                        var totalForegroundTime = 0L
                        if (stats != null) {
                            for (usageStats in stats) {
                                totalForegroundTime += usageStats.totalTimeInForeground
                            }
                        }

                        val hours = totalForegroundTime.toDouble() / (1000.0 * 60.0 * 60.0)
                        result.success(hours)
                    } catch (e: Exception) {
                        result.error("ERROR", "Failed to fetch screen time: ${e.message}", null)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}
