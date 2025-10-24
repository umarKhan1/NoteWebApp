import 'dart:convert';

import '../../domain/entities/activity.dart';

/// Activity model for JSON serialization
class ActivityModel extends Activity {
  /// Creates an [ActivityModel] instance
  const ActivityModel({
    required String id,
    required ActivityType type,
    required String title,
    required String description,
    required DateTime timestamp,
    String? noteId,
  }) : super(
    id: id,
    type: type,
    title: title,
    description: description,
    timestamp: timestamp,
    noteId: noteId,
  );

  /// Create from Activity entity
  factory ActivityModel.fromEntity(Activity activity) {
    return ActivityModel(
      id: activity.id,
      type: activity.type,
      title: activity.title,
      description: activity.description,
      timestamp: activity.timestamp,
      noteId: activity.noteId,
    );
  }

  /// Create from JSON
  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      id: json['id'] as String,
      type: ActivityType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => ActivityType.noteCreated,
      ),
      title: json['title'] as String,
      description: json['description'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      noteId: json['noteId'] as String?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString(),
      'title': title,
      'description': description,
      'timestamp': timestamp.toIso8601String(),
      'noteId': noteId,
    };
  }

  /// Convert to JSON string
  String toJsonString() => jsonEncode(toJson());

  /// Create from JSON string
  factory ActivityModel.fromJsonString(String jsonString) {
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    return ActivityModel.fromJson(json);
  }
}
