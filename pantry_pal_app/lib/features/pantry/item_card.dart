import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pantry_pal/features/pantry/create_item_page.dart';
import 'package:pantry_pal/shared/date_extension.dart';
import '../api/models/pantry.dart';

class ItemCard extends StatelessWidget {
  final PantryItem item;
  final VoidCallback onMarkAsEaten;

  const ItemCard({super.key, required this.item, required this.onMarkAsEaten});

  Text getExpiryText(PantryItem item) {
    final text = "exp ${item.expiryDate.toDisplay()}";
    final now = DateTime.now();

    Color? color;

    if (item.expiryDate.isBefore(now)) {
      color = Colors.red;
    } else if (item.expiryDate
        .subtract(const Duration(days: 3))
        .isBefore(now)) {
      color = Colors.deepOrange;
    }

    return Text(text, style: color != null ? TextStyle(color: color) : null);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
      child: Slidable(
        key: const ValueKey(0),
        endActionPane: ActionPane(
          motion: const BehindMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                onMarkAsEaten();
              },
              label: "Mark Finished",
              backgroundColor: Theme.of(context).colorScheme.secondary,
              foregroundColor: Theme.of(context).colorScheme.onSecondary,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
          ],
        ),
        child: ListTile(
          onTap: () {
            Navigator.pushNamed(
              context,
              "/pantry/item",
              arguments: CreateItemPageArguments(item),
            );
          },
          tileColor: Theme.of(context).colorScheme.secondaryContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          title: Text(item.productName),
          trailing: getExpiryText(item),
        ),
      ),
    );
  }
}
