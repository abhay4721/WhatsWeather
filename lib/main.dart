import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'weather_service.dart';

void main() => runApp(WeatherApp());

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather Forecast',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.dark,
      home: WeatherHomePage(),
    );
  }
}

class WeatherHomePage extends StatefulWidget {
  @override
  _WeatherHomePageState createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  String _cityName = '';
  String _condition = '';
  String _temperature = '';
  String _errorMessage = '';

  Future<void> _getWeather() async {
    final city = _controller.text.trim();
    if (city.isEmpty) {
      setState(() => _errorMessage = 'Please enter a city name');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _cityName = '';
      _condition = '';
      _temperature = '';
    });

    try {
      final data = await WeatherService.fetchWeather(city);
      if (data == null) {
        setState(() => _errorMessage = 'City not found');
        return;
      }

      setState(() {
        _cityName = data.description.split('\n')[0];
        _condition = data.condition.toLowerCase();
        _temperature = data.description.split('\n')[2];
      });
    } catch (e) {
      setState(() => _errorMessage = 'Failed to fetch weather');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String _getAnimationAsset(String condition) {
    switch (condition) {
      case 'clear':
        return 'assets/animations/sunny.json';
      case 'rain':
        return 'assets/animations/rainy.json';
      case 'clouds':
        return 'assets/animations/cloudy.json';
      case 'snow':
        return 'assets/animations/snowy.json';
      default:
        return 'assets/animations/default.json';
    }
  }

  @override
  Widget build(BuildContext context) {
    final animationAsset = _condition.isNotEmpty 
        ? _getAnimationAsset(_condition) 
        : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Weather Forecast')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter City',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _getWeather,
                ),
              ),
              onSubmitted: (_) => _getWeather(),
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const CircularProgressIndicator()
            else if (_errorMessage.isNotEmpty)
              Text(_errorMessage, style: TextStyle(color: Colors.red))
            else if (_cityName.isNotEmpty)
              Column(
                children: [
                  Text(
                    _cityName,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _condition.toUpperCase(),
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _temperature,
                    style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  if (animationAsset != null)
                    SizedBox(
                      height: 200,
                      child: Lottie.asset(animationAsset),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}