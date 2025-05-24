import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

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

  void _toggleTheme() {
    setState(() => _darkMode = !_darkMode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WhatsWeather',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _darkMode ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: HomeScreen(
        onThemeToggle: _toggleTheme,
        darkMode: _darkMode,
      ),
    );
  }
}
