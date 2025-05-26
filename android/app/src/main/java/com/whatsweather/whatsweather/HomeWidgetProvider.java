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
        String iconType = prefs.getString("weather_icon_type", "sunny"); // default to sunny

        // Map the iconType string to your drawable
        int iconResId = R.drawable.ic_sunny;
        switch (iconType) {
            case "cloudy":
                iconResId = R.drawable.ic_cloudy;
                break;
            case "partly_cloudy":
                iconResId = R.drawable.ic_partly_cloudy;
                break;
            case "rain":
                iconResId = R.drawable.ic_rain;
                break;
            case "thunder":
                iconResId = R.drawable.ic_thunder;
                break;
            case "snow":
                iconResId = R.drawable.ic_snow;
                break;
            case "mist":
                iconResId = R.drawable.ic_mist;
                break;
            // Add other cases for your icons
            // ...
            default:
                iconResId = R.drawable.ic_sunny;
        }

        for (int appWidgetId : appWidgetIds) {
            RemoteViews views = new RemoteViews(context.getPackageName(), R.layout.home_widget);
            views.setTextViewText(R.id.weather_temp, temp);
            views.setTextViewText(R.id.weather_desc, desc);
            views.setTextViewText(R.id.weather_city, city);

            // Set the icon resource dynamically
            views.setImageViewResource(R.id.weather_icon, iconResId);

            appWidgetManager.updateAppWidget(appWidgetId, views);
        }
    }
}
