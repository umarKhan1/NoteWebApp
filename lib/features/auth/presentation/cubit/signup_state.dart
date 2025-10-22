import 'package:formz/formz.dart';

/// Represents the various states of the signup process.
abstract class SignupState {
  /// Creates a new [SignupState].
  const SignupState();
}

/// Initial state of the signup process.
class SignupInitial extends SignupState {
  /// Creates a new [SignupInitial] state.
  const SignupInitial();
}

/// State indicating signup is in progress.
class SignupLoading extends SignupState {
  /// Creates a new [SignupLoading] state.
  const SignupLoading();
}

/// State indicating successful signup.
class SignupSuccess extends SignupState {
  /// Creates a new [SignupSuccess] state.
  const SignupSuccess();
}

/// State indicating signup failed with an error.
class SignupError extends SignupState {

  /// Creates a new [SignupError] state with the provided [message].
  const SignupError(this.message);
  /// The error message.
  final String message;
}

/// State representing the signup form data and validation.
class SignupFormState extends SignupState {

  /// Creates a new [SignupFormState].
  const SignupFormState({
    this.name = '',
    this.email = '',
    this.password = '',
    this.isValid = false,
    this.status = FormzSubmissionStatus.initial,
    this.isPasswordVisible = false,
  });
  /// User's name.
  final String name;
  
  /// User's email address.
  final String email;
  
  /// User's password.
  final String password;
  
  /// Whether the form is valid.
  final bool isValid;
  
  /// Whether password is visible.
  final bool isPasswordVisible;
  
  /// Form submission status.
  final FormzSubmissionStatus status;

  /// Creates a copy of this state with the provided parameters.
  SignupFormState copyWith({
    String? name,
    String? email,
    String? password,
    bool? isValid,
    bool? isPasswordVisible,
    FormzSubmissionStatus? status,
  }) {
    return SignupFormState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      isValid: isValid ?? this.isValid,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      status: status ?? this.status,
    );
  }
}
