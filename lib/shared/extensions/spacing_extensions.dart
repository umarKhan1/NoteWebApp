import 'package:flutter/material.dart';

/// Extensions for consistent spacing throughout the app
extension SpacingExtensions on num {
  /// Vertical spacing
  Widget get verticalSpace => SizedBox(height: toDouble());
  
  /// Horizontal spacing
  Widget get horizontalSpace => SizedBox(width: toDouble());
  
  /// Square spacing (both width and height)
  Widget get squareSpace => SizedBox(
        width: toDouble(),
        height: toDouble(),
      );
}

/// Common spacing values
class AppSpacing {
  /// Extra small spacing - 4
  static const double xs = 4.0;
  
  /// Small spacing - 8
  static const double sm = 8.0;
  
  /// Medium spacing - 16
  static const double md = 16.0;
  
  /// Large spacing - 24
  static const double lg = 24.0;
  
  /// Extra large spacing - 32
  static const double xl = 32.0;
  
  /// Extra extra large spacing - 48
  static const double xxl = 48.0;
  
  /// Massive spacing - 64
  static const double massive = 64.0;
}
