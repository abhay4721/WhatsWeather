import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static Future<void> setDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', value);
  }

  static Future<bool> getDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('darkMode') ?? false;
  }

  static Future<void> setUnit(bool useF) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('useFahrenheit', useF);
  }

  static Future<bool> getUnit() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('useFahrenheit') ?? false;
  }

  static Future<void> setDefaultCity(String city) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('defaultCity', city);
  }

  static Future<String> getDefaultCity() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('defaultCity') ?? "Delhi";
  }
}
