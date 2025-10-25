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
    this.imageBase64,
    this.imageName,
  });

  /// Current content
  final String content;

  /// Currently selected category
  final String? selectedCategory;

  /// Pin status
  final bool isPinned;

  /// Base64 encoded image data
  final String? imageBase64;

  /// Original image filename
  final String? imageName;

  /// Create a copy with modified fields
  AddNoteFormContentUpdated copyWith({
    String? content,
    String? selectedCategory,
    bool? isPinned,
    String? imageBase64,
    String? imageName,
  }) {
    return AddNoteFormContentUpdated(
      content: content ?? this.content,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      isPinned: isPinned ?? this.isPinned,
      imageBase64: imageBase64 ?? this.imageBase64,
      imageName: imageName ?? this.imageName,
    );
  }

  @override
  List<Object?> get props => [
    content,
    selectedCategory,
    isPinned,
    imageBase64,
    imageName,
  ];
}

/// Save success state
class AddNoteFormSaveSuccess extends AddNoteFormState {
  /// Constructor for save success state
  const AddNoteFormSaveSuccess({
    required this.content,
    this.selectedCategory,
    this.isPinned = false,
    this.imageBase64,
    this.imageName,
  });

  /// Current content
  final String content;

  /// Currently selected category
  final String? selectedCategory;

  /// Pin status
  final bool isPinned;

  /// Base64 encoded image data
  final String? imageBase64;

  /// Original image filename
  final String? imageName;

  @override
  List<Object?> get props => [
    content,
    selectedCategory,
    isPinned,
    imageBase64,
    imageName,
  ];
}

/// Save error state
class AddNoteFormSaveError extends AddNoteFormState {
  /// Constructor for save error state
  const AddNoteFormSaveError({
    required this.error,
    required this.content,
    this.selectedCategory,
    this.isPinned = false,
    this.imageBase64,
    this.imageName,
  });

  /// Error message
  final String error;

  /// Current content
  final String content;

  /// Currently selected category
  final String? selectedCategory;

  /// Pin status
  final bool isPinned;

  /// Base64 encoded image data
  final String? imageBase64;

  /// Original image filename
  final String? imageName;

  @override
  List<Object?> get props => [
    error,
    content,
    selectedCategory,
    isPinned,
    imageBase64,
    imageName,
  ];
}

/// Cubit for managing add note form state
class AddNoteFormCubit extends Cubit<AddNoteFormState> {
  /// Constructor for add note form cubit
  AddNoteFormCubit() : super(const AddNoteFormInitial());

  String? _selectedCategory;
  String _content = '';
  bool _isPinned = false;
  String? _imageBase64;
  String? _imageName;

  /// Get current selected category
  String? get selectedCategory => _selectedCategory;

  /// Get current content
  String get content => _content;

  /// Get pin status
  bool get isPinned => _isPinned;

  /// Get current image Base64
  String? get imageBase64 => _imageBase64;

  /// Get current image filename
  String? get imageName => _imageName;

  /// Set loading state
  void setLoading(bool isLoading) {
    if (isLoading) {
      emit(const AddNoteFormLoading());
    } else {
      // Return to previous state with current data
      emit(
        AddNoteFormContentUpdated(
          content: _content,
          selectedCategory: _selectedCategory,
          isPinned: _isPinned,
          imageBase64: _imageBase64,
          imageName: _imageName,
        ),
      );
    }
  }

  /// Select category
  void selectCategory(String? category) {
    _selectedCategory = category;
    // Always emit ContentUpdated to preserve all state including isPinned
    emit(
      AddNoteFormContentUpdated(
        content: _content,
        selectedCategory: category,
        isPinned: _isPinned,
        imageBase64: _imageBase64,
        imageName: _imageName,
      ),
    );
  }

  /// Update content
  void updateContent(String content) {
    _content = content;
    // Use copyWith to preserve isPinned when updating content
    emit(
      AddNoteFormContentUpdated(
        content: content,
        selectedCategory: _selectedCategory,
        isPinned: _isPinned,
        imageBase64: _imageBase64,
        imageName: _imageName,
      ),
    );
  }

  /// Toggle pin status
  void togglePin() {
    _isPinned = !_isPinned;
    // Preserve all other state when toggling pin
    emit(
      AddNoteFormContentUpdated(
        content: _content,
        selectedCategory: _selectedCategory,
        isPinned: _isPinned,
        imageBase64: _imageBase64,
        imageName: _imageName,
      ),
    );
  }

  /// Reset form
  void reset() {
    _selectedCategory = null;
    _content = '';
    _isPinned = false;
    _imageBase64 = null;
    _imageName = null;
    emit(const AddNoteFormInitial());
  }

  /// Set edit mode with existing note data
  void setEditMode({
    required String title,
    required String content,
    String? category,
    bool isPinned = false,
    String? imageBase64,
    String? imageName,
  }) {
    _content = content;
    _selectedCategory = category;
    _isPinned = isPinned;
    _imageBase64 = imageBase64;
    _imageName = imageName;
    emit(
      AddNoteFormContentUpdated(
        content: content,
        selectedCategory: category,
        isPinned: isPinned,
        imageBase64: imageBase64,
        imageName: imageName,
      ),
    );
  }

  /// Set image with Base64 data
  void setImage(String imageBase64, String imageName) {
    _imageBase64 = imageBase64;
    _imageName = imageName;
    emit(
      AddNoteFormContentUpdated(
        content: _content,
        selectedCategory: _selectedCategory,
        isPinned: _isPinned,
        imageBase64: imageBase64,
        imageName: imageName,
      ),
    );
  }

  /// Remove image
  void removeImage() {
    _imageBase64 = null;
    _imageName = null;
    emit(
      AddNoteFormContentUpdated(
        content: _content,
        selectedCategory: _selectedCategory,
        isPinned: _isPinned,
        imageBase64: null,
        imageName: null,
      ),
    );
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
        imageBase64: _imageBase64,
        imageName: _imageName,
      );

      // Emit success state with all current data preserved
      emit(
        AddNoteFormSaveSuccess(
          content: _content,
          selectedCategory: _selectedCategory,
          isPinned: _isPinned,
          imageBase64: _imageBase64,
          imageName: _imageName,
        ),
      );
    } catch (e) {
      // Emit error state with all current data preserved
      emit(
        AddNoteFormSaveError(
          error: e.toString(),
          content: _content,
          selectedCategory: _selectedCategory,
          isPinned: _isPinned,
          imageBase64: _imageBase64,
          imageName: _imageName,
        ),
      );
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
        imageBase64: _imageBase64,
        imageName: _imageName,
      );

      // Emit success state with all current data preserved
      emit(
        AddNoteFormSaveSuccess(
          content: _content,
          selectedCategory: _selectedCategory,
          isPinned: _isPinned,
          imageBase64: _imageBase64,
          imageName: _imageName,
        ),
      );
    } catch (e) {
      // Emit error state with all current data preserved
      emit(
        AddNoteFormSaveError(
          error: e.toString(),
          content: _content,
          selectedCategory: _selectedCategory,
          isPinned: _isPinned,
          imageBase64: _imageBase64,
          imageName: _imageName,
        ),
      );
    }
  }
}
