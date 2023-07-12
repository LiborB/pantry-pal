import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppSwitchListTile extends StatefulWidget {
  final ValueGetter<Widget> pageBuilder;
  final String label;

  const AppListTile(
      {super.key, required this.label, required this.pageBuilder});

  @override
  State<AppSwitchListTile> createState() => _AppSwitchListTileState();
}

class _AppSwitchListTileState extends State<AppSwitchListTile> {
  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(widget.label),
      onChanged: (value) {
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
