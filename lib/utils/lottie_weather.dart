import 'package:flutter/material.dart';

String lottieForWeather(
  int code, {
  required BuildContext context,
  int? hour,
}) {
  final isNight = hour != null && (hour < 6 || hour >= 19);
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final mode = isDark ? 'dark' : 'light';

  // Clear sky
  if (code == 0) {
    if (isNight) return "assets/lottie/night_$mode.json";
    return "assets/lottie/sunny_$mode.json";
  }

  // Cloudy & Partly Cloudy
  if (code == 1 || code == 2 || code == 3) return "assets/lottie/cloudy_$mode.json";

  // Fog
  if (code == 45 || code == 48) return "assets/lottie/fog_$mode.json";

  // Rain
  if ([51, 53, 55, 61, 63, 65, 80, 81, 82].contains(code)) return "assets/lottie/rain_$mode.json";

  // Snow
  if ([71, 73, 75, 77, 85, 86].contains(code)) return "assets/lottie/snow_$mode.json";

  // Thunderstorm
  if ([95, 96, 99].contains(code)) return "assets/lottie/thunder_$mode.json";

  // Default fallback
  if (isNight) return "assets/lottie/night_$mode.json";
  return "assets/lottie/cloudy_$mode.json";
}
