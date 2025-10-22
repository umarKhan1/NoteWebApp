import 'package:flutter/material.dart';
import '../../../../../core/base/base_stateless_widget.dart';
import '../../../../../core/constants/app_image_const.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/theme/app_colors.dart';

/// Hero section widget for signup page with motivational content.
class SignupHeroSection extends BaseStatelessWidget {
  /// Creates a new [SignupHeroSection].
  const SignupHeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = getTheme(context);
    final responsiveInfo = getResponsiveInfo(context);
    final screenSize = getScreenSize(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Hero text at the top left - Fixed size for desktop
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            top: responsiveInfo.isDesktop ? 60 : 30, 
            bottom: responsiveInfo.isDesktop ? 40 : 20
          ),
          child: Text(
            AppStrings.signupHeroMessage,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: isDark ? AppColors.darkBackground : Colors.white,
              fontSize: responsiveInfo.isDesktop ? 48 : 36, // Fixed size for desktop
              height: 1.2,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.left,
          ),
        ),
        
        // Professional woman image - Fixed size for desktop
        Expanded(
          child: SizedBox(
            width: double.infinity,
            child: Center(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: responsiveInfo.isDesktop ? 950 : 500, // Fixed 950px for desktop
                  maxHeight: responsiveInfo.isDesktop ? 650 : screenSize.height * 0.6, // Fixed 650px for desktop
                ),
                child: Image.asset(
                  AppImageConst.womanImage,
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
