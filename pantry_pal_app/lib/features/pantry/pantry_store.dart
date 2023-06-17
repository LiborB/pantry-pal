import 'package:flutter/material.dart';
import 'package:pantry_pal/store/app_store.dart';

import '../api/api_http.dart';

enum PageSort {
  dateAddedAsc,
  dateAddedDesc,
  nameAsc,
  expiryAsc,
}

class PantryStore extends ChangeNotifier {
  PantryStore(this.appStore);

  PageSort _sort = PageSort.dateAddedDesc;

  PageSort get sort => _sort;

  List<PantryItem> _allPantryItems = [];

  List<PantryItem> get allPantryItems => _allPantryItems;

   AppStore appStore;

  Future refreshPantryItems() async {
    _allPantryItems = await ApiHttp().getPantryItems(appStore.householdId);
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

  getProductInformation(String barcode) async {
    return await ApiHttp().getProductInformation(
      appStore.householdId,
      barcode,
    );
  }

  updatePantryItem(UpdatePantryItem item) async {
    await ApiHttp().updatePantryItem(appStore.householdId, item);
    await refreshPantryItems();
  }
}
