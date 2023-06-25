import 'package:flutter/material.dart';
import 'package:pantry_pal/features/home/accept_invite_dialog.dart';
import 'package:pantry_pal/features/home/onboard_dialog.dart';
import 'package:provider/provider.dart';

import '../../store/app_store.dart';
import 'home_store.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            showDialog(
              context: context,
              builder: (context) {
                return AcceptInviteDialog(
                  member: invitedMember,
                  onAccept: () async {
                    await Provider.of<HomeStore>(context, listen: false).respondInvite(invitedMember, true);

                    if (mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                  onDecline: () async {
                    await Provider.of<HomeStore>(context, listen: false).respondInvite(invitedMember, false);

                    if (mounted) {
                      Navigator.of(context).pop();
                    }
                  },
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
