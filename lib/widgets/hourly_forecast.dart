import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../utils/weather_icon.dart';

class HourlyForecast extends StatelessWidget {
  final List<HourlyWeather> hourly;

  const HourlyForecast({super.key, required this.hourly});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final scheme = Theme.of(context).colorScheme;
    final upcoming = hourly.where((h) {
      final time = DateTime.tryParse(h.time);
      return time != null && time.isAfter(now);
    }).take(12).toList();

    return SizedBox(
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: upcoming.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final hourData = upcoming[i];
          final hourDateTime = DateTime.parse(hourData.time);
          final hourValue = hourDateTime.hour;
          final displayHour = '${hourDateTime.hour}:00';

          return Card(
            elevation: 2,
            color: scheme.secondaryContainer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Container(
              width: 78,
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    getWeatherIcon(hourData.weathercode, hour: hourValue),
                    size: 28,
                    color: scheme.primary,
                  ),
                  const SizedBox(height: 10),
                  Text('${hourData.temperature.toStringAsFixed(0)}°',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: scheme.onSecondaryContainer,
                      )),
                  const SizedBox(height: 4),
                  Text(displayHour,
                      style: TextStyle(
                        fontSize: 13,
                        color: scheme.onSecondaryContainer.withOpacity(0.7),
                      )),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
