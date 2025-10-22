import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Base cubit with common functionality
abstract class BaseCubit<T> extends Cubit<T> {
  /// Creates a [BaseCubit] with initial state.
  BaseCubit(super.initialState);
  
  /// Handles errors in a consistent way
  void handleError(Object error, [String? customMessage]) {
    final message = customMessage ?? 'An error occurred: ${error.toString()}';
    handleErrorMessage(message);
  }
  
  /// Called when an error occurs - should be implemented by subclasses
  void handleErrorMessage(String message);
  
  /// Logs debug information
  void logDebug(String message) {
    // In a real app, this would use a proper logging framework
    if (kDebugMode) {
      print('$runtimeType: $message');
    }
  }
  
  @override
  void onChange(Change<T> change) {
    super.onChange(change);
    logDebug('State changed from ${change.currentState} to ${change.nextState}');
  }
}
