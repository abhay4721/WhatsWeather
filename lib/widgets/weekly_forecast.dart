import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../utils/weather_icon.dart';
import '../screens/daily_details_page.dart'; // <-- Adjust path if needed

class WeeklyForecast extends StatelessWidget {
  final List<DailyWeather> daily;
  final List<HourlyWeather> hourly;

  const WeeklyForecast({
    super.key,
    required this.daily,
    required this.hourly,
  });

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
              getWeatherIcon(d.weathercode, hour: 12), // or use your icon logic
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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DailyDetailsPage(
                    day: d,
                    hourly: hourly,
                  ),
                ),
              );
            },
          ),
        );
      }).toList(),
    );
  }
}
