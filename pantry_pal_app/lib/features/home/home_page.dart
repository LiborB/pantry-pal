import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:pantry_pal/features/home/accept_invite_dialog.dart';
import 'package:pantry_pal/features/home/home_store.dart';
import 'package:pantry_pal/features/home/onboard_dialog.dart';
import 'package:provider/provider.dart';

import '../api/models/household.dart';
import '../settings/add_member_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    FirebaseMessaging.instance.requestPermission();

    super.initState();
  }

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

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeStore>(
      builder: (context, store, child) {
        if (store.appStore.user.onboardedVersion == 0) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            showDialog(
              context: context,
              builder: (context) {
                return const OnboardDialog();
              },
              barrierDismissible: false,
            );
          });
        } else if (store.pendingInvites.isNotEmpty) {
          final invitedMember = store.pendingInvites[0];
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
            await showDialog(
              context: context,
              builder: (context) {
                return AcceptInviteDialog(
                  member: invitedMember,
                );
              },
              barrierDismissible: false,
            );
          });
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text("Home"),
          ),
          body: Consumer<HomeStore>(
            builder: (context, store, child) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  children: [
                    HouseholdSelector(
                      selectedHousehold:
                          store.appStore.selectedHousehold.value!,
                      onHouseholdChange: (household) {
                        store.appStore.setSelectedHousehold(household);
                      },
                      households: store.appStore.households.value,
                    ),
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
            },
          ),
        );
      },
    );
  }
}

class HouseholdSelector extends StatelessWidget {
  final Household selectedHousehold;
  final List<Household> households;
  final ValueChanged<Household> onHouseholdChange;

  const HouseholdSelector(
      {super.key,
      required this.selectedHousehold,
      required this.onHouseholdChange,
      required this.households});

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      items: [
        for (var household in households)
          DropdownMenuItem(
            value: household,
            child: Text(
              household.name,
            ),
          )
      ],
      value: selectedHousehold,
      onChanged: (value) => onHouseholdChange(value!),
      style: Theme.of(context).textTheme.titleMedium,
    );
  }
}
