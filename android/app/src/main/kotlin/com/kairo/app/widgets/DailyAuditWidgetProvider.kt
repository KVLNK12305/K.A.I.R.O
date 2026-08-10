package com.kairo.app.widgets

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.widget.RemoteViews
import com.kairo.app.MainActivity
import com.kairo.app.R
import es.antonborri.home_widget.HomeWidgetPlugin

class DailyAuditWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        val widgetData = HomeWidgetPlugin.getData(context)

        for (appWidgetId in appWidgetIds) {
            try {
                val views = RemoteViews(context.packageName, R.layout.widget_daily_audit)

                val sleep = widgetData.getString("audit_sleep", "7.5h") ?: "7.5h"
                val work = widgetData.getString("audit_work", "4.0h") ?: "4.0h"
                val free = widgetData.getString("audit_free", "12.5h") ?: "12.5h"

                views.setTextViewText(R.id.tv_audit_sleep, "Sleep: $sleep")
                views.setTextViewText(R.id.tv_audit_work, "Work: $work")
                views.setTextViewText(R.id.tv_audit_free, "Free: $free")

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
                Log.e("DailyAuditWidget", "Error updating widget $appWidgetId", e)
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
