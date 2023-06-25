import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pantry_pal/features/api/helper.dart';
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
  var _errorMessage = "";

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
            if (_errorMessage.isNotEmpty)
              const SizedBox(height: 8),
              Text(
                _errorMessage,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                try {
                  await Provider.of<SettingsStore>(context, listen: false)
                      .addMember(_emailController.text);
                  if (mounted) {
                    Navigator.of(context).pop();
                  }
                } catch (err) {
                  final errorCode = unwrapErrorResponse(err);
                  setState(() {
                    switch (errorCode) {
                      case "user_not_found":
                        _errorMessage = "User not found. Please enter an email address of an existing user.";
                        break;
                      case "member_exists":
                        _errorMessage = "This member is already in your household.";
                        break;
                      default:
                        _errorMessage = "Failed to add member. Please try again.";
                        break;
                    }
                  });
                }
              }
            },
            child: const Text("Invite"),
          )
        ],
      ),
    );
  }
}
