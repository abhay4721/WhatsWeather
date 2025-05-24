import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../utils/weather_icon.dart';

class WeeklyForecast extends StatelessWidget {
  final List<DailyWeather> daily;

  const WeeklyForecast({super.key, required this.daily});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: daily.map((d) {
        return Card(
          color: scheme.surfaceVariant,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ListTile(
            leading: Icon(
              getWeatherIcon(d.weathercode, hour: 12), // noon = day icon
              color: scheme.primary,
              size: 32,
            ),
            title: Text(
              d.date,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: scheme.onSurfaceVariant,
              ),
            ),
            subtitle: Text(
              'Max: ${d.maxTemp}°C, Min: ${d.minTemp}°C',
              style: TextStyle(color: scheme.onSurfaceVariant.withOpacity(0.8)),
            ),
          ),
        );
      }).toList(),
    );
  }
}
