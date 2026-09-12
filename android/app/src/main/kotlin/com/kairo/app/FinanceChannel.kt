package com.kairo.app

import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.os.Handler
import android.os.Looper
import android.provider.Settings
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class FinanceChannel(private val context: Context, flutterEngine: FlutterEngine) {
    private val channelName = "com.kairo.app/finance"
    private val channel: MethodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
    private val mainHandler = Handler(Looper.getMainLooper())

    init {
        // Wire real-time notification callback to Flutter
        KairoNotificationListenerService.onNotificationCapturedListener = {
            mainHandler.post {
                channel.invokeMethod("onNotificationReceived", null)
            }
        }

        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "checkNotificationListenerPermission" -> {
                    try {
                        val cn = ComponentName(context, KairoNotificationListenerService::class.java)
                        val flat = Settings.Secure.getString(context.contentResolver, "enabled_notification_listeners")
                        val isGranted = flat != null && flat.contains(cn.flattenToString())
                        result.success(isGranted)
                    } catch (e: Exception) {
                        result.error("CHECK_PERMISSION_ERROR", e.message, null)
                    }
                }
                "requestNotificationListenerPermission" -> {
                    try {
                        val intent = Intent(Settings.ACTION_NOTIFICATION_LISTENER_SETTINGS)
                        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                        context.startActivity(intent)
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("REQUEST_PERMISSION_ERROR", e.message, null)
                    }
                }
                "getPendingNotifications" -> {
                    try {
                        val items = KairoNotificationListenerService.popPending(context)
                        result.success(items)
                    } catch (e: Exception) {
                        result.error("GET_PENDING_ERROR", e.message, null)
                    }
                }
                "getDiagnosticStatus" -> {
                    try {
                        val cn = ComponentName(context, KairoNotificationListenerService::class.java)
                        val flat = Settings.Secure.getString(context.contentResolver, "enabled_notification_listeners")
                        val isGranted = flat != null && flat.contains(cn.flattenToString())
                        val diags = KairoNotificationListenerService.getDiagnostics().toMutableMap()
                        diags["isRegistered"] = true
                        diags["isPermissionGranted"] = isGranted
                        result.success(diags)
                    } catch (e: Exception) {
                        result.error("GET_DIAGNOSTICS_ERROR", e.message, null)
                    }
                }
                "rebindListener" -> {
                    try {
                        val success = KairoNotificationListenerService.tryRebind(context)
                        result.success(success)
                    } catch (e: Exception) {
                        result.error("REBIND_ERROR", e.message, null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }
}
