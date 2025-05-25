import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'screens/home_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/settings_screen.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
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
  bool _useFahrenheit = false;
  bool _isPrefsLoaded = false; // <-- Add this flag

  ColorScheme? _lightScheme;
  ColorScheme? _darkScheme;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _darkMode = prefs.getBool('darkMode') ?? false;
      _currentCity = prefs.getString('defaultCity') ?? "Delhi";
      _useFahrenheit = prefs.getBool('useFahrenheit') ?? false;
      _isPrefsLoaded = true; // <-- Only show app after loading
    });
  }

  // ... (rest of your methods remain unchanged)

  void _onNavTap(int idx) => setState(() => _selectedIndex = idx);

  void _onFavoritesChanged() => setState(() => _refreshFavorites++);

  void _onSelectFavorite(String city) {
    setState(() {
      _currentCity = city;
      _selectedIndex = 0;
    });
    _savePrefs();
  }

  void _onCityChanged(String city) {
    setState(() {
      _currentCity = city;
    });
    _savePrefs();
  }

  Future<void> _savePrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', _darkMode);
    await prefs.setString('defaultCity', _currentCity);
    await prefs.setBool('useFahrenheit', _useFahrenheit);
  }

  void _openSettings(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SettingsScreen(
          darkMode: _darkMode,
          useFahrenheit: _useFahrenheit,
          defaultCity: _currentCity,
        ),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        _darkMode = result['darkMode'] ?? _darkMode;
        _useFahrenheit = result['useFahrenheit'] ?? _useFahrenheit;
        _currentCity = result['defaultCity'] ?? _currentCity;
      });
      _savePrefs();
    }
  }

  @override
  Widget build(BuildContext context) {
    // --- SHOW A SPLASH/LOADING SCREEN UNTIL PREFS LOADED ---
    if (!_isPrefsLoaded) {
      return MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.black, // Or dark color if you want!
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
        debugShowCheckedModeBanner: false,
      );
    }

    // --- REST OF YOUR APP ---
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        _lightScheme = lightDynamic ?? ColorScheme.fromSeed(seedColor: Colors.blue);
        _darkScheme = darkDynamic ?? ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark);

        return MaterialApp(
          title: 'WhatsWeather',
          theme: ThemeData(
            colorScheme: _lightScheme,
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: _darkScheme,
            useMaterial3: true,
          ),
          themeMode: _darkMode ? ThemeMode.dark : ThemeMode.light,
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: IndexedStack(
              index: _selectedIndex,
              children: [
                HomeScreen(
                  initialCity: _currentCity,
                  useFahrenheit: _useFahrenheit,
                  darkMode: _darkMode,
                  onFavoritesChanged: _onFavoritesChanged,
                  onCityChanged: _onCityChanged,
                  onSettingsPressed: () => _openSettings(context),
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
      },
    );
  }
}
