import 'package:cs_project/views/home_page.dart';
import 'package:cs_project/views/search_page.dart';
import 'package:cs_project/views/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkModeEnabled = false;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        _prefs = prefs;
        _isDarkModeEnabled = _prefs.getBool('isDarkModeEnabled') ?? true;
      });
    });
  }

  void _toggleDarkMode(bool value) {
    setState(() {
      _isDarkModeEnabled = value;
      _prefs.setBool('isDarkModeEnabled', value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _isDarkModeEnabled
          ? ThemeData.dark()
          : ThemeData.light(), // set theme based on toggle
      home: RootPage(
        toggleDarkMode: _toggleDarkMode, // pass function to toggle theme
        isDarkModeEnabled: _isDarkModeEnabled, // pass current theme value
      ),
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({
    Key? key,
    required this.toggleDarkMode,
    required this.isDarkModeEnabled,
  }) : super(key: key);

  final Function(bool) toggleDarkMode;
  final bool isDarkModeEnabled;

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _currentPage = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    final bool isDarkModeEnabled = widget.isDarkModeEnabled;
    _pages = [
      Scaffold(
        body: HomePage(isDarkModeEnabled: isDarkModeEnabled),
      ),
      const Scaffold(
        body: SearchPage(),
      ),
      Scaffold(
        body: SettingsPage(
          toggleDarkMode: widget.toggleDarkMode,
          isDarkModeEnabled: isDarkModeEnabled,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    print('isDarkModeEnabled: ${widget.isDarkModeEnabled}');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: const Text('AniDiary'),
      ),
      body: Center(
        child: _pages.elementAt(_currentPage),
      ),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'home',
          ),
          NavigationDestination(
            icon: Icon(Icons.book),
            label: 'browse',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'settings',
          ),
        ],
        onDestinationSelected: (int index) {
          setState(() {
            _currentPage = index;
          });
        },
        selectedIndex: _currentPage,
      ),
    );
  }
}
