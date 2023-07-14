import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pantry_pal/shared/firebase.dart';

import '../../store/app_store.dart';
import '../api/api_http.dart';
import '../api/models/household.dart';
import '../api/models/user.dart';

class SettingsStore with ChangeNotifier {
  AppStore appStore;
  List<HouseholdMember> _householdMembers = [];
  List<HouseholdMember> get householdMembers => _householdMembers;

  UserSettings? _userSettings;
  UserSettings? get userSettings => _userSettings;

  SettingsStore(this.appStore) {
    refreshUserSettings();
  }

  Future signOut() async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
  }

  Future refreshUserSettings() async {
    _userSettings = await ApiHttp().getUserSettings();

    notifyListeners();
  }

  Future updateUserSettings(UserSettings newSettings) async {
    _userSettings = newSettings;

    notifyListeners();

    await FirebaseManager(FirebaseMessaging.instance).unsubscribeToExpiryNotifications(this.appStore.householdId);

    await ApiHttp().updateUserSettings(newSettings);
    refreshUserSettings();
  }
}
