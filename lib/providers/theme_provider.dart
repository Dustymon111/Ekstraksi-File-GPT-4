import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier with ChangeNotifier {
  static const String _themePrefKey = 'theme_pref';
  bool _isDarkTheme = false;

  ThemeNotifier() {
    _loadThemePreference();
  }

  bool get isDarkTheme => _isDarkTheme;

  ThemeMode get currentTheme => _isDarkTheme ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    _saveThemePreference();
    notifyListeners();
  }

  void _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkTheme = prefs.getBool(_themePrefKey) ?? false;
    notifyListeners();
  }

  void _saveThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_themePrefKey, _isDarkTheme);
  }
}