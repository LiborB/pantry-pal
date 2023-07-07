import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:pantry_pal/features/home/accept_invite_dialog.dart';
import 'package:pantry_pal/features/home/onboard_dialog.dart';
import 'package:provider/provider.dart';

import '../../store/app_store.dart';

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

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStore>(
      builder: (context, value, child) {
        if (value.user.onboardedVersion == 0) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            showDialog(
              context: context,
              builder: (context) {
                return const OnboardDialog();
              },
              barrierDismissible: false,
            );
          });
        } else if (value.pendingInvites.isNotEmpty) {
          final invitedMember = value.pendingInvites[0];
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
          body: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text("Home works!")],
            ),
          ),
        );
      },
    );
  }
}
