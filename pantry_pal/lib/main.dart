import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pantry_pal/features/home/home_page.dart';
import 'package:pantry_pal/features/pantry/pantry_page.dart';

final _router = GoRouter(routes: [
  GoRoute(path: "/home", builder: (context, state) => const HomePage()),
  GoRoute(path: "/pantry", builder: (context, state) => const PantryPage())
], initialLocation: "/home");

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();

}

class _MyAppState extends State {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const PantryPage()
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      home: Scaffold(
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
      ),
    );
  }
}
