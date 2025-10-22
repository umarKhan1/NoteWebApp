import 'package:formz/formz.dart';

import '../../../../core/base/base_cubit.dart';
import '../../../../core/constants/app_strings.dart';
import 'signup_state.dart';

/// Cubit responsible for managing signup form state and submission.
class SignupCubit extends BaseCubit<SignupState> {
  /// Creates a new [SignupCubit] with initial form state.
  SignupCubit() : super(const SignupFormState());

  /// Updates the name field and validates the form.
  void nameChanged(String name) {
    if (state is SignupFormState) {
      final currentState = state as SignupFormState;
      final newState = currentState.copyWith(
        name: name,
        isValid: _isFormValid(
          name: name,
          email: currentState.email,
          password: currentState.password,
        ),
      );
      emit(newState);
    }
  }

  /// Updates the email field and validates the form.
  void emailChanged(String email) {
    if (state is SignupFormState) {
      final currentState = state as SignupFormState;
      final newState = currentState.copyWith(
        email: email,
        isValid: _isFormValid(
          name: currentState.name,
          email: email,
          password: currentState.password,
        ),
      );
      emit(newState);
    }
  }

  /// Updates the password field and validates the form.
  void passwordChanged(String password) {
    if (state is SignupFormState) {
      final currentState = state as SignupFormState;
      final newState = currentState.copyWith(
        password: password,
        isValid: _isFormValid(
          name: currentState.name,
          email: currentState.email,
          password: password,
        ),
      );
      emit(newState);
    }
  }

  /// Toggles password visibility.
  void togglePasswordVisibility() {
    if (state is SignupFormState) {
      final currentState = state as SignupFormState;
      emit(currentState.copyWith(
        isPasswordVisible: !currentState.isPasswordVisible,
      ));
    }
  }

  /// Submits the signup form.
  Future<void> signupSubmitted() async {
    if (state is! SignupFormState) return;
    
    final currentState = state as SignupFormState;
    
    if (!currentState.isValid) {
      emit(const SignupError(AppStrings.checkEmailPassword));
      return;
    }

    emit(currentState.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));
      
      // For now, we'll simulate a successful signup
      
      emit(currentState.copyWith(status: FormzSubmissionStatus.success));
      emit(const SignupSuccess());
    } catch (error) {
      emit(currentState.copyWith(status: FormzSubmissionStatus.failure));
      emit(SignupError(error.toString()));
    }
  }

  /// Resets the signup state to initial form state.
  void resetState() {
    emit(const SignupFormState());
  }

  /// Resets the signup form to initial state.
  void resetForm() {
    emit(const SignupFormState());
  }

  /// Validates if the form is complete and valid.
  bool _isFormValid({
    required String name,
    required String email,
    required String password,
  }) {
    return name.isNotEmpty &&
           email.isNotEmpty &&
           email.contains('@') &&
           password.isNotEmpty &&
           password.length >= 6;
  }

  @override
  void handleErrorMessage(String message) {
    emit(SignupError(message));
  }
}
