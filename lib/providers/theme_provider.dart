import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode? themeMode;

  bool get isLightMode => themeMode == ThemeMode.light;
  /*{
    if (themeMode == ThemeMode.light) {
      return true;
    } else {
      return false;
    }
  }*/

  Future<void> toggleThemeMode(bool isLight) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('theme', isLight);

    themeMode = isLight ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    bool? isLight = prefs.getBool('theme') ?? true;
    themeMode = isLight ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
