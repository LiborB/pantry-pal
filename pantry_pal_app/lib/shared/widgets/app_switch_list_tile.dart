import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppSwitchListTile extends StatefulWidget {
  final ValueChanged<bool> onChanged;
  final String label;
  final bool value;
  final String? subtitle;

  const AppSwitchListTile({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.subtitle,
  });

  @override
  State<AppSwitchListTile> createState() => _AppSwitchListTileState();
}

class _AppSwitchListTileState extends State<AppSwitchListTile> {
  @override
  Widget build(BuildContext context) {
    final subtitle = widget.subtitle;
    final theme = Theme.of(context);
    return SwitchListTile(
      title: Text(widget.label),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: theme.textTheme.bodySmall!.copyWith(
                color: theme.textTheme.bodySmall!.color!.withOpacity(0.75),
              ),
            )
          : null,
      onChanged: widget.onChanged,
      value: widget.value,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}
