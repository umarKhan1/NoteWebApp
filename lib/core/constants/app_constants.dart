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

  // Filter UI Labels
  /// Filter title in popover
  static const String filterTitle = 'Filter';

  /// Filter apply button label
  static const String filterApply = 'Apply Filter';

  /// Filter operator: is
  static const String filterOperatorIs = 'is';

  /// Filter operator: is not
  static const String filterOperatorIsNot = 'is not';

  /// Filter operator: contains
  static const String filterOperatorContains = 'contains';

  /// Filter operator: has any value
  static const String filterOperatorHasAnyValue = 'has any value';

  /// Filter value hint text
  static const String filterValueHint = 'Enter value';

  // Sort UI Labels
  /// Sort title in popover
  static const String sortTitle = 'Sort';

  /// Sort apply button label
  static const String sortApply = 'Apply Sort';

  /// Sort option: recently updated
  static const String sortRecentlyUpdated = 'Recently Updated';

  /// Sort option: oldest first
  static const String sortOldestFirst = 'Oldest First';

  /// Sort option: title A-Z
  static const String sortTitleAtoZ = 'Title (A-Z)';

  /// Sort option: title Z-A
  static const String sortTitleZtoA = 'Title (Z-A)';

  /// Sort option: pinned first
  static const String sortPinnedFirst = 'Pinned First';

  // Search UI Labels
  /// Search placeholder text
  static const String searchHint = 'Search notes...';

  // Splash Screen Labels
  /// Splash screen tagline
  static const String splashTagline = 'Your Notes, Your Way';

  /// Splash screen duration in seconds
  static const int splashDurationSeconds = 3;
}
