import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../utils/weather_icon.dart';

class WeeklyForecast extends StatelessWidget {
  final List<DailyWeather> daily;

  const WeeklyForecast({super.key, required this.daily});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            "7-Day Forecast",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        ...daily.map((d) {
          // Assume day icon for now; can improve if you add daily sunrise/sunset logic!
          return ListTile(
            leading: Icon(
              getWeatherIcon(d.weathercode, hour: 12), // 12 noon = day icon
              color: getWeatherIconColor(d.weathercode),
            ),
            title: Text(d.date),
            subtitle: Text('Max: ${d.maxTemp}°C, Min: ${d.minTemp}°C'),
          );
        }),
      ],
    );
  }
}
