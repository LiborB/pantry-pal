import 'package:flutter/material.dart';

import '../api/api_http.dart';

class PantryStore extends ChangeNotifier {
  List<PantryItem> _pantryItems = [];

  List<PantryItem> get pantryItems => _pantryItems;

  Future refreshPantryItems() async {
    _pantryItems = await ApiHttp().getPantryItems();

    notifyListeners();
  }
}
