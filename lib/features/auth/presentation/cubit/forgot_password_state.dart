/// Forgot password state management.
class ForgotPasswordState {

  /// Creates a new [ForgotPasswordState].
  const ForgotPasswordState({
    this.email = '',
    this.isEmailValid = false,
    this.isFormValid = false,
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
  });
  /// Email field value.
  final String email;
  
  /// Whether email is valid.
  final bool isEmailValid;
  
  /// Whether form is valid and can be submitted.
  final bool isFormValid;
  
  /// Whether form is currently being submitted.
  final bool isLoading;
  
  /// Error message to display.
  final String? errorMessage;
  
  /// Success message to display.
  final String? successMessage;

  /// Creates a copy of this state with updated values.
  ForgotPasswordState copyWith({
    String? email,
    bool? isEmailValid,
    bool? isFormValid,
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
  }) {
    return ForgotPasswordState(
      email: email ?? this.email,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isFormValid: isFormValid ?? this.isFormValid,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }
}
