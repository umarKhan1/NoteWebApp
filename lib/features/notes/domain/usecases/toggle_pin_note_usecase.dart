import '../entities/note.dart';
import '../repositories/notes_repository.dart';

/// Use case for toggling pin status of a note
class TogglePinNoteUseCase {
  /// Constructor [TogglePinNoteUseCase]
  const TogglePinNoteUseCase(this._repository);
  final NotesRepository _repository;

  /// Execute the use case to toggle pin status
  Future<Note> call(String noteId) async {
    return await _repository.togglePinNote(noteId);
  }
}
