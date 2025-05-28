import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WeatherLottie extends StatelessWidget {
  final String weatherType;
  final double size;

  const WeatherLottie({
    super.key,
    required this.weatherType,
    this.size = 100,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mode = isDark ? 'dark' : 'light';
    final assetPath = 'assets/animation/ic_${weatherType}_$mode.json';

    return Lottie.asset(
      assetPath,
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}
