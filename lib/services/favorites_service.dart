import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const _key = "favorite_cities";

  // Save the list of cities
  static Future<void> saveFavorites(List<String> cities) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, cities);
  }

  // Load the list of cities
  static Future<List<String>> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }
}
