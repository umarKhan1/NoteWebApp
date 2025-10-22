import '../entities/dashboard_stats.dart';

/// Abstract repository for dashboard data operations
abstract class DashboardRepository {
  /// Get dashboard statistics
  Future<DashboardStats> getDashboardStats();
  
  /// Get recent activity list
  Future<List<String>> getRecentActivity();
  
  /// Refresh dashboard data
  Future<void> refreshDashboard();
}
