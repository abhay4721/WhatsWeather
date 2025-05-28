import 'package:flutter/material.dart';

// Helper function to map weather codes to Lottie type strings
String _weatherTypeFromCode(int code) {
  if (code == 0) return 'sunny';
  if (code == 1) return 'cloudy';
  if (code == 2) return 'cloudy';
  if (code == 3) return 'cloudy';
  if ([45, 48].contains(code)) return 'fog';
  if ([51, 53, 55, 61, 63, 65, 80, 81, 82].contains(code)) return 'rain';
  if ([71, 73, 75, 77, 85, 86].contains(code)) return 'snow';
  if ([95, 96, 99].contains(code)) return 'thunder';
  return 'sunny'; // fallback
}

///
/// Returns the correct Lottie animation file path based on weather code and theme mode.
///
String lottieForWeather(int weatherCode, {required BuildContext context, int? hour}) {
  final isNight = hour != null && (hour < 6 || hour >= 19);
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final mode = isDark ? 'dark' : 'light';
  String type = _weatherTypeFromCode(weatherCode);

  // Optionally, you can override for night-time (if you use separate night Lotties)
  // if (isNight && type == 'sunny') type = 'night'; // Example if you have night.json

  // Result: assets/animation/ic_sunny_dark.json etc
  return 'assets/lottie/${type}_$mode.json';
}
