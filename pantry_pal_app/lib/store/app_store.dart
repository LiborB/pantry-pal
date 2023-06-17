import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:pantry_pal/features/api/api_http.dart';
import 'package:pantry_pal/shared/globals.dart';

class AppStore extends ChangeNotifier {
  Household? _selectedHousehold;

  Household get selectedHousehold => _selectedHousehold!;

  String get householdId => _selectedHousehold!.id.toString();

  List<Household> _households = [];

  List<Household> get households => _households;

  setSelectedHousehold(Household household) {
    _selectedHousehold = household;
    notifyListeners();
  }

  Future handleAuth(User user) async {
    currentUserToken = await user.getIdToken();
    FirebaseMessaging.instance.subscribeToTopic(user.uid);

    _households = await ApiHttp().getHouseholds();

    setSelectedHousehold(_households.first);
  }

  Future handleSignup(String email, String password) async {
    final userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    currentUserToken = await userCredential.user!.getIdToken();
    await ApiHttp().createUser();
    await ApiHttp().createHousehold(CreateHouseholdPayload(name: "My House"));

    await handleAuth(userCredential.user!);
  }
}
