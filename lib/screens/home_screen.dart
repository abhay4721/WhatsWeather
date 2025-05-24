import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';
import '../widgets/weekly_forecast.dart';
import '../widgets/weather_card.dart';
import '../widgets/hourly_forecast.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  WeatherResponse? weather;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetch();
  }

  Future<void> fetch() async {
    setState(() => isLoading = true);
    final data = await WeatherService.fetchWeather();
    setState(() {
      weather = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WhatsWeather'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetch,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : weather == null
              ? const Center(child: Text('Failed to load weather data.'))
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      WeatherCard(current: weather!.current),
                      const SizedBox(height: 8),
                      HourlyForecast(hourly: weather!.hourly),
                      const SizedBox(height: 8),
                      WeeklyForecast(daily: weather!.daily),
                    ],
                  ),
                ),
    );
  }
}
