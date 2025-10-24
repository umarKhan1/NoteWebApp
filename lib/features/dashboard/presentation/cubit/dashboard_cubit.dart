import 'package:flutter/foundation.dart';

import '../../../../core/base/base_cubit.dart';
import '../../../../core/utils/user_utils.dart';
import '../../domain/entities/activity.dart';
import '../../domain/usecases/get_recent_activities_usecase.dart';
import '../../domain/usecases/load_dashboard_usecase.dart';
import 'dashboard_state.dart';

/// Dashboard Cubit for state management following OOP principles
class DashboardCubit extends BaseCubit<DashboardState> {

  /// Creates a [DashboardCubit] with dependency injection
  DashboardCubit(
    this._loadDashboardUseCase,
    this._getRecentActivitiesUseCase,
  ) : super(DashboardInitial());
  
  final LoadDashboardUseCase _loadDashboardUseCase;
  final GetRecentActivitiesUseCase _getRecentActivitiesUseCase;
  
  /// Current user ID for activity tracking
  String? _currentUserId;

  /// Load dashboard data using use case
  Future<void> loadDashboard({String? userId}) async {
    emit(DashboardLoading());
    
    // Ensure userId is always non-null
    final finalUserId = userId ?? (await UserUtils.getCurrentUserId()) ?? UserUtils.getDefaultUserId();
    _currentUserId = finalUserId;
    
    try {
      final dashboardData = await _loadDashboardUseCase.execute();

      // Get recent activities
      List<Activity> activities = [];
      activities = await _getRecentActivitiesUseCase(finalUserId, limit: 10);
      
      emit(DashboardLoaded(
        stats: dashboardData.stats,
        recentActivity: activities,
      ));
    } catch (e) {
      if (kDebugMode) print('[Dashboard] Error: $e');
      handleError(e, 'Failed to load dashboard');
    }
  }

  /// Refresh only the activities for the current user
  Future<void> refreshActivities() async {
    if (_currentUserId == null || _currentUserId!.isEmpty) {
      _currentUserId = (await UserUtils.getCurrentUserId()) ?? UserUtils.getDefaultUserId();
    }
    
    try {
      final activities = await _getRecentActivitiesUseCase(_currentUserId!, limit: 10);
      
      // Keep the current state but update activities
      final currentState = state;
      if (currentState is DashboardLoaded) {
        emit(DashboardLoaded(
          stats: currentState.stats,
          recentActivity: activities,
        ));
        if (kDebugMode) print('[Activity] ${activities.length} activities refreshed');
      } else if (currentState is DashboardInitial || currentState is DashboardLoading) {
        // If still loading, fetch the full dashboard
        await loadDashboard(userId: _currentUserId);
      }
    } catch (e) {
      if (kDebugMode) print('[Dashboard] Refresh error: $e');
    }
  }

  /// Refresh dashboard data
  Future<void> refreshDashboard({String? userId}) async {
    logDebug('Refreshing dashboard data');
    await loadDashboard(userId: userId);
  }
  
  @override
  void handleErrorMessage(String message) {
    emit(DashboardError(message));
  }
}

