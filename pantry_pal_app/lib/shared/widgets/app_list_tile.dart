import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppListTile extends StatefulWidget {
  final ValueGetter<Widget> pageBuilder;
  final String label;

  const AppListTile(
      {super.key, required this.label, required this.pageBuilder});

  @override
  State<AppListTile> createState() => _AppListTileState();
}

class _AppListTileState extends State<AppListTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.label),
      trailing: const Icon(Icons.arrow_right_rounded),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return widget.pageBuilder();
            },
          ),
        );
      },
    );
  }
}
