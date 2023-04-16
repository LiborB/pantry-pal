import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pantry_pal/features/pantry/create_item_page.dart';
import 'package:pantry_pal/features/pantry/pantry_store.dart';
import 'package:provider/provider.dart';

class PantryPage extends StatefulWidget {
  const PantryPage({super.key});

  @override
  State<StatefulWidget> createState() => _PantryPageState();
}

class _PantryPageState extends State<PantryPage> {
  var isDialOpen = ValueNotifier(false);

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
          ),
          body: ListView.separated(
            separatorBuilder: (context, i) {
              return const SizedBox();
            },
            itemCount: store.pantryItems.length,
            itemBuilder: (context, i) {
              return Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 12, right: 12, top: 24, bottom: 24),
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

                            if (store.pantryItems[i].expiryDate != null)
                              Text(
                                "exp ${store.pantryItems[i].expiryDate.toString()}",
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
