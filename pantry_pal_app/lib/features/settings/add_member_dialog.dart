import 'package:flutter/material.dart';
import 'package:pantry_pal/features/settings/settings_store.dart';
import 'package:provider/provider.dart';

class AddMemberDialog extends StatefulWidget {
  const AddMemberDialog({super.key});

  @override
  State<AddMemberDialog> createState() => _AddMemberDialogState();
}

class _AddMemberDialogState extends State<AddMemberDialog> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AlertDialog(
        title: const Text("Invite Member"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Add a member to your household. Your pantry will be editable by all members.",
            ),
            const SizedBox(height: 16),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter an email address";
                }
                return null;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Member Email",
              ),
            ),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Provider.of<SettingsStore>(context).addMember(_emailController.text);
                Navigator.of(context).pop();
              }
            },
            child: const Text("Invite"),
          )
        ],
      ),
    );
  }
}
