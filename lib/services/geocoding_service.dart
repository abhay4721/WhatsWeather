import 'dart:convert';
import 'package:http/http.dart' as http;

class GeocodingResult {
  final double latitude;
  final double longitude;
  final String name;

  GeocodingResult({required this.latitude, required this.longitude, required this.name});
}

class GeocodingService {
  static Future<GeocodingResult?> getLocation(String city) async {
    final url = Uri.parse(
      'https://geocoding-api.open-meteo.com/v1/search?name=$city&count=1'
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['results'] != null && data['results'].isNotEmpty) {
        final result = data['results'][0];
        return GeocodingResult(
          latitude: (result['latitude'] as num).toDouble(),
          longitude: (result['longitude'] as num).toDouble(),
          name: result['name'],
        );
      }
    }
    return null;
  }
}
