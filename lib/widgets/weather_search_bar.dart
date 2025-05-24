import 'package:flutter/material.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(32),
        color: scheme.surface,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: scheme.primary.withOpacity(0.18),
              width: 1.3,
            ),
          ),
          child: Row(
            children: [
              const SizedBox(width: 16),
              Icon(Icons.search, color: scheme.primary.withOpacity(0.8)),
              const SizedBox(width: 6),
              Expanded(
                child: TextField(
                  controller: controller,
                  onSubmitted: (_) => onSearch(),
                  textInputAction: TextInputAction.search,
                  style: TextStyle(
                    color: scheme.onSurface,
                    fontSize: 18,
                  ),
                  decoration: InputDecoration(
                    hintText: "Search city...",
                    hintStyle: TextStyle(
                      color: scheme.onSurface.withOpacity(0.5),
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.star : Icons.star_border,
                  color: isFavorite ? Colors.amber : scheme.primary.withOpacity(0.7),
                ),
                tooltip: isFavorite ? "Remove Favorite" : "Add Favorite",
                onPressed: onFavorite,
              ),
              const SizedBox(width: 6),
              IconButton(
                icon: Icon(Icons.arrow_forward_ios_rounded, color: scheme.primary),
                tooltip: "Search",
                onPressed: onSearch,
              ),
              const SizedBox(width: 6),
            ],
          ),
        ),
      ),
    );
  }
}
