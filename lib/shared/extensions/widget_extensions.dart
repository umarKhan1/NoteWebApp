import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

/// Extension for adding convenient spacing methods to widgets.
extension WidgetExtensions on Widget {
  /// Adds vertical spacing below this widget.
  Widget paddingBottom(double height) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        this,
        SizedBox(height: height),
      ],
    );
  }

  /// Adds horizontal spacing to the right of this widget.
  Widget paddingRight(double width) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        this,
        SizedBox(width: width),
      ],
    );
  }

  /// Adds vertical spacing above this widget.
  Widget paddingTop(double height) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: height),
        this,
      ],
    );
  }

  /// Adds horizontal spacing to the left of this widget.
  Widget paddingLeft(double width) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(width: width),
        this,
      ],
    );
  }

  /// Adds all-around padding to this widget.
  Widget paddingAll(double padding) {
    return Padding(padding: EdgeInsets.all(padding), child: this);
  }

  /// Adds symmetric padding to this widget.
  Widget paddingSymmetric({double? horizontal, double? vertical}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontal ?? 0,
        vertical: vertical ?? 0,
      ),
      child: this,
    );
  }

  /// Adds custom padding to this widget.
  Widget paddingOnly({
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        left: left ?? 0,
        top: top ?? 0,
        right: right ?? 0,
        bottom: bottom ?? 0,
      ),
      child: this,
    );
  }
}

/// Extensions for consistent spacing throughout the app
extension SpacingExtensions on num {
  /// Vertical spacing
  Widget get verticalSpace => SizedBox(height: toDouble());

  /// Horizontal spacing
  Widget get horizontalSpace => SizedBox(width: toDouble());

  /// Creates a vertical SizedBox with this height.
  Widget get heightBox => SizedBox(height: toDouble());

  /// Creates a horizontal SizedBox with this width.
  Widget get widthBox => SizedBox(width: toDouble());

  /// Creates a square SizedBox with this dimension.
  Widget get box => SizedBox(width: toDouble(), height: toDouble());

  /// Square spacing (both width and height)
  Widget get squareSpace => SizedBox(width: toDouble(), height: toDouble());

  /// Creates responsive vertical space using responsive_sizer.
  Widget get vSpace => SizedBox(height: toDouble().h);

  /// Creates responsive horizontal space using responsive_sizer.
  Widget get hSpace => SizedBox(width: toDouble().w);
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
