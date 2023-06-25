import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../store/app_store.dart';
import '../api/api_http.dart';

class SettingsStore with ChangeNotifier {
  AppStore appStore;
  List<HouseholdMember> _householdMembers = [];
  List<HouseholdMember> get householdMembers => _householdMembers;

  SettingsStore(this.appStore) {
    refreshSettings();

    appStore.selectedHousehold.addListener(householdChanged);
  }

  @override
  void dispose() {
    appStore.selectedHousehold.removeListener(householdChanged);
    super.dispose();
  }

  void householdChanged() {
    refreshSettings();
  }

  Future refreshSettings() async {
      _householdMembers = await ApiHttp().getHouseholdMembers(appStore.householdId);
      _householdMembers.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      notifyListeners();
  }

  Future addMember(String email) async {
    await ApiHttp().addHouseholdMember(appStore.householdId, AddMember(email: email));
    refreshSettings();
  }

  Future signOut() async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
  }
}
