import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/router/route_names.dart';
import '../../../../../shared/extensions/widget_extensions.dart';
import '../../cubit/forgot_password_cubit.dart';
import '../../cubit/forgot_password_state.dart';
import '../../cubit/login_cubit.dart';
import '../custom_text_field.dart';

/// Forgot password form card widget containing the reset password form.
class ForgotPasswordFormCard extends StatefulWidget {
  /// Creates a new [ForgotPasswordFormCard].
  const ForgotPasswordFormCard({super.key});

  @override
  State<ForgotPasswordFormCard> createState() => _ForgotPasswordFormCardState();
}

class _ForgotPasswordFormCardState extends State<ForgotPasswordFormCard> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < AppConstants.mobileMaxWidth;
    
    return Container(
      constraints: BoxConstraints(
        maxWidth: isMobile ? double.infinity : 400.w,
      ),
      padding: EdgeInsets.all(
        isMobile ? AppConstants.defaultPadding.w : AppConstants.extraLargePadding.w,
      ),
      child: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
        listener: (context, state) {
          if (state.successMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.successMessage!),
                backgroundColor: Theme.of(context).primaryColor,
              ),
            );
          } else if (state.errorMessage != null) {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              Text(
                AppStrings.resetPasswordTitle,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize: isMobile ? 25.sp : 42.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              8.heightBox,
              
              // Subtitle
              Text(
                AppStrings.resetPasswordSubtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: isMobile ? 17.sp : 18.sp,
                ),
              ),
              (isMobile ? 20 : 32).heightBox,
              
              // Email Field
              CustomTextField(
                labelText: AppStrings.email,
                hintText: AppStrings.emailHint,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                onChanged: context.read<ForgotPasswordCubit>().emailChanged,
                errorText: !state.isEmailValid && state.email.isNotEmpty
                    ? AppStrings.invalidEmail
                    : null,
              ),
              (isMobile ? 24 : 40).heightBox,
              
              // Reset Password Button
              SizedBox(
                width: double.infinity,
                height: isMobile ? AppConstants.mobileButtonHeight.h : AppConstants.buttonHeight.h,
                child: ElevatedButton(
                  onPressed: state.isFormValid && !state.isLoading
                      ? context.read<ForgotPasswordCubit>().resetPasswordSubmitted
                      : null,
                  child: state.isLoading
                      ? SizedBox(
                          width: 24.w,
                          height: 24.h,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          AppStrings.resetPassword,
                          style: TextStyle(
                            fontSize: isMobile ? 15.sp : 20.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              (isMobile ? 15 : 32).heightBox,
              
              // Back to Login Button
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    overlayColor: Colors.transparent,
                  ),
                  onPressed: () {
                    // Reset login form before navigation
                    context.read<LoginCubit>().resetForm();
                    context.go(RouteNames.login);
                  },
                  child: Text(
                    AppStrings.backToLogin,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: isMobile ? 15.sp : 18.sp,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
