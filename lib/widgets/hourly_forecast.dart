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
        separatorBuilder: (_, __) => const SizedBox(width: 10), // More space
        itemBuilder: (context, i) {
          final hourData = upcoming[i];
          final hourDateTime = DateTime.parse(hourData.time);
          final hourValue = hourDateTime.hour;
          final displayHour = '${hourDateTime.hour}:00';

          return _PrettyCard(
            gradient: LinearGradient(
              colors: [
                scheme.primaryContainer.withOpacity(0.78),
                scheme.secondaryContainer.withOpacity(0.5),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: 18,
            child: Container(
              width: 78, // Wider card
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8), // More space inside
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
                        color: scheme.onPrimaryContainer.withOpacity(0.9),
                      )),
                  const SizedBox(height: 4),
                  Text(displayHour,
                      style: TextStyle(
                        fontSize: 13,
                        color: scheme.onPrimaryContainer.withOpacity(0.55),
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

class _PrettyCard extends StatelessWidget {
  final Widget child;
  final Gradient? gradient;
  final double borderRadius;

  const _PrettyCard({
    required this.child,
    this.gradient,
    this.borderRadius = 16,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient ??
            LinearGradient(
              colors: [
                Colors.white.withOpacity(0.12),
                Colors.white.withOpacity(0.08),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(
          color: Colors.white.withOpacity(0.13),
          width: 0.8,
        ),
      ),
      child: child,
    );
  }
}
