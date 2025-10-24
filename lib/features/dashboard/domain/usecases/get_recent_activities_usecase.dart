import '../entities/activity.dart';
import '../repositories/activity_repository.dart';

/// Use case for getting recent activities
class GetRecentActivitiesUseCase {
  /// Creates a [GetRecentActivitiesUseCase]
  const GetRecentActivitiesUseCase(this._repository);

  /// Activity repository
  final ActivityRepository _repository;

  /// Execute the use case
  /// 
  /// Returns recent activities for a specific user
  /// Limit defaults to 10 activities
  Future<List<Activity>> call(String userId, {int limit = 10}) async {
    return await _repository.getRecentActivities(userId, limit: limit);
  }
}
