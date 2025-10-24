import '../entities/activity.dart';
import '../repositories/activity_repository.dart';

/// Use case for logging an activity
class LogActivityUseCase {
  /// Creates a [LogActivityUseCase]
  const LogActivityUseCase(this._repository);

  /// Activity repository
  final ActivityRepository _repository;

  /// Execute the use case
  Future<void> call(String userId, Activity activity) async {
    await _repository.logActivity(userId, activity);
  }
}
