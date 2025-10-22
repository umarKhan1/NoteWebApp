import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../cubit/signup_cubit.dart';
import '../widgets/signup/signup_desktop_layout.dart';
import '../widgets/signup/signup_mobile_layout.dart';

/// Main signup view widget.
class SignupView extends StatefulWidget {
  /// Creates a new [SignupView].
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  @override
  void initState() {
    super.initState();
    // Reset signup form when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SignupCubit>().resetForm();
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
              ? SignupMobileLayout(isDark: isDark)
              : SignupDesktopLayout(isDark: isDark),
          ),
        );
      },
    );
  }
}
