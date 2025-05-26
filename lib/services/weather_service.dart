import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';
import '../config.dart';
import 'package:home_widget/home_widget.dart';         // For widget update
import '../utils/widget_helper.dart';                  // Import helper

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
    bool useFahrenheit = false, // <--- Added for unit toggle
  }) async {
    final tempUnit = useFahrenheit ? "fahrenheit" : "celsius";

    final url = Uri.parse(
      "$openMeteoBaseUrl"
      "?latitude=$latitude"
      "&longitude=$longitude"
      "&current_weather=true"
      "&hourly=temperature_2m,weathercode,relative_humidity_2m,pressure_msl,windspeed_10m,precipitation,cloudcover"
      "&daily=temperature_2m_max,temperature_2m_min,weathercode,sunrise,sunset,pressure_msl_max"
      "&temperature_unit=$tempUnit"
      "&weather_alerts=true"
      "&timezone=auto"
    );
    final response = await http.get(url);

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

      // Parse daily
      final List<DailyWeather> daily = [];
      final dailyJson = data['daily'];
      final List days = dailyJson['time'];
      final List maxTemps = dailyJson['temperature_2m_max'];
      final List minTemps = dailyJson['temperature_2m_min'];
      final List dailyWcodes = dailyJson['weathercode'];
      final List? humiditiesMax = dailyJson['humidity_2m_max'];
      final List? pressuresMax = dailyJson['pressure_msl_max'];
      final List? sunrises = dailyJson['sunrise'];
      final List? sunsets = dailyJson['sunset'];

      for (int i = 0; i < days.length; i++) {
        daily.add(DailyWeather(
          date: days[i],
          maxTemp: (maxTemps[i] as num).toDouble(),
          minTemp: (minTemps[i] as num).toDouble(),
          weathercode: dailyWcodes[i],
          humidity: humiditiesMax != null && i < humiditiesMax.length
              ? (humiditiesMax[i] as num?)?.toDouble()
              : null,
          pressure: pressuresMax != null && i < pressuresMax.length
              ? (pressuresMax[i] as num?)?.toDouble()
              : null,
          sunrise: sunrises != null && i < sunrises.length
              ? sunrises[i]
              : null,
          sunset: sunsets != null && i < sunsets.length
              ? sunsets[i]
              : null,
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

      // ---- Update Widget Here ----
      await updateWeatherWidget(
        iconType: getIconTypeFromWeatherCode(current.weathercode),
        temp: "${current.temperature.round()}°${useFahrenheit ? 'F' : 'C'}",
        desc: getWeatherDescription(current.weathercode),
        city: "Delhi",
      );

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

/// Helper: Map weather codes to icon types used in the widget.
/// Put this in widget_helper.dart if you want reusability!
String getIconTypeFromWeatherCode(int code) {
  if (code == 0) return 'sunny';
  if ([1, 2].contains(code)) return 'partly_cloudy';
  if (code == 3) return 'cloudy';
  if ([45, 48].contains(code)) return 'mist';
  if ([51, 53, 55, 61, 63, 65, 80, 81, 82].contains(code)) return 'rain';
  if ([71, 73, 75, 85, 86].contains(code)) return 'snow';
  if ([95, 96, 99].contains(code)) return 'thunder';
  return 'sunny'; // fallback
}
