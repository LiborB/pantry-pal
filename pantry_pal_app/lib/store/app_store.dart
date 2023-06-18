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

  setSelectedHousehold(Household household) {
    _selectedHousehold = household;
    notifyListeners();
  }

  Future handleUnAuth() async {
    _households = [];
    _selectedHousehold = null;
    notifyListeners();
  }

  Future handleAuth(User? user) async {
    if (user == null) {
      await handleUnAuth();
      return;
    }

    FirebaseMessaging.instance.subscribeToTopic(user.uid);

    _households = await ApiHttp().getHouseholds();

    setSelectedHousehold(_households.first);
  }

  Future handleSignup(UserCredential userCredential) async {
    await ApiHttp().createUser();
    await ApiHttp().createHousehold(CreateHouseholdPayload(name: "My House"));

    await handleAuth(userCredential.user!);
  }

  Future handleUserPassSignup(String email, String password) async {
    final userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    await handleSignup(userCredential);
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

    await handleSignup(userCredential);
  }

  Future handleSignupApple() async {
    final appleProvider = AppleAuthProvider();

    UserCredential credential;
    if (kIsWeb) {
      credential = await FirebaseAuth.instance.signInWithPopup(appleProvider);
    } else {
      credential = await FirebaseAuth.instance.signInWithProvider(appleProvider);
    }

    await handleSignup(credential);
  }
}
