import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pantry_pal/features/api/api_http.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:pantry_pal/shared/firebase.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../features/api/models/household.dart';
import '../features/api/models/user.dart';

class AppStore extends ChangeNotifier {
  ValueNotifier<Household?> selectedHousehold = ValueNotifier(null);

  String get householdId => selectedHousehold.value!.id.toString();

  ValueNotifier<List<Household>> households = ValueNotifier([]);

  AppUser? _user;

  AppUser get user => _user!;

  SharedPreferences prefs;

  AppStore({required this.prefs});

  setSelectedHousehold(Household household) {
    selectedHousehold.value = household;

    for (var element in households.value) {
      if (element.id != household.id) {
        FirebaseManager(FirebaseMessaging.instance).unsubscribeToExpiryNotifications(element.id.toString());
      }
    }

    FirebaseManager(FirebaseMessaging.instance).subscribeToExpiryNotifications(household.id.toString());

    prefs.setInt("selectedHouseholdId", household.id);

    notifyListeners();
  }

  Future handleUnAuth() async {
    households.value = [];
    selectedHousehold.value = null;
    _user = null;
    notifyListeners();
  }

  Future refreshHouseholds() async {
    households.value = await ApiHttp().getHouseholds();
    notifyListeners();
  }

  Future refreshUser() async {
    _user = await ApiHttp().getUser();
    notifyListeners();
  }

  Future handleAuth(User? user) async {
    if (user == null) {
      await handleUnAuth();
      return;
    }

    try {
      _user = await ApiHttp().getUser();
    } catch (err) {
      if (err is DioException) {
        if (err.response?.data?.errorCode == "RESOURCE_NOT_FOUND") {
          await ApiHttp().createUser();
          await ApiHttp()
              .createHousehold(CreateHouseholdPayload(name: "My House"));
          _user = await ApiHttp().getUser();
        }
      }
    }

    await refreshHouseholds();

    final storedHouseholdId = prefs.getInt("selectedHouseholdId");

    final household = households.value.firstWhere(
        (x) => x.id == storedHouseholdId,
        orElse: () => households.value.first);

    setSelectedHousehold(household);
  }

  Future handleLogin(UserCredential userCredential) async {
    try {
      _user = await ApiHttp().getUser();
    } catch (err) {
      if (err is DioException) {
        print(err.response?.data);
        if (err.response?.data["errorCode"] == "RESOURCE_NOT_FOUND") {
          await ApiHttp().createUser();
          await ApiHttp()
              .createHousehold(CreateHouseholdPayload(name: "My House"));
          _user = await ApiHttp().getUser();
        }
      }
    }

    if (_user != null) {
      await handleAuth(userCredential.user!);
      return;
    }
  }

  Future handleSignInGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    await handleLogin(userCredential);
  }

  Future handleSigninApple() async {
    final appleProvider = AppleAuthProvider();

    UserCredential credential;
    if (kIsWeb) {
      credential = await FirebaseAuth.instance.signInWithPopup(appleProvider);
    } else {
      credential =
          await FirebaseAuth.instance.signInWithProvider(appleProvider);
    }

    await handleLogin(credential);
  }
}
