import '../entities/note.dart';
import '../repositories/notes_repository.dart';

/// Use case for searching notes
class SearchNotesUseCase {
  final NotesRepository _repository;

  const SearchNotesUseCase(this._repository);

  /// Execute the use case to search notes
  Future<List<Note>> call(String query) async {
    return await _repository.searchNotes(query);
  }
}
