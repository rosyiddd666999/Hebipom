package com.marimo.hebipom

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.graphics.Paint
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin
import org.json.JSONArray
import androidx.core.content.edit

class MyHomeWidget : AppWidgetProvider() {

    companion object {
        const val ACTION_TOGGLE = "TOGGLE_HABIT"
        const val EXTRA_ID = "habit_id"
    }

    override fun onUpdate(context: Context, manager: AppWidgetManager, ids: IntArray) {
        ids.forEach { updateAppWidget(context, manager, it) }
    }

    override fun onReceive(context: Context?, intent: Intent?) {
        super.onReceive(context, intent)

        if (context != null && intent?.action == ACTION_TOGGLE) {

            val habitId = intent.getStringExtra(EXTRA_ID)
            val prefs = HomeWidgetPlugin.getData(context)

            prefs.edit { putString("toggle_habit_id", habitId) }

            val appWidgetManager = AppWidgetManager.getInstance(context)
            val componentName = ComponentName(context, MyHomeWidget::class.java)
            appWidgetManager.updateAppWidget(
                componentName,
                RemoteViews(context.packageName, R.layout.my_home_widget)
            )
        }
    }


}

private fun updateAppWidget(
    context: Context,
    manager: AppWidgetManager,
    id: Int
) {
    val views = RemoteViews(context.packageName, R.layout.my_home_widget)

    val prefs = HomeWidgetPlugin.getData(context)
    val habitsJson = prefs.getString("habits_data", null)

    if (habitsJson != null) {
        val arr = JSONArray(habitsJson)
        views.removeAllViews(R.id.habits_container)

        val maxShow = minOf(arr.length(), 5)

        for (i in 0 until maxShow) {
            val obj = arr.getJSONObject(i)

            val habitView = RemoteViews(context.packageName, R.layout.habit_item_widget)

            val idHabit = obj.getString("id")
            val name = obj.getString("name")
            val isCompleted = obj.getBoolean("isCompleted")
            val timeReminder = obj.getString("timeReminder")

            habitView.setTextViewText(R.id.habit_name, name.uppercase())
            habitView.setTextViewText(R.id.habit_time, timeReminder)

            if (isCompleted) {
                habitView.setInt(
                    R.id.habit_name,
                    "setPaintFlags",
                    Paint.STRIKE_THRU_TEXT_FLAG or Paint.ANTI_ALIAS_FLAG
                )
                habitView.setImageViewResource(
                    R.id.habit_checkbox,
                    R.drawable.checkbox_active
                )
            } else {
                habitView.setInt(
                    R.id.habit_name,
                    "setPaintFlags",
                    Paint.ANTI_ALIAS_FLAG
                )
                habitView.setImageViewResource(
                    R.id.habit_checkbox,
                    R.drawable.checkbox_nonactive
                )
            }

            // GUNAKAN ACTION + EXTRA (bukan URL scheme)
            val toggleIntent = Intent(context, MainActivity::class.java).apply {
                action = "TOGGLE_HABIT_ACTION"
                putExtra("habit_id", idHabit)
                // PENTING: flag ini membuat activity tidak restart
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP
            }

            val togglePI = PendingIntent.getActivity(
                context,
                idHabit.hashCode(),
                toggleIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )

            habitView.setOnClickPendingIntent(R.id.checkbox_container, togglePI)

            views.addView(R.id.habits_container, habitView)
        }
    }

    val openIntent = Intent(context, MainActivity::class.java)
    val openPI = PendingIntent.getActivity(
        context, 0, openIntent,
        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
    )
    views.setOnClickPendingIntent(R.id.widget_title, openPI)

    manager.updateAppWidget(id, views)
}