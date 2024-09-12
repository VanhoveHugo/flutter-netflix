import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FavoritesProvider with ChangeNotifier {
  List<dynamic> _favoriteMovies = [];

  List<dynamic> get favoriteMovies => _favoriteMovies;

  FavoritesProvider() {
    _loadFavorites();
  }

  void _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? favoritesString = prefs.getString('favoriteMovies');
    if (favoritesString != null) {
      _favoriteMovies = json.decode(favoritesString);
      notifyListeners();
    }
  }

  void toggleFavorite(dynamic movie) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_favoriteMovies.any((item) => item['imdbID'] == movie['imdbID'])) {
      _favoriteMovies.removeWhere((item) => item['imdbID'] == movie['imdbID']);
    } else {
      _favoriteMovies.add(movie);
    }
    await prefs.setString('favoriteMovies', json.encode(_favoriteMovies));
    notifyListeners();
  }

  bool isFavorite(dynamic movie) {
    return _favoriteMovies.any((item) => item['imdbID'] == movie['imdbID']);
  }
}
