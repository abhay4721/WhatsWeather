import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';
import '../config.dart';

// Weather alert model
class WeatherAlert {
  final String event;
  final String description;

  WeatherAlert({required this.event, required this.description});
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
      // Request all advanced hourly fields!
      "&hourly=temperature_2m,weathercode,relative_humidity_2m,pressure_msl,windspeed_10m,precipitation,cloudcover"
      // Request only safe daily fields for all regions
      "&daily=temperature_2m_max,temperature_2m_min,weathercode,sunrise,sunset"
      "&weather_alerts=true"
      "&timezone=auto"
    );
    final response = await http.get(url);

    // Debug: Print URL and response for troubleshooting
    print('API URL: $url');
    print('API RESPONSE: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Parse current weather
      final current = CurrentWeather.fromJson(data['current_weather']);

      // Parse hourly
      final List<HourlyWeather> hourly = [];
      final List times = data['hourly']['time'];
      final List temps = data['hourly']['temperature_2m'];
      final List wcodes = data['hourly']['weathercode'];
      final List humidities = data['hourly']['relative_humidity_2m'];
      final List pressures = data['hourly']['pressure_msl'];
      final List winds = data['hourly']['windspeed_10m'];
      final List precs = data['hourly']['precipitation'];
      final List clouds = data['hourly']['cloudcover'];

      for (int i = 0; i < times.length; i++) {
        hourly.add(HourlyWeather(
          time: times[i],
          temperature: (temps[i] as num).toDouble(),
          weathercode: wcodes[i],
          humidity: humidities.isNotEmpty ? (humidities[i] as num?)?.toDouble() : null,
          pressure: pressures.isNotEmpty ? (pressures[i] as num?)?.toDouble() : null,
          windspeed: winds.isNotEmpty ? (winds[i] as num?)?.toDouble() : null,
          precipitation: precs.isNotEmpty ? (precs[i] as num?)?.toDouble() : null,
          cloudcover: clouds.isNotEmpty ? (clouds[i] as num?)?.toDouble() : null,
        ));
      }

      // Parse daily (for India, humidity/pressure are always null)
      final List<DailyWeather> daily = [];
      final dailyJson = data['daily'];
      final List days = dailyJson['time'];
      final List maxTemps = dailyJson['temperature_2m_max'];
      final List minTemps = dailyJson['temperature_2m_min'];
      final List dailyWcodes = dailyJson['weathercode'];
      final List? sunrises = dailyJson['sunrise'];
      final List? sunsets = dailyJson['sunset'];

      for (int i = 0; i < days.length; i++) {
        daily.add(DailyWeather(
          date: days[i],
          maxTemp: (maxTemps[i] as num).toDouble(),
          minTemp: (minTemps[i] as num).toDouble(),
          weathercode: dailyWcodes[i],
          humidity: null, // Always null for India (see explanation)
          pressure: null, // Always null for India
          sunrise: sunrises != null && i < sunrises.length ? sunrises[i] : null,
          sunset: sunsets != null && i < sunsets.length ? sunsets[i] : null,
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
      print("Weather API error: ${response.statusCode}");
      return null;
    }
  }
}
