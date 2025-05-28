import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../utils/weather_icon.dart';
import '../widgets/weather_lottie.dart';


class WeatherCard extends StatelessWidget {
  final CurrentWeather current;

  const WeatherCard({super.key, required this.current});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final now = DateTime.now();

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      color: scheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              getWeatherIcon(current.weathercode, hour: now.hour),
              size: 64,
              color: scheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              '${current.temperature}°C',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: scheme.onPrimaryContainer,
                letterSpacing: -2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              current.weathercode == 0 ? "Clear Sky" : "Condition Code: ${current.weathercode}",
              style: TextStyle(
                color: scheme.onPrimaryContainer.withOpacity(0.8),
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.air, color: scheme.secondary, size: 20),
                const SizedBox(width: 4),
                Text(
                  'Wind: ${current.windspeed} km/h',
                  style: TextStyle(
                    color: scheme.onPrimaryContainer.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
