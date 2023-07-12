import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppListTile extends StatefulWidget {
  final VoidCallback onTap;
  final String label;

  const AppListTile(
      {super.key, required this.label, required this.onTap});

  @override
  State<AppListTile> createState() => _AppListTileState();
}

class _AppListTileState extends State<AppListTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.label),
      trailing: const Icon(Icons.chevron_right),
      onTap: widget.onTap,
      shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(8)),
    );
  }
}
