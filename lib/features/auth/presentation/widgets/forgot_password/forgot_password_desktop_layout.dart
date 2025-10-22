import 'package:flutter/material.dart';

import '../../../../../core/base/base_stateless_widget.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/theme/app_colors.dart';
import '../login/login_hero_section.dart';
import 'forgot_password_form_card.dart';

/// Desktop layout widget for forgot password page with two columns.
class ForgotPasswordDesktopLayout extends BaseStatelessWidget {

  /// Creates a new [ForgotPasswordDesktopLayout].
  const ForgotPasswordDesktopLayout({
    super.key,
    required this.isDark,
  });
  /// Theme flag indicating if dark mode is active.
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Left side - Forgot Password Form
        Expanded(
          flex: 1,
          child: Container(
            color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
            child: const Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppConstants.extraLargePadding),
                child: ForgotPasswordFormCard(),
              ),
            ),
          ),
        ),
        
        // Right side - Hero Section (reuse login hero section)
        Expanded(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark 
                  ? AppColors.darkGradient
                  : AppColors.lightGradient,
              ),
            ),
            child: const Center(
              child: Padding(
                padding: EdgeInsets.all(AppConstants.extraLargePadding),
                child: LoginHeroSection(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
