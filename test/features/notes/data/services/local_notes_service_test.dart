import 'package:flutter_test/flutter_test.dart';
import 'package:notewebapp/features/notes/data/services/local_notes_service.dart';
import 'package:notewebapp/features/notes/domain/entities/note.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('LocalNotesService Tests', () {
    setUp(() {
      // Set up mock SharedPreferences for testing
      SharedPreferences.setMockInitialValues({});
    });

    test('Initialize loads notes from SharedPreferences', () async {
      await LocalNotesService.initialize();
      // If no notes exist, should return empty list
      final notes = await LocalNotesService.loadNotes();
      expect(notes, isEmpty);
    });

    test('SaveNotes persists notes to SharedPreferences', () async {
      await LocalNotesService.initialize();

      final testNotes = [
        Note(
          id: 'test-1',
          title: 'Note 1',
          content: 'Content 1',
          createdAt: DateTime(2025, 10, 25),
          updatedAt: DateTime(2025, 10, 25),
        ),
        Note(
          id: 'test-2',
          title: 'Note 2',
          content: 'Content 2',
          createdAt: DateTime(2025, 10, 25),
          updatedAt: DateTime(2025, 10, 25),
          imageBase64: 'base64data',
          imageName: 'image.png',
        ),
      ];

      final saved = await LocalNotesService.saveNotes(testNotes);
      expect(saved, isTrue);

      final loadedNotes = await LocalNotesService.loadNotes();
      expect(loadedNotes, hasLength(2));
      expect(loadedNotes[0].id, equals('test-1'));
      expect(loadedNotes[1].id, equals('test-2'));
      expect(loadedNotes[1].imageBase64, equals('base64data'));
    });

    test('LoadNotes returns empty list when no notes exist', () async {
      await LocalNotesService.initialize();
      final notes = await LocalNotesService.loadNotes();
      expect(notes, isEmpty);
    });

    test('ClearNotes removes all notes from storage', () async {
      await LocalNotesService.initialize();

      final testNote = Note(
        id: 'test-1',
        title: 'Note to Clear',
        content: 'This will be cleared',
        createdAt: DateTime(2025, 10, 25),
        updatedAt: DateTime(2025, 10, 25),
      );

      await LocalNotesService.saveNotes([testNote]);
      var loadedNotes = await LocalNotesService.loadNotes();
      expect(loadedNotes, hasLength(1));

      final cleared = await LocalNotesService.clearNotes();
      expect(cleared, isTrue);

      loadedNotes = await LocalNotesService.loadNotes();
      expect(loadedNotes, isEmpty);
    });

    test('SaveNotes overwrites previous notes', () async {
      await LocalNotesService.initialize();

      final firstNotes = [
        Note(
          id: 'note-1',
          title: 'First Set',
          content: 'Content',
          createdAt: DateTime(2025, 10, 25),
          updatedAt: DateTime(2025, 10, 25),
        ),
      ];

      await LocalNotesService.saveNotes(firstNotes);
      var loadedNotes = await LocalNotesService.loadNotes();
      expect(loadedNotes, hasLength(1));

      final secondNotes = [
        Note(
          id: 'note-2',
          title: 'Second Set',
          content: 'Different Content',
          createdAt: DateTime(2025, 10, 25),
          updatedAt: DateTime(2025, 10, 25),
        ),
        Note(
          id: 'note-3',
          title: 'Third Note',
          content: 'More content',
          createdAt: DateTime(2025, 10, 25),
          updatedAt: DateTime(2025, 10, 25),
        ),
      ];

      await LocalNotesService.saveNotes(secondNotes);
      loadedNotes = await LocalNotesService.loadNotes();
      expect(loadedNotes, hasLength(2));
      expect(loadedNotes[0].id, equals('note-2'));
      expect(loadedNotes[1].id, equals('note-3'));
    });

    test('Notes with images are preserved through persistence', () async {
      await LocalNotesService.initialize();

      final largeBase64 =
          'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==' *
          50;

      final notesWithImages = [
        Note(
          id: 'img-note-1',
          title: 'Note with Image',
          content: 'Content',
          createdAt: DateTime(2025, 10, 25),
          updatedAt: DateTime(2025, 10, 25),
          imageBase64: largeBase64,
          imageName: 'photo.jpg',
          isPinned: true,
        ),
      ];

      await LocalNotesService.saveNotes(notesWithImages);
      final loadedNotes = await LocalNotesService.loadNotes();

      expect(loadedNotes, hasLength(1));
      expect(loadedNotes[0].imageBase64, equals(largeBase64));
      expect(loadedNotes[0].imageName, equals('photo.jpg'));
      expect(loadedNotes[0].isPinned, isTrue);
    });
  });
}
