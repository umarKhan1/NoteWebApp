import '../entities/note.dart';
import '../repositories/notes_repository.dart';

/// Use case for getting all notes from the repository.
///
/// This use case encapsulates the business logic for retrieving
/// all notes from the data source through the repository pattern.
class GetNotesUseCase {
  /// Creates a new instance of [GetNotesUseCase]
  ///
  /// Requires a [NotesRepository] implementation to function.
  const GetNotesUseCase(this._repository);

  /// The notes repository instance
  final NotesRepository _repository;

  /// Execute the use case to get all notes
  ///
  /// Returns a [Future] that completes with a list of all notes
  /// from the repository.
  Future<List<Note>> call() async {
    return await _repository.getAllNotes();
  }
}
