import 'package:flutter/material.dart';
import '../../../../../core/base/base_stateless_widget.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/theme/app_colors.dart';
import 'signup_form_card.dart';
import 'signup_hero_section.dart';

/// Desktop layout widget for signup page with two columns.
class SignupDesktopLayout extends BaseStatelessWidget {

  /// Creates a new [SignupDesktopLayout].
  const SignupDesktopLayout({
    super.key,
    required this.isDark,
  });
  /// Theme flag indicating if dark mode is active.
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Left side - Signup Form
        Expanded(
          flex: 1,
          child: Container(
            color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
            child: const Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppConstants.extraLargePadding),
                child: SignupFormCard(),
              ),
            ),
          ),
        ),
        
        // Right side - Hero Section
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
                child: SignupHeroSection(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
