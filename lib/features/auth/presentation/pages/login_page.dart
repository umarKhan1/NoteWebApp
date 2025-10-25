import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../cubit/login_cubit.dart';
import '../cubit/login_state.dart';
import '../widgets/login/login_desktop_layout.dart';
import '../widgets/login/login_mobile_layout.dart';

/// Main login view widget.
class LoginView extends StatefulWidget {
  /// Creates a new [LoginView].
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  void initState() {
    super.initState();
    // Reset login form when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LoginCubit>().resetForm();
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
          body: BlocListener<LoginCubit, LoginState>(
            listener: (context, state) {
              if (state.isSuccess) {
                context.go(RouteNames.dashboard);
              }
            },
            child: Container(
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
                  ? LoginMobileLayout(isDark: isDark)
                  : LoginDesktopLayout(isDark: isDark),
            ),
          ),
        );
      },
    );
  }
}
