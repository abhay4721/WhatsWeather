import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';
import '../services/geocoding_service.dart';
import '../services/favorites_service.dart';
import '../widgets/weekly_forecast.dart';
import '../widgets/hourly_forecast.dart';
import '../widgets/weather_search_bar.dart'; // <<-- Add this import
import '../utils/weather_icon.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onThemeToggle;
  final bool darkMode;
  final String initialCity;
  final VoidCallback? onFavoritesChanged;
  final ValueChanged<String>? onCityChanged;

  const HomeScreen({
    super.key,
    this.onThemeToggle,
    this.darkMode = false,
    this.initialCity = "Delhi",
    this.onFavoritesChanged,
    this.onCityChanged,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  WeatherResponse? weather;
  bool isLoading = true;
  late String _city;
  TextEditingController _searchController = TextEditingController();
  List<String> _favorites = [];

  @override
  void initState() {
    super.initState();
    _city = widget.initialCity;
    _searchController.text = _city;
    _initFavorites();
    fetchForCity(_city);
  }

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialCity != oldWidget.initialCity && widget.initialCity != _city) {
      _city = widget.initialCity;
      _searchController.text = _city;
      fetchForCity(_city);
    }
  }

  Future<void> _initFavorites() async {
    final favs = await FavoritesService.loadFavorites();
    setState(() => _favorites = favs);
  }

  Future<void> fetchForCity(String city) async {
    setState(() => isLoading = true);
    final result = await GeocodingService.getLocation(city);
    if (result != null) {
      setState(() {
        _city = result.name;
        _searchController.text = result.name;
      });
      widget.onCityChanged?.call(result.name);
      final data = await WeatherService.fetchWeather(latitude: result.latitude, longitude: result.longitude);
      setState(() {
        weather = data;
        isLoading = false;
      });
    } else {
      setState(() {
        weather = null;
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('City not found')),
      );
    }
  }

  Future<void> _searchCity() async {
    if (_searchController.text.isEmpty) return;
    await fetchForCity(_searchController.text);
  }

  void _toggleFavorite() async {
    if (_city == "My Location") return; // Don't favorite GPS
    setState(() {
      if (_favorites.contains(_city)) {
        _favorites.remove(_city);
      } else {
        _favorites.add(_city);
      }
    });
    await FavoritesService.saveFavorites(_favorites);
    if (widget.onFavoritesChanged != null) widget.onFavoritesChanged!();
  }

  bool get _isFavorite => _favorites.contains(_city);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: scheme.primaryContainer,
        elevation: 0,
        title: Text(
          'WhatsWeather - $_city',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: scheme.onPrimaryContainer,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              widget.darkMode ? Icons.dark_mode : Icons.light_mode,
              color: scheme.onPrimaryContainer,
            ),
            tooltip: 'Toggle Theme',
            onPressed: widget.onThemeToggle,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : weather == null
              ? const Center(child: Text('Failed to load weather data.'))
              : RefreshIndicator(
                  onRefresh: () async => await fetchForCity(_city),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // MODERN SEARCH BAR
                        WeatherSearchBar(
                          controller: _searchController,
                          onSearch: _searchCity,
                          onFavorite: _toggleFavorite,
                          isFavorite: _isFavorite,
                        ),
                        const SizedBox(height: 8),

                        // Floating weather card
                        Center(
                          child: Card(
                            elevation: 10,
                            color: scheme.primaryContainer.withOpacity(0.85),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 38),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    getWeatherIcon(weather!.current.weathercode, hour: DateTime.now().hour),
                                    size: 78,
                                    color: scheme.primary,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    '${weather!.current.temperature.toStringAsFixed(1)}°C',
                                    style: TextStyle(
                                      fontSize: 48,
                                      fontWeight: FontWeight.bold,
                                      color: scheme.onPrimaryContainer,
                                      letterSpacing: -2,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _weatherDescription(weather!.current.weathercode),
                                    style: TextStyle(
                                      color: scheme.onPrimaryContainer.withOpacity(0.8),
                                      fontSize: 19,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.air, color: scheme.secondary, size: 20),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Wind: ${weather!.current.windspeed.toStringAsFixed(1)} km/h',
                                        style: TextStyle(
                                          color: scheme.onPrimaryContainer.withOpacity(0.8),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Today and hourly
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 8, 20, 6),
                          child: Row(
                            children: [
                              Text(
                                "Today",
                                style: TextStyle(
                                  color: scheme.onBackground,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                DateFormat('EEEE, MMM d').format(DateTime.now()),
                                style: TextStyle(
                                  color: scheme.onBackground.withOpacity(0.7),
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        HourlyForecast(hourly: weather!.hourly),

                        const SizedBox(height: 10),

                        // Weekly
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
                          child: Text(
                            "7-Day Forecast",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: scheme.onBackground,
                            ),
                          ),
                        ),
                        WeeklyForecast(daily: weather!.daily),
                        const SizedBox(height: 26),
                      ],
                    ),
                  ),
                ),
    );
  }

  // Weather code to description (simplified for demo)
  String _weatherDescription(int code) {
    switch (code) {
      case 0:
        return "Clear Sky";
      case 1:
        return "Mainly Clear";
      case 2:
        return "Partly Cloudy";
      case 3:
        return "Overcast";
      case 45:
      case 48:
        return "Fog";
      case 51:
      case 53:
      case 55:
        return "Drizzle";
      case 61:
      case 63:
      case 65:
      case 80:
      case 81:
      case 82:
        return "Rain Showers";
      case 71:
      case 73:
      case 75:
      case 77:
      case 85:
      case 86:
        return "Snow";
      case 95:
      case 96:
      case 99:
        return "Thunderstorm";
      default:
        return "Condition Code: $code";
    }
  }
}
