import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../cubit/forgot_password_cubit.dart';
import '../widgets/forgot_password/forgot_password_desktop_layout.dart';
import '../widgets/forgot_password/forgot_password_mobile_layout.dart';

/// Main forgot password view widget.
class ForgotPasswordView extends StatefulWidget {
  /// Creates a new [ForgotPasswordView].
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  @override
  void initState() {
    super.initState();
    // Reset forgot password form when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ForgotPasswordCubit>().resetForm();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < AppConstants.mobileMaxWidth;
    
    return ScreenUtilInit(
      designSize: isMobile ? const Size(375, 812) : const Size(1440, 900),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark 
                  ? AppColors.darkGradient
                  : AppColors.lightGradient,
              ),
            ),
            child: isMobile 
              ? ForgotPasswordMobileLayout(isDark: isDark)
              : ForgotPasswordDesktopLayout(isDark: isDark),
          ),
        );
      },
    );
  }
}
