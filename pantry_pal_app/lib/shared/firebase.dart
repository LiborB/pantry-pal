import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseManager {
  final FirebaseMessaging _firebaseMessaging;

  FirebaseManager(this._firebaseMessaging);

  Future subscribeToExpiryNotifications(String householdId) async {
    _firebaseMessaging.subscribeToTopic("notification.expiry.$householdId");
  }

  Future unsubscribeToExpiryNotifications(String householdId) async {
    _firebaseMessaging.unsubscribeFromTopic("notification.expiry.$householdId");
  }
}