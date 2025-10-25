/// Activity types enumeration
enum ActivityType {
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

/// Recent activity entity
class Activity {
  /// Creates an [Activity] instance
  const Activity({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.timestamp,
    this.noteId,
  });

  /// Unique activity identifier
  final String id;

  /// Type of activity
  final ActivityType type;

  /// Activity title (note/category name)
  final String title;

  /// User-friendly activity description
  final String description;

  /// When the activity occurred
  final DateTime timestamp;

  /// Related note ID (if applicable)
  final String? noteId;

  /// Get time ago formatted string (e.g., "2 mins ago")
  String getTimeAgo() {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inSeconds < 60) {
      return 'Just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else {
      return '${(diff.inDays / 7).floor()}w ago';
    }
  }

  /// Get icon based on activity type
  String getIcon() {
    switch (type) {
      case ActivityType.noteCreated:
        return '📝';
      case ActivityType.noteUpdated:
        return '✏️';
      case ActivityType.noteDeleted:
        return '🗑️';
      case ActivityType.notePinned:
        return '📌';
      case ActivityType.noteUnpinned:
        return '📍';
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Activity &&
        other.id == id &&
        other.type == type &&
        other.title == title &&
        other.description == description &&
        other.timestamp == timestamp &&
        other.noteId == noteId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        type.hashCode ^
        title.hashCode ^
        description.hashCode ^
        timestamp.hashCode ^
        noteId.hashCode;
  }

  @override
  String toString() {
    return 'Activity(id: $id, type: $type, title: $title, timestamp: $timestamp)';
  }

  /// Create a copy with optional fields replaced
  Activity copyWith({
    String? id,
    ActivityType? type,
    String? title,
    String? description,
    DateTime? timestamp,
    String? noteId,
  }) {
    return Activity(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      timestamp: timestamp ?? this.timestamp,
      noteId: noteId ?? this.noteId,
    );
  }
}
