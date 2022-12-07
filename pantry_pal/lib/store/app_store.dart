import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppStore extends ChangeNotifier {
  User? _user;

  User? get user => _user;

  AppStore() {
    FirebaseAuth.instance.idTokenChanges().listen((user) {
      _user = user;

      notifyListeners();
    });
  }
}
