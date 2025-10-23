import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

/// State for markdown editor
abstract class MarkdownEditorState extends Equatable {
  const MarkdownEditorState();
  
  @override
  List<Object?> get props => [];
}

/// Initial state
class MarkdownEditorInitial extends MarkdownEditorState {
  const MarkdownEditorInitial();
}

/// Content updated state
class MarkdownEditorContentUpdated extends MarkdownEditorState {
  const MarkdownEditorContentUpdated({required this.content});
  
  final String content;
  
  @override
  List<Object?> get props => [content];
}

/// Cubit for managing markdown editor state
class MarkdownEditorCubit extends Cubit<MarkdownEditorState> {
  MarkdownEditorCubit() : super(const MarkdownEditorInitial());
  
  /// Update content and emit new state
  void updateContent(String content) {
    emit(MarkdownEditorContentUpdated(content: content));
  }
  
  /// Reset to initial state
  void reset() {
    emit(const MarkdownEditorInitial());
  }
}
