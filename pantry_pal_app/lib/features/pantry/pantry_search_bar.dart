import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pantry_pal/features/pantry/pantry_store.dart';
import 'package:pantry_pal/features/pantry/util/expiry.dart';
import 'package:provider/provider.dart';

import 'create_item_page.dart';

class PantrySearchBar extends StatefulWidget {
  const PantrySearchBar({Key? key}) : super(key: key);

  @override
  State<PantrySearchBar> createState() => _PantrySearchBarState();
}

class _PantrySearchBarState extends State<PantrySearchBar> {
  final SearchController searchController = SearchController();

  @override
  Widget build(BuildContext context) {
    return Consumer<PantryStore>(
      builder: (context, store, child) {
        return SearchAnchor(
          searchController: searchController,
          viewHintText: "Search items",
          viewLeading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              searchController.clear();
              searchController.closeView(null);
            },
          ),
          builder: (context, controller) {
            return IconButton(
              onPressed: () {
                controller.openView();
              },
              icon: const Icon(Icons.search),
            );
          },
          suggestionsBuilder: (context, controller) {
            final filteredItems = store.allPantryItems.where((item) => item.name
                .toLowerCase()
                .contains(searchController.text.toLowerCase()));

            return filteredItems.map(
              (item) => ListTile(
                key: Key(item.id.toString()),
                title: Text(item.name),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateItemPage(item: item),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
