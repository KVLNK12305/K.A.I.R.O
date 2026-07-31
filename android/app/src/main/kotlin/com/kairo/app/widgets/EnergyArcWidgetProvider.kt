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

class EnergyArcWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        val widgetData = HomeWidgetPlugin.getData(context)

        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.widget_energy_arc)

            val p1Pct = widgetData.getInt("energy_peak1_pct", 0)
            val p2Pct = widgetData.getInt("energy_peak2_pct", 0)
            val recPct = widgetData.getInt("energy_recovery_pct", 0)
            val avgPct = widgetData.getInt("energy_avg_pct", 0)

            views.setTextViewText(R.id.tv_energy_avg, "$avgPct%")

            views.setProgressBar(R.id.pb_peak1, 100, p1Pct, false)
            views.setTextViewText(R.id.tv_peak1_pct, "$p1Pct%")

            views.setProgressBar(R.id.pb_peak2, 100, p2Pct, false)
            views.setTextViewText(R.id.tv_peak2_pct, "$p2Pct%")

            views.setProgressBar(R.id.pb_recovery, 100, recPct, false)
            views.setTextViewText(R.id.tv_recovery_pct, "$recPct%")

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
