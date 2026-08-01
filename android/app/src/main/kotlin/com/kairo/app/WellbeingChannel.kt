package com.kairo.app

import android.app.NotificationManager
import android.content.Context
import android.content.Intent
import android.provider.Settings
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class WellbeingChannel(private val context: Context, flutterEngine: FlutterEngine) {
    private val channelName = "com.kairo.app/wellbeing"
    private val channel: MethodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
    private val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

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
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}
