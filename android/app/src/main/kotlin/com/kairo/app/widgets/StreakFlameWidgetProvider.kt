package com.kairo.app.widgets

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.widget.RemoteViews
import com.kairo.app.MainActivity
import com.kairo.app.R
import es.antonborri.home_widget.HomeWidgetPlugin

class StreakFlameWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        val widgetData = HomeWidgetPlugin.getData(context)

        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.widget_streak_flame)

            val dayNumber = widgetData.getInt("streak_day", 1)
            val isBroken = widgetData.getBoolean("streak_broken", false)
            val completed = widgetData.getInt("streak_completed", 0)

            views.setTextViewText(R.id.tv_streak_day, "$dayNumber")

            if (isBroken) {
                views.setTextViewText(R.id.tv_streak_status, "CHAIN BROKEN • RESET")
                views.setTextColor(R.id.tv_streak_day, Color.parseColor("#FF4444"))
            } else {
                views.setTextViewText(R.id.tv_streak_status, "DAY $dayNumber OF 21  •  $completed LOGGED")
                views.setTextColor(R.id.tv_streak_day, Color.parseColor("#FF6B35"))
            }

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
