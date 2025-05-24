import 'package:flutter/material.dart';
import '../services/favorites_service.dart';

class FavoritesScreen extends StatefulWidget {
  final Function(String) onSelectCity;
  final int refresh;
  const FavoritesScreen({super.key, required this.onSelectCity, this.refresh = 0});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<String> _favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  @override
  void didUpdateWidget(covariant FavoritesScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.refresh != oldWidget.refresh) {
      _loadFavorites();
    }
  }

  Future<void> _loadFavorites() async {
    final favs = await FavoritesService.loadFavorites();
    setState(() => _favorites = favs);
  }

  Future<void> _removeFavorite(String city) async {
    _favorites.remove(city);
    await FavoritesService.saveFavorites(_favorites);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorite Cities")),
      body: _favorites.isEmpty
          ? const Center(child: Text("No favorite cities yet."))
          : ListView.separated(
              itemCount: _favorites.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, i) {
                final city = _favorites[i];
                return ListTile(
                  title: Text(city),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeFavorite(city),
                  ),
                  onTap: () => widget.onSelectCity(city),
                );
              },
            ),
    );
  }
}
