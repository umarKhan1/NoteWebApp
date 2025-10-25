import 'package:flutter/material.dart';

/// Base stateless widget with common functionality
abstract class BaseStatelessWidget extends StatelessWidget {
  /// Creates a [BaseStatelessWidget].
  const BaseStatelessWidget({super.key});

  /// Gets responsive breakpoint information
  ResponsiveInfo getResponsiveInfo(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return ResponsiveInfo.fromWidth(screenWidth);
  }

  /// Gets theme data
  ThemeData getTheme(BuildContext context) => Theme.of(context);

  /// Gets screen size information
  Size getScreenSize(BuildContext context) => MediaQuery.of(context).size;
}

/// Information about responsive breakpoints
class ResponsiveInfo {
  /// Creates a [ResponsiveInfo].
  const ResponsiveInfo({
    required this.isMobile,
    required this.isTablet,
    required this.isDesktop,
    required this.screenWidth,
  });

  /// Creates responsive info from screen width
  factory ResponsiveInfo.fromWidth(double width) {
    return ResponsiveInfo(
      isMobile: width < 768,
      isTablet: width >= 768 && width < 1200,
      isDesktop: width >= 1200,
      screenWidth: width,
    );
  }

  /// Whether the screen is mobile size
  final bool isMobile;

  /// Whether the screen is tablet size
  final bool isTablet;

  /// Whether the screen is desktop size
  final bool isDesktop;

  /// Current screen width
  final double screenWidth;
}
