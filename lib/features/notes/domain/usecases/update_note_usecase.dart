import '../entities/note.dart';
import '../repositories/notes_repository.dart';

/// Parameters for updating a note
class UpdateNoteParams {
  /// The unique identifier of the note to update
  final String id;
  
  /// The updated title of the note
  final String? title;
  
  /// The updated content of the note
  final String? content;
  
  /// The updated category of the note
  final String? category;
  
  /// Whether the note is pinned
  final bool? isPinned;
  
  /// The updated color of the note
  final String? color;
  
  /// The updated Base64 encoded image data
  final String? imageBase64;
  
  /// The updated original image filename
  final String? imageName;

  /// Creates an instance of [UpdateNoteParams]
  const UpdateNoteParams({
    required this.id,
    this.title,
    this.content,
    this.category,
    this.isPinned,
    this.color,
    this.imageBase64,
    this.imageName,
  });
}

/// Use case for updating an existing note
class UpdateNoteUseCase {
  final NotesRepository _repository;

  /// Creates a new instance of [UpdateNoteUseCase]
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
      imageBase64: params.imageBase64,
      imageName: params.imageName,
    );
  }
}
