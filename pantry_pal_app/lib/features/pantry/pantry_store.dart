import 'package:flutter/material.dart';
import 'package:pantry_pal/features/pantry/pantry_page.dart';

import '../api/api_http.dart';

enum PageSort {
  dateAddedAsc,
  dateAddedDesc,
  nameAsc,
  expiryDesc,
}

class PantryStore extends ChangeNotifier {
  PageSort _sort = PageSort.dateAddedDesc;
  PageSort get sort => _sort;

  List<PantryItem> _pantryItems = [];
  List<PantryItem> get pantryItems => _pantryItems;

  Future refreshPantryItems() async {
    _pantryItems = await ApiHttp().getPantryItems();
    _sortItems();

    notifyListeners();
  }

  setPageSort(PageSort newSort) {
    _sort = newSort;
    _sortItems();

    notifyListeners();
  }

  _sortItems() {
    switch (sort) {
      case PageSort.dateAddedAsc:
        _pantryItems.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case PageSort.dateAddedDesc:
        _pantryItems.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case PageSort.nameAsc:
        _pantryItems.sort((a, b) => a.name.compareTo(b.name));
        break;
      case PageSort.expiryDesc:
        _pantryItems.sort((a, b) => b.expiryDate.compareTo(a.expiryDate));
        break;
    }
  }
}
