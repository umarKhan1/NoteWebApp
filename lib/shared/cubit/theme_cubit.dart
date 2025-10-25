import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/theme_storage_service.dart';
import 'theme_state.dart';

/// Cubit for managing the application theme (light/dark mode)
class ThemeCubit extends Cubit<ThemeState> {
  /// Creates a new [ThemeCubit].
  ThemeCubit() : super(const ThemeState(themeMode: ThemeMode.light)) {
    _initializeTheme();
  }

  /// Initialize theme from local storage
  void _initializeTheme() {
    ThemeStorageService.loadThemeMode().then((themeMode) {
      if (themeMode != state.themeMode) {
        emit(state.copyWith(themeMode: themeMode));
        _updateWebFavicon(themeMode);
      }
    });
  }

  /// Update web favicon based on theme
  void _updateWebFavicon(ThemeMode themeMode) {
    if (kIsWeb) {
      try {
        // Web platform favicon update
        final isDarkMode = themeMode == ThemeMode.dark;
        _updateFaviconUrl(isDarkMode ? 'logo-dark.png' : 'logo-light.png');
      } catch (_) {
        // Silently ignore platform-specific errors
      }
    }
  }

  /// Update favicon URL via JavaScript
  void _updateFaviconUrl(String faviconUrl) {
    // This will be handled via native JavaScript in the web folder
    // For now, this is a placeholder for web-specific implementation
  }

  /// Toggles between light and dark theme
  void toggleTheme() {
    final isCurrentlyDark = state.isDarkMode;
    final newThemeMode = isCurrentlyDark ? ThemeMode.light : ThemeMode.dark;
    
    // Save to local storage
    ThemeStorageService.saveThemeMode(newThemeMode);
    
    // Update favicon on web
    _updateWebFavicon(newThemeMode);
    
    emit(state.copyWith(themeMode: newThemeMode));
  }

  /// Sets the theme mode to light
  void setLightTheme() {
    if (!state.isLightMode) {
      ThemeStorageService.saveThemeMode(ThemeMode.light);
      _updateWebFavicon(ThemeMode.light);
      emit(state.copyWith(themeMode: ThemeMode.light));
    }
  }

  /// Sets the theme mode to dark
  void setDarkTheme() {
    if (!state.isDarkMode) {
      ThemeStorageService.saveThemeMode(ThemeMode.dark);
      _updateWebFavicon(ThemeMode.dark);
      emit(state.copyWith(themeMode: ThemeMode.dark));
    }
  }

  /// Gets the current theme mode
  ThemeMode get themeMode => state.themeMode;
}
