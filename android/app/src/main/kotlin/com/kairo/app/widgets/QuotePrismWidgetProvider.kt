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

class QuotePrismWidgetProvider : AppWidgetProvider() {

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
                val views = RemoteViews(context.packageName, R.layout.widget_quote_prism)

                val chapter = widgetData.getIntSafe("quote_chapter", 2)
                val verse = widgetData.getIntSafe("quote_verse", 47)
                val slok = widgetData.getString("quote_slok", "कर्मण्येवाधिकारस्ते मा फलेषु कदाचन।") ?: "कर्मण्येवाधिकारस्ते मा फलेषु कदाचन।"
                val translation = widgetData.getString("quote_translation", "You have a right to perform your prescribed duties, but you are not entitled to the fruits of your actions.") ?: ""

                views.setTextViewText(R.id.tv_quote_reference, "CH $chapter:$verse")
                views.setTextViewText(R.id.tv_quote_slok, slok)
                views.setTextViewText(R.id.tv_quote_translation, "\"$translation\"")

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
                Log.e("QuotePrismWidget", "Error updating widget $appWidgetId", e)
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
