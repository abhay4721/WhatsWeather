import 'package:flutter/material.dart';
import '../models/weather_model.dart';

class HourlyForecast extends StatelessWidget {
  final List<HourlyWeather> hourly;

  const HourlyForecast({super.key, required this.hourly});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final upcoming = hourly.where((h) {
      final time = DateTime.tryParse(h.time);
      return time != null && time.isAfter(now);
    }).take(12).toList();

    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: upcoming.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final hourData = upcoming[i];
          final hour = DateTime.parse(hourData.time);
          final displayHour = '${hour.hour}:00';

          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Container(
              width: 70,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.wb_sunny), // TODO: Dynamic icon by weathercode
                  const SizedBox(height: 8),
                  Text('${hourData.temperature.toStringAsFixed(0)}°', style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(displayHour, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
