import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pantry_pal/features/auth/login_page.dart';
import 'package:pantry_pal/features/home/home_page.dart';
import 'package:pantry_pal/features/home/home_store.dart';
import 'package:pantry_pal/features/pantry/pantry_page.dart';
import 'package:pantry_pal/features/pantry/pantry_store.dart';
import 'package:pantry_pal/features/settings/settings_page.dart';
import 'package:pantry_pal/features/settings/settings_store.dart';
import 'package:pantry_pal/store/app_store.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'firebase_options.dart';

Future main() async {
  await dotenv.load(mergeWith: Platform.environment);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (FirebaseAuth.instance.currentUser != null) {
    try {
      await FirebaseAuth.instance.currentUser?.reload();
    } catch (e) {
      await FirebaseAuth.instance.signOut();
    }
  }

  if (dotenv.get("LOCAL") != "true") {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://9f0352e73aa74b79b5cfaeab272568ee@o4505418746757120.ingest.sentry.io/4505418752196608';
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AppStore>(create: (context) => AppStore()),
          ChangeNotifierProxyProvider<AppStore, PantryStore>(
              create: (context) =>
                  PantryStore(Provider.of<AppStore>(context, listen: false)),
              update: (context, appStore, pantryStore) =>
                  pantryStore!..appStore = appStore),
          ChangeNotifierProxyProvider<AppStore, SettingsStore>(
              create: (context) =>
                  SettingsStore(Provider.of<AppStore>(context, listen: false)),
              update: (context, appStore, settingsStore) =>
                  settingsStore!..appStore = appStore),
          ChangeNotifierProxyProvider<AppStore, HomeStore>(
              create: (context) =>
                  HomeStore(Provider.of<AppStore>(context, listen: false)),
              update: (context, appStore, homeStore) =>
                  homeStore!..appStore = appStore),
        ],
        child: MaterialApp(
          home: const MyApp(),
          theme: ThemeData(useMaterial3: true),
        ),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    Provider.of<AppStore>(context, listen: false)
        .handleAuth(FirebaseAuth.instance.currentUser);
  }

  Widget _getLandingPage() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.userChanges(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const LoginPage();
          } else {
            Navigator.of(context).popUntil((route) => true);
            return Consumer<AppStore>(
              builder: (context, value, child) {
                if (value.households.value.isNotEmpty) {
                  return child!;
                } else {
                  return const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
              child: Scaffold(
                body: const [
                  HomePage(),
                  PantryPage(),
                  SettingsPage()
                ][_currentIndex],
                bottomNavigationBar: NavigationBar(
                  onDestinationSelected: (index) => setState(() {
                    _currentIndex = index;
                  }),
                  selectedIndex: _currentIndex,
                  destinations: const [
                    NavigationDestination(
                        icon: Icon(Icons.home), label: "Home"),
                    NavigationDestination(
                        icon: Icon(Icons.inventory), label: "Pantry"),
                    NavigationDestination(
                        icon: Icon(Icons.settings), label: "Settings")
                  ],
                ),
              ),
            );
          }
        });
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
