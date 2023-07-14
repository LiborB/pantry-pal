  import 'package:flutter/material.dart';
import 'package:pantry_pal/features/api/api_http.dart';

import '../../store/app_store.dart';
import '../api/models/household.dart';
import '../api/models/user.dart';

class HomeStore extends ChangeNotifier {
  AppStore appStore;

  HomeStore(this.appStore);

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