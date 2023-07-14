import 'package:flutter/material.dart';
import 'package:pantry_pal/store/app_store.dart';

import '../api/api_http.dart';
import '../api/models/pantry.dart';

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

  Product? _product;
  Product? get product => _product;

  AppStore appStore;

  PantryStore(this.appStore) {
      appStore.selectedHousehold.addListener(refreshPantryItems);
  }

  @override
  void dispose() {
    appStore.selectedHousehold.removeListener(refreshPantryItems);
    super.dispose();
  }

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
        _allPantryItems.sort((a, b) => a.productName.compareTo(b.productName));
        break;
      case PageSort.expiryAsc:
        _allPantryItems.sort((a, b) => a.expiryDate.compareTo(b.expiryDate));
        break;
    }
  }

  Future<Product> getProductInformation(String barcode) async {
    final info = await ApiHttp().getProductInformation(
      appStore.householdId,
      barcode,
    );
    _product = info;

    return info;
  }

  updatePantryItem(UpdatePantryItem item) async {
    await ApiHttp().updatePantryItem(appStore.householdId, item);
    await refreshPantryItems();
  }

  createPantryItem(UpdatePantryItem item) async {
    if (_product != null) {
      item.quantity = _product!.quantity;
      item.quantityUnit = _product!.quantityUnit;
      item.energyPer100g = _product!.energyPer100g;
    }

    await ApiHttp().createPantryItem(appStore.householdId, item);
    await refreshPantryItems();
  }
}
