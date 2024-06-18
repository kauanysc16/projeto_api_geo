
import 'package:exemplo_api/Model/favorites_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FavoritesController {
  final FavoritesModel _model = FavoritesModel(); 

  List<String> getFavorites() {
    return _model.favoriteItems;
  }

  void addToFavorites(String newItem) {
    _model.favoriteItems.add(newItem);
  }

  void removeFromFavorites(String itemToRemove) {
    _model.favoriteItems.remove(itemToRemove);
  }
}
