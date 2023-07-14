import 'package:flutter/material.dart';
import 'package:pantry_pal/features/api/api_http.dart';
import 'package:pantry_pal/features/settings/add_member_dialog.dart';
import 'package:pantry_pal/features/settings/edit_profile_page.dart';
import 'package:pantry_pal/features/settings/notification_preferences_page.dart';
import 'package:pantry_pal/features/settings/settings_store.dart';
import 'package:pantry_pal/shared/widgets/app_list_tile.dart';
import 'package:provider/provider.dart';

import '../../store/app_store.dart';
import '../api/models/household.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsStore>(builder: (context, store, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Settings"),
        ),
        body: ListView(
          padding: const EdgeInsets.only(left: 8, right: 8),
          children: [
            AppListTile(
              label: "Profile",
              onTap: () {
                Navigator.pushNamed(context, "/settings/profile");
              },
            ),
            AppListTile(label: "Notifications", onTap: () {
              Navigator.pushNamed(context, "/settings/notifications");
            }),

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
