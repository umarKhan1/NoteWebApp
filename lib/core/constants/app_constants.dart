/// Application-wide constants and configuration values.
class AppConstants {
  /// Private constructor to prevent instantiation.
  AppConstants._();
  
  // App Information
  /// The name of the application.
  static const String appName = 'NoteWebApp';
  /// The current version of the application.
  static const String appVersion = '1.0.0';
  
  // UI Constants
  /// Default padding value used throughout the app.
  static const double defaultPadding = 16.0;
  /// Small padding value for tight spaces.
  static const double smallPadding = 8.0;
  /// Large padding value for spacious layouts.
  static const double largePadding = 24.0;
  /// Extra large padding value for maximum spacing.
  static const double extraLargePadding = 32.0;
  /// Default border radius for rounded corners.
  static const double borderRadius = 12.0;
  /// Standard height for buttons across the app.
  static const double buttonHeight = 64.0;
  /// Mobile button height for better touch targets.
  static const double mobileButtonHeight = 48.0;
  
  // Animation Durations
  /// Short animation duration in milliseconds.
  static const int shortAnimationDuration = 200;
  /// Medium animation duration in milliseconds.
  static const int mediumAnimationDuration = 300;
  /// Long animation duration in milliseconds.
  static const int longAnimationDuration = 500;
  
  // Breakpoints for responsive design
  /// Maximum width for mobile devices.
  static const double mobileMaxWidth = 768.0;
  /// Maximum width for tablet devices.
  static const double tabletMaxWidth = 1024.0;
  /// Maximum width for desktop devices.
  static const double desktopMaxWidth = 1200.0;
  /// Maximum width for form containers.
  static const double maxFormWidth = 400.0;
  
  // Font Weights
  /// Font family name for Lato font.
  static const String fontFamilyLato = 'Lato';
}
