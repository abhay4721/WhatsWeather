class WeatherResponse {
  final CurrentWeather current;
  final List<HourlyWeather> hourly;
  final List<DailyWeather> daily;

  WeatherResponse({required this.current, required this.hourly, required this.daily});

  factory WeatherResponse.fromJson(Map<String, dynamic> json) {
    // Parse daily data
    final dailyJson = json['daily'];
    final List<DailyWeather> dailyList = [];
    final List times = dailyJson['time'];
    final List maxTemps = dailyJson['temperature_2m_max'];
    final List minTemps = dailyJson['temperature_2m_min'];
    final List weathercodes = dailyJson['weathercode'];
    final List? humidities = dailyJson['humidity_2m_max'];
    final List? pressures = dailyJson['pressure_msl_max'];
    final List? sunrises = dailyJson['sunrise'];
    final List? sunsets = dailyJson['sunset'];

    for (int i = 0; i < times.length; i++) {
      dailyList.add(DailyWeather(
        date: times[i],
        maxTemp: (maxTemps[i] as num).toDouble(),
        minTemp: (minTemps[i] as num).toDouble(),
        weathercode: weathercodes[i],
        humidity: humidities != null ? (humidities[i] as num?)?.toDouble() : null,
        pressure: pressures != null ? (pressures[i] as num?)?.toDouble() : null,
        sunrise: sunrises != null ? sunrises[i] : null,
        sunset: sunsets != null ? sunsets[i] : null,
      ));
    }

    // Dummy parsing for current and hourly, update as per your logic
    return WeatherResponse(
      current: CurrentWeather.fromJson(json['current']),
      hourly: [], // Fill if you need hourly details
      daily: dailyList,
    );
  }
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
  final double? humidity;
  final double? pressure;
  final String? sunrise;
  final String? sunset;

  DailyWeather({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.weathercode,
    this.humidity,
    this.pressure,
    this.sunrise,
    this.sunset,
  });
}
