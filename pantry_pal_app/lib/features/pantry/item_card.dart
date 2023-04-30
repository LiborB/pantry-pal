import 'package:flutter/material.dart';
import 'package:pantry_pal/features/pantry/create_item_page.dart';
import '../api/api_http.dart';
import "../../shared/date_extension.dart";

class ItemCard extends StatelessWidget {
  final PantryItem item;
  const ItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreateItemPage(item: item),
          ),
        );
      },
      child: Card(
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
                      item.name,
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
                      "exp ${item.expiryDate.toDisplay()}",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
