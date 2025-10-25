import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// State representing the theme mode
class ThemeState extends Equatable {
  /// Creates a [ThemeState].
  const ThemeState({
    this.themeMode = ThemeMode.light,
  });

  /// The current theme mode (light or dark)
  final ThemeMode themeMode;

  /// Returns true if in dark mode
  bool get isDarkMode => themeMode == ThemeMode.dark;

  /// Returns true if in light mode
  bool get isLightMode => themeMode == ThemeMode.light;

  /// Creates a copy of this state with the given fields replaced
  ThemeState copyWith({
    ThemeMode? themeMode,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
    );
  }

  @override
  List<Object?> get props => [themeMode];
}
