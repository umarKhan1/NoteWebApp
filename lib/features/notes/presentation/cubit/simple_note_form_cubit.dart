import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

/// State for simple note form
class SimpleNoteFormState extends Equatable {
  /// Constructor
  const SimpleNoteFormState({
    this.title = '',
    this.content = '',
    this.isLoading = false,
    this.error = '',
  });

  /// Note title
  final String title;
  
  /// Note content
  final String content;
  
  /// Loading state
  final bool isLoading;
  
  /// Error message
  final String error;

  /// Copy with method
  SimpleNoteFormState copyWith({
    String? title,
    String? content,
    bool? isLoading,
    String? error,
  }) {
    return SimpleNoteFormState(
      title: title ?? this.title,
      content: content ?? this.content,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props => [title, content, isLoading, error];
}

/// Cubit for managing simple note form state
class SimpleNoteFormCubit extends Cubit<SimpleNoteFormState> {
  /// Constructor
  SimpleNoteFormCubit() : super(const SimpleNoteFormState());

  /// Update title
  void updateTitle(String title) {
    emit(state.copyWith(title: title, error: ''));
  }

  /// Update content
  void updateContent(String content) {
    emit(state.copyWith(content: content, error: ''));
  }

  /// Set loading state
  void setLoading(bool isLoading) {
    emit(state.copyWith(isLoading: isLoading));
  }

  /// Set error message
  void setError(String error) {
    emit(state.copyWith(error: error, isLoading: false));
  }

  /// Clear error
  void clearError() {
    emit(state.copyWith(error: ''));
  }

  /// Reset form
  void reset() {
    emit(const SimpleNoteFormState());
  }

  /// Validate form
  String? validateForm() {
    if (state.title.trim().isEmpty) {
      return 'Please enter a title';
    }
    return null;
  }
}
