import 'package:flutter/material.dart';
import 'package:pantry_pal/features/api/api_http.dart';
import 'package:pantry_pal/features/settings/add_member_dialog.dart';
import 'package:pantry_pal/features/settings/settings_store.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  List<ListTile> _buildMemberList(List<HouseholdMember> members) {
    return [
      for (var member in members)
        ListTile(
          title: Text(member.email),
          trailing: Chip(
            label: Text(member.status.name),
          ),
          leading: const Icon(Icons.person),
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsStore>(builder: (context, store, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Settings"),
        ),
        body: ListView(
          padding: const EdgeInsets.only(left: 16, right: 16),
          children: [
            ListTile(
              title: const Text("Your Household"),
              contentPadding: EdgeInsets.zero,
              trailing: IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => const AddMemberDialog(),
                  );
                },
                icon: const Icon(Icons.add),
              ),
            ),
            ..._buildMemberList(store.householdMembers),
          ],
        ),
      );
    });
  }
}
