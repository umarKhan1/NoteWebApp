import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../shared/extensions/widget_extensions.dart';
import '../../cubit/login_cubit.dart';
import '../../cubit/login_state.dart';
import '../custom_text_field.dart';

/// Login form card widget containing the login form.
class LoginFormCard extends StatefulWidget {
  /// Creates a new [LoginFormCard].
  const LoginFormCard({super.key});

  @override
  State<LoginFormCard> createState() => _LoginFormCardState();
}

class _LoginFormCardState extends State<LoginFormCard> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < AppConstants.mobileMaxWidth;

    return Container(
      constraints: BoxConstraints(maxWidth: isMobile ? double.infinity : 400.w),
      padding: EdgeInsets.all(
        isMobile
            ? AppConstants.defaultPadding.w
            : AppConstants.extraLargePadding.w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          Text(
            AppStrings.login,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: isMobile ? 25.sp : 42.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          2.vSpace,

          // Subtitle
          Text(
            AppStrings.loginSubtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: isMobile ? 17.sp : 18.sp,
            ),
          ),
          isMobile ? 3.vSpace : 3.vSpace,

          // Login Form
          BlocConsumer<LoginCubit, LoginState>(
            listener: (context, state) {
              if (state.errorMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage!),
                    backgroundColor: Theme.of(context).colorScheme.error,
                  ),
                );
              }
            },
            builder: (context, state) {
              return Column(
                children: [
                  // Email Field
                  CustomTextField(
                    labelText: AppStrings.email,
                    hintText: AppStrings.emailHint,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: context.read<LoginCubit>().emailChanged,
                    errorText: !state.isEmailValid && state.email.isNotEmpty
                        ? AppStrings.emailInvalid
                        : null,
                  ),
                  isMobile ? 2.vSpace : 3.vSpace,

                  // Password Field
                  CustomTextField(
                    labelText: AppStrings.password,
                    hintText: AppStrings.passwordHint,
                    controller: _passwordController,
                    obscureText: !state.isPasswordVisible,
                    onChanged: context.read<LoginCubit>().passwordChanged,
                    suffixIcon: IconButton(
                      icon: Icon(
                        state.isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                        size: 20.sp,
                      ),
                      onPressed: context
                          .read<LoginCubit>()
                          .togglePasswordVisibility,
                    ),
                    errorText:
                        !state.isPasswordValid && state.password.isNotEmpty
                        ? AppStrings.passwordTooShort
                        : null,
                  ),
                  isMobile ? 2.vSpace : 3.vSpace,

                  // Sign In Button
                  SizedBox(
                    width: double.infinity,
                    height: isMobile
                        ? AppConstants.mobileButtonHeight.h
                        : AppConstants.buttonHeight.h,
                    child: ElevatedButton(
                      onPressed: state.isFormValid && !state.isLoading
                          ? context.read<LoginCubit>().loginSubmitted
                          : null,
                      child: state.isLoading
                          ? SizedBox(
                              width: 24.w,
                              height: 24.h,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Text(
                              AppStrings.signIn,
                              style: TextStyle(
                                fontSize: isMobile ? 15.sp : 20.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
