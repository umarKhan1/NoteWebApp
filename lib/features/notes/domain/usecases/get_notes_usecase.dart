import '../entities/note.dart';
import '../repositories/notes_repository.dart';

/// Use case for getting all notes
class GetNotesUseCase {
  final NotesRepository _repository;

  const GetNotesUseCase(this._repository);

  /// Execute the use case to get all notes
  Future<List<Note>> call() async {
    return await _repository.getAllNotes();
  }
}
