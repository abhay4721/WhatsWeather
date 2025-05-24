import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const WhatsWeatherApp());
}

class WhatsWeatherApp extends StatelessWidget {
  const WhatsWeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WhatsWeather',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
