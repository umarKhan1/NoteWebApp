import 'package:flutter_test/flutter_test.dart';
import 'package:notewebapp/features/dashboard/domain/entities/activity.dart';

void main() {
  group('Activity Entity', () {
    test('Activity should be created with all parameters', () {
      // Arrange
      final now = DateTime.now();
      const activityType = ActivityType.noteCreated;
      const title = 'Test Note';
      const description = 'Created "Test Note" note';
      const noteId = 'note123';
      const id = 'activity1';

      // Act
      final activity = Activity(
        id: id,
        type: activityType,
        title: title,
        description: description,
        timestamp: now,
        noteId: noteId,
      );

      // Assert
      expect(activity.id, equals(id));
      expect(activity.type, equals(activityType));
      expect(activity.title, equals(title));
      expect(activity.description, equals(description));
      expect(activity.timestamp, equals(now));
      expect(activity.noteId, equals(noteId));
    });

    test('Activity with null noteId should be valid', () {
      // Arrange & Act
      final activity = Activity(
        id: '1',
        type: ActivityType.noteDeleted,
        title: 'Test Note',
        description: 'Deleted "Test Note" note',
        timestamp: DateTime.now(),
        noteId: null,
      );

      // Assert
      expect(activity.noteId, isNull);
      expect(activity.title, equals('Test Note'));
    });

    test('Activity types should have correct values', () {
      // Assert
      expect(ActivityType.noteCreated, equals(ActivityType.noteCreated));
      expect(ActivityType.noteUpdated, equals(ActivityType.noteUpdated));
      expect(ActivityType.noteDeleted, equals(ActivityType.noteDeleted));
      expect(ActivityType.notePinned, equals(ActivityType.notePinned));
      expect(ActivityType.noteUnpinned, equals(ActivityType.noteUnpinned));
    });

    test('Multiple activities should be independent', () {
      // Arrange
      final now = DateTime.now();
      final activity1 = Activity(
        id: '1',
        type: ActivityType.noteCreated,
        title: 'Note 1',
        description: 'Created "Note 1" note',
        timestamp: now,
        noteId: 'note1',
      );

      final activity2 = Activity(
        id: '2',
        type: ActivityType.noteUpdated,
        title: 'Note 2',
        description: 'Updated "Note 2" note',
        timestamp: now,
        noteId: 'note2',
      );

      // Assert
      expect(activity1.id, isNot(equals(activity2.id)));
      expect(activity1.type, isNot(equals(activity2.type)));
      expect(activity1.title, isNot(equals(activity2.title)));
    });
  });
}
