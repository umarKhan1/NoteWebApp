import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'theme_state.dart';

/// Cubit for managing the application theme (light/dark mode)
class ThemeCubit extends Cubit<ThemeState> {
  /// Creates a new [ThemeCubit].
  ThemeCubit() : super(const ThemeState(themeMode: ThemeMode.light));

  /// Toggles between light and dark theme
  void toggleTheme() {
    final isCurrentlyDark = state.isDarkMode;
    emit(state.copyWith(
      themeMode: isCurrentlyDark ? ThemeMode.light : ThemeMode.dark,
    ));
  }

  /// Sets the theme mode to light
  void setLightTheme() {
    if (!state.isLightMode) {
      emit(state.copyWith(themeMode: ThemeMode.light));
    }
  }

  /// Sets the theme mode to dark
  void setDarkTheme() {
    if (!state.isDarkMode) {
      emit(state.copyWith(themeMode: ThemeMode.dark));
    }
  }

  /// Gets the current theme mode
  ThemeMode get themeMode => state.themeMode;
}
