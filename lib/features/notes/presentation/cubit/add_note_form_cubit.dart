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
    this.isPinned = false,
  });
  /// Current content
  final String content;
  /// Currently selected category
  final String? selectedCategory;
  /// Pin status
  final bool isPinned;
  
  /// Create a copy with modified fields
  AddNoteFormContentUpdated copyWith({
    String? content,
    String? selectedCategory,
    bool? isPinned,
  }) {
    return AddNoteFormContentUpdated(
      content: content ?? this.content,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      isPinned: isPinned ?? this.isPinned,
    );
  }
  
  @override
  List<Object?> get props => [content, selectedCategory, isPinned];
}

/// Save success state
class AddNoteFormSaveSuccess extends AddNoteFormState {
  /// Constructor for save success state
  const AddNoteFormSaveSuccess({
    required this.content,
    this.selectedCategory,
    this.isPinned = false,
  });
  /// Current content
  final String content;
  /// Currently selected category
  final String? selectedCategory;
  /// Pin status
  final bool isPinned;
  
  @override
  List<Object?> get props => [content, selectedCategory, isPinned];
}

/// Save error state
class AddNoteFormSaveError extends AddNoteFormState {
  /// Constructor for save error state
  const AddNoteFormSaveError({
    required this.error,
    required this.content,
    this.selectedCategory,
    this.isPinned = false,
  });
  /// Error message
  final String error;
  /// Current content
  final String content;
  /// Currently selected category
  final String? selectedCategory;
  /// Pin status
  final bool isPinned;
  
  @override
  List<Object?> get props => [error, content, selectedCategory, isPinned];
}

/// Cubit for managing add note form state
class AddNoteFormCubit extends Cubit<AddNoteFormState> {
  /// Constructor for add note form cubit
  AddNoteFormCubit() : super(const AddNoteFormInitial());
  
  String? _selectedCategory;
  String _content = '';
  bool _isPinned = false;
  
  /// Get current selected category
  String? get selectedCategory => _selectedCategory;
  
  /// Get current content
  String get content => _content;
  
  /// Get pin status
  bool get isPinned => _isPinned;
  
  /// Set loading state
  void setLoading(bool isLoading) {
    if (isLoading) {
      emit(const AddNoteFormLoading());
    } else {
      // Return to previous state with current data
      emit(AddNoteFormContentUpdated(
        content: _content,
        selectedCategory: _selectedCategory,
        isPinned: _isPinned,
      ));
    }
  }
  
  /// Select category
  void selectCategory(String? category) {
    _selectedCategory = category;
    // Always emit ContentUpdated to preserve all state including isPinned
    emit(AddNoteFormContentUpdated(
      content: _content,
      selectedCategory: category,
      isPinned: _isPinned,
    ));
  }
  
  /// Update content
  void updateContent(String content) {
    _content = content;
    // Use copyWith to preserve isPinned when updating content
    emit(AddNoteFormContentUpdated(
      content: content,
      selectedCategory: _selectedCategory,
      isPinned: _isPinned,
    ));
  }
  
  /// Toggle pin status
  void togglePin() {
    _isPinned = !_isPinned;
    // Preserve all other state when toggling pin
    emit(AddNoteFormContentUpdated(
      content: _content,
      selectedCategory: _selectedCategory,
      isPinned: _isPinned,
    ));
  }
  
  /// Reset form
  void reset() {
    _selectedCategory = null;
    _content = '';
    _isPinned = false;
    emit(const AddNoteFormInitial());
  }
  
  /// Set edit mode with existing note data
  void setEditMode({
    required String title,
    required String content,
    String? category,
    bool isPinned = false,
  }) {
    _content = content;
    _selectedCategory = category;
    _isPinned = isPinned;
    emit(AddNoteFormContentUpdated(
      content: content,
      selectedCategory: category,
      isPinned: isPinned,
    ));
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
        isPinned: _isPinned,
      );
      
      // Emit success state with all current data preserved
      emit(AddNoteFormSaveSuccess(
        content: _content,
        selectedCategory: _selectedCategory,
        isPinned: _isPinned,
      ));
    } catch (e) {
      // Emit error state with all current data preserved
      emit(AddNoteFormSaveError(
        error: e.toString(),
        content: _content,
        selectedCategory: _selectedCategory,
        isPinned: _isPinned,
      ));
    }
  }
  
  /// Update existing note with current form data
  Future<void> updateNote({
    required String noteId,
    required String title,
    required String content,
    required dynamic notesCubit, // Using dynamic to avoid circular dependency
  }) async {
    setLoading(true);
    
    try {
      await notesCubit.updateNote(
        id: noteId,
        title: title,
        content: content,
        category: _selectedCategory,
        isPinned: _isPinned,
      );
      
      // Emit success state with all current data preserved
      emit(AddNoteFormSaveSuccess(
        content: _content,
        selectedCategory: _selectedCategory,
        isPinned: _isPinned,
      ));
    } catch (e) {
      // Emit error state with all current data preserved
      emit(AddNoteFormSaveError(
        error: e.toString(),
        content: _content,
        selectedCategory: _selectedCategory,
        isPinned: _isPinned,
      ));
    }
  }
}