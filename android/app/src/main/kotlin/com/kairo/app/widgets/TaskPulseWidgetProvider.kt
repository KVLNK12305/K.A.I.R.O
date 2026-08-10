package com.kairo.app.widgets

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.os.Bundle
import android.util.Log
import android.widget.RemoteViews
import com.kairo.app.MainActivity
import com.kairo.app.R
import es.antonborri.home_widget.HomeWidgetPlugin

class TaskPulseWidgetProvider : AppWidgetProvider() {

    private fun SharedPreferences.getIntSafe(key: String, defaultValue: Int): Int {
        return try {
            getInt(key, defaultValue)
        } catch (e: ClassCastException) {
            try {
                getLong(key, defaultValue.toLong()).toInt()
            } catch (e2: Exception) {
                defaultValue
            }
        } catch (e: Exception) {
            defaultValue
        }
    }

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        val widgetData = HomeWidgetPlugin.getData(context)

        for (appWidgetId in appWidgetIds) {
            try {
                val views = RemoteViews(context.packageName, R.layout.widget_task_pulse)

                val completed = widgetData.getIntSafe("task_completed", 0)
                val total = widgetData.getIntSafe("task_total", 0)

                val p1Done = widgetData.getIntSafe("peak1_done", 0)
                val p1Total = widgetData.getIntSafe("peak1_total", 0)
                val p2Done = widgetData.getIntSafe("peak2_done", 0)
                val p2Total = widgetData.getIntSafe("peak2_total", 0)
                val recDone = widgetData.getIntSafe("recovery_done", 0)
                val recTotal = widgetData.getIntSafe("recovery_total", 0)

                val pct = if (total > 0) (completed * 100 / total) else 0

                views.setTextViewText(R.id.tv_task_summary, "$completed OF $total")
                views.setProgressBar(R.id.pb_task_progress, 100, pct, false)

                views.setTextViewText(R.id.tv_peak1_count, "P1: $p1Done/$p1Total")
                views.setTextViewText(R.id.tv_peak2_count, "P2: $p2Done/$p2Total")
                views.setTextViewText(R.id.tv_recovery_count, "REC: $recDone/$recTotal")

                // Tap to open app
                val intent = Intent(context, MainActivity::class.java)
                val pendingIntent = PendingIntent.getActivity(
                    context,
                    0,
                    intent,
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                )
                views.setOnClickPendingIntent(R.id.widget_root, pendingIntent)

                appWidgetManager.updateAppWidget(appWidgetId, views)
            } catch (e: Exception) {
                Log.e("TaskPulseWidget", "Error updating widget $appWidgetId", e)
            }
        }
    }

    override fun onAppWidgetOptionsChanged(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int,
        newOptions: Bundle
    ) {
        onUpdate(context, appWidgetManager, intArrayOf(appWidgetId))
        super.onAppWidgetOptionsChanged(context, appWidgetManager, appWidgetId, newOptions)
    }
}
