import 'package:flutter/material.dart';
import 'package:pantry_pal/features/pantry/create_item_page.dart';
import 'package:pantry_pal/features/pantry/util/expiry.dart';
import '../api/api_http.dart';

class ItemCard extends StatelessWidget {
  final PantryItem item;

  const ItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4, left: 8, right: 8),
      child: InkWell(
        child: ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateItemPage(item: item),
              ),
            );
          },
          tileColor: Theme.of(context).colorScheme.secondaryContainer,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: Text(item.productName),
          trailing: getExpiryText(item),
        ),
      ),
    );
  }
}
