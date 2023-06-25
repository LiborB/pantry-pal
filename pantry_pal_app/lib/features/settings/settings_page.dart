import 'package:flutter/material.dart';
import 'package:pantry_pal/features/api/api_http.dart';
import 'package:pantry_pal/features/settings/add_member_dialog.dart';
import 'package:pantry_pal/features/settings/settings_store.dart';
import 'package:provider/provider.dart';

import '../../store/app_store.dart';

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
          title: Text(member.isOwner ? "${member.email} (Me)" : member.email),
          trailing: member.status == MemberStatus.pending
              ? Chip(
                  label: Text(member.status.name),
                )
              : null,
          leading: const Icon(Icons.person),
        ),
    ];
  }

  List<ListTile> _buildHouseholdList() {
    List<ListTile> tiles = [];
    final households = context.read<AppStore>().households.value;
    final householdId = context.read<AppStore>().householdId;

    for (var household in households) {
      final isSelected = household.id.toString() == householdId;

      tiles.add(
        ListTile(
          title: Text(household.name),
          leading: const Icon(Icons.home),
          trailing: isSelected ? const Icon(Icons.check) : null,
          onTap: () async {
            await context.read<AppStore>().setSelectedHousehold(household);
          },
          selected: isSelected,
          selectedTileColor:
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
      );
    }

    return tiles;
  }

  @override
  void initState() {
    super.initState();
    Provider.of<SettingsStore>(context, listen: false).refreshSettings();
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
            ..._buildHouseholdList(),
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
            FilledButton(
              onPressed: () async {
                await store.signOut();
              },
              style: FilledButton.styleFrom(
                backgroundColor:
                    Theme.of(context).buttonTheme.colorScheme!.error,
              ),
              child: const Text("Sign Out"),
            )
          ],
        ),
      );
    });
  }
}
