import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// State for markdown editor functionality.
/// 
/// This abstract base class represents all possible states
/// for the markdown editor component.
abstract class MarkdownEditorState extends Equatable {
  /// Creates a new markdown editor state
  const MarkdownEditorState();
  
  @override
  List<Object?> get props => [];
}

/// Initial state of the markdown editor.
/// 
/// This represents the state when the editor is first created
/// or has been reset to its default condition.
class MarkdownEditorInitial extends MarkdownEditorState {
  /// Creates a new initial markdown editor state
  const MarkdownEditorInitial();
}

/// State when markdown content has been updated.
/// 
/// This state contains the current content of the markdown editor
/// and is emitted whenever the user modifies the text.
class MarkdownEditorContentUpdated extends MarkdownEditorState {
  /// Creates a new content updated state
  const MarkdownEditorContentUpdated({required this.content});
  
  /// The current markdown content
  final String content;
  
  @override
  List<Object?> get props => [content];
}

/// Cubit for managing markdown editor state.
/// 
/// This cubit handles the state management for the markdown editor
/// component, including content updates and resets.
class MarkdownEditorCubit extends Cubit<MarkdownEditorState> {
  /// Creates a new markdown editor cubit
  MarkdownEditorCubit() : super(const MarkdownEditorInitial());
  
  /// Update content and emit new state
  /// 
  /// This method updates the markdown content and emits a new state
  /// to notify listeners of the change.
  void updateContent(String content) {
    emit(MarkdownEditorContentUpdated(content: content));
  }
  
  /// Reset to initial state
  /// 
  /// This method resets the editor to its initial state,
  /// clearing any existing content.
  void reset() {
    emit(const MarkdownEditorInitial());
  }
}
