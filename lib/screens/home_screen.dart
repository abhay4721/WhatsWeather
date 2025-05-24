import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';
import '../services/geocoding_service.dart';
import '../widgets/weekly_forecast.dart';
import '../widgets/weather_card.dart';
import '../widgets/hourly_forecast.dart';
import '../config.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  WeatherResponse? weather;
  bool isLoading = true;
  String _city = "Delhi";
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetch(); // Default fetch for Delhi
  }

  Future<void> fetch({double? latitude, double? longitude}) async {
    setState(() => isLoading = true);
    final data = await WeatherService.fetchWeather(
      latitude: latitude ?? defaultLatitude,
      longitude: longitude ?? defaultLongitude,
    );
    setState(() {
      weather = data;
      isLoading = false;
    });
  }

  Future<void> _searchCity() async {
    if (_searchController.text.isEmpty) return;
    final result = await GeocodingService.getLocation(_searchController.text);
    if (result != null) {
      setState(() {
        _city = result.name;
      });
      fetch(latitude: result.latitude, longitude: result.longitude);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('City not found')),
      );
    }
  }

  Future<void> _fetchMyLocationWeather() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location services are disabled.')),
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied')),
        );
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permissions are permanently denied')),
      );
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _city = "My Location";
    });
    fetch(latitude: position.latitude, longitude: position.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WhatsWeather - $_city'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : weather == null
              ? const Center(child: Text('Failed to load weather data.'))
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Search Bar
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                decoration: const InputDecoration(
                                  hintText: "Enter city name",
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 8),
                                ),
                                onSubmitted: (v) => _searchCity(),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.search),
                              onPressed: _searchCity,
                            ),
                            IconButton(
                              icon: const Icon(Icons.my_location),
                              onPressed: _fetchMyLocationWeather,
                            ),
                          ],
                        ),
                      ),
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
