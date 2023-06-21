import 'package:flutter/material.dart';
import 'package:pantry_pal/features/home/home_store.dart';
import 'package:provider/provider.dart';

class OnboardDialog extends StatefulWidget {
  const OnboardDialog({super.key});

  @override
  State<OnboardDialog> createState() => _OnboardDialogState();
}

class _OnboardDialogState extends State<OnboardDialog> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AlertDialog(
        title: const Text("Finish setting up your account"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "We need a little more information to finish setting up your account.",
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _firstNameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter your first name";
                }
                return null;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "First Name",
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _lastNameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter your last name";
                }
                return null;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Last Name",
              ),
            ),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () async {
              if (!_formKey.currentState!.validate()) {
                return;
              }

              await Provider.of<HomeStore>(context, listen: false)
                  .finishOnboarding(
                      firstName: _firstNameController.text,
                      lastName: _lastNameController.text);

              if (mounted) {
                Navigator.of(context).pop();
              }
            },
            child: const Text("Complete Setup"),
          )
        ],
      ),
    );
  }
}
