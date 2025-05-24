import 'package:flutter/material.dart';
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
  int _refreshFavorites = 0; // Used to force refresh of FavoritesScreen

  void _toggleTheme() => setState(() => _darkMode = !_darkMode);

  void _onNavTap(int idx) => setState(() => _selectedIndex = idx);

  // Called when a favorite is added/removed, to refresh the screen
  void _onFavoritesChanged() {
    setState(() {
      _refreshFavorites++; // just triggers rebuild of FavoritesScreen
    });
  }

  // Called when a favorite city is selected
  void _onSelectFavorite(String city) {
    setState(() {
      _currentCity = city;
      _selectedIndex = 0;
    });
  }

  // Called when city is changed from the HomeScreen (search/star/click)
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
