import 'package:flutter/material.dart';

class FavoritesManager extends ChangeNotifier {
  final Set<String> _favoriteIds = {};

  bool isFavorite(String id) => _favoriteIds.contains(id);

  void toggleFavorite(String id) {
    if (_favoriteIds.contains(id)) {
      _favoriteIds.remove(id);
    } else {
      _favoriteIds.add(id);
    }
    notifyListeners();
  }

  List<String> get favoriteIds => _favoriteIds.toList();
}

final favoritesManager = FavoritesManager();
