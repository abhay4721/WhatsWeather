import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';
import '../config.dart';

class WeatherAlert {
  final String event;
  final String description;

  WeatherAlert({required this.event, required this.description});
}

class WeatherService {
  static Future<WeatherResponseWithAlerts?> fetchWeather({
    double latitude = defaultLatitude,
    double longitude = defaultLongitude,
  }) async {
    final url = Uri.parse(
      "$openMeteoBaseUrl"
      "?latitude=$latitude"
      "&longitude=$longitude"
      "&current_weather=true"
      "&hourly=temperature_2m,weathercode"
      "&daily=temperature_2m_max,temperature_2m_min,weathercode"
      "&weather_alerts=true"
      "&timezone=auto"
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Parse current weather
      final current = CurrentWeather.fromJson(data['current_weather']);

      // Parse hourly
      final List<HourlyWeather> hourly = [];
      final List times = data['hourly']['time'];
      final List temps = data['hourly']['temperature_2m'];
      final List wcodes = data['hourly']['weathercode'];
      for (int i = 0; i < times.length; i++) {
        hourly.add(HourlyWeather(
          time: times[i],
          temperature: (temps[i] as num).toDouble(),
          weathercode: wcodes[i],
        ));
      }

      // Parse daily
      final List<DailyWeather> daily = [];
      final List days = data['daily']['time'];
      final List maxTemps = data['daily']['temperature_2m_max'];
      final List minTemps = data['daily']['temperature_2m_min'];
      final List dailyWcodes = data['daily']['weathercode'];
      for (int i = 0; i < days.length; i++) {
        daily.add(DailyWeather(
          date: days[i],
          maxTemp: (maxTemps[i] as num).toDouble(),
          minTemp: (minTemps[i] as num).toDouble(),
          weathercode: dailyWcodes[i],
        ));
      }

      // Parse alerts
      List<WeatherAlert> alerts = [];
      if (data["alerts"] != null && data["alerts"]["alert"] != null) {
        for (var alert in data["alerts"]["alert"]) {
          alerts.add(
            WeatherAlert(
              event: alert["event"] ?? "Alert",
              description: alert["description"] ?? "",
            ),
          );
        }
      }

      return WeatherResponseWithAlerts(
        current: current,
        hourly: hourly,
        daily: daily,
        alerts: alerts,
      );
    } else {
      return null;
    }
  }
}

// New wrapper model with alerts
class WeatherResponseWithAlerts extends WeatherResponse {
  final List<WeatherAlert> alerts;
  WeatherResponseWithAlerts({
    required CurrentWeather current,
    required List<HourlyWeather> hourly,
    required List<DailyWeather> daily,
    required this.alerts,
  }) : super(current: current, hourly: hourly, daily: daily);
}
