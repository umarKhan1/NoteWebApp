import '../repositories/dashboard_repository.dart';

/// Params for loading dashboard
class LoadDashboardParams {
  /// Creates [LoadDashboardParams]
  const LoadDashboardParams({this.refresh = false});

  /// Whether to refresh the data
  final bool refresh;
}

/// Use case for loading dashboard data
class LoadDashboardUseCase {
  /// Creates a [LoadDashboardUseCase]
  LoadDashboardUseCase(this._repository);

  /// Dashboard repository
  final DashboardRepository _repository;

  /// Result model for dashboard data
  late DashboardData _lastData;

  /// Execute the use case
  ///
  /// Returns dashboard data containing stats and activities
  Future<DashboardData> execute({bool refresh = false}) async {
    if (refresh) {
      await _repository.refreshDashboard();
    }

    final stats = await _repository.getDashboardStats();
    final activities = await _repository.getRecentActivity();

    _lastData = DashboardData(stats: stats, activities: activities);

    return _lastData;
  }
}

/// Model for dashboard data
class DashboardData {
  /// Creates [DashboardData]
  const DashboardData({this.stats, this.activities = const []});

  /// Dashboard statistics
  final dynamic stats;

  /// Recent activities
  final List<String> activities;
}
