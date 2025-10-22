import 'package:equatable/equatable.dart';

/// Represents the state of the login form.
class LoginState extends Equatable {
  /// Creates a new [LoginState].
  const LoginState({
    this.email = '',
    this.password = '',
    this.isEmailValid = true,
    this.isPasswordValid = true,
    this.isPasswordVisible = false,
    this.isLoading = false,
    this.isFormValid = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  /// User's email input.
  final String email;

  /// User's password input.
  final String password;

  /// Whether the email is valid.
  final bool isEmailValid;

  /// Whether the password is valid.
  final bool isPasswordValid;

  /// Whether the password is visible.
  final bool isPasswordVisible;

  /// Whether the form is currently submitting.
  final bool isLoading;

  /// Whether the form is valid for submission.
  final bool isFormValid;
  
  /// Whether login was successful.
  final bool isSuccess;

  /// Error message to display.
  final String? errorMessage;

  /// Creates a copy of this state with updated fields.
  LoginState copyWith({
    String? email,
    String? password,
    bool? isEmailValid,
    bool? isPasswordValid,
    bool? isPasswordVisible,
    bool? isLoading,
    bool? isFormValid,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isLoading: isLoading ?? this.isLoading,
      isFormValid: isFormValid ?? this.isFormValid,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        email,
        password,
        isEmailValid,
        isPasswordValid,
        isPasswordVisible,
        isLoading,
        isFormValid,
        isSuccess,
        errorMessage,
      ];
}
