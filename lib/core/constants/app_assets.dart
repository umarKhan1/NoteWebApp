/// Application asset constants for centralized asset management.
class AppAssets {
  /// Private constructor to prevent instantiation.
  AppAssets._();
  
  // Animation Assets
  /// Lottie animation for no notes state.
  static const String notesAnimation = 'assets/animations/notes.json';
  
  /// Lottie animation for loading states.
  static const String loadingAnimation = 'assets/animations/loading.json';
  
  /// Lottie animation for success states.
  static const String successAnimation = 'assets/animations/success.json';
  
  /// Lottie animation for empty states.
  static const String emptyStateAnimation = 'assets/animations/empty.json';
  
  // Image Assets
  /// Woman image for authentication pages.
  static const String womanImage = 'assets/images/woman1.png';
  
  // Icon Assets
  /// Base path for icon assets.
  static const String _iconsBasePath = 'assets/icons/';
  
  /// Get icon asset path.
  static String getIconPath(String iconName) => '$_iconsBasePath$iconName';
}
