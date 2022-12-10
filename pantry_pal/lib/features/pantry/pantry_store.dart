import 'package:flutter/material.dart';
import 'package:pantry_pal/features/pantry/api_service.dart';
import 'package:pantry_pal/shared/api_http.dart';

class PantryStore extends ChangeNotifier {
  List<PantryItem> _pantryItems = [];

  List<PantryItem> get pantryItems => _pantryItems;

  Future refreshPantryItems() async {
    _pantryItems = await PantryService.getPantryItems();

    notifyListeners();
  }
}
