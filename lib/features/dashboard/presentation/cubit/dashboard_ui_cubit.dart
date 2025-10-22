import 'package:flutter_bloc/flutter_bloc.dart';

import 'dashboard_ui_state.dart';

/// Cubit for managing dashboard UI state
class DashboardUiCubit extends Cubit<DashboardUiState> {
  /// Creates a new [DashboardUiCubit].
  DashboardUiCubit() : super(const DashboardUiState());

  /// Toggles sidebar expanded state
  void toggleSidebar() {
    emit(state.copyWith(sidebarExpanded: !state.sidebarExpanded));
  }

  /// Sets sidebar expanded state based on screen size
  void setSidebarExpanded(bool expanded) {
    emit(state.copyWith(sidebarExpanded: expanded));
  }

  /// Initializes sidebar state based on screen width
  void initializeSidebar(double screenWidth) {
    final shouldExpand = screenWidth >= 1200;
    emit(state.copyWith(sidebarExpanded: shouldExpand));
  }
}
