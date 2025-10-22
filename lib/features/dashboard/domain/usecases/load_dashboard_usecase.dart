import '../entities/dashboard_stats.dart';
import '../repositories/dashboard_repository.dart';

/// Use case for loading dashboard data
class LoadDashboardUseCase {
  
  /// Creates a [LoadDashboardUseCase] with the given repository.
  const LoadDashboardUseCase(this._repository);
  final DashboardRepository _repository;
  
  /// Executes the use case to load dashboard data
  Future<DashboardData> execute() async {
    try {
      final stats = await _repository.getDashboardStats();
      final activity = await _repository.getRecentActivity();
      
      return DashboardData(
        stats: stats,
        recentActivity: activity,
      );
    } catch (e) {
      throw DashboardException('Failed to load dashboard: ${e.toString()}');
    }
  }
}

/// Data container for dashboard information
class DashboardData {
  /// Creates a [DashboardData] instance.
  const DashboardData({
    required this.stats,
    required this.recentActivity,
  });
  
  /// Dashboard statistics
  final DashboardStats stats;
  
  /// Recent activity list
  final List<String> recentActivity;
}

/// Exception thrown when dashboard operations fail
class DashboardException implements Exception {
  /// Creates a [DashboardException] with the given message.
  const DashboardException(this.message);
  
  /// Error message
  final String message;
  
  @override
  String toString() => 'DashboardException: $message';
}
