import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pantry_pal/features/home/home_page.dart';
import 'package:pantry_pal/features/pantry/pantry_page.dart';

Future main() async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State {
  int _currentIndex = 0;

  final List<Widget> _pages = [const HomePage(), const PantryPage()];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.indigo,
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
