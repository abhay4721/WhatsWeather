import 'package:http/http.dart' as http;
import 'dart:convert';

// Simple city geocoding result
class GeocodingResult {
  final String name;
  final double latitude;
  final double longitude;

  GeocodingResult({
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  factory GeocodingResult.fromJson(Map<String, dynamic> json) {
    return GeocodingResult(
      name: json['name'],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }
}

class GeocodingService {
  // 1. Get location info for a city name
  static Future<GeocodingResult?> getLocation(String city) async {
    final url = 'https://geocoding-api.open-meteo.com/v1/search?name=$city&count=1&language=en&format=json';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['results'] != null && data['results'].isNotEmpty) {
        return GeocodingResult.fromJson(data['results'][0]);
      }
    }
    return null;
  }

  // 2. Suggest city names for autocomplete
  static Future<List<String>> suggestCities(String query) async {
    if (query.isEmpty) return [];
    final url = 'https://geocoding-api.open-meteo.com/v1/search?name=$query&count=6&language=en&format=json';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['results'] != null) {
        // Show city + country if possible for clarity
        return List<String>.from(
          data['results'].map((e) => e['country'] != null
              ? "${e['name']}, ${e['country']}"
              : e['name']
          ),
        );
      }
    }
    return [];
  }
}
