import '../../../../core/base/base_cubit.dart';
import '../../../../core/constants/app_strings.dart';
import 'forgot_password_state.dart';

/// Cubit for managing forgot password form state and validation.
class ForgotPasswordCubit extends BaseCubit<ForgotPasswordState> {
  /// Creates a new [ForgotPasswordCubit].
  ForgotPasswordCubit() : super(const ForgotPasswordState());

  /// Updates the email field and validates it.
  void emailChanged(String email) {
    final isEmailValid = _isValidEmail(email);
    final isFormValid = isEmailValid;
    
    emit(state.copyWith(
      email: email,
      isEmailValid: isEmailValid,
      isFormValid: isFormValid,
      errorMessage: null,
      successMessage: null,
    ));
  }

  /// Submits the forgot password form.
  Future<void> resetPasswordSubmitted() async {
    if (!state.isFormValid) {
      emit(state.copyWith(
        errorMessage: AppStrings.checkEmailPassword,
      ));
      return;
    }

    emit(state.copyWith(isLoading: true, errorMessage: null, successMessage: null));

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // For demo purposes, always succeed
      emit(state.copyWith(
        isLoading: false,
        successMessage: AppStrings.resetLinkSent,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: AppStrings.loginError,
      ));
    }
  }

  /// Resets the forgot password form to initial state.
  void resetForm() {
    emit(const ForgotPasswordState());
  }

  /// Validates email format.
  bool _isValidEmail(String email) {
    if (email.isEmpty) return false;
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  @override
  void handleErrorMessage(String message) {
    emit(state.copyWith(errorMessage: message));
  }
}
