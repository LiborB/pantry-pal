import 'package:flutter/material.dart';
import 'package:pantry_pal/features/pantry/create_item_page.dart';
import 'package:pantry_pal/features/pantry/pantry_store.dart';
import 'package:pantry_pal/features/pantry/pantry_search_bar.dart';
import 'package:provider/provider.dart';

import 'item_card.dart';

class PantryPage extends StatefulWidget {
  const PantryPage({super.key});

  @override
  State<StatefulWidget> createState() => _PantryPageState();
}

class _PantryPageState extends State<PantryPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<PantryStore>(context, listen: false).refreshPantryItems();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PantryStore>(
      builder: (context, store, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Pantry"),
            actions: [
              const PantrySearchBar(),
              PopupMenuButton<PageSort>(
                  initialValue: store.sort,
                  onSelected: (value) {
                    store.setPageSort(value);
                  },
                  itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: PageSort.dateAddedDesc,
                          child: Text("Recently Added"),
                        ),
                        const PopupMenuItem(
                          value: PageSort.nameAsc,
                          child: Text("Name"),
                        ),
                        const PopupMenuItem(
                          value: PageSort.expiryAsc,
                          child: Text("Expiry Date"),
                        )
                      ],
                  child: IconButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStatePropertyAll(
                          Theme.of(context).colorScheme.onBackground),
                    ),
                    onPressed: null,
                    icon: const Icon(Icons.sort),
                  )),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () {
              return store.refreshPantryItems();
            },
            child: ListView.separated(
              separatorBuilder: (context, i) {
                return const SizedBox();
              },
              itemCount: store.allPantryItems.length,
              itemBuilder: (context, i) {
                return ItemCard(
                  key: ValueKey(i),
                  item: store.allPantryItems[i],
                );
              },
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                "/pantry.dart/add-item",
              );
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
