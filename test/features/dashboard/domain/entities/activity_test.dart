import 'package:flutter_test/flutter_test.dart';
import 'package:notewebapp/features/dashboard/domain/entities/activity.dart';

void main() {
  group('ActivityType Enum', () {
    test('All activity types should be defined', () {
      // Assert that all enum values exist
      expect(ActivityType.noteCreated, isNotNull);
      expect(ActivityType.noteUpdated, isNotNull);
      expect(ActivityType.noteDeleted, isNotNull);
      expect(ActivityType.notePinned, isNotNull);
      expect(ActivityType.noteUnpinned, isNotNull);
    });

    test('Activity types should be distinct', () {
      // Arrange
      final types = [
        ActivityType.noteCreated,
        ActivityType.noteUpdated,
        ActivityType.noteDeleted,
        ActivityType.notePinned,
        ActivityType.noteUnpinned,
      ];

      // Assert - all types should be unique
      expect(types.toSet().length, equals(types.length));
    });

    test('Activity type values should be identifiable', () {
      // Assert - each type should have a string representation
      expect(ActivityType.noteCreated.toString(), contains('noteCreated'));
      expect(ActivityType.noteUpdated.toString(), contains('noteUpdated'));
      expect(ActivityType.noteDeleted.toString(), contains('noteDeleted'));
      expect(ActivityType.notePinned.toString(), contains('notePinned'));
      expect(ActivityType.noteUnpinned.toString(), contains('noteUnpinned'));
    });
  });

  group('Activity Instance Tests', () {
    test('Activity should be immutable (final fields)', () {
      // Arrange
      final activity = Activity(
        id: '1',
        type: ActivityType.noteCreated,
        title: 'Test',
        description: 'Test description',
        timestamp: DateTime.now(),
        noteId: 'note1',
      );

      // Assert - we can't modify fields (they should be final)
      expect(activity.id, equals('1'));
      expect(activity.title, equals('Test'));
      // If we try to modify, it should fail at compile time
    });

    test('Activity with same data should equal each other', () {
      // Arrange
      final now = DateTime(2025, 10, 24, 21, 30);
      final activity1 = Activity(
        id: '1',
        type: ActivityType.noteCreated,
        title: 'Test',
        description: 'Test description',
        timestamp: now,
        noteId: 'note1',
      );

      final activity2 = Activity(
        id: '1',
        type: ActivityType.noteCreated,
        title: 'Test',
        description: 'Test description',
        timestamp: now,
        noteId: 'note1',
      );

      // Assert
      expect(activity1.id, equals(activity2.id));
      expect(activity1.type, equals(activity2.type));
      expect(activity1.title, equals(activity2.title));
    });

    test('Activity with different data should not equal', () {
      // Arrange
      final now = DateTime(2025, 10, 24, 21, 30);
      final activity1 = Activity(
        id: '1',
        type: ActivityType.noteCreated,
        title: 'Test 1',
        description: 'Test description',
        timestamp: now,
        noteId: 'note1',
      );

      final activity2 = Activity(
        id: '2',
        type: ActivityType.noteUpdated,
        title: 'Test 2',
        description: 'Test description',
        timestamp: now,
        noteId: 'note2',
      );

      // Assert
      expect(activity1.id, isNot(equals(activity2.id)));
      expect(activity1.type, isNot(equals(activity2.type)));
      expect(activity1.title, isNot(equals(activity2.title)));
    });

    test('Activity can be created without noteId', () {
      // Arrange & Act
      final activity = Activity(
        id: '1',
        type: ActivityType.noteDeleted,
        title: 'Deleted Note',
        description: 'Deleted "Deleted Note" note',
        timestamp: DateTime.now(),
      );

      // Assert
      expect(activity.noteId, isNull);
      expect(activity.title, equals('Deleted Note'));
      expect(activity.type, equals(ActivityType.noteDeleted));
    });

    test('Activity timestamp should be stored correctly', () {
      // Arrange
      final timestamp = DateTime(2025, 10, 24, 21, 30, 45);
      final activity = Activity(
        id: '1',
        type: ActivityType.noteCreated,
        title: 'Test',
        description: 'Test',
        timestamp: timestamp,
      );

      // Assert
      expect(activity.timestamp.year, equals(2025));
      expect(activity.timestamp.month, equals(10));
      expect(activity.timestamp.day, equals(24));
      expect(activity.timestamp.hour, equals(21));
      expect(activity.timestamp.minute, equals(30));
      expect(activity.timestamp.second, equals(45));
    });
  });
}
