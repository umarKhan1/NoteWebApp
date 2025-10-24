# Activity Tracking - Quick Testing Guide

## Demo Credentials
- **Email**: `demo@example.com`
- **Password**: `password123`

## Step-by-Step Testing

### 1. Login & Initial Setup
```
1. Open the app
2. Go to Login page
3. Enter email: demo@example.com
4. Enter password: password123
5. Click Login
   → User ID is stored: demo_example_com
```

### 2. Create Note Activity
```
1. Navigate to Notes section
2. Click "Create Note" or "+"
3. Enter title: "My Test Note"
4. Enter content: "This is a test note for activity tracking"
5. Click Create
   → Activity logged: 📝 Created "My Test Note" note
   → Appears in Dashboard > Recent Activity
```

### 3. Update Note Activity
```
1. Open the note you created
2. Edit the title to: "Updated Test Note"
3. Make some changes to content
4. Click Save/Update
   → Activity logged: ✏️ Updated "Updated Test Note" note
   → Dashboard updates with new activity
```

### 4. Pin Note Activity
```
1. In notes list, find your note
2. Click pin icon
   → Activity logged: 📌 Pinned "Updated Test Note" note
   → Activity appears in dashboard
3. Click pin again to unpin
   → Activity logged: 📍 Unpinned "Updated Test Note" note
```

### 5. Delete Note Activity
```
1. Open a note (create a new one if needed)
2. Click delete button
3. Confirm deletion
   → Activity logged: 🗑️ Deleted "Note Title" note
   → Activity shows in dashboard
```

### 6. Persistence Test (Logout/Login)
```
1. Note current number of activities in dashboard
2. Click Logout
3. Login again with same credentials
   → All previous activities should still be visible
   → Confirms user-scoped persistence
```

### 7. Performance Test
```
1. Create 20-30 notes quickly
2. Check Dashboard > Recent Activity
   → Should show last 5 activities efficiently
3. Create 100+ activities (automated if possible)
   → Auto-cleanup should keep max 100 per user
```

### 8. Multi-User Test (Optional)
```
1. Create activities with demo_example_com user
2. Logout
3. Create a different user account (different email)
4. Login and verify:
   → Only that user's activities are shown
   → demo_example_com's activities are NOT visible
   → Each user has isolated activity history
```

## Expected Activity Icons & Messages

| Type | Icon | Message Pattern |
|------|------|-----------------|
| Note Created | 📝 | Created "title" note |
| Note Updated | ✏️ | Updated "title" note |
| Note Deleted | 🗑️ | Deleted "title" note |
| Note Pinned | 📌 | Pinned "title" note |
| Note Unpinned | 📍 | Unpinned "title" note |

## Time Display Format
- Less than 1 minute: "Just now"
- 1-59 minutes: "Xm ago" (e.g., "5m ago")
- 1-23 hours: "Xh ago" (e.g., "3h ago")
- 1-30 days: "Xd ago" (e.g., "2d ago")
- Older: Full date (e.g., "Oct 20")

## Verification Locations

### Dashboard View
- **Path**: Home > Dashboard
- **Widget**: RecentActivityCard
- **Shows**: Last 5 activities with full details
- **Updates**: Automatically after each note operation

### Activity Storage
- **Location**: SharedPreferences
- **Key Format**: `activities_<userId>`
- **Storage**: JSON array of Activity objects
- **Persistence**: Survives app restart

### Developer Console (Debug)
Add this to any cubit to verify:
```dart
final userId = await UserUtils.getCurrentUserId();
print('Current User: $userId');

final activities = await GetRecentActivitiesUseCase(repo).call(userId);
print('Activities: $activities');
```

## Troubleshooting

### Activities not showing?
1. ✅ Confirm you're logged in (check email in sidebar)
2. ✅ Verify note operations complete successfully
3. ✅ Check that recent activity card is visible on dashboard
4. ✅ Restart app to clear cache

### Wrong user's activities showing?
1. ✅ Logout and login with correct credentials
2. ✅ Check UserUtils.getCurrentUserId() returns correct ID
3. ✅ Clear app data and login again

### Activities disappearing?
1. ✅ Check if auto-cleanup triggered (100+ activities)
2. ✅ Verify SharedPreferences isn't cleared
3. ✅ Check app permissions for data storage

### Performance issues?
1. ✅ Reduce max activities limit in ActivityLocalDatasource
2. ✅ Use pagination for large activity lists
3. ✅ Consider migrating to SQLite for persistence

## Code Locations for Testing

**Recent Activity Display**:
- File: `lib/features/dashboard/presentation/widgets/recent_activity_card.dart`
- Widget: `RecentActivityCard`
- State: `List<Activity>`

**Activity Logging**:
- File: `lib/features/notes/presentation/cubit/notes_cubit.dart`
- Methods: `_logNoteCreatedActivity()`, `_logNoteUpdatedActivity()`, etc.

**Activity Storage**:
- File: `lib/features/dashboard/data/datasources/activity_local_datasource.dart`
- Key: `activities_<userId>`

**User Management**:
- File: `lib/core/utils/user_utils.dart`
- Methods: `getCurrentUserId()`, `setCurrentUserId()`

## Success Criteria

✅ Activities appear immediately after operations
✅ Activities persist after logout/login
✅ Each user sees only their activities
✅ Dashboard shows up to 5 recent activities
✅ Time formatting works correctly
✅ Icons display for each activity type
✅ Auto-cleanup works (100+ limit)
✅ No performance degradation
✅ App doesn't crash if tracking fails
✅ Silent errors logged for debugging

---

**Happy Testing! 🚀**
