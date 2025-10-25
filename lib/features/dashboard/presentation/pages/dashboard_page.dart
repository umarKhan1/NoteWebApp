import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/user_utils.dart';
import '../../../../shared/widgets/responsive_sidebar.dart';
import '../cubit/dashboard_cubit.dart';
import '../cubit/dashboard_state.dart';
import '../cubit/dashboard_ui_cubit.dart';
import '../cubit/dashboard_ui_state.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/dashboard_stats_grid.dart';
import '../widgets/sections/dashboard_content_grid.dart';
import '../widgets/sections/dashboard_welcome_section.dart';

/// Main dashboard page
class DashboardPage extends StatelessWidget {
  /// Creates a [DashboardPage].
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _DashboardView();
  }
}

class _DashboardView extends StatefulWidget {
  const _DashboardView();

  @override
  State<_DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<_DashboardView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late DashboardCubit _dashboardCubit;

  @override
  void initState() {
    super.initState();
    _dashboardCubit = context.read<DashboardCubit>();
    
    Future.delayed(Duration.zero, () async {
      if (!mounted) return;
      
      // Get current user ID for activity tracking
      final userId = await UserUtils.getCurrentUserId() ?? 
                     UserUtils.getDefaultUserId();
      
      if (mounted) {
        _dashboardCubit.loadDashboard(userId: userId);
        
        // Initialize sidebar state based on screen size
        final screenWidth = MediaQuery.of(context).size.width;
        context.read<DashboardUiCubit>().initializeSidebar(screenWidth);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final showSidebar = !isMobile;

    return BlocBuilder<DashboardUiCubit, DashboardUiState>(
      builder: (context, uiState) {
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: theme.colorScheme.surface,
          drawer: isMobile 
            ? Drawer(
                child: ResponsiveSidebar(
                  isExpanded: true,
                  currentPath: '/dashboard',
                  onToggle: () => Navigator.of(context).pop(),
                ),
              )
            : null,
          body: Row(
            children: [
              // Desktop/Tablet Sidebar
              if (showSidebar)
                ResponsiveSidebar(
                  isExpanded: uiState.sidebarExpanded,
                  currentPath: '/dashboard',
                  onToggle: () => context.read<DashboardUiCubit>().toggleSidebar(),
                ),
              
              // Main Content
              Expanded(
                child: Column(
                  children: [
                    // Header
                    DashboardHeader(
                      onMenuPressed: isMobile 
                        ? () => _scaffoldKey.currentState?.openDrawer()
                        : null,
                    ),
                    
                    // Content
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(isMobile ? 16 : 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Welcome Section
                            const DashboardWelcomeSection(),
                            const SizedBox(height: 24),
                            
                            // Stats Grid
                            BlocBuilder<DashboardCubit, DashboardState>(
                              builder: (context, state) {
                                if (state is DashboardLoaded) {
                                  return DashboardStatsGrid(stats: state.stats);
                                }
                                return const DashboardStatsGrid();
                              },
                            ),
                            const SizedBox(height: 24),
                            
                            // Content Grid
                            const DashboardContentGrid(),
                            
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
             
            },
            backgroundColor: theme.primaryColor,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        );
      },
    );
  }
}
