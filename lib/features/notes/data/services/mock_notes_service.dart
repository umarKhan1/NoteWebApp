import '../../domain/entities/note.dart';

/// Mock data service for notes (temporary until API integration)
class MockNotesService {
  static final List<Note> _mockNotes = [
    Note(
      id: '1',
      title: 'Welcome to COCUS Notes',
      content: 'This is your first note! You can create, edit, and organize your notes here. Start by adding your own content.',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      category: 'Welcome',
      isPinned: true,
      color: 'blue',
    ),
    Note(
      id: '2',
      title: 'Meeting Notes - Project Kickoff',
      content: '''
# Project Kickoff Meeting

## Attendees
- John Doe (PM)
- Jane Smith (Developer)
- Mike Johnson (Designer)

## Key Points
- Project timeline: 6 weeks
- Tech stack: Flutter + Node.js
- Weekly standup meetings on Mondays

## Action Items
- [ ] Set up development environment
- [ ] Create project wireframes
- [ ] Define API endpoints
      ''',
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
      category: 'Work',
      isPinned: false,
      color: 'green',
    ),
    Note(
      id: '3',
      title: 'Shopping List',
      content: '''
Weekly groceries:
- Milk
- Bread
- Eggs
- Apples
- Chicken breast
- Rice
- Vegetables (broccoli, carrots)
- Yogurt
      ''',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 12)),
      category: 'Personal',
      isPinned: false,
      color: 'orange',
    ),
    Note(
      id: '4',
      title: 'Book Ideas',
      content: '''
Ideas for the novel I want to write:

## Main Character
- Sarah, 28, software engineer
- Lives in San Francisco
- Discovers she can see glimpses of the future

## Plot Points
- Strange dreams that come true
- Government conspiracy
- Race against time to prevent disaster
- Love interest who may be working against her

## Themes
- Technology vs. humanity
- Free will vs. destiny
- Trust and betrayal
      ''',
      createdAt: DateTime.now().subtract(const Duration(hours: 18)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 3)),
      category: 'Creative',
      isPinned: false,
      color: 'purple',
    ),
    Note(
      id: '5',
      title: 'Workout Plan',
      content: '''
# Weekly Workout Schedule

## Monday - Chest & Triceps
- Bench Press: 3x8-10
- Incline Dumbbell Press: 3x10-12
- Tricep Dips: 3x12-15
- Push-ups: 2x max

## Wednesday - Back & Biceps
- Pull-ups: 3x8-10
- Rows: 3x10-12
- Bicep Curls: 3x12-15
- Lat Pulldowns: 3x10-12

## Friday - Legs & Shoulders
- Squats: 3x8-10
- Lunges: 3x12 each leg
- Shoulder Press: 3x10-12
- Planks: 3x60 seconds
      ''',
      createdAt: DateTime.now().subtract(const Duration(hours: 24)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 8)),
      category: 'Health',
      isPinned: false,
      color: 'red',
    ),
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
      throw Exception('Note not found');
    }
    
    final updatedNote = _mockNotes[index].copyWith(
      isPinned: !_mockNotes[index].isPinned,
      updatedAt: DateTime.now(),
    );
    
    _mockNotes[index] = updatedNote;
    return updatedNote;
  }
}
