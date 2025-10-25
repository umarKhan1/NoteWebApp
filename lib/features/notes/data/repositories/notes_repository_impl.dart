import '../../domain/entities/note.dart';
import '../../domain/repositories/notes_repository.dart';
import '../services/mock_notes_service.dart';

/// Implementation of the NotesRepository interface
class NotesRepositoryImpl implements NotesRepository {
  @override
  Future<List<Note>> getAllNotes() async {
    return await MockNotesService.getAllNotes();
  }

  @override
  Future<Note?> getNoteById(String id) async {
    return await MockNotesService.getNoteById(id);
  }

  @override
  Future<Note> createNote({
    required String title,
    required String content,
    String? category,
    bool isPinned = false,
    String? color,
    String? imageBase64,
    String? imageName,
  }) async {
    return await MockNotesService.createNote(
      title: title,
      content: content,
      category: category,
      isPinned: isPinned,
      color: color,
      imageBase64: imageBase64,
      imageName: imageName,
    );
  }

  @override
  Future<Note> updateNote({
    required String id,
    String? title,
    String? content,
    String? category,
    bool? isPinned,
    String? color,
    String? imageBase64,
    String? imageName,
  }) async {
    return await MockNotesService.updateNote(
      id: id,
      title: title,
      content: content,
      category: category,
      isPinned: isPinned,
      color: color,
      imageBase64: imageBase64,
      imageName: imageName,
    );
  }

  @override
  Future<bool> deleteNote(String id) async {
    return await MockNotesService.deleteNote(id);
  }

  @override
  Future<List<Note>> searchNotes(String query) async {
    return await MockNotesService.searchNotes(query);
  }

  @override
  Future<List<Note>> getNotesByCategory(String category) async {
    return await MockNotesService.getNotesByCategory(category);
  }

  @override
  Future<Note> togglePinNote(String id) async {
    return await MockNotesService.togglePinNote(id);
  }

  @override
  Future<List<String>> getCategories() async {
    return await MockNotesService.getCategories();
  }
}
