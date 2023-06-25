import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pantry_pal/features/api/api_http.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AppStore extends ChangeNotifier {
  Household? _selectedHousehold;
  Household get selectedHousehold => _selectedHousehold!;

  String get householdId => _selectedHousehold!.id.toString();

  List<Household> _households = [];
  List<Household> get households => _households;

  AppUser? _user;
  AppUser get user => _user!;

  List<HouseholdMember> _pendingInvites = [];
  List<HouseholdMember> get pendingInvites => _pendingInvites;

  setSelectedHousehold(Household household) {
    _selectedHousehold = household;
    notifyListeners();
  }

  Future handleUnAuth() async {
    _households = [];
    _selectedHousehold = null;
    _user = null;
    notifyListeners();
  }

  Future refreshHouseholds() async {
    _households = await ApiHttp().getHouseholds();
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

    _pendingInvites = await ApiHttp().getPendingInvites();

    _user = await ApiHttp().getUser();

    await FirebaseMessaging.instance.subscribeToTopic(user.uid);

    await refreshHouseholds();

    setSelectedHousehold(_households.first);
  }

  Future handleLogin(UserCredential userCredential) async {
    try {
      _user = await ApiHttp().getUser();
    } catch (err) {
      switch (err.runtimeType) {
        case DioException:
          final res = (err as DioException).response;
          if (res?.statusCode == 404) {
            await ApiHttp().createUser();
            await ApiHttp().createHousehold(CreateHouseholdPayload(name: "My House"));
            _user = await ApiHttp().getUser();
            break;
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
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

    await handleLogin(userCredential);
  }

  Future handleSigninApple() async {
    final appleProvider = AppleAuthProvider();

    UserCredential credential;
    if (kIsWeb) {
      credential = await FirebaseAuth.instance.signInWithPopup(appleProvider);
    } else {
      credential = await FirebaseAuth.instance.signInWithProvider(appleProvider);
    }

    await handleLogin(credential);
  }
}
