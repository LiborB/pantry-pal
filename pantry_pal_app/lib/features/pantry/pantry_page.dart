import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pantry_pal/features/pantry/create_item_page.dart';
import 'package:pantry_pal/features/pantry/pantry_store.dart';
import 'package:pantry_pal/shared/date_extension.dart';
import 'package:provider/provider.dart';

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
                          value: PageSort.expiryDesc,
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
          body: ListView.separated(
            separatorBuilder: (context, i) {
              return const SizedBox();
            },
            itemCount: store.pantryItems.length,
            itemBuilder: (context, i) {
              return Card(
                color: Theme.of(context).colorScheme.secondaryContainer,
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 12,
                    right: 12,
                    top: 16,
                    bottom: 16,
                  ),
                  child: SizedBox(
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              store.pantryItems[i].name,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                        const Spacer(
                          flex: 1,
                        ),
                        Column(
                          children: [
                            Text(
                              "exp ${store.pantryItems[i].expiryDate.toDisplay()}",
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CreateItemPage()));
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
