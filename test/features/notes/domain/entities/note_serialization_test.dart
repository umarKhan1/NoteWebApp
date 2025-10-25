import 'package:flutter_test/flutter_test.dart';
import 'package:notewebapp/features/notes/domain/entities/note.dart';

void main() {
  group('Note Serialization Tests', () {
    test('Note.toJson() creates correct JSON map', () {
      final note = Note(
        id: '1',
        title: 'Test Note',
        content: 'Test content',
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 2),
        category: 'Test',
        isPinned: true,
        color: 'blue',
        imageBase64: 'base64data',
        imageName: 'image.png',
      );

      final json = note.toJson();

      expect(json['id'], '1');
      expect(json['title'], 'Test Note');
      expect(json['content'], 'Test content');
      expect(json['category'], 'Test');
      expect(json['isPinned'], true);
      expect(json['color'], 'blue');
      expect(json['imageBase64'], 'base64data');
      expect(json['imageName'], 'image.png');
    });

    test('Note.fromJson() creates correct Note instance', () {
      final json = {
        'id': '1',
        'title': 'Test Note',
        'content': 'Test content',
        'createdAt': '2024-01-01T00:00:00.000Z',
        'updatedAt': '2024-01-02T00:00:00.000Z',
        'category': 'Test',
        'isPinned': true,
        'color': 'blue',
        'imageBase64': 'base64data',
        'imageName': 'image.png',
      };

      final note = Note.fromJson(json);

      expect(note.id, '1');
      expect(note.title, 'Test Note');
      expect(note.content, 'Test content');
      expect(note.category, 'Test');
      expect(note.isPinned, true);
      expect(note.color, 'blue');
      expect(note.imageBase64, 'base64data');
      expect(note.imageName, 'image.png');
    });

    test('Note serialization roundtrip preserves data', () {
      final originalNote = Note(
        id: '123',
        title: 'Original Title',
        content: 'Original Content',
        createdAt: DateTime(2024, 1, 1, 10, 30),
        updatedAt: DateTime(2024, 1, 2, 15, 45),
        category: 'Work',
        isPinned: true,
        color: 'red',
        imageBase64: 'iVBORw0KGgoAAAANSUhEUgAAAAUA',
        imageName: 'test.png',
      );

      // Serialize to JSON
      final json = originalNote.toJson();

      // Deserialize from JSON
      final deserializedNote = Note.fromJson(json);

      // Verify all fields match
      expect(deserializedNote, originalNote);
    });

    test('Note.fromJson() handles optional fields', () {
      final json = {
        'id': '1',
        'title': 'Minimal Note',
        'content': 'Content',
        'createdAt': '2024-01-01T00:00:00.000Z',
        'updatedAt': '2024-01-02T00:00:00.000Z',
        'category': null,
        'isPinned': false,
        'color': null,
        'imageBase64': null,
        'imageName': null,
      };

      final note = Note.fromJson(json);

      expect(note.id, '1');
      expect(note.category, null);
      expect(note.color, null);
      expect(note.imageBase64, null);
      expect(note.imageName, null);
      expect(note.isPinned, false);
    });

    test(
      'Note.fromJson() handles missing isPinned field (defaults to false)',
      () {
        final json = {
          'id': '1',
          'title': 'Test Note',
          'content': 'Test content',
          'createdAt': '2024-01-01T00:00:00.000Z',
          'updatedAt': '2024-01-02T00:00:00.000Z',
        };

        final note = Note.fromJson(json);

        expect(note.isPinned, false);
      },
    );
  });
}
