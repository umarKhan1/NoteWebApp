import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/router/route_names.dart';
import '../../../../../shared/extensions/widget_extensions.dart';
import '../../cubit/login_cubit.dart';
import '../../cubit/signup_cubit.dart';
import '../../cubit/signup_state.dart';
import '../custom_text_field.dart';

/// Signup form card widget containing the signup form.
class SignupFormCard extends StatefulWidget {
  /// Creates a new [SignupFormCard].
  const SignupFormCard({super.key});

  @override
  State<SignupFormCard> createState() => _SignupFormCardState();
}

class _SignupFormCardState extends State<SignupFormCard> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          Text(
            AppStrings.createAccount,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: isMobile ? 25.sp : 42.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          8.heightBox,
          
          // Subtitle
          Text(
            AppStrings.joinUs,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: isMobile ? 17.sp : 18.sp,
            ),
          ),
          (isMobile ? 20 : 32).heightBox,
          
          // Signup Form
          BlocConsumer<SignupCubit, SignupState>(
            listener: (context, state) {
              if (state is SignupSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(AppStrings.accountCreatedSuccessfully),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                );
                // Navigate to login page after successful signup
                context.read<LoginCubit>().resetForm();
                context.go(RouteNames.login);
              } else if (state is SignupError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Theme.of(context).colorScheme.error,
                  ),
                );
              }
            },
            builder: (context, state) {
              return Column(
                children: [
                  // Name Field
                  CustomTextField(
                    labelText: AppStrings.fullName,
                    hintText: AppStrings.fullNameHint,
                    controller: _nameController,
                    keyboardType: TextInputType.name,
                    onChanged: context.read<SignupCubit>().nameChanged,
                  ),
                  (isMobile ? 16 : 24).heightBox,
                  
                  // Email Field
                  CustomTextField(
                    labelText: AppStrings.email,
                    hintText: AppStrings.emailHint,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: context.read<SignupCubit>().emailChanged,
                  ),
                  (isMobile ? 16 : 24).heightBox,
                  
                  // Password Field
                  CustomTextField(
                    labelText: AppStrings.password,
                    hintText: AppStrings.passwordHint,
                    controller: _passwordController,
                    obscureText: state is SignupFormState ? !state.isPasswordVisible : true,
                    suffixIcon: IconButton(
                      icon: Icon(
                        state is SignupFormState && state.isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                        size: 20.sp,
                      ),
                      onPressed: context.read<SignupCubit>().togglePasswordVisibility,
                    ),
                    onChanged: context.read<SignupCubit>().passwordChanged,
                  ),
                  (isMobile ? 24 : 40).heightBox,
                  
                  // Create Account Button
                  SizedBox(
                    width: double.infinity,
                    height: isMobile ? AppConstants.mobileButtonHeight.h : AppConstants.buttonHeight.h,
                    child: ElevatedButton(
                      onPressed: (state is SignupFormState && state.isValid && 
                                state.status != FormzSubmissionStatus.inProgress)
                          ? () => context.read<SignupCubit>().signupSubmitted()
                          : null,
                      child: state is SignupFormState && 
                             state.status == FormzSubmissionStatus.inProgress
                          ? SizedBox(
                              height: 20.h,
                              width: 20.h,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              AppStrings.createAccount,
                              style: TextStyle(
                                fontSize: isMobile ? 18.sp : 20.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                  (isMobile ? 15 : 32).heightBox,  
                  
                  // Login Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppStrings.alreadyHaveAccount,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: isMobile ? 15.sp : 18.sp,
                        ),
                      ),
                      TextButton(
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
                          AppStrings.signIn,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: isMobile ? 15.sp : 18.sp,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
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
