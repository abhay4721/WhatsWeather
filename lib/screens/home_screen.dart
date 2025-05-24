import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';
import '../services/geocoding_service.dart';
import '../services/favorites_service.dart';
import '../widgets/weekly_forecast.dart';
import '../widgets/weather_card.dart';
import '../widgets/hourly_forecast.dart';
import '../config.dart';

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
    // If initialCity changes, load that city
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

  Future<void> fetchForCity(String city) async {
    setState(() => isLoading = true);
    final result = await GeocodingService.getLocation(city);
    if (result != null) {
      setState(() {
        _city = result.name;
        _searchController.text = result.name;
      });
      widget.onCityChanged?.call(result.name);
      await fetch(latitude: result.latitude, longitude: result.longitude);
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
      _searchController.text = "My Location";
    });
    widget.onCityChanged?.call("My Location");
    await fetch(latitude: position.latitude, longitude: position.longitude);
  }

  // Favorite toggle logic
  void _toggleFavorite() async {
    if (_city == "My Location") return; // Don't favorite current GPS
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
    return Scaffold(
      appBar: AppBar(
        title: Text('WhatsWeather - $_city'),
        actions: [
          IconButton(
            icon: Icon(widget.darkMode ? Icons.dark_mode : Icons.light_mode),
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
                  onRefresh: () async {
                    await fetchForCity(_city);
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
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
                                icon: Icon(
                                  _isFavorite ? Icons.star : Icons.star_border,
                                  color: _isFavorite ? Colors.amber : null,
                                ),
                                tooltip: _isFavorite ? "Remove Favorite" : "Add Favorite",
                                onPressed: _toggleFavorite,
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
                ),
    );
  }
}
