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
