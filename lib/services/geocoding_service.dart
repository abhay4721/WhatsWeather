import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class LocationResult {
  final String name;
  final double latitude;
  final double longitude;

  LocationResult({
    required this.name,
    required this.latitude,
    required this.longitude,
  });
}

class GeocodingService {
  // Open-Meteo/Nominatim geocoding endpoint
  static const _baseUrl = 'https://geocoding-api.open-meteo.com/v1/search';

  /// Searches for a location by name (city, town, etc.).
  static Future<LocationResult?> getLocation(String name) async {
    final url = Uri.parse('$_baseUrl?name=${Uri.encodeComponent(name)}&count=1&language=en');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['results'] != null && data['results'].isNotEmpty) {
        final first = data['results'][0];
        return LocationResult(
          name: first['name'],
          latitude: first['latitude'],
          longitude: first['longitude'],
        );
      } else {
        // No results found
        return null;
      }
    } else {
      // Error from API
      return null;
    }
  }

  /// Suggest cities for autocomplete
static Future<List<String>> suggestCities(String pattern) async {
  if (pattern.isEmpty) return [];
  final url = Uri.parse('$_baseUrl?name=${Uri.encodeComponent(pattern)}&count=5&language=en');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    if (data['results'] != null && data['results'].isNotEmpty) {
      // Return a list of city names (and optionally, state/country)
      return List<String>.from(
        data['results'].map<String>((item) {
          String city = item['name'] ?? '';
          String? admin = item['admin1'];
          String? country = item['country'];
          if (admin != null && admin.isNotEmpty && admin != city) city += ', $admin';
          if (country != null && country.isNotEmpty && country != city) city += ', $country';
          return city;
        }),
      );
    }
  }
  return [];
}

  /// Gets the current GPS location of the device.
  static Future<Position> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
}
