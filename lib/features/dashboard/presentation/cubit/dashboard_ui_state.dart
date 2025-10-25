import 'package:equatable/equatable.dart';

/// State for dashboard UI
class DashboardUiState extends Equatable {
  /// Creates a [DashboardUiState].
  const DashboardUiState({this.sidebarExpanded = true});

  /// Whether the sidebar is expanded
  final bool sidebarExpanded;

  /// Creates a copy of this state with the given fields replaced
  DashboardUiState copyWith({bool? sidebarExpanded}) {
    return DashboardUiState(
      sidebarExpanded: sidebarExpanded ?? this.sidebarExpanded,
    );
  }

  @override
  List<Object?> get props => [sidebarExpanded];
}
