import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/base/base_stateless_widget.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/extensions/widget_extensions.dart';

/// Custom text field widget with consistent styling.
class CustomTextField extends BaseStatelessWidget {
  /// Creates a new [CustomTextField].
  const CustomTextField({
    super.key,
    required this.labelText,
    this.hintText,
    this.controller,
    this.onChanged,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType,
    this.validator,
    this.errorText,
  });

  /// The label text for the field.
  final String labelText;

  /// The hint text for the field.
  final String? hintText;

  /// The controller for the text field.
  final TextEditingController? controller;

  /// Called when the text changes.
  final ValueChanged<String>? onChanged;

  /// Whether to obscure the text (for passwords).
  final bool obscureText;

  /// Suffix icon for the field.
  final Widget? suffixIcon;

  /// The keyboard type for the field.
  final TextInputType? keyboardType;

  /// Validator function for the field.
  final String? Function(String?)? validator;

  /// Error text to display.
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < AppConstants.mobileMaxWidth;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontSize: isMobile ? 15.sp : 18.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        2.vSpace,
        TextFormField(
          controller: controller,
          onChanged: onChanged,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontSize: isMobile ? 15.sp : 20.sp),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(fontSize: isMobile ? 15.sp : 20.sp),
            suffixIcon: suffixIcon,
            errorText: errorText,
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppConstants.defaultPadding.w,
              vertical: isMobile ? 12.h : 20.h,
            ),
          ),
        ),
      ],
    );
  }
}
