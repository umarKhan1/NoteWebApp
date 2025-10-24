import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// State for add note form
abstract class AddNoteFormState extends Equatable {
  /// Constructor for add note form state
  const AddNoteFormState();
  
  @override
  List<Object?> get props => [];
}

/// Initial state
/// 
class AddNoteFormInitial extends AddNoteFormState {
  ///  Constructor for initial state [initial state]
  const AddNoteFormInitial();
}

/// Loading state
class AddNoteFormLoading extends AddNoteFormState {
  /// Constructor for loading state [loading state]
  const AddNoteFormLoading();
}

/// Category selection state
class AddNoteFormCategorySelected extends AddNoteFormState {
  /// Constructor for category selected state
  const AddNoteFormCategorySelected({this.selectedCategory});
  /// Currently selected category
  final String? selectedCategory;
  
  @override
  List<Object?> get props => [selectedCategory];
}

/// Content updated state
class AddNoteFormContentUpdated extends AddNoteFormState {
  /// Constructor for content updated state
  const AddNoteFormContentUpdated({
    required this.content,
    this.selectedCategory,
  });
  /// Current content
  final String content;
  /// Currently selected category
  final String? selectedCategory;
  
  @override
  List<Object?> get props => [content, selectedCategory];
}

/// Save success state
class AddNoteFormSaveSuccess extends AddNoteFormState {
  /// Constructor for save success state
  const AddNoteFormSaveSuccess({
    required this.content,
    this.selectedCategory,
  });
  /// Current content
  final String content;
  /// Currently selected category
  final String? selectedCategory;
  
  @override
  List<Object?> get props => [content, selectedCategory];
}

/// Save error state
class AddNoteFormSaveError extends AddNoteFormState {
  /// Constructor for save error state
  const AddNoteFormSaveError({
    required this.error,
    required this.content,
    this.selectedCategory,
  });
  /// Error message
  final String error;
  /// Current content
  final String content;
  /// Currently selected category
  final String? selectedCategory;
  
  @override
  List<Object?> get props => [error, content, selectedCategory];
}

/// Cubit for managing add note form state
class AddNoteFormCubit extends Cubit<AddNoteFormState> {
  /// Constructor for add note form cubit
  AddNoteFormCubit() : super(const AddNoteFormInitial());
  
  String? _selectedCategory;
  String _content = '';
  
  /// Get current selected category
  String? get selectedCategory => _selectedCategory;
  
  /// Get current content
  String get content => _content;
  
  /// Set loading state
  void setLoading(bool isLoading) {
    if (isLoading) {
      emit(const AddNoteFormLoading());
    } else {
      // Return to previous state with current data
      emit(AddNoteFormContentUpdated(
        content: _content,
        selectedCategory: _selectedCategory,
      ));
    }
  }
  
  /// Select category
  void selectCategory(String? category) {
    _selectedCategory = category;
    // Always emit ContentUpdated to preserve both content and category
    emit(AddNoteFormContentUpdated(
      content: _content,
      selectedCategory: category,
    ));
  }
  
  /// Update content
  void updateContent(String content) {
    _content = content;
    emit(AddNoteFormContentUpdated(
      content: content,
      selectedCategory: _selectedCategory,
    ));
  }
  
  /// Reset form
  void reset() {
    _selectedCategory = null;
    _content = '';
    emit(const AddNoteFormInitial());
  }
  
  /// Save note with current form data
  Future<void> saveNote({
    required String title,
    required String content,
    required dynamic notesCubit, // Using dynamic to avoid circular dependency
  }) async {
    setLoading(true);
    
    try {
      await notesCubit.createNote(
        title: title,
        content: content,
        category: _selectedCategory,
      );
      
      // Emit success state
      emit(AddNoteFormSaveSuccess(
        content: _content,
        selectedCategory: _selectedCategory,
      ));
    } catch (e) {
      // Emit error state
      emit(AddNoteFormSaveError(
        error: e.toString(),
        content: _content,
        selectedCategory: _selectedCategory,
      ));
    }
  }
}
