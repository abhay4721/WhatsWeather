import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherData {
  final String description;
  final String condition;

  WeatherData({required this.description, required this.condition});
}

class WeatherService {
  static const _apiKey = ''; // WARNING: Replace with your own OpenWeatherMap API key
// Get one at: https://openweathermap.org/api

  static Future<WeatherData?> fetchWeather(String city) async {
    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$_apiKey&units=metric',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final temp = data['main']['temp'];
        final condition = data['weather'][0]['main'];
        final cityName = data['name'];
        final description = '$cityName\n$condition\n${temp.toString()} °C';
        return WeatherData(description: description, condition: condition);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}