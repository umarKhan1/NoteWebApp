import '../entities/activity.dart';

/// Abstract repository for activity management
abstract class ActivityRepository {
  /// Log an activity for a specific user
  Future<void> logActivity(String userId, Activity activity);

  /// Get all activities for a specific user
  Future<List<Activity>> getActivities(String userId);

  /// Get recent activities for a user with a limit
  Future<List<Activity>> getRecentActivities(String userId, {int limit = 10});

  /// Clear all activities for a specific user
  Future<void> clearActivities(String userId);

  /// Delete a specific activity
  Future<void> deleteActivity(String userId, String activityId);

  /// Get activity count for a user
  Future<int> getActivityCount(String userId);
}
