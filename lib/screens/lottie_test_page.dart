import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
// Update this path to where your lottieForWeather function is:
//import '../your_path/lottie_weather.dart';
import '../utils/lottie_weather.dart';

class LottieTestPage extends StatefulWidget {
  const LottieTestPage({Key? key}) : super(key: key);

  @override
  State<LottieTestPage> createState() => _LottieTestPageState();
}

class _LottieTestPageState extends State<LottieTestPage> {
  int _weatherCode = 0;
  int _hour = 0;

  // You can add more weather codes if you want
  final List<Map<String, dynamic>> _weatherOptions = [
    {'name': 'Clear (0)', 'code': 0},
    {'name': 'Cloudy (2)', 'code': 2},
    {'name': 'Fog (45)', 'code': 45},
    {'name': 'Rain (61)', 'code': 61},
    {'name': 'Snow (75)', 'code': 75},
    {'name': 'Thunder (95)', 'code': 95},
  ];

  @override
  Widget build(BuildContext context) {
    final lottiePath = lottieForWeather(
      _weatherCode,
      hour: _hour,
      context: context,
    );

    return Scaffold(
      appBar: AppBar(title: Text('Lottie Weather Tester')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Weather code selector
            Text('Weather:', style: TextStyle(fontSize: 18)),
            DropdownButton<int>(
              value: _weatherCode,
              items: _weatherOptions.map<DropdownMenuItem<int>>((opt) => DropdownMenuItem<int>(
  child: Text(opt['name']),
  value: opt['code'],
)).toList(),
              onChanged: (val) => setState(() => _weatherCode = val!),
            ),
            SizedBox(height: 16),
            // Hour slider
            Text('Hour (0=Midnight, 12=Noon, 23=11PM):', style: TextStyle(fontSize: 18)),
            Slider(
              min: 0, max: 23, divisions: 23,
              value: _hour.toDouble(),
              label: '$_hour',
              onChanged: (val) => setState(() => _hour = val.toInt()),
            ),
            SizedBox(height: 16),
            // See what the app theme is
            Text('Theme: ${Theme.of(context).brightness == Brightness.dark ? "Dark" : "Light"}'),
            SizedBox(height: 24),
            // The actual Lottie animation preview
            Lottie.asset(
              lottiePath,
              width: 120,
              height: 120,
              repeat: true,
            ),
            SizedBox(height: 8),
            // Shows which file path is being loaded
            Text('Lottie path: $lottiePath', style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
