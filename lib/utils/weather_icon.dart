import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

/// Returns the correct WeatherIcons icon based on weather code and hour.
IconData getWeatherIcon(int code, {required int hour}) {
  final isDay = hour >= 6 && hour < 18;

  // Clear
  if (code == 0) return isDay ? WeatherIcons.day_sunny : WeatherIcons.night_clear;
  // Mainly clear
  if (code == 1) return isDay ? WeatherIcons.day_sunny_overcast : WeatherIcons.night_alt_partly_cloudy;
  // Partly cloudy
  if (code == 2) return isDay ? WeatherIcons.day_cloudy : WeatherIcons.night_alt_cloudy;
  // Overcast
  if (code == 3) return WeatherIcons.cloudy;
  // Fog
  if (code == 45 || code == 48) return isDay ? WeatherIcons.day_fog : WeatherIcons.night_fog;
  // Drizzle
  if ([51, 53, 55, 56, 57].contains(code)) return isDay ? WeatherIcons.day_sprinkle : WeatherIcons.night_alt_sprinkle;
  // Rain
  if ([61, 63, 65, 66, 67].contains(code)) return isDay ? WeatherIcons.day_rain : WeatherIcons.night_alt_rain;
  // Rain showers
  if ([80, 81, 82].contains(code)) return isDay ? WeatherIcons.day_showers : WeatherIcons.night_alt_showers;
  // Snow
  if ([71, 73, 75, 77, 85, 86].contains(code)) return isDay ? WeatherIcons.day_snow : WeatherIcons.night_alt_snow;
  // Thunderstorm
  if ([95, 96, 99].contains(code)) return isDay ? WeatherIcons.day_thunderstorm : WeatherIcons.night_alt_thunderstorm;
  // Unknown
  return isDay ? WeatherIcons.day_sunny : WeatherIcons.night_clear;
}

Color getWeatherIconColor(int code) {
  if (code == 0) return Colors.orange; // Sunny
  if (code == 1 || code == 2 || code == 3) return Colors.grey; // Clouds
  if (code == 45 || code == 48) return Colors.blueGrey; // Fog
  if ([51, 53, 55, 56, 57].contains(code)) return Colors.blueAccent; // Drizzle
  if ([61, 63, 65, 66, 67, 80, 81, 82].contains(code)) return Colors.blue; // Rain
  if ([71, 73, 75, 77, 85, 86].contains(code)) return Colors.lightBlueAccent; // Snow
  if ([95, 96, 99].contains(code)) return Colors.purple; // Thunderstorm
  return Colors.grey;
}
