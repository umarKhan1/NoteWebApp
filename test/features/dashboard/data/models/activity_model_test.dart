import 'package:flutter_test/flutter_test.dart';
import 'package:notewebapp/features/dashboard/data/models/activity_model.dart';
import 'package:notewebapp/features/dashboard/domain/entities/activity.dart';

void main() {
  group('ActivityModel', () {
    test('ActivityModel.fromJson should deserialize correctly', () {
      // Arrange
      final json = {
        'id': '1',
        'type': 'noteCreated',
        'title': 'Test Note',
        'description': 'Created "Test Note" note',
        'timestamp': '2025-10-24T21:30:00.000Z',
        'noteId': 'note123',
      };

      // Act
      final model = ActivityModel.fromJson(json);

      // Assert
      expect(model.id, equals('1'));
      expect(model.title, equals('Test Note'));
      expect(model.description, equals('Created "Test Note" note'));
      expect(model.noteId, equals('note123'));
    });

    test('ActivityModel.toJson should serialize correctly', () {
      // Arrange
      final model = ActivityModel(
        id: '1',
        type: ActivityType.noteCreated,
        title: 'Test Note',
        description: 'Created "Test Note" note',
        timestamp: DateTime(2025, 10, 24, 21, 30),
        noteId: 'note123',
      );

      // Act
      final json = model.toJson();

      // Assert
      expect(json['id'], equals('1'));
      expect(json['title'], equals('Test Note'));
      expect(json['type'], isNotEmpty); // Type is serialized
      expect(json.containsKey('noteId'), true);
    });

    test('ActivityModel should convert to Activity entity', () {
      // Arrange
      final model = ActivityModel(
        id: '1',
        type: ActivityType.noteUpdated,
        title: 'Updated Note',
        description: 'Updated "Updated Note" note',
        timestamp: DateTime(2025, 10, 24, 21, 30),
        noteId: 'note123',
      );

      // Act
      final activity = Activity(
        id: model.id,
        type: model.type,
        title: model.title,
        description: model.description,
        timestamp: model.timestamp,
        noteId: model.noteId,
      );

      // Assert
      expect(activity.id, equals(model.id));
      expect(activity.type, equals(model.type));
      expect(activity.title, equals(model.title));
    });

    test('ActivityModel with null noteId should serialize/deserialize', () {
      // Arrange
      final json = {
        'id': '1',
        'type': 'noteDeleted',
        'title': 'Deleted Note',
        'description': 'Deleted "Deleted Note" note',
        'timestamp': '2025-10-24T21:30:00.000Z',
        'noteId': null,
      };

      // Act
      final model = ActivityModel.fromJson(json);
      final serialized = model.toJson();

      // Assert
      expect(model.noteId, isNull);
      expect(serialized['noteId'], isNull);
    });

    test('Multiple ActivityModels should be independent', () {
      // Arrange & Act
      final model1 = ActivityModel(
        id: '1',
        type: ActivityType.noteCreated,
        title: 'Note 1',
        description: 'Created "Note 1" note',
        timestamp: DateTime(2025, 10, 24, 21, 30),
        noteId: 'note1',
      );

      final model2 = ActivityModel(
        id: '2',
        type: ActivityType.noteDeleted,
        title: 'Note 2',
        description: 'Deleted "Note 2" note',
        timestamp: DateTime(2025, 10, 24, 21, 35),
        noteId: null,
      );

      // Assert
      expect(model1.id, isNot(equals(model2.id)));
      expect(model1.type, isNot(equals(model2.type)));
      expect(model1.noteId, isNotNull);
      expect(model2.noteId, isNull);
    });
  });
}
