import 'package:flutter/material.dart';

/// Application color palette and theme colors.
class AppColors {
  /// Private constructor to prevent instantiation.
  AppColors._();
  
  // Light Theme Colors
  /// Primary color for light theme.
  static const Color lightPrimary = Color(0xFF6E39CB);
  /// Secondary color for light theme.
  static const Color lightSecondary = Color(0xFF9C72E8);
  /// Background color for light theme.
  static const Color lightBackground = Color(0xFFFFFFFF);
  /// Surface color for light theme.
  static const Color lightSurface = Color(0xFFFFFFFF);
  /// Card color for light theme.
  static const Color lightCard = Color(0xFFFFFFFF);
  /// Primary text color for light theme.
  static const Color lightTextPrimary = Color(0xFF212121);
  /// Secondary text color for light theme.
  static const Color lightTextSecondary = Color(0xFF757575);
  /// Hint text color for light theme.
  static const Color lightTextHint = Color(0xFFBDBDBD);
  /// Divider color for light theme.
  static const Color lightDivider = Color(0xFFE0E0E0);
  
  // Dark Theme Colors
  /// Primary color for dark theme.
  static const Color darkPrimary = Color(0xFFFFD700);
  /// Secondary color for dark theme.
  static const Color darkSecondary = Color(0xFFFFF700);
  /// Background color for dark theme.
  static const Color darkBackground = Color(0xFF000000);
  /// Surface color for dark theme.
  static const Color darkSurface = Color(0xFF1C1C1C);
  /// Card color for dark theme.
  static const Color darkCard = Color(0xFF2C2C2C);
  /// Primary text color for dark theme.
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  /// Secondary text color for dark theme.
  static const Color darkTextSecondary = Color(0xFFB3B3B3);
  /// Hint text color for dark theme.
  static const Color darkTextHint = Color(0xFF757575);
  /// Divider color for dark theme.
  static const Color darkDivider = Color(0xFF373737);
  
  // Common Colors
  /// Error color used across both themes.
  static const Color errorColor = Color(0xFFE53E3E);
  /// Warning color used across both themes.
  static const Color warningColor = Color(0xFFFF9800);
  /// Success color used across both themes.
  static const Color successColor = Color(0xFF4CAF50);
  /// Info color used across both themes.
  static const Color infoColor = Color(0xFF2196F3);
  
  // Social Login Colors
  /// Google brand color for social login buttons.
  static const Color googleColor = Color(0xFF4285F4);
  /// Facebook brand color for social login buttons.
  static const Color facebookColor = Color(0xFF1877F2);
  
  // Gradient Colors
  /// Gradient colors for light theme backgrounds.
  static const List<Color> lightGradient = [
    Color(0xFF6E39CB),
    Color(0xFF9C72E8),
  ];
  
  /// Gradient colors for dark theme backgrounds.
  static const List<Color> darkGradient = [
    Color(0xFFFFD700),
    Color(0xFFFFF700),
  ];
  
  // Primary Colors for buttons and accents
  /// Primary color for buttons and accents.
  static const Color primaryColor = Color(0xFFFFD700);
}
