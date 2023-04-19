// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB9dk4S1m7KsZsvMJpKFhsumK2eP7kZe9w',
    appId: '1:135361706279:web:c237fad825f33d0a785102',
    messagingSenderId: '135361706279',
    projectId: 'pantrypal-3d54e',
    authDomain: 'pantrypal-3d54e.firebaseapp.com',
    storageBucket: 'pantrypal-3d54e.appspot.com',
    measurementId: 'G-4Q4KJTZM3N',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC_ZSsgBYCtzUXgriOh4e56f_04EepsTyo',
    appId: '1:135361706279:android:9be3c8b0eef1ad58785102',
    messagingSenderId: '135361706279',
    projectId: 'pantrypal-3d54e',
    storageBucket: 'pantrypal-3d54e.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDJIRs2pEh2rAXPjMXf10wo0lBY0flmOPQ',
    appId: '1:135361706279:ios:5a9ff3d0455710b6785102',
    messagingSenderId: '135361706279',
    projectId: 'pantrypal-3d54e',
    storageBucket: 'pantrypal-3d54e.appspot.com',
    iosClientId: '135361706279-bf0sbfvfrm6u89i9lhg06d6gjh843227.apps.googleusercontent.com',
    iosBundleId: 'com.furionsoftware.pantryPalApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDJIRs2pEh2rAXPjMXf10wo0lBY0flmOPQ',
    appId: '1:135361706279:ios:047db9cc8ef52fc5785102',
    messagingSenderId: '135361706279',
    projectId: 'pantrypal-3d54e',
    storageBucket: 'pantrypal-3d54e.appspot.com',
    iosClientId: '135361706279-712vj6m4u3dd33rnugqdnre0obccej8e.apps.googleusercontent.com',
    iosBundleId: 'com.furionsoftware.pantrypal',
  );
}
