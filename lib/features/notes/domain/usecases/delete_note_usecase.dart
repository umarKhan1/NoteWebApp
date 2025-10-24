import '../repositories/notes_repository.dart';

/// Use case for deleting a note
class DeleteNoteUseCase {
  final NotesRepository _repository;

  const DeleteNoteUseCase(this._repository);

  /// Execute the use case to delete a note
  Future<bool> call(String noteId) async {
    return await _repository.deleteNote(noteId);
  }
}
