import '../../domain/entities/activity.dart';
import '../../domain/repositories/activity_repository.dart';
import '../datasources/activity_local_datasource.dart';
import '../models/activity_model.dart';

/// Implementation of activity repository
class ActivityRepositoryImpl implements ActivityRepository {
  /// Creates an [ActivityRepositoryImpl]
  const ActivityRepositoryImpl(this._datasource);

  /// Local datasource for activity data
  final ActivityLocalDatasource _datasource;

  @override
  Future<void> logActivity(String userId, Activity activity) async {
    final model = ActivityModel.fromEntity(activity);
    await _datasource.saveActivity(userId, model);
  }

  @override
  Future<List<Activity>> getActivities(String userId) async {
    return await _datasource.getActivities(userId);
  }

  @override
  Future<List<Activity>> getRecentActivities(
    String userId, {
    int limit = 10,
  }) async {
    return await _datasource.getRecentActivities(userId, limit: limit);
  }

  @override
  Future<void> clearActivities(String userId) async {
    await _datasource.clearActivities(userId);
  }

  @override
  Future<void> deleteActivity(String userId, String activityId) async {
    await _datasource.deleteActivity(userId, activityId);
  }

  @override
  Future<int> getActivityCount(String userId) async {
    return await _datasource.getActivityCount(userId);
  }
}
