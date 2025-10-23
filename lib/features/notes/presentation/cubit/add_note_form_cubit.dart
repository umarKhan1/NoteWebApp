import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

/// State for add note form
abstract class AddNoteFormState extends Equatable {
  const AddNoteFormState();
  
  @override
  List<Object?> get props => [];
}

/// Initial state
class AddNoteFormInitial extends AddNoteFormState {
  const AddNoteFormInitial();
}

/// Loading state
class AddNoteFormLoading extends AddNoteFormState {
  const AddNoteFormLoading();
}

/// Category selection state
class AddNoteFormCategorySelected extends AddNoteFormState {
  const AddNoteFormCategorySelected({this.selectedCategory});
  
  final String? selectedCategory;
  
  @override
  List<Object?> get props => [selectedCategory];
}

/// Content updated state
class AddNoteFormContentUpdated extends AddNoteFormState {
  const AddNoteFormContentUpdated({
    required this.content,
    this.selectedCategory,
  });
  
  final String content;
  final String? selectedCategory;
  
  @override
  List<Object?> get props => [content, selectedCategory];
}

/// Cubit for managing add note form state
class AddNoteFormCubit extends Cubit<AddNoteFormState> {
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
      emit(AddNoteFormCategorySelected(selectedCategory: _selectedCategory));
    }
  }
  
  /// Select category
  void selectCategory(String? category) {
    _selectedCategory = category;
    emit(AddNoteFormCategorySelected(selectedCategory: category));
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
}
