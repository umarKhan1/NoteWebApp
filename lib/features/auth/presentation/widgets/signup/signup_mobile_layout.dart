import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/base/base_stateless_widget.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/theme/app_colors.dart';
import 'signup_form_card.dart';

/// Mobile layout widget for signup page.
class SignupMobileLayout extends BaseStatelessWidget {

  /// Creates a new [SignupMobileLayout].
  const SignupMobileLayout({
    super.key,
    required this.isDark,
  });
  /// Theme flag indicating if dark mode is active.
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppConstants.defaultPadding.w,
            vertical: AppConstants.largePadding.h,
          ),
          child: const SignupFormCard(),
        ),
      ),
    );
  }
}
