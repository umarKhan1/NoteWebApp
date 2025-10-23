import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Extension for adding convenient spacing methods to widgets.
extension WidgetExtensions on Widget {
  /// Adds vertical spacing below this widget.
  Widget paddingBottom(double height) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        this,
        SizedBox(height: height.h),
      ],
    );
  }

  /// Adds horizontal spacing to the right of this widget.
  Widget paddingRight(double width) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        this,
        SizedBox(width: width.w),
      ],
    );
  }

  /// Adds vertical spacing above this widget.
  Widget paddingTop(double height) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: height.h),
        this,
      ],
    );
  }

  /// Adds horizontal spacing to the left of this widget.
  Widget paddingLeft(double width) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(width: width.w),
        this,
      ],
    );
  }
}

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

/// Extension for creating common SizedBox instances.
extension SizedBoxExtensions on num {
  /// Creates a vertical SizedBox with this height.
  Widget get heightBox => SizedBox(height: toDouble().h);

  /// Creates a horizontal SizedBox with this width.
  Widget get widthBox => SizedBox(width: toDouble().w);

  /// Creates a square SizedBox with this dimension.
  Widget get box => SizedBox(
        width: toDouble().w,
        height: toDouble().h,
      );
}

/// Commonly used spacing widgets as extensions.
extension CommonSpacing on int {
  /// Vertical spacing widgets.
  Widget get vSpace => SizedBox(height: toDouble().h);
  
  /// Horizontal spacing widgets.
  Widget get hSpace => SizedBox(width: toDouble().w);
}
