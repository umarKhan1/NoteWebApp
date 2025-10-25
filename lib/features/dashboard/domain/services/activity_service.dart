import '../entities/activity.dart';
import '../repositories/activity_repository.dart';

/// Service for logging activities throughout the app
///
/// This is a convenience layer that makes it easy to log activities
/// from any part of the app without directly depending on the repository
class ActivityService {
  /// Creates an [ActivityService]
  const ActivityService(this._repository);

  /// Activity repository instance
  final ActivityRepository _repository;

  /// Log a note creation activity
  Future<void> logNoteCreated(
    String userId,
    String noteTitle,
    String noteId,
  ) async {
    await _repository.logActivity(
      userId,
      Activity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: ActivityType.noteCreated,
        title: noteTitle,
        description: 'Created "$noteTitle" note',
        timestamp: DateTime.now(),
        noteId: noteId,
      ),
    );
  }

  /// Log a note update activity
  Future<void> logNoteUpdated(
    String userId,
    String noteTitle,
    String noteId,
  ) async {
    await _repository.logActivity(
      userId,
      Activity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: ActivityType.noteUpdated,
        title: noteTitle,
        description: 'Updated "$noteTitle" note',
        timestamp: DateTime.now(),
        noteId: noteId,
      ),
    );
  }

  /// Log a note deletion activity
  Future<void> logNoteDeleted(String userId, String noteTitle) async {
    await _repository.logActivity(
      userId,
      Activity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: ActivityType.noteDeleted,
        title: noteTitle,
        description: 'Deleted "$noteTitle" note',
        timestamp: DateTime.now(),
      ),
    );
  }

  /// Log a note pin activity
  Future<void> logNotePinned(
    String userId,
    String noteTitle,
    String noteId,
  ) async {
    await _repository.logActivity(
      userId,
      Activity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: ActivityType.notePinned,
        title: noteTitle,
        description: 'Pinned "$noteTitle" note',
        timestamp: DateTime.now(),
        noteId: noteId,
      ),
    );
  }

  /// Log a note unpin activity
  Future<void> logNoteUnpinned(
    String userId,
    String noteTitle,
    String noteId,
  ) async {
    await _repository.logActivity(
      userId,
      Activity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: ActivityType.noteUnpinned,
        title: noteTitle,
        description: 'Unpinned "$noteTitle" note',
        timestamp: DateTime.now(),
        noteId: noteId,
      ),
    );
  }

  /// Log a custom activity
  Future<void> logCustomActivity(String userId, Activity activity) async {
    await _repository.logActivity(userId, activity);
  }
}
