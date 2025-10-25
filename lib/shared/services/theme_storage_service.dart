import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing theme preference persistence using SharedPreferences
class ThemeStorageService {
  static const String _themeStorageKey = 'app_theme_mode';
  static late SharedPreferences _prefs;

  /// Initialize the service by loading SharedPreferences instance
  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Load theme mode from local storage
  static Future<ThemeMode> loadThemeMode() async {
    try {
      final themeModeString = _prefs.getString(_themeStorageKey);
      if (themeModeString == null) {
        return ThemeMode.light;
      }
      return themeModeString == 'dark' ? ThemeMode.dark : ThemeMode.light;
    } catch (e) {
      return ThemeMode.light;
    }
  }

  /// Save theme mode to local storage
  static Future<bool> saveThemeMode(ThemeMode themeMode) async {
    try {
      final themeModeString = themeMode == ThemeMode.dark ? 'dark' : 'light';
      return await _prefs.setString(_themeStorageKey, themeModeString);
    } catch (e) {
      return false;
    }
  }
}
