import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../utils/weather_icon.dart';
import 'package:intl/intl.dart';

class DailyDetailsPage extends StatelessWidget {
  final DailyWeather day;
  final List<HourlyWeather> hourly;

  const DailyDetailsPage({super.key, required this.day, required this.hourly});

  @override
  Widget build(BuildContext context) {
    // Find all hourly entries for this date
    final dayDate = DateTime.parse(day.date);
    final hoursForDay = hourly.where((h) {
      final t = DateTime.parse(h.time);
      return t.year == dayDate.year && t.month == dayDate.month && t.day == dayDate.day;
    }).toList();

    double avg(List<double?> vals) {
      vals = vals.where((v) => v != null).toList();
      if (vals.isEmpty) return 0;
      return vals.reduce((a, b) => a! + b!)! / vals.length;
    }
    double max(List<double?> vals) {
      vals = vals.where((v) => v != null).toList();
      if (vals.isEmpty) return 0;
      return vals.reduce((a, b) => (a! > b! ? a : b))!;
    }
    double sum(List<double?> vals) {
      vals = vals.where((v) => v != null).toList();
      if (vals.isEmpty) return 0;
      return vals.reduce((a, b) => a! + b!)!;
    }

    final avgHumidity = avg(hoursForDay.map((h) => h.humidity).toList());
    final maxHumidity = max(hoursForDay.map((h) => h.humidity).toList());
    final avgPressure = avg(hoursForDay.map((h) => h.pressure).toList());
    final avgWind = avg(hoursForDay.map((h) => h.windspeed).toList());
    final maxWind = max(hoursForDay.map((h) => h.windspeed).toList());
    final totalRain = sum(hoursForDay.map((h) => h.precipitation).toList());
    final avgCloud = avg(hoursForDay.map((h) => h.cloudcover).toList());

    return Scaffold(
      appBar: AppBar(
        title: Text('Details - ${DateFormat('EEE, MMM d').format(dayDate)}'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(22),
        children: [
          Center(
            child: Icon(
              getWeatherIcon(day.weathercode, hour: 12),
              size: 64,
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              '${day.maxTemp.toStringAsFixed(1)}°C / ${day.minTemp.toStringAsFixed(1)}°C',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
          ),
          const SizedBox(height: 18),
          _detailRow("Sunrise", day.sunrise != null ? DateFormat.Hm().format(DateTime.parse(day.sunrise!)) : '--'),
          _detailRow("Sunset", day.sunset != null ? DateFormat.Hm().format(DateTime.parse(day.sunset!)) : '--'),
          _detailRow("Avg Humidity", avgHumidity > 0 ? '${avgHumidity.toStringAsFixed(0)}%' : '--'),
          _detailRow("Max Humidity", maxHumidity > 0 ? '${maxHumidity.toStringAsFixed(0)}%' : '--'),
          _detailRow("Avg Pressure", avgPressure > 0 ? '${avgPressure.toStringAsFixed(0)} hPa' : '--'),
          _detailRow("Avg Wind Speed", avgWind > 0 ? '${avgWind.toStringAsFixed(1)} km/h' : '--'),
          _detailRow("Max Wind Speed", maxWind > 0 ? '${maxWind.toStringAsFixed(1)} km/h' : '--'),
          _detailRow("Total Rain", totalRain > 0 ? '${totalRain.toStringAsFixed(1)} mm' : '0 mm'),
          _detailRow("Avg Cloud Cover", avgCloud > 0 ? '${avgCloud.toStringAsFixed(0)}%' : '--'),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500))),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
