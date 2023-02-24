import 'package:cs_project/views/home_page.dart';
import 'package:cs_project/views/search_page.dart';
import 'package:cs_project/views/settings_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: const RootPage(),
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int currentPage = 0;
  // ignore: constant_identifier_names
  static const List<Widget> _Pages = <Widget>[
    //creates a scaffold which contains the program in each folder
    Scaffold(
      body: HomePage(),
    ),
    Scaffold(
      body: AnimeListScreen(),
    ),
    Scaffold(
      body: SettingsPage(),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: const Text('AniDiary'),
      ),
      body: Center(
        child: _Pages.elementAt(currentPage),
      ),
      bottomNavigationBar: NavigationBar(
        //creates the navigation bar and sets the destinations
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'home'),
          NavigationDestination(icon: Icon(Icons.book), label: 'browse'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'settings'),
        ],
        onDestinationSelected: (int index) {
          setState(() {
            currentPage = index;
          });
        },
        selectedIndex: currentPage,
      ),
    );
  }
}
