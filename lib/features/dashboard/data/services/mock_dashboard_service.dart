import '../../domain/entities/dashboard_stats.dart';

/// Mock service for dashboard data
class MockDashboardService {
  /// Get dashboard statistics
  Future<DashboardStats> getDashboardStats() async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    return const DashboardStats(
      totalNotes: 24,
      todayNotes: 3,
      totalCategories: 5,
      pinnedNotes: 8,
    );
  }
  
  /// Get recent activity
  Future<List<String>> getRecentActivity() async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    return [
      'Created "Project Ideas" note',
      'Updated "Meeting Notes" category',
      'Pinned "Important Reminder"',
      'Shared "Research Document"',
    ];
  }
}
