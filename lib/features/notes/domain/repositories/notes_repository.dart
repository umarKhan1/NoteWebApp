import '../entities/note.dart';

/// Abstract repository interface for notes operations
abstract class NotesRepository {
  /// Get all notes
  Future<List<Note>> getAllNotes();

  /// Get a specific note by ID
  Future<Note?> getNoteById(String id);

  /// Create a new note
  Future<Note> createNote({
    required String title,
    required String content,
    String? category,
    bool isPinned = false,
    String? color,
    String? imageBase64,
    String? imageName,
  });

  /// Update an existing note
  Future<Note> updateNote({
    required String id,
    String? title,
    String? content,
    String? category,
    bool? isPinned,
    String? color,
    String? imageBase64,
    String? imageName,
  });

  /// Delete a note
  Future<bool> deleteNote(String id);

  /// Search notes by query
  Future<List<Note>> searchNotes(String query);

  /// Get notes by category
  Future<List<Note>> getNotesByCategory(String category);

  /// Toggle pin status of a note
  Future<Note> togglePinNote(String id);

  /// Get all available categories
  Future<List<String>> getCategories();
}
