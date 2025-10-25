import '../entities/note.dart';
import '../repositories/notes_repository.dart';

/// Use case for getting notes by category
class GetNotesByCategoryUseCase {
  /// Creates a new instance of [GetNotesByCategoryUseCase]
  const GetNotesByCategoryUseCase(this._repository);
  final NotesRepository _repository;

  /// Execute the use case to get notes by category
  Future<List<Note>> call(String category) async {
    return await _repository.getNotesByCategory(category);
  }
}
