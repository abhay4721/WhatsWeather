import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../services/geocoding_service.dart';

class WeatherSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSearch;
  final VoidCallback onFavorite;
  final bool isFavorite;

  const WeatherSearchBar({
    super.key,
    required this.controller,
    required this.onSearch,
    required this.onFavorite,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: TypeAheadField<String>(
              textFieldConfiguration: TextFieldConfiguration(
                controller: controller,
                onSubmitted: (_) => onSearch(),
                textInputAction: TextInputAction.search,
                style: TextStyle(
                  color: scheme.onSurface,
                  fontSize: 18,
                ),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: scheme.primary),
                  hintText: "Search city...",
                  hintStyle: TextStyle(
                    color: scheme.onSurface.withOpacity(0.54),
                  ),
                  filled: true,
                  fillColor: scheme.surfaceVariant.withOpacity(0.8),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(28),
                    borderSide: BorderSide(
                      color: scheme.primary.withOpacity(0.17),
                      width: 1.1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(28),
                    borderSide: BorderSide(
                      color: scheme.primary.withOpacity(0.42),
                      width: 1.5,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
              ),
              suggestionsCallback: (pattern) async {
                if (pattern.length < 2) return [];
                return await GeocodingService.suggestCities(pattern);
              },
              itemBuilder: (context, String suggestion) {
                return ListTile(
                  title: Text(suggestion),
                );
              },
              onSuggestionSelected: (String suggestion) {
                controller.text = suggestion;
                onSearch();
              },
              suggestionsBoxDecoration: SuggestionsBoxDecoration(
                elevation: 6,
                borderRadius: BorderRadius.circular(18),
                color: scheme.background,
              ),
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: Icon(
              isFavorite ? Icons.star : Icons.star_border,
              color: isFavorite ? Colors.amber : scheme.primary.withOpacity(0.8),
            ),
            tooltip: isFavorite ? "Remove Favorite" : "Add Favorite",
            onPressed: onFavorite,
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward_ios_rounded, color: scheme.primary),
            tooltip: "Search",
            onPressed: onSearch,
          ),
        ],
      ),
    );
  }
}
