import 'dart:async';

import 'package:flutter/foundation.dart';

/// Event type for activity bus
enum ActivityEventType {
  /// Note was created
  noteCreated,
  /// Note was updated
  noteUpdated,
  /// Note was deleted
  noteDeleted,
  /// Note was pinned
  notePinned,
  /// Note was unpinned
  noteUnpinned,
}

/// Activity event to be emitted through the activity bus
class ActivityEvent {
  /// Creates an [ActivityEvent]
  const ActivityEvent({
    required this.type,
    required this.noteId,
    required this.timestamp,
  });

  /// Type of activity event
  final ActivityEventType type;

  /// ID of the note involved in the activity
  final String noteId;

  /// Timestamp of the activity
  final DateTime timestamp;

  @override
  String toString() =>
      'ActivityEvent(type: ${type.name}, noteId: $noteId, timestamp: $timestamp)';
}

/// Global activity bus using a singleton pattern
class ActivityBus {
  /// Private constructor
  ActivityBus._();

  /// Singleton instance
  static final ActivityBus _instance = ActivityBus._();

  /// Get the singleton instance
  static ActivityBus get instance => _instance;

  /// Stream controller for broadcasting activity events
  late final _controller = StreamController<ActivityEvent>.broadcast();

  /// Get the stream of activity events
  Stream<ActivityEvent> get stream => _controller.stream;

  /// Emit an activity event
  void emit(ActivityEvent event) {
    if (kDebugMode) {
      print('[ActivityBus] 📡 Emitting ${event.type.name} event');
    }
    _controller.add(event);
    if (kDebugMode) {
      print('[ActivityBus] 📤 Event added to stream');
    }
  }

  /// Dispose resources
  void dispose() {
    _controller.close();
  }
}
