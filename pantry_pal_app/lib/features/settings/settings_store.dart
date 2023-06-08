import 'package:flutter/material.dart';

import '../api/api_http.dart';

class SettingsStore extends ChangeNotifier {
  List<HouseholdMember> _householdMembers = [];

  List<HouseholdMember> get householdMembers => _householdMembers;

  SettingsStore() {
      refreshSettings();
  }

  refreshSettings() async {
      _householdMembers = await ApiHttp().getHouseholdMembers();
      notifyListeners();
  }

  addMember(String email) async {
    await ApiHttp().addMember(AddMember(email: email));
    refreshSettings();
  }
}
