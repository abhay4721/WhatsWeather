import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'screens/home_screen.dart';
import 'screens/favorites_screen.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init(); // Make sure to init notifications!
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
  ColorScheme? _lightScheme;
  ColorScheme? _darkScheme;

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
    _saveTheme(!_darkMode ? false : true);
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
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        _lightScheme = lightDynamic ?? ColorScheme.fromSeed(seedColor: Colors.blue);
        _darkScheme = darkDynamic ?? ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark);

        return MaterialApp(
          title: 'WhatsWeather',
          theme: ThemeData(
            colorScheme: _lightScheme,
            useMaterial3: true,
            appBarTheme: AppBarTheme(
              backgroundColor: _lightScheme!.primaryContainer,
              foregroundColor: _lightScheme!.onPrimaryContainer,
              elevation: 0,
              titleTextStyle: TextStyle(
                color: _lightScheme!.onPrimaryContainer,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            scaffoldBackgroundColor: _lightScheme!.background,
            cardTheme: CardThemeData(
              color: _lightScheme!.surface,
              elevation: 3,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: _lightScheme!.surface,
              selectedItemColor: _lightScheme!.primary,
              unselectedItemColor: _lightScheme!.onSurface.withOpacity(0.7),
              type: BottomNavigationBarType.fixed,
            ),
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: _lightScheme!.primary),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: _lightScheme!.primary, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              filled: true,
              fillColor: _lightScheme!.surfaceVariant,
            ),
          ),
          darkTheme: ThemeData(
            colorScheme: _darkScheme,
            useMaterial3: true,
            appBarTheme: AppBarTheme(
              backgroundColor: _darkScheme!.primaryContainer,
              foregroundColor: _darkScheme!.onPrimaryContainer,
              elevation: 0,
              titleTextStyle: TextStyle(
                color: _darkScheme!.onPrimaryContainer,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            scaffoldBackgroundColor: _darkScheme!.background,
            cardTheme: CardThemeData(
              color: _darkScheme!.surface,
              elevation: 3,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: _darkScheme!.surface,
              selectedItemColor: _darkScheme!.primary,
              unselectedItemColor: _darkScheme!.onSurface.withOpacity(0.7),
              type: BottomNavigationBarType.fixed,
            ),
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: _darkScheme!.primary),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: _darkScheme!.primary, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              filled: true,
              fillColor: _darkScheme!.surfaceVariant,
            ),
          ),
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
      },
    );
  }
}
