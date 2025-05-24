import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen.dart';
import 'screens/favorites_screen.dart';

void main() {
  runApp(const WhatsWeatherApp());
}

class WhatsWeatherApp extends StatefulWidget {
  const WhatsWeatherApp({super.key});
  @override
  State<WhatsWeatherApp> createState() => _WhatsWeatherAppState();
}

class _WhatsWeatherAppState extends State<WhatsWeatherApp> {
  bool _darkMode = false;
  int _selectedIndex = 0;
  String _currentCity = "Delhi";
  int _refreshFavorites = 0;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  // Load theme from SharedPreferences
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _darkMode = prefs.getBool('darkMode') ?? false;
    });
  }

  // Save theme setting
  Future<void> _saveTheme(bool dark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', dark);
  }

  void _toggleTheme() {
    setState(() => _darkMode = !_darkMode);
    _saveTheme(!_darkMode ? false : true); // Save after change
  }

  void _onNavTap(int idx) => setState(() => _selectedIndex = idx);

  void _onFavoritesChanged() {
    setState(() {
      _refreshFavorites++;
    });
  }

  void _onSelectFavorite(String city) {
    setState(() {
      _currentCity = city;
      _selectedIndex = 0;
    });
  }

  void _onCityChanged(String city) {
    setState(() {
      _currentCity = city;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WhatsWeather',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _darkMode ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            HomeScreen(
              initialCity: _currentCity,
              onThemeToggle: _toggleTheme,
              darkMode: _darkMode,
              onFavoritesChanged: _onFavoritesChanged,
              onCityChanged: _onCityChanged,
            ),
            FavoritesScreen(
              onSelectCity: _onSelectFavorite,
              refresh: _refreshFavorites,
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onNavTap,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.cloud),
              label: "Weather",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star),
              label: "Favorites",
            ),
          ],
        ),
      ),
    );
  }
}
