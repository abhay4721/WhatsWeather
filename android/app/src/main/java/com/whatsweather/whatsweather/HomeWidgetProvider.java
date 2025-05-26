package com.whatsweather.whatsweather;

import android.appwidget.AppWidgetManager;
import android.appwidget.AppWidgetProvider;
import android.content.Context;
import android.widget.RemoteViews;
import android.content.SharedPreferences;
import com.whatsweather.whatsweather.R;


public class HomeWidgetProvider extends AppWidgetProvider {
    @Override
    public void onUpdate(Context context, AppWidgetManager appWidgetManager, int[] appWidgetIds) {
        SharedPreferences prefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE);

        String temp = prefs.getString("weather_temp", "--°C");
        String desc = prefs.getString("weather_desc", "Condition");
        String city = prefs.getString("weather_city", "City");

        for (int appWidgetId : appWidgetIds) {
            RemoteViews views = new RemoteViews(context.getPackageName(), R.layout.home_widget);
            views.setTextViewText(R.id.weather_temp, temp);
            views.setTextViewText(R.id.weather_desc, desc);
            views.setTextViewText(R.id.weather_city, city);

            appWidgetManager.updateAppWidget(appWidgetId, views);
        }
    }
}
