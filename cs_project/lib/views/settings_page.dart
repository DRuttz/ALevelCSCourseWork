import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  final ValueChanged<bool> toggleDarkMode;

  const SettingsPage({
    Key? key,
    required this.toggleDarkMode,
    required bool isDarkModeEnabled,
  }) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _darkMode = false;

  @override
  void initState() {
    super.initState();
    _loadDarkModePreference();
  }

  void _loadDarkModePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool darkModeEnabled = prefs.getBool('darkModeEnabled') ?? false;
    setState(() {
      _darkMode = darkModeEnabled;
    });
  }

  void _saveDarkModePreference(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkModeEnabled', value);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: _darkMode,
            onChanged: (value) {
              setState(() {
                _darkMode = value;
              });
              widget.toggleDarkMode(value);
              _saveDarkModePreference(
                  value); // save the value to SharedPreferences
            },
          ),
        ],
      ),
    );
  }
}
