import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pantry_pal/features/auth/login_page.dart';
import 'package:pantry_pal/features/home/home_page.dart';
import 'package:pantry_pal/features/pantry/pantry_page.dart';
import 'package:pantry_pal/features/pantry/pantry_store.dart';
import 'package:pantry_pal/features/settings/settings_page.dart';
import 'package:pantry_pal/features/settings/settings_store.dart';
import 'package:pantry_pal/shared/globals.dart';
import 'package:pantry_pal/store/app_store.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

Future main() async {
  await dotenv.load();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (dotenv.get("LOCAL") != "true") {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => AppStore()),
      ChangeNotifierProvider(create: (context) => PantryStore()),
      ChangeNotifierProvider(create: (context) => SettingsStore())
    ],
    child: MaterialApp(
      home: const MyApp(),
      theme: ThemeData(useMaterial3: true),
    ),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State {
  int _currentIndex = 0;

  Widget _getLandingPage() {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        final data = snapshot.data;
        if (data == null) {
          return const LoginPage();
        } else {
          data.getIdToken().then((token) => currentUserToken = token);

          FirebaseMessaging.instance.subscribeToTopic(data.uid);
          return Scaffold(
            body: const [HomePage(), PantryPage(), SettingsPage()][_currentIndex],
            bottomNavigationBar: NavigationBar(
              onDestinationSelected: (index) => setState(() {
                _currentIndex = index;
              }),
              selectedIndex: _currentIndex,
              destinations: const [
                NavigationDestination(icon: Icon(Icons.home), label: "Home"),
                NavigationDestination(
                    icon: Icon(Icons.inventory), label: "Pantry"),
                NavigationDestination(
                    icon: Icon(Icons.settings), label: "Settings")
              ],
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          useMaterial3: true,
        ),
        home: _getLandingPage());
  }
}
