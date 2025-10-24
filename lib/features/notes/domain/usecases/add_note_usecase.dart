import '../entities/note.dart';
import '../repositories/notes_repository.dart';

/// Parameters for creating a note
class CreateNoteParams {
  final String title;
  final String content;
  final String? category;
  final bool isPinned;
  final String? color;

  const CreateNoteParams({
    required this.title,
    required this.content,
    this.category,
    this.isPinned = false,
    this.color,
  });
}

/// Use case for creating a new note
class CreateNoteUseCase {
  final NotesRepository _repository;

  const CreateNoteUseCase(this._repository);

  /// Execute the use case to create a note
  Future<Note> call(CreateNoteParams params) async {
    return await _repository.createNote(
      title: params.title,
      content: params.content,
      category: params.category,
      isPinned: params.isPinned,
      color: params.color,
    );
  }
}
