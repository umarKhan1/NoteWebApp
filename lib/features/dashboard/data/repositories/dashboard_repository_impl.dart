import '../../domain/entities/dashboard_stats.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../services/mock_dashboard_service.dart';

/// Implementation of dashboard repository using mock service
class DashboardRepositoryImpl implements DashboardRepository {
  
  /// Creates a [DashboardRepositoryImpl] with the given service.
  const DashboardRepositoryImpl(this._dashboardService);
  final MockDashboardService _dashboardService;
  
  @override
  Future<DashboardStats> getDashboardStats() async {
    return _dashboardService.getDashboardStats();
  }
  
  @override
  Future<List<String>> getRecentActivity() async {
    return _dashboardService.getRecentActivity();
  }
  
  @override
  Future<void> refreshDashboard() async {
    // Implementation for refreshing dashboard
    // Could invalidate cache, refetch data, etc.
    await Future.delayed(const Duration(milliseconds: 100));
  }
}
