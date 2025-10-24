import '../../domain/entities/note.dart';

/// Mock data service for notes (temporary until API integration)
class MockNotesService {
  static final List<Note> _mockNotes = <Note>[
    // Empty list to show empty state initially
  ];

  /// Get all notes
  static Future<List<Note>> getAllNotes() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_mockNotes);
  }

  /// Get a note by ID
  static Future<Note?> getNoteById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _mockNotes.firstWhere((note) => note.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Create a new note
  static Future<Note> createNote({
    required String title,
    required String content,
    String? category,
    bool isPinned = false,
    String? color,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    final newNote = Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      content: content,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      category: category,
      isPinned: isPinned,
      color: color,
    );
    
    _mockNotes.insert(0, newNote);
    return newNote;
  }

  /// Update an existing note
  static Future<Note> updateNote({
    required String id,
    String? title,
    String? content,
    String? category,
    bool? isPinned,
    String? color,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    
    final index = _mockNotes.indexWhere((note) => note.id == id);
    if (index == -1) {
      throw Exception('Note not found');
    }
    
    final updatedNote = _mockNotes[index].copyWith(
      title: title,
      content: content,
      category: category,
      isPinned: isPinned,
      color: color,
      updatedAt: DateTime.now(),
    );
    
    _mockNotes[index] = updatedNote;
    return updatedNote;
  }

  /// Delete a note
  static Future<bool> deleteNote(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    
    final index = _mockNotes.indexWhere((note) => note.id == id);
    if (index == -1) {
      return false;
    }
    
    _mockNotes.removeAt(index);
    return true;
  }

  /// Search notes by title or content
  static Future<List<Note>> searchNotes(String query) async {
    await Future.delayed(const Duration(milliseconds: 600));
    
    if (query.isEmpty) {
      return getAllNotes();
    }
    
    final lowercaseQuery = query.toLowerCase();
    return _mockNotes.where((note) {
      return note.title.toLowerCase().contains(lowercaseQuery) ||
          note.content.toLowerCase().contains(lowercaseQuery) ||
          (note.category?.toLowerCase().contains(lowercaseQuery) ?? false);
    }).toList();
  }

  /// Get notes by category
  static Future<List<Note>> getNotesByCategory(String category) async {
    await Future.delayed(const Duration(milliseconds: 400));
    
    return _mockNotes.where((note) => note.category == category).toList();
  }

  /// Get all unique categories
  static Future<List<String>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    final categories = _mockNotes
        .where((note) => note.category != null)
        .map((note) => note.category!)
        .toSet()
        .toList();
    
    categories.sort();
    return categories;
  }

  /// Toggle pin status of a note
  static Future<Note> togglePinNote(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    
    final index = _mockNotes.indexWhere((note) => note.id == id);
    if (index == -1) {
      throw Exception('Note not found with id: $id');
    }
    
    final updatedNote = _mockNotes[index].copyWith(
      isPinned: !_mockNotes[index].isPinned,
      updatedAt: DateTime.now(),
    );
    
    _mockNotes[index] = updatedNote;
    return updatedNote;
  }
}
