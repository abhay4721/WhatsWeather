import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../utils/weather_icon.dart';

class DetailsScreen extends StatelessWidget {
  final DailyWeather day;

  const DetailsScreen({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text("Weather Details"),
        backgroundColor: scheme.primaryContainer,
        iconTheme: IconThemeData(color: scheme.onPrimaryContainer),
        titleTextStyle: TextStyle(
          color: scheme.onPrimaryContainer,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              getWeatherIcon(day.weathercode, hour: 12),
              size: 64,
              color: scheme.primary,
            ),
            const SizedBox(height: 20),
            Text(
              day.date,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Max: ${day.maxTemp}°C, Min: ${day.minTemp}°C",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 22),
            _DetailRow(icon: Icons.water_drop, label: "Humidity", value: day.humidity != null ? "${day.humidity!.toStringAsFixed(0)}%" : "--"),
            _DetailRow(icon: Icons.speed, label: "Pressure", value: day.pressure != null ? "${day.pressure!.toStringAsFixed(0)} hPa" : "--"),
            _DetailRow(icon: Icons.wb_twilight, label: "Sunrise", value: day.sunrise ?? "--"),
            _DetailRow(icon: Icons.nightlight, label: "Sunset", value: day.sunset ?? "--"),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _DetailRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary, size: 28),
          const SizedBox(width: 16),
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
