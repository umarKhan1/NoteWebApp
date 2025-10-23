import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/extensions/widget_extensions.dart';
import '../cubit/dashboard_cubit.dart';
import '../cubit/dashboard_state.dart';
import '../widgets/dashboard_stats_grid.dart';
import '../widgets/sections/dashboard_content_grid.dart';
import '../widgets/sections/dashboard_welcome_section.dart';

/// Dashboard content widget without shell/sidebar
class DashboardContent extends StatefulWidget {
  /// Creates a [DashboardContent].
  const DashboardContent({super.key});

  @override
  State<DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<DashboardContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<DashboardCubit>().loadDashboard();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoading) {
          return Center(
            child: CircularProgressIndicator(
              color: theme.primaryColor,
            ),
          );
        }
        
        if (state is DashboardError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: AppSpacing.massive,
                  color: theme.colorScheme.error,
                ),
                AppSpacing.md.verticalSpace,
                Text(
                  'Failed to load dashboard',
                  style: theme.textTheme.headlineSmall,
                ),
                AppSpacing.sm.verticalSpace,
                Text(
                  state.message,
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                AppSpacing.md.verticalSpace,
                ElevatedButton(
                  onPressed: () => context.read<DashboardCubit>().loadDashboard(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        
        return SingleChildScrollView(
          padding: EdgeInsets.all(isMobile ? AppSpacing.md : AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              const DashboardWelcomeSection(),
              
              AppSpacing.lg.verticalSpace,
              
              // Stats Grid
              if (state is DashboardLoaded)
                DashboardStatsGrid(stats: state.stats),
              
              AppSpacing.xl.verticalSpace,
              
              // Content Grid (Recent Notes, Activity, etc.)
              const DashboardContentGrid(),
            ],
          ),
        );
      },
    );
  }
}
