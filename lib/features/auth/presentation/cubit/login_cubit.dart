import '../../../../core/base/base_cubit.dart';
import '../../../../core/constants/app_strings.dart';
import 'login_state.dart';

/// Cubit for managing login form state and validation.
class LoginCubit extends BaseCubit<LoginState> {
  /// Creates a new [LoginCubit].
  LoginCubit() : super(const LoginState());

  /// Updates the email field and validates it.
  void emailChanged(String email) {
    final isEmailValid = _isValidEmail(email);
    final isFormValid = isEmailValid && _isValidPassword(state.password);
    
    emit(state.copyWith(
      email: email,
      isEmailValid: isEmailValid,
      isFormValid: isFormValid,
      errorMessage: null,
    ));
  }

  /// Updates the password field and validates it.
  void passwordChanged(String password) {
    final isPasswordValid = _isValidPassword(password);
    final isFormValid = _isValidEmail(state.email) && isPasswordValid;
    
    emit(state.copyWith(
      password: password,
      isPasswordValid: isPasswordValid,
      isFormValid: isFormValid,
      errorMessage: null,
    ));
  }

  /// Toggles password visibility.
  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  /// Submits the login form.
  Future<void> loginSubmitted() async {
    if (!state.isFormValid) {
      emit(state.copyWith(
        errorMessage: AppStrings.checkEmailPassword,
      ));
      return;
    }

    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // For demo purposes, check for demo credentials
      if (state.email == 'demo@example.com' && state.password == 'password123') {
        // Success - this would typically navigate to home page
        emit(state.copyWith(isLoading: false, isSuccess: true));
       
      } else {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: AppStrings.invalidCredentials,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: AppStrings.loginError,
      ));
    }
  }

  /// Resets the login form to initial state.
  void resetForm() {
    emit(const LoginState());
  }

  @override
  void handleErrorMessage(String message) {
    emit(state.copyWith(errorMessage: message));
  }

  /// Validates email format.
  bool _isValidEmail(String email) {
    if (email.isEmpty) return false;
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  /// Validates password strength.
  bool _isValidPassword(String password) {
    return password.length >= 6;
  }
}
