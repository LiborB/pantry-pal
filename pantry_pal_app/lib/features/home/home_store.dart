  import 'package:flutter/material.dart';
import 'package:pantry_pal/features/api/api_http.dart';

import '../../store/app_store.dart';
import '../api/models/household.dart';
import '../api/models/user.dart';

class HomeStore extends ChangeNotifier {
  AppStore appStore;

  List<HouseholdMember> _householdMembers = [];
  List<HouseholdMember> get householdMembers => _householdMembers;

  List<HouseholdMember> _pendingInvites = [];
  List<HouseholdMember> get pendingInvites => _pendingInvites;

  HomeStore(this.appStore) {
    refreshMembers();

    appStore.selectedHousehold.addListener(refreshMembers);
  }

  @override
  void dispose() {
    appStore.selectedHousehold.removeListener(refreshMembers);
    super.dispose();
  }

  Future refreshMembers() async {
    _householdMembers = await ApiHttp().getHouseholdMembers(appStore.householdId);
    _householdMembers.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    _pendingInvites = await ApiHttp().getPendingInvites();

    notifyListeners();
  }

  Future addMember(String email) async {
    await ApiHttp().addHouseholdMember(appStore.householdId, AddMember(email: email));
    refreshMembers();
  }

  Future<void> finishOnboarding({
    required String firstName,
    required String lastName,
  }) async {
    await ApiHttp().updateUser(UpdateUserPayload(firstName: firstName, lastName: lastName));

    await ApiHttp().updateHousehold(appStore.householdId, UpdateHouseholdPayload(name: "$firstName's Household"));

    await appStore.refreshUser();
    await appStore.refreshHouseholds();
  }

  Future<void> respondInvite(HouseholdMember member, bool accept) async {
    await ApiHttp().respondInvite(member.householdId.toString(), accept);
    await appStore.refreshHouseholds();
  }
}