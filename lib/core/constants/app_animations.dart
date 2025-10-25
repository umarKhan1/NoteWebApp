import 'package:flutter/material.dart';

/// Animation constants for consistent animations throughout the app.
class AppAnimations {
  /// Private constructor to prevent instantiation.
  AppAnimations._();

  // Animation Durations
  /// Fast animation duration (200ms).
  static const Duration fast = Duration(milliseconds: 200);

  /// Normal animation duration (300ms).
  static const Duration normal = Duration(milliseconds: 300);

  /// Slow animation duration (500ms).
  static const Duration slow = Duration(milliseconds: 500);

  /// Extra slow animation duration (800ms).
  static const Duration extraSlow = Duration(milliseconds: 800);

  // Animation Curves
  /// Standard ease in out curve.
  static const Curve easeInOut = Curves.easeInOut;

  /// Bounce curve for playful animations.
  static const Curve bounceIn = Curves.bounceIn;

  /// Elastic curve for spring-like animations.
  static const Curve elasticOut = Curves.elasticOut;

  /// Fast out slow in curve for material design.
  static const Curve fastOutSlowIn = Curves.fastOutSlowIn;

  // Stagger Delays
  /// Short stagger delay (50ms).
  static const Duration shortStagger = Duration(milliseconds: 50);

  /// Medium stagger delay (100ms).
  static const Duration mediumStagger = Duration(milliseconds: 100);

  /// Long stagger delay (150ms).
  static const Duration longStagger = Duration(milliseconds: 150);

  // Scale Values
  /// Scale from value for fade in animations.
  static const double scaleFrom = 0.8;

  /// Scale to value for animations.
  static const double scaleTo = 1.0;

  // Offset Values
  /// Slide from bottom offset.
  static const Offset slideFromBottom = Offset(0.0, 0.3);

  /// Slide from right offset.
  static const Offset slideFromRight = Offset(0.3, 0.0);

  /// Slide from left offset.
  static const Offset slideFromLeft = Offset(-0.3, 0.0);

  /// No offset.
  static const Offset noOffset = Offset.zero;
}
