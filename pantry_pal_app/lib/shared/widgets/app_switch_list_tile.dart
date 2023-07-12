import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppSwitchListTile extends StatefulWidget {
  final ValueChanged<bool> onChanged;
  final String label;
  final bool value;

  const AppSwitchListTile({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  State<AppSwitchListTile> createState() => _AppSwitchListTileState();
}

class _AppSwitchListTileState extends State<AppSwitchListTile> {
  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(widget.label),
      onChanged: widget.onChanged,
      value: widget.value,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}
