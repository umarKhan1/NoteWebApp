import '../../../../core/base/base_cubit.dart';
import '../../domain/usecases/load_dashboard_usecase.dart';
import 'dashboard_state.dart';

/// Dashboard Cubit for state management following OOP principles
class DashboardCubit extends BaseCubit<DashboardState> {

  /// Creates a [DashboardCubit] with dependency injection
  DashboardCubit(this._loadDashboardUseCase) : super(DashboardInitial());
  final LoadDashboardUseCase _loadDashboardUseCase;

  /// Load dashboard data using use case
  Future<void> loadDashboard() async {
    emit(DashboardLoading());
    
    try {
      final dashboardData = await _loadDashboardUseCase.execute();
      
      emit(DashboardLoaded(
        stats: dashboardData.stats,
        recentActivity: dashboardData.recentActivity,
      ));
    } catch (e) {
      handleError(e, 'Failed to load dashboard');
    }
  }

  /// Refresh dashboard data
  Future<void> refreshDashboard() async {
    logDebug('Refreshing dashboard data');
    await loadDashboard();
  }
  
  @override
  void handleErrorMessage(String message) {
    emit(DashboardError(message));
  }
}
