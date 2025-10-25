import '../entities/note.dart';
import '../repositories/notes_repository.dart';

/// Use case for getting a specific note by ID
class GetNoteByIdUseCase {
  /// Creates a new instance of [GetNoteByIdUseCase]
  const GetNoteByIdUseCase(this._repository);
  final NotesRepository _repository;

  /// Execute the use case to get a note by ID
  Future<Note?> call(String noteId) async {
    return await _repository.getNoteById(noteId);
  }
}
