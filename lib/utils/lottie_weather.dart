String lottieForWeather(int code) {
  // Customize this as needed for your WMO codes!
  if (code == 0) return "assets/lottie/sunny.json";
  if (code == 1 || code == 2) return "assets/lottie/cloudy.json";
  if (code == 3) return "assets/lottie/cloudy.json";
  if (code == 45 || code == 48) return "assets/lottie/fog.json";
  if ([51, 53, 55, 61, 63, 65, 80, 81, 82].contains(code)) return "assets/lottie/rain.json";
  if ([71, 73, 75, 77, 85, 86].contains(code)) return "assets/lottie/snow.json";
  if ([95, 96, 99].contains(code)) return "assets/lottie/thunder.json";
  return "assets/lottie/cloudy.json";
}
