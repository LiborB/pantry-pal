import 'package:flutter/material.dart';
import 'package:pantry_pal/features/api/api_http.dart';
import 'package:provider/provider.dart';

import 'home_store.dart';

class AcceptInviteDialog extends StatefulWidget {
  final HouseholdMember member;

  const AcceptInviteDialog({
    super.key,
    required this.member,
  });

  @override
  State<AcceptInviteDialog> createState() => _AcceptInviteDialogState();
}

class _AcceptInviteDialogState extends State<AcceptInviteDialog> {
  onActionClick(bool accept) async {
    await Provider.of<HomeStore>(context, listen: false)
        .respondInvite(widget.member, accept);

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Household Invite"),
      content: Text("You have been invited by ${widget.member.email} to join their household."),
      actions: [
        OutlinedButton(onPressed: () => onActionClick(false), child: const Text("Decline")),
        FilledButton(onPressed: () => onActionClick(true), child: const Text("Accept")),
      ],
    );
  }
}
