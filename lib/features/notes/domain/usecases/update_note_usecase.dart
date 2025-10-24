import '../entities/note.dart';
import '../repositories/notes_repository.dart';

/// Parameters for updating a note
class UpdateNoteParams {
  final String id;
  final String? title;
  final String? content;
  final String? category;
  final bool? isPinned;
  final String? color;

  const UpdateNoteParams({
    required this.id,
    this.title,
    this.content,
    this.category,
    this.isPinned,
    this.color,
  });
}

/// Use case for updating an existing note
class UpdateNoteUseCase {
  final NotesRepository _repository;

  const UpdateNoteUseCase(this._repository);

  /// Execute the use case to update a note
  Future<Note> call(UpdateNoteParams params) async {
    return await _repository.updateNote(
      id: params.id,
      title: params.title,
      content: params.content,
      category: params.category,
      isPinned: params.isPinned,
      color: params.color,
    );
  }
}
