import 'package:cs_project/views/home_page.dart';
import 'package:cs_project/views/search_page.dart';
import 'package:cs_project/views/settings_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
      const MyApp()); // runs the app when the icon is pressed on the phones app menu
}

class MyApp extends StatelessWidget {
  // displays everything programmed into the app
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // hides the debug notification
      theme: ThemeData(
        // sets theme of app
        brightness: Brightness.dark, // sets the theme to dark
      ),
      home: const RootPage(), // displays the root page state
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int currentPage = 0; // contains the index of the current page
  // ignore: constant_identifier_names
  static const List<Widget> _Pages = <Widget>[
    // creates a scaffold which contains the program in each folder
    Scaffold(
      body: HomePage(),
    ),
    Scaffold(
      body: SearchPage(),
    ),
    Scaffold(
      body: SettingsPage(),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // as flutter is essentially multiple widgets placed over each other,
      // the scaffold is responsible for structuring these widgets
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: const Text('AniDiary'),
      ),
      body: Center(
        child: _Pages.elementAt(currentPage), // displays the menus
      ),
      bottomNavigationBar: NavigationBar(
        // creates the navigation bar and sets the destinations
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.home),
              label: 'home'), //navigation button for the home menu
          NavigationDestination(
              icon: Icon(Icons.book),
              label: 'browse'), //navigation button for the browse menu
          NavigationDestination(
              icon: Icon(Icons.settings),
              label: 'settings'), //navigation button for the settings menu
        ],
        onDestinationSelected: (int index) {
          // changess the current page to the index of the button pressed
          setState(() {
            currentPage = index;
          });
        },
        selectedIndex: currentPage,
      ),
    );
  }
}
