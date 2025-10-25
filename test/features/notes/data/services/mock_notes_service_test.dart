import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:notewebapp/features/notes/data/services/mock_notes_service.dart';
import 'package:notewebapp/features/notes/data/services/local_notes_service.dart';

void main() {
  group('MockNotesService Persistence Tests', () {
    setUp(() {
      // Set up mock SharedPreferences for testing
      SharedPreferences.setMockInitialValues({});
    });

    test('CreateNote persists note to storage', () async {
      await LocalNotesService.initialize();
      await MockNotesService.initialize();

      final createdNote = await MockNotesService.createNote(
        title: 'Test Note',
        content: 'Test content',
        category: 'Work',
      );

      expect(createdNote.id, isNotEmpty);
      expect(createdNote.title, equals('Test Note'));

      // Verify it was persisted by loading from storage
      final allNotes = await MockNotesService.getAllNotes();
      expect(allNotes, hasLength(1));
      expect(allNotes[0].id, equals(createdNote.id));
    });

    test('UpdateNote persists changes to storage', () async {
      await LocalNotesService.initialize();
      await MockNotesService.initialize();

      final created = await MockNotesService.createNote(
        title: 'Original Title',
        content: 'Original content',
      );

      final updated = await MockNotesService.updateNote(
        id: created.id,
        title: 'Updated Title',
        content: 'Updated content',
      );

      expect(updated.title, equals('Updated Title'));

      // Verify update was persisted
      final note = await MockNotesService.getNoteById(created.id);
      expect(note?.title, equals('Updated Title'));
      expect(note?.content, equals('Updated content'));
    });

    test('DeleteNote removes note from storage', () async {
      await LocalNotesService.initialize();
      await MockNotesService.initialize();

      final created = await MockNotesService.createNote(
        title: 'Note to Delete',
        content: 'This will be deleted',
      );

      var allNotes = await MockNotesService.getAllNotes();
      expect(allNotes, hasLength(1));

      final deleted = await MockNotesService.deleteNote(created.id);
      expect(deleted, isTrue);

      allNotes = await MockNotesService.getAllNotes();
      expect(allNotes, isEmpty);
    });

    test('TogglePinNote persists pin status', () async {
      await LocalNotesService.initialize();
      await MockNotesService.initialize();

      final created = await MockNotesService.createNote(
        title: 'Note to Pin',
        content: 'Content',
        isPinned: false,
      );

      expect(created.isPinned, isFalse);

      final pinned = await MockNotesService.togglePinNote(created.id);
      expect(pinned.isPinned, isTrue);

      // Verify persistence
      final note = await MockNotesService.getNoteById(created.id);
      expect(note?.isPinned, isTrue);

      final unpinned = await MockNotesService.togglePinNote(created.id);
      expect(unpinned.isPinned, isFalse);
    });

    test('CreateNote with image persists image data', () async {
      await LocalNotesService.initialize();
      await MockNotesService.initialize();

      const imageBase64 = 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==';

      final created = await MockNotesService.createNote(
        title: 'Note with Image',
        content: 'Content',
        imageBase64: imageBase64,
        imageName: 'photo.png',
      );

      expect(created.imageBase64, equals(imageBase64));
      expect(created.imageName, equals('photo.png'));

      // Verify image was persisted
      final note = await MockNotesService.getNoteById(created.id);
      expect(note?.imageBase64, equals(imageBase64));
      expect(note?.imageName, equals('photo.png'));
    });

    test('Multiple operations maintain correct state', () async {
      await LocalNotesService.initialize();
      await MockNotesService.initialize();

      // Create 3 notes
      final note1 = await MockNotesService.createNote(
        title: 'Note 1',
        content: 'Content 1',
      );

      final note2 = await MockNotesService.createNote(
        title: 'Note 2',
        content: 'Content 2',
      );

      final note3 = await MockNotesService.createNote(
        title: 'Note 3',
        content: 'Content 3',
      );

      var allNotes = await MockNotesService.getAllNotes();
      expect(allNotes, hasLength(3));

      // Pin note 1
      await MockNotesService.togglePinNote(note1.id);

      // Update note 2
      await MockNotesService.updateNote(
        id: note2.id,
        title: 'Note 2 Updated',
        category: 'Work',
      );

      // Delete note 3
      await MockNotesService.deleteNote(note3.id);

      allNotes = await MockNotesService.getAllNotes();
      expect(allNotes, hasLength(2));

      final updated1 = await MockNotesService.getNoteById(note1.id);
      expect(updated1?.isPinned, isTrue);

      final updated2 = await MockNotesService.getNoteById(note2.id);
      expect(updated2?.title, equals('Note 2 Updated'));
      expect(updated2?.category, equals('Work'));

      final deleted3 = await MockNotesService.getNoteById(note3.id);
      expect(deleted3, isNull);
    });

    test('SearchNotes works with persisted notes', () async {
      await LocalNotesService.initialize();
      await MockNotesService.initialize();

      await MockNotesService.createNote(
        title: 'Flutter Tutorial',
        content: 'Learn Flutter basics',
      );

      await MockNotesService.createNote(
        title: 'Dart Guide',
        content: 'Understanding Dart language',
      );

      final results = await MockNotesService.searchNotes('Flutter');
      expect(results, hasLength(1));
      expect(results[0].title, equals('Flutter Tutorial'));
    });

    test('GetCategories returns correct categories from persisted notes',
        () async {
      await LocalNotesService.initialize();
      await MockNotesService.initialize();

      await MockNotesService.createNote(
        title: 'Work Meeting',
        content: 'Meeting notes',
        category: 'Work',
      );

      await MockNotesService.createNote(
        title: 'Personal Todo',
        content: 'Todo list',
        category: 'Personal',
      );

      await MockNotesService.createNote(
        title: 'Another Work Note',
        content: 'More work',
        category: 'Work',
      );

      final categories = await MockNotesService.getCategories();
      expect(categories, hasLength(2));
      expect(categories, containsAll(['Work', 'Personal']));
    });
  });
}
