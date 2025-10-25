import '../entities/note.dart';
import '../repositories/notes_repository.dart';

/// Parameters for creating a new note.
///
/// This class encapsulates all the data needed to create a new note,
/// following the parameter object pattern for clean use case interfaces.
class CreateNoteParams {
  /// Creates a new instance of [CreateNoteParams]
  const CreateNoteParams({
    required this.title,
    required this.content,
    this.category,
    this.isPinned = false,
    this.color,
    this.imageBase64,
    this.imageName,
  });

  /// The title of the note
  final String title;

  /// The content/body of the note
  final String content;

  /// Optional category for the note
  final String? category;

  /// Whether the note should be pinned (defaults to false)
  final bool isPinned;

  /// Optional color identifier for the note
  final String? color;

  /// Optional Base64 encoded image data
  final String? imageBase64;

  /// Optional original image filename
  final String? imageName;
}

/// Use case for creating a new note.
///
/// This use case handles the business logic for creating new notes
/// in the application through the repository pattern.
class CreateNoteUseCase {
  /// Creates a new instance of [CreateNoteUseCase]
  const CreateNoteUseCase(this._repository);

  /// The notes repository instance
  final NotesRepository _repository;

  /// Execute the use case to create a new note
  ///
  /// Takes [CreateNoteParams] and returns a [Future] that completes
  /// with the newly created [Note] instance.
  Future<Note> call(CreateNoteParams params) async {
    return await _repository.createNote(
      title: params.title,
      content: params.content,
      category: params.category,
      isPinned: params.isPinned,
      color: params.color,
      imageBase64: params.imageBase64,
      imageName: params.imageName,
    );
  }
}
