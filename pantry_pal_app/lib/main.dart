import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pantry_pal/features/auth/login_page.dart';
import 'package:pantry_pal/features/home/home_page.dart';
import 'package:pantry_pal/features/pantry/pantry_page.dart';
import 'package:pantry_pal/features/pantry/pantry_store.dart';
import 'package:pantry_pal/store/app_store.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

Future main() async {
  await dotenv.load();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // await FirebaseAuth.instance.signOut();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => AppStore()),
      ChangeNotifierProvider(create: (context) => PantryStore())
    ],
    child: const MaterialApp(home: MyApp()),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State {
  int _currentIndex = 0;
  final List<Widget> _pages = [const HomePage(), const PantryPage()];

  Widget _getLandingPage() {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        snapshot.data?.getIdToken().then((value) => print(value));
        if (snapshot.data == null) {
          return const LoginPage();
        } else {
          return Scaffold(
            body: _pages[_currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              onTap: (index) => setState(() {
                _currentIndex = index;
              }),
              currentIndex: _currentIndex,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
                BottomNavigationBarItem(icon: Icon(Icons.list), label: "Pantry")
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
        ),
        home: _getLandingPage());
  }
}
