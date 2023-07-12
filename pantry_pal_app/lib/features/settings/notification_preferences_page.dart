import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pantry_pal/features/settings/edit_profile_page.dart';
import 'package:pantry_pal/shared/widgets/app_list_tile.dart';

class NotificationPreferencesPage extends StatefulWidget {
  const NotificationPreferencesPage({super.key});

  @override
  State<NotificationPreferencesPage> createState() =>
      _NotificationPreferencesPageState();
}

class _NotificationPreferencesPageState
    extends State<NotificationPreferencesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      body: ListView(
        children: [
          AppListTile(
            label: "Profile",
            pageBuilder: () {
              return const EditProfilePage();
            },
          ),
          AppListTile(
            label: "Notifications",
            pageBuilder: () {
              return const NotificationPreferencesPage();
            },
          )
        ],
      ),
    );
  }
}
