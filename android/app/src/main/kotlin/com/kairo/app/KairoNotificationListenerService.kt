package com.kairo.app

import android.app.Notification
import android.content.ComponentName
import android.content.Context
import android.os.Build
import android.service.notification.NotificationListenerService
import android.service.notification.StatusBarNotification
import android.util.Log
import org.json.JSONArray
import org.json.JSONObject
import java.io.File
import java.util.Collections

class KairoNotificationListenerService : NotificationListenerService() {

    companion object {
        private const val TAG = "KairoNotifListener"
        private const val BACKLOG_FILE = "kairo_notification_backlog.json"
        private const val MAX_DIAGNOSTICS = 50

        @Volatile
        var isConnected: Boolean = false
            private set

        @Volatile
        var lastConnectedTime: Long = 0L
            private set

        @Volatile
        var totalNotificationsObserved: Int = 0
            private set

        @Volatile
        var totalFinancialCaptured: Int = 0
            private set

        val memoryQueue: MutableList<Map<String, Any>> = Collections.synchronizedList(mutableListOf())
        val diagnosticLogs: MutableList<Map<String, Any>> = Collections.synchronizedList(mutableListOf())

        var onNotificationCapturedListener: (() -> Unit)? = null

        fun getDiagnostics(): Map<String, Any> {
            return mapOf(
                "isConnected" to isConnected,
                "lastConnectedTime" to lastConnectedTime,
                "totalObserved" to totalNotificationsObserved,
                "totalFinancial" to totalFinancialCaptured,
                "queueSize" to memoryQueue.size,
                "recentLogs" to synchronized(diagnosticLogs) { ArrayList(diagnosticLogs) }
            )
        }

        fun tryRebind(context: Context): Boolean {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                try {
                    val cn = ComponentName(context, KairoNotificationListenerService::class.java)
                    requestRebind(cn)
                    Log.i(TAG, "Requested rebind for KairoNotificationListenerService")
                    return true
                } catch (e: Exception) {
                    Log.e(TAG, "Failed to request rebind: ${e.message}")
                }
            }
            return false
        }

        fun popPending(context: Context): List<Map<String, Any>> {
            val results = mutableListOf<Map<String, Any>>()

            // 1. Pop memory queue
            synchronized(memoryQueue) {
                results.addAll(memoryQueue)
                memoryQueue.clear()
            }

            // 2. Read and clear disk backlog
            try {
                val file = File(context.filesDir, BACKLOG_FILE)
                if (file.exists()) {
                    val content = file.readText()
                    if (content.isNotBlank()) {
                        val array = JSONArray(content)
                        for (i in 0 until array.length()) {
                            val obj = array.getJSONObject(i)
                            val map = mutableMapOf<String, Any>()
                            val keys = obj.keys()
                            while (keys.hasNext()) {
                                val k = keys.next()
                                map[k] = obj.get(k)
                            }
                            results.add(map)
                        }
                    }
                    file.delete()
                }
            } catch (e: Exception) {
                Log.e(TAG, "Error reading notification backlog: ${e.message}")
            }

            return results
        }

        private fun appendToDisk(context: Context, item: Map<String, Any>) {
            try {
                val file = File(context.filesDir, BACKLOG_FILE)
                val array = if (file.exists() && file.length() > 0) {
                    try {
                        JSONArray(file.readText())
                    } catch (_: Exception) {
                        JSONArray()
                    }
                } else {
                    JSONArray()
                }

                array.put(JSONObject(item))
                file.writeText(array.toString())
            } catch (e: Exception) {
                Log.e(TAG, "Error writing notification to backlog: ${e.message}")
            }
        }

        private fun recordDiagnostic(
            eventType: String,
            packageName: String,
            category: String,
            hasTitle: Boolean,
            hasText: Boolean,
            isFinancial: Boolean,
            matchedKeyword: String
        ) {
            val diag = mapOf<String, Any>(
                "eventType" to eventType,
                "packageName" to packageName,
                "category" to category,
                "hasTitle" to hasTitle,
                "hasText" to hasText,
                "isFinancial" to isFinancial,
                "matchedKeyword" to matchedKeyword,
                "timestamp" to System.currentTimeMillis()
            )
            synchronized(diagnosticLogs) {
                if (diagnosticLogs.size >= MAX_DIAGNOSTICS) {
                    diagnosticLogs.removeAt(0)
                }
                diagnosticLogs.add(diag)
            }
        }
    }

    override fun onListenerConnected() {
        super.onListenerConnected()
        isConnected = true
        lastConnectedTime = System.currentTimeMillis()
        Log.i(TAG, ">>> KairoNotificationListenerService CONNECTED at $lastConnectedTime <<<")
        recordDiagnostic(
            eventType = "LISTENER_CONNECTED",
            packageName = packageName ?: "com.kairo.app",
            category = "system",
            hasTitle = false,
            hasText = false,
            isFinancial = false,
            matchedKeyword = "none"
        )
    }

    override fun onListenerDisconnected() {
        super.onListenerDisconnected()
        isConnected = false
        Log.w(TAG, ">>> KairoNotificationListenerService DISCONNECTED <<<")
        recordDiagnostic(
            eventType = "LISTENER_DISCONNECTED",
            packageName = packageName ?: "com.kairo.app",
            category = "system",
            hasTitle = false,
            hasText = false,
            isFinancial = false,
            matchedKeyword = "none"
        )
    }

    override fun onNotificationPosted(sbn: StatusBarNotification?) {
        if (sbn == null) return

        try {
            totalNotificationsObserved++
            val notification = sbn.notification ?: return
            val extras = notification.extras ?: return
            val pkg = sbn.packageName ?: ""
            val postTime = sbn.postTime
            val category = notification.category ?: ""

            // Extract text from all potential extras fields
            val title = extractTitle(extras)
            val body = extractBody(extras)

            val hasTitle = title.isNotBlank()
            val hasText = body.isNotBlank()

            // Safe diagnostic logging (no sensitive amounts, numbers, or full body)
            Log.i(TAG, "Notification received from [$pkg], hasTitle=$hasTitle, hasText=$hasText, category=$category")

            val combined = "$title $body"
            val matchedKeyword = findFinancialKeyword(combined, pkg)
            val isFinancial = matchedKeyword.isNotBlank()

            recordDiagnostic(
                eventType = if (isFinancial) "PAYMENT_NOTIFICATION_DETECTED" else "NOTIFICATION_RECEIVED",
                packageName = pkg,
                category = category,
                hasTitle = hasTitle,
                hasText = hasText,
                isFinancial = isFinancial,
                matchedKeyword = matchedKeyword
            )

            if (!isFinancial) return

            totalFinancialCaptured++
            Log.i(TAG, "Financial payment captured from [$pkg] (keyword: $matchedKeyword)")

            val item = mapOf<String, Any>(
                "packageName" to pkg,
                "title" to title,
                "body" to body,
                "postTime" to postTime,
                "id" to sbn.id.toString(),
                "tag" to (sbn.tag ?: ""),
                "category" to category
            )

            synchronized(memoryQueue) {
                memoryQueue.add(item)
            }
            appendToDisk(applicationContext, item)

            // Notify Flutter in real time if running
            try {
                onNotificationCapturedListener?.invoke()
            } catch (e: Exception) {
                Log.e(TAG, "Error invoking callback: ${e.message}")
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error in onNotificationPosted: ${e.message}")
        }
    }

    override fun onNotificationRemoved(sbn: StatusBarNotification?) {}

    private fun extractTitle(extras: android.os.Bundle): String {
        val titleBig = extras.getCharSequence(Notification.EXTRA_TITLE_BIG)?.toString()
        if (!titleBig.isNullOrBlank()) return titleBig

        val title = extras.getCharSequence(Notification.EXTRA_TITLE)?.toString()
        if (!title.isNullOrBlank()) return title

        return ""
    }

    private fun extractBody(extras: android.os.Bundle): String {
        // 1. Check big text
        val bigText = extras.getCharSequence(Notification.EXTRA_BIG_TEXT)?.toString()
        if (!bigText.isNullOrBlank()) return bigText

        // 2. Check standard text
        val text = extras.getCharSequence(Notification.EXTRA_TEXT)?.toString()
        if (!text.isNullOrBlank()) return text

        // 3. Check InboxStyle text lines (common in consolidated bank SMS or GPay/Paytm)
        val textLines = extras.getCharSequenceArray(Notification.EXTRA_TEXT_LINES)
        if (textLines != null && textLines.isNotEmpty()) {
            val sb = java.lang.StringBuilder()
            for (line in textLines) {
                if (line != null && line.isNotBlank()) {
                    if (sb.isNotEmpty()) sb.append(" ")
                    sb.append(line.toString().trim())
                }
            }
            if (sb.isNotBlank()) return sb.toString()
        }

        // 4. Check sub-text / info-text / summary
        val subText = extras.getCharSequence(Notification.EXTRA_SUB_TEXT)?.toString()
        val infoText = extras.getCharSequence(Notification.EXTRA_INFO_TEXT)?.toString()
        val summaryText = extras.getCharSequence(Notification.EXTRA_SUMMARY_TEXT)?.toString()

        val fallback = listOfNotNull(subText, infoText, summaryText).filter { it.isNotBlank() }.joinToString(" ")
        if (fallback.isNotBlank()) return fallback

        return ""
    }

    private fun findFinancialKeyword(text: String, pkg: String): String {
        val lower = text.lowercase()
        val lowerPkg = pkg.lowercase()

        // Currency markers
        if (text.contains("₹")) return "₹"
        if (lower.contains("rs.") || lower.contains("rs ") || lower.contains("inr")) return "currency_marker"

        // Transaction verbs
        if (lower.contains("debited")) return "debited"
        if (lower.contains("credited")) return "credited"
        if (lower.contains("paid to") || lower.contains("paid ")) return "paid"
        if (lower.contains("sent to") || lower.contains("sent rs")) return "sent"
        if (lower.contains("refund")) return "refund"
        if (lower.contains("transferred")) return "transferred"
        if (lower.contains("invested")) return "invested"
        if (lower.contains("upi ref") || lower.contains("utr")) return "upi_ref"

        // Known payment apps with transaction keywords
        val isPaymentApp = lowerPkg.contains("paisa") || // Google Pay
                lowerPkg.contains("phonepe") ||
                lowerPkg.contains("paytm") ||
                lowerPkg.contains("dreamplug") || // CRED
                lowerPkg.contains("upiapp") || // BHIM
                lowerPkg.contains("naviapp") ||
                lowerPkg.contains("mobikwik") ||
                lowerPkg.contains("bank") ||
                lowerPkg.contains("messaging") // SMS

        if (isPaymentApp) {
            if (lower.contains("success") ||
                lower.contains("completed") ||
                lower.contains("received") ||
                lower.contains("spent") ||
                lower.contains("payment") ||
                lower.contains("withdrawn") ||
                lower.contains("money sent")
            ) {
                return "payment_app_success"
            }
        }

        return ""
    }
}
