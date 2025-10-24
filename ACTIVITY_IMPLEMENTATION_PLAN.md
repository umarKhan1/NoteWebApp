## 🔐 **SharedPreferences + Logout Data Management - Complete Analysis**

### **How SharedPreferences Works:**

```
SharedPreferences Storage Location:
├── Android: /data/data/com.example.app/shared_prefs/ (app-specific directory)
├── iOS: ~/Library/Preferences/com.example.app.plist
└── Web: localStorage in browser
```

**Key Point**: SharedPreferences is **device-level storage**, NOT user-level storage.

---

## **The Problem with Current Approach:**

### **Scenario 1: User A logs in**
```
User A (ID: user_123)
    ↓
Creates activity: "Created 'Project Ideas' note"
    ↓
Activity saved to SharedPreferences with key: "activities"
    ↓
Data stored: [Activity1, Activity2, Activity3]
```

### **Scenario 2: User A logs out, User B logs in on SAME DEVICE**
```
User A logs out
    ↓
Activity data still in SharedPreferences ❌ (NOT deleted)
    ↓
User B logs in
    ↓
User B sees User A's activity history ❌ **SECURITY & PRIVACY ISSUE**
```

---

## **The Solution: User-Isolated Storage** ✅

We need to **namespace the activity data by user ID**:

```dart
// BEFORE (WRONG):
SharedPreferences.getInstance().setString('activities', jsonString);

// AFTER (CORRECT):
SharedPreferences.getInstance().setString('activities_${userId}', jsonString);
// Example: 'activities_user_123'
```

---

## **Complete Flow Diagram:**

```
┌─────────────────────────────────────────────────────────────┐
│                    USER LOGS IN                             │
└─────────────────────────────────────────────────────────────┘
                            ↓
        ┌───────────────────────────────────────┐
        │ Retrieve userId from auth             │
        │ (e.g., 'user_123')                    │
        └───────────────────────────────────────┘
                            ↓
    ┌──────────────────────────────────────────────┐
    │ Load activities from SharedPreferences       │
    │ Key: 'activities_user_123'                   │
    │ If not found → Initialize empty list        │
    └──────────────────────────────────────────────┘
                            ↓
        ┌───────────────────────────────────────┐
        │ User Creates/Updates/Deletes Notes    │
        │ ↓                                      │
        │ ActivityService tracks action         │
        │ ↓                                      │
        │ Save to SharedPreferences             │
        │ Key: 'activities_user_123'            │
        │ Activity persists locally             │
        └───────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│                    USER LOGS OUT                            │
└─────────────────────────────────────────────────────────────┘
                            ↓
    ┌──────────────────────────────────────────────┐
    │ Logout logic:                                │
    │ 1. Clear auth token                          │
    │ 2. Remove 'activities_user_123'              │
    │ 3. Clear other user-specific data            │
    │ 4. Navigate to login screen                  │
    └──────────────────────────────────────────────┘
                            ↓
        ┌───────────────────────────────────────┐
        │ User B logs in on SAME device         │
        │ ↓                                      │
        │ Retrieve userId: 'user_456'           │
        │ ↓                                      │
        │ Load activities_user_456 (empty)      │
        │ ✅ User B sees NO User A's history    │
        └───────────────────────────────────────┘
```

---

## **Implementation Strategy:**

### **Step 1: Create Activity Service with User Isolation**

```dart
class ActivityService {
  static const String _activityPrefix = 'activities_';
  
  /// Get namespaced key for user
  static String _getUserActivityKey(String userId) {
    return '$_activityPrefix$userId';
  }
  
  /// Save activity for specific user
  static Future<void> saveActivity(String userId, Activity activity) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _getUserActivityKey(userId);
    
    // Get existing activities
    List<Activity> activities = await getActivities(userId);
    
    // Add new activity at the top
    activities.insert(0, activity);
    
    // Keep only last 100 activities
    if (activities.length > 100) {
      activities = activities.take(100).toList();
    }
    
    // Save back to SharedPreferences
    final json = jsonEncode(activities.map((a) => a.toJson()).toList());
    await prefs.setString(key, json);
  }
  
  /// Get all activities for specific user
  static Future<List<Activity>> getActivities(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _getUserActivityKey(userId);
    
    final json = prefs.getString(key);
    if (json == null) return [];
    
    return (jsonDecode(json) as List)
        .map((item) => Activity.fromJson(item as Map<String, dynamic>))
        .toList();
  }
  
  /// Clear activities for specific user (on logout)
  static Future<void> clearActivities(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _getUserActivityKey(userId);
    await prefs.remove(key);
  }
}
```

### **Step 2: Update Logout Logic**

```dart
// In Auth Cubit or Service:
Future<void> logout() async {
  try {
    final userId = _currentUser?.id; // Get current user ID
    
    // Clear user-specific activities
    if (userId != null) {
      await ActivityService.clearActivities(userId);
    }
    
    // Clear auth token
    await prefs.remove('auth_token');
    
    // Clear other user data
    await prefs.remove('user_profile_$userId');
    
    // Navigate to login
    emit(LogoutSuccess());
  } catch (e) {
    emit(LogoutError(e.toString()));
  }
}
```

### **Step 3: Update Activity Creation in NotesCubit**

```dart
Future<void> createNote({...}) async {
  try {
    final newNote = await _createNoteUseCase.execute(...);
    
    // Track activity
    final activity = Activity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: 'created',
      noteTitle: newNote.title,
      noteName: newNote.title,
      timestamp: DateTime.now(),
      details: null,
    );
    
    // Save with user isolation
    final userId = _authCubit.state.user?.id; // Get current user ID
    if (userId != null) {
      await ActivityService.saveActivity(userId, activity);
    }
    
    // Emit to dashboard
    add(NotesCreated());
  } catch (e) {
    handleError(e, 'Failed to create note');
  }
}
```

### **Step 4: Update ActivityCubit**

```dart
class ActivityCubit extends BaseCubit<ActivityState> {
  final ActivityService _activityService;
  final AuthCubit _authCubit;
  
  ActivityCubit(this._activityService, this._authCubit) 
    : super(ActivityInitial());
  
  Future<void> loadActivities() async {
    emit(ActivityLoading());
    try {
      final userId = _authCubit.state.user?.id;
      if (userId == null) {
        emit(ActivityError('User not authenticated'));
        return;
      }
      
      // Load activities for current user
      final activities = await _activityService.getActivities(userId);
      emit(ActivityLoaded(activities));
    } catch (e) {
      emit(ActivityError(e.toString()));
    }
  }
}
```

---

## **Data Persistence Table:**

| Scenario | What Happens | Data Result |
|----------|--------------|-------------|
| **User A logs in** | Loads `activities_user_A` | Empty (first login) |
| **User A creates note** | Saves to `activities_user_A` | [Activity1] |
| **User A updates note** | Appends to `activities_user_A` | [Activity2, Activity1] |
| **User A logs out** | `activities_user_A` deleted | ✅ Gone |
| **User B logs in** | Loads `activities_user_B` | Empty (first login) |
| **User B sees activity** | Only `activities_user_B` | ✅ User A's data invisible |

---

## **Security Benefits:**

```
✅ User A's data is completely isolated
✅ User B cannot see User A's activity history
✅ Logout = complete data cleanup for that user
✅ Multiple users on same device = separate activity logs
✅ GDPR compliant (data deleted on logout)
```

---

## **Retention Policy Options:**

### **Option A: Delete on Logout** (Most Secure)
```dart
// Pros: Maximum privacy
// Cons: User loses history on logout
await ActivityService.clearActivities(userId);
```

### **Option B: Keep 30 Days** (User Convenience)
```dart
// Keep activities but auto-delete after 30 days
static Future<void> cleanupOldActivities(String userId) async {
  final activities = await getActivities(userId);
  final thirtyDaysAgo = DateTime.now().subtract(Duration(days: 30));
  
  final filtered = activities
      .where((a) => a.timestamp.isAfter(thirtyDaysAgo))
      .toList();
  
  // Save filtered list
}
```

### **Option C: Hybrid** (Recommended)
```dart
// Keep last 50 activities
// Auto-delete after 90 days
// Delete everything on logout
```

---

## **Implementation Recommendation:**

**GO WITH: Option C (Hybrid)**

```
On Login:
  └─ Load last 50 activities for user from SharedPreferences
  
During Usage:
  └─ Keep activities in memory + sync to SharedPreferences
  └─ Auto-remove activities older than 90 days (background task)
  
On Logout:
  └─ Clear all user-specific activities
  └─ Clear auth token
  └─ Clear other user data
```

---

## **Files We'll Create/Modify:**

```
CREATE:
├── lib/features/activity/domain/entities/activity.dart
├── lib/features/activity/data/services/activity_service.dart
├── lib/features/activity/presentation/cubit/activity_cubit.dart
├── lib/features/activity/presentation/cubit/activity_state.dart

MODIFY:
├── lib/features/notes/presentation/cubit/notes_cubit.dart
├── lib/features/auth/presentation/cubit/auth_cubit.dart (logout logic)
├── lib/features/dashboard/presentation/widgets/recent_activity_card.dart
└── lib/features/dashboard/presentation/cubit/dashboard_cubit.dart
```

---

## **Summary:**

```
Before: SharedPreferences key = "activities" (global)
After:  SharedPreferences key = "activities_user_123" (user-specific)

Result: ✅ Secure, private, and cleaned on logout
```

---

**Should I proceed with this implementation?** 🚀
