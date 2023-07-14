import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pantry_pal/features/settings/edit_profile_page.dart';
import 'package:pantry_pal/features/settings/settings_store.dart';
import 'package:pantry_pal/shared/widgets/app_list_tile.dart';
import 'package:pantry_pal/shared/widgets/app_switch_list_tile.dart';
import 'package:provider/provider.dart';

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
      body: Consumer<SettingsStore>(
        builder: (context, store, child) {
          final settings = store.userSettings;
          if (settings == null) {
            return const Center(child: CircularProgressIndicator());
          }
          
          return ListView(
            children: [
              AppSwitchListTile(
                label: "Expiry Notifications",
                subtitle: "Receive notifications when items are about to expire (3 days before)",
                value: settings.notificationExpiryEnabled,
                onChanged: (value) {
                  store.updateUserSettings(settings.copyWith(notificationExpiryEnabled: value));
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
