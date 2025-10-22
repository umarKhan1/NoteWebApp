import 'package:equatable/equatable.dart';

import '../../domain/entities/dashboard_stats.dart';

/// Dashboard state management
abstract class DashboardState extends Equatable {
 /// Creates a [DashboardState] instance.
  const DashboardState();

  @override
  List<Object?> get props => [];
}

/// Initial dashboard state
class DashboardInitial extends DashboardState {}

/// Dashboard loading state
class DashboardLoading extends DashboardState {}

/// Dashboard loaded state
class DashboardLoaded extends DashboardState {
  /// Creates a [DashboardLoaded] instance.
  const DashboardLoaded({
    required this.stats,
    required this.recentActivity,
  });
  /// Dashboard statistics
  final DashboardStats stats;
  
  /// Recent activity list
  final List<String> recentActivity;

  @override
  List<Object?> get props => [stats, recentActivity];
}

/// Dashboard error state
class DashboardError extends DashboardState {
/// Creates a [DashboardError] instance.
  const DashboardError(this.message);
  /// Error message
  final String message;

  @override
  List<Object?> get props => [message];
}
