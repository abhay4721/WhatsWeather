import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../utils/weather_icon.dart';

class WeatherCard extends StatelessWidget {
  final CurrentWeather current;

  const WeatherCard({super.key, required this.current});

  @override
  Widget build(BuildContext context) {
    // Get current hour
    final now = DateTime.now();
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              getWeatherIcon(current.weathercode, hour: now.hour),
              size: 56,
              color: getWeatherIconColor(current.weathercode),
            ),
            const SizedBox(height: 12),
            Text(
              '${current.temperature}°C',
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Wind: ${current.windspeed} km/h'),
          ],
        ),
      ),
    );
  }
}
