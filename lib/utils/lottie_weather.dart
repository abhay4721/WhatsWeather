String lottieForWeather(int code, {int? hour}) {
  final isNight = hour != null && (hour < 6 || hour >= 19);

  // Clear sky
  if (code == 0) {
    if (isNight) return "assets/lottie/night.json";
    return "assets/lottie/sunny.json";
  }

  // Cloudy & Partly Cloudy
  if (code == 1 || code == 2 || code == 3) return "assets/lottie/cloudy.json";

  // Fog
  if (code == 45 || code == 48) return "assets/lottie/fog.json";

  // Rain
  if ([51, 53, 55, 61, 63, 65, 80, 81, 82].contains(code)) return "assets/lottie/rain.json";

  // Snow
  if ([71, 73, 75, 77, 85, 86].contains(code)) return "assets/lottie/snow.json";

  // Thunderstorm
  if ([95, 96, 99].contains(code)) return "assets/lottie/thunder.json";

  // Default fallback
  if (isNight) return "assets/lottie/night.json";
  return "assets/lottie/cloudy.json";
}
