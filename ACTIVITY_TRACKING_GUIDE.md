# Activity Tracking Implementation Guide

## Architecture Overview

```
Domain Layer
├── entities/activity.dart (Activity, ActivityType)
├── repositories/activity_repository.dart (interface)
├── services/activity_service.dart (convenience service)
└── usecases/ (log & get activities)

Data Layer
├── datasources/activity_local_datasource.dart (SharedPreferences)
├── models/activity_model.dart (JSON serialization)
└── repositories/activity_repository_impl.dart (implementation)

Presentation Layer
├── cubit/dashboard_cubit.dart (loads activities)
└── widgets/recent_activity_card.dart (displays activities)
```

## How to Integrate with Notes Feature

### Step 1: Inject ActivityService into NotesCubit

```dart
// In your dependency injection setup or cubit provider
class NotesCubit extends Cubit<NotesState> {
  final NoteRepository _noteRepository;
  final ActivityService _activityService;
  final AuthRepository _authRepository;
  
  NotesCubit(
    this._noteRepository,
    this._activityService,
    this._authRepository,
  );
}
```

### Step 2: Log Activities After Note Operations

#### Create Note
```dart
Future<void> createNote({
  required String title,
  required String content,
  String? category,
  bool isPinned = false,
}) async {
  try {
    final note = await _noteRepository.createNote(
      title: title,
      content: content,
      category: category,
      isPinned: isPinned,
    );
    
    // Log activity
    final userId = await _authRepository.getCurrentUserId();
    if (userId != null) {
      await _activityService.logNoteCreated(userId, title, note.id);
    }
    
    await loadNotes();
  } catch (e) {
    handleError(e, 'Failed to create note');
  }
}
```

#### Update Note
```dart
Future<void> updateNote({
  required String id,
  String? title,
  // ... other params
}) async {
  try {
    final currentNote = /* get current note */;
    await _noteRepository.updateNote(
      id: id,
      title: title,
      // ... other params
    );
    
    // Log activity
    final userId = await _authRepository.getCurrentUserId();
    if (userId != null) {
      await _activityService.logNoteUpdated(
        userId,
        title ?? currentNote.title,
        id,
      );
    }
    
    await loadNotes();
  } catch (e) {
    handleError(e, 'Failed to update note');
  }
}
```

#### Delete Note
```dart
Future<void> deleteNote(String id) async {
  try {
    final currentNote = /* get current note */;
    await _noteRepository.deleteNote(id);
    
    // Log activity
    final userId = await _authRepository.getCurrentUserId();
    if (userId != null) {
      await _activityService.logNoteDeleted(userId, currentNote.title);
    }
    
    await loadNotes();
  } catch (e) {
    handleError(e, 'Failed to delete note');
  }
}
```

#### Pin/Unpin Note
```dart
Future<void> togglePinNote(String id) async {
  try {
    final currentNote = /* get current note */;
    final newPinnedStatus = !currentNote.isPinned;
    
    await _noteRepository.togglePin(id, newPinnedStatus);
    
    // Log activity
    final userId = await _authRepository.getCurrentUserId();
    if (userId != null) {
      if (newPinnedStatus) {
        await _activityService.logNotePinned(userId, currentNote.title, id);
      } else {
        await _activityService.logNoteUnpinned(userId, currentNote.title, id);
      }
    }
    
    await loadNotes();
  } catch (e) {
    handleError(e, 'Failed to toggle pin');
  }
}
```

## Data Storage

### SharedPreferences Structure

Activities are stored per user with key: `activities_<userId>`

```json
{
  "activities_user_123": [
    {
      "id": "1728399000000",
      "type": "ActivityType.noteCreated",
      "title": "Project Ideas",
      "description": "Created \"Project Ideas\" note",
      "timestamp": "2025-10-24T10:30:00.000Z",
      "noteId": "note_456"
    }
  ]
}
```

### Storage Limits

- **Max activities per user**: 100
- **Auto-cleanup**: Oldest activities are removed when limit is reached
- **File size**: Optimized to stay under 1MB per user

## Usage in Dashboard

```dart
@override
Widget build(BuildContext context) {
  return BlocBuilder<DashboardCubit, DashboardState>(
    builder: (context, state) {
      if (state is DashboardLoaded) {
        return RecentActivityCard(
          activities: state.recentActivity,
        );
      }
      return const SizedBox.shrink();
    },
  );
}
```

## Logout Handling

Activities are automatically user-scoped, so no manual cleanup is needed:

```dart
// When user logs out
Future<void> logout() async {
  await _authRepository.logout();
  // Activities remain in SharedPrefs under 'activities_<old_userId>'
  // New user's activities will be stored under 'activities_<new_userId>'
}
```

## Testing Activities

To test activity logging:

1. Create a note → Check "Created note" activity
2. Edit a note → Check "Updated note" activity
3. Pin a note → Check "Pinned note" activity
4. Delete a note → Check "Deleted note" activity
5. Logout → Activities persist (user-scoped)
6. Login as different user → Different activities shown

## Activity Types and Icons

| Type | Icon | Description |
|------|------|-------------|
| noteCreated | 📝 | Note was created |
| noteUpdated | ✏️ | Note was modified |
| noteDeleted | 🗑️ | Note was removed |
| notePinned | 📌 | Note was pinned |
| noteUnpinned | 📍 | Note was unpinned |

## Time Ago Formatting

- Less than 1 minute: "Just now"
- Less than 1 hour: "2m ago"
- Less than 24 hours: "3h ago"
- Less than 7 days: "2d ago"
- More than 7 days: "3w ago"

## Future Enhancements

1. Add activity filtering by type
2. Add activity search functionality
3. Add "View All Activities" page
4. Add activity analytics/statistics
5. Add export activities as CSV/JSON
6. Implement cloud sync with API backend
7. Add activity categories for different features
