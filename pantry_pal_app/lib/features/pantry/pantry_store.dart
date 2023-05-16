import 'package:flutter/material.dart';

import '../api/api_http.dart';

enum PageSort {
  dateAddedAsc,
  dateAddedDesc,
  nameAsc,
  expiryAsc,
}

class PantryStore extends ChangeNotifier {
  PageSort _sort = PageSort.dateAddedDesc;
  PageSort get sort => _sort;

  List<PantryItem> _allPantryItems = [];
  List<PantryItem> get allPantryItems => _allPantryItems;

  Future refreshPantryItems() async {
    _allPantryItems = await ApiHttp().getPantryItems();
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
        _allPantryItems.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case PageSort.dateAddedDesc:
        _allPantryItems.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case PageSort.nameAsc:
        _allPantryItems.sort((a, b) => a.name.compareTo(b.name));
        break;
      case PageSort.expiryAsc:
        _allPantryItems.sort((a, b) => a.expiryDate.compareTo(b.expiryDate));
        break;
    }
  }
}
