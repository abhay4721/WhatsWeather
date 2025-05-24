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
      height: 128,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: upcoming.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          final hourData = upcoming[i];
          final hourDateTime = DateTime.parse(hourData.time);
          final hourValue = hourDateTime.hour;
          final displayHour = '${hourDateTime.hour}:00';

          return _SimpleCard(
            borderRadius: 18,
            color: scheme.surfaceVariant, // <-- No gradient, just theme card color
            child: Container(
              width: 78,
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    getWeatherIcon(hourData.weathercode, hour: hourValue),
                    size: 26,
                    color: scheme.primary.withOpacity(0.92),
                  ),
                  const SizedBox(height: 10),
                  Text('${hourData.temperature.toStringAsFixed(0)}°',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: scheme.onSurface,
                      )),
                  const SizedBox(height: 4),
                  Text(displayHour,
                      style: TextStyle(
                        fontSize: 13,
                        color: scheme.onSurface.withOpacity(0.6),
                        fontWeight: FontWeight.w500,
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

class _SimpleCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final Color color;

  const _SimpleCard({
    required this.child,
    required this.color,
    this.borderRadius = 16,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(
          color: Colors.white.withOpacity(0.09),
          width: 0.7,
        ),
      ),
      child: child,
    );
  }
}
