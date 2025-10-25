import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/extensions/widget_extensions.dart';
import '../../../domain/entities/activity.dart';
import '../../cubit/dashboard_cubit.dart';
import '../../cubit/dashboard_state.dart';
import '../recent_activity_card.dart';
import '../recent_notes_preview.dart';
import '../upcoming_deadlines_card.dart';

/// Content grid widget for dashboard
class DashboardContentGrid extends StatelessWidget {
  /// Creates a [DashboardContentGrid].
  const DashboardContentGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1200;
    
    if (isMobile) {
      return Column(
        children: [
          const RecentNotesPreview(),
          AppSpacing.md.verticalSpace,
          BlocBuilder<DashboardCubit, DashboardState>(
            builder: (context, state) {
              List<Activity> activity = [];
              if (state is DashboardLoaded) {
                activity = state.recentActivity;
              }
              return RecentActivityCard(activities: activity);
            },
          ),
          AppSpacing.md.verticalSpace,
          const UpcomingDeadlinesCard(),
        ],
      );
    }
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column
        Expanded(
          flex: isTablet ? 3 : 2,
          child: Column(
            children: [
              const RecentNotesPreview(),
              AppSpacing.md.verticalSpace,
              const UpcomingDeadlinesCard(),
            ],
          ),
        ),
        (isTablet ? AppSpacing.md : AppSpacing.lg).horizontalSpace,
        
        // Right Column
        Expanded(
          flex: isTablet ? 2 : 1,
          child:          BlocBuilder<DashboardCubit, DashboardState>(
            builder: (context, state) {
              List<Activity> activity = [];
              if (state is DashboardLoaded) {
                activity = state.recentActivity;
              }
              return RecentActivityCard(activities: activity);
            },
          ),
        ),
      ],
    );
  }
}
