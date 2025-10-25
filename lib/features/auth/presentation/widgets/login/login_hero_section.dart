import 'package:flutter/material.dart';
import '../../../../../core/base/base_stateless_widget.dart';
import '../../../../../core/constants/app_image_const.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/theme/app_colors.dart';

/// Hero section widget for login page with motivational content and image.
class LoginHeroSection extends BaseStatelessWidget {
  /// Creates a new [LoginHeroSection].
  const LoginHeroSection({super.key});

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
        Text(
          AppStrings.heroMessage,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            color: isDark ? AppColors.darkBackground : Colors.white,
            fontSize: responsiveInfo.isDesktop
                ? 30
                : 36, // Fixed size for desktop
            fontWeight: FontWeight.bold,
          ),
        ),

        Expanded(
          child: SizedBox(
            child: Center(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: responsiveInfo.isDesktop ? 1400 : 300,
                  maxHeight: responsiveInfo.isDesktop
                      ? 900
                      : screenSize.height * 0.8, // Bigger height
                ),
                child: Image.asset(
                  AppImageConst.womanImage,
                  fit: BoxFit
                      .contain, // Contain to show full image without cropping
                  alignment:
                      Alignment.bottomCenter, // Center the image properly
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
