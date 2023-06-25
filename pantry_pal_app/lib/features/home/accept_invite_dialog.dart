import 'package:flutter/material.dart';
import 'package:pantry_pal/features/api/api_http.dart';

class AcceptInviteDialog extends StatefulWidget {
  final VoidCallback onAccept;
  final VoidCallback onDecline;
  final HouseholdMember member;

  const AcceptInviteDialog({
    super.key,
    required this.onAccept,
    required this.onDecline,
    required this.member,
  });

  @override
  State<AcceptInviteDialog> createState() => _AcceptInviteDialogState();
}

class _AcceptInviteDialogState extends State<AcceptInviteDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Household Invite"),
      content: Text("You have been invited by ${widget.member.email} to join their household."),
      actions: [
        OutlinedButton(onPressed: widget.onDecline, child: const Text("Decline")),
        FilledButton(onPressed: widget.onAccept, child: const Text("Accept")),
      ],
    );
  }
}
