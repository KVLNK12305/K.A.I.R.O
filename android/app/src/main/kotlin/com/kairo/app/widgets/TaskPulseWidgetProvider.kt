package com.kairo.app.widgets

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import com.kairo.app.MainActivity
import com.kairo.app.R
import es.antonborri.home_widget.HomeWidgetPlugin

class TaskPulseWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        val widgetData = HomeWidgetPlugin.getData(context)

        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.widget_task_pulse)

            val completed = widgetData.getInt("task_completed", 0)
            val total = widgetData.getInt("task_total", 0)

            val p1Done = widgetData.getInt("peak1_done", 0)
            val p1Total = widgetData.getInt("peak1_total", 0)
            val p2Done = widgetData.getInt("peak2_done", 0)
            val p2Total = widgetData.getInt("peak2_total", 0)
            val recDone = widgetData.getInt("recovery_done", 0)
            val recTotal = widgetData.getInt("recovery_total", 0)

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
        }
    }
}
