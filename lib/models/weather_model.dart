class WeatherResponse {
  final CurrentWeather current;
  final List<HourlyWeather> hourly;
  final List<DailyWeather> daily;

  WeatherResponse({required this.current, required this.hourly, required this.daily});
}

class CurrentWeather {
  final double temperature;
  final double windspeed;
  final int weathercode;

  CurrentWeather({required this.temperature, required this.windspeed, required this.weathercode});

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      temperature: (json['temperature'] as num).toDouble(),
      windspeed: (json['windspeed'] as num).toDouble(),
      weathercode: json['weathercode'],
    );
  }
}

class HourlyWeather {
  final String time;
  final double temperature;
  final int weathercode;

  HourlyWeather({required this.time, required this.temperature, required this.weathercode});
}

class DailyWeather {
  final String date;
  final double maxTemp;
  final double minTemp;
  final int weathercode;

  DailyWeather({required this.date, required this.maxTemp, required this.minTemp, required this.weathercode});
}
