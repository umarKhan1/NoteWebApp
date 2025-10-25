import 'package:flutter_test/flutter_test.dart';
import 'package:notewebapp/features/notes/domain/entities/note.dart';

void main() {
  group('Note Entity', () {
    test('Note creation with all fields', () {
      final note = Note(
        id: 'note1',
        title: 'Test Note',
        content: 'Test content',
        category: 'Work',
        isPinned: true,
        color: '#FF5733',
        createdAt: DateTime(2025, 10, 24),
        updatedAt: DateTime(2025, 10, 24),
      );

      expect(note.id, 'note1');
      expect(note.title, 'Test Note');
      expect(note.content, 'Test content');
      expect(note.category, 'Work');
      expect(note.isPinned, true);
      expect(note.color, '#FF5733');
    });

    test('Note with default pin status', () {
      final note = Note(
        id: 'note2',
        title: 'Default Note',
        content: 'Content',
        category: 'Personal',
        isPinned: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(note.isPinned, false);
    });

    test('Note title and content are preserved', () {
      const title = 'Important Meeting Notes';
      const content = 'Discussed project timeline and deliverables';
      
      final note = Note(
        id: 'note3',
        title: title,
        content: content,
        category: 'Work',
        isPinned: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(note.title, title);
      expect(note.content, content);
    });

    test('Multiple notes can be created independently', () {
      final note1 = Note(
        id: 'note1',
        title: 'Note 1',
        content: 'Content 1',
        category: 'Work',
        isPinned: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final note2 = Note(
        id: 'note2',
        title: 'Note 2',
        content: 'Content 2',
        category: 'Personal',
        isPinned: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(note1.id, 'note1');
      expect(note2.id, 'note2');
      expect(note1.title != note2.title, true);
    });

    test('Note category can be changed', () {
      final note = Note(
        id: 'note4',
        title: 'Flexible Note',
        content: 'Can change category',
        category: 'Work',
        isPinned: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(note.category, 'Work');
      
      // Create new note with updated category
      final updatedNote = Note(
        id: note.id,
        title: note.title,
        content: note.content,
        category: 'Personal',
        isPinned: note.isPinned,
        createdAt: note.createdAt,
        updatedAt: DateTime.now(),
      );

      expect(updatedNote.category, 'Personal');
    });

    test('Note timestamps are tracked', () {
      final created = DateTime(2025, 10, 24, 10, 0, 0);
      final updated = DateTime(2025, 10, 24, 11, 30, 0);
      
      final note = Note(
        id: 'note5',
        title: 'Timestamped Note',
        content: 'Has timestamps',
        category: 'Work',
        isPinned: false,
        createdAt: created,
        updatedAt: updated,
      );

      expect(note.createdAt.hour, 10);
      expect(note.updatedAt.hour, 11);
      expect(note.updatedAt.isAfter(note.createdAt), true);
    });
  });
}
