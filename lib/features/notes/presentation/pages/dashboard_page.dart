import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/constants/app_strings.dart';
import '../cubit/notes_cubit.dart';
import '../cubit/notes_state.dart';
import '../widgets/dashboard/dashboard_sidebar.dart';
import '../widgets/dashboard/dashboard_header.dart';
import '../widgets/dashboard/dashboard_stats_cards.dart';
import '../widgets/dashboard/notes_grid_view.dart';
import '../widgets/dashboard/dashboard_mobile_drawer.dart';

/// Main dashboard page with sidebar and notes grid
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // Load notes when page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotesCubit>().loadNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = Device.screenType == ScreenType.desktop;
    final screenWidth = MediaQuery.of(context).size.width;
    final showSidebar = isDesktop && screenWidth >= 1024; // Show sidebar only on larger screens
    
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF8F9FA),
      drawer: !showSidebar ? const DashboardMobileDrawer() : null,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              // Desktop Sidebar
              if (showSidebar)
                const DashboardSidebar(),
              
              // Main Content
              Expanded(
                child: Column(
                  children: [
                    // Header
                    DashboardHeader(
                      onMenuPressed: !showSidebar 
                        ? () => _scaffoldKey.currentState?.openDrawer()
                        : null,
                    ),
                    
                    // Main Content Area
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(isDesktop ? 3.w : 4.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Welcome Section
                            _buildWelcomeSection(context),
                            SizedBox(height: 3.h),
                            
                            // Stats Cards
                            const DashboardStatsCards(),
                            SizedBox(height: 3.h),
                            
                            // Notes Section
                            _buildNotesSection(context),
                            SizedBox(height: 3.h),
                            
                            // Upcoming Deadlines Section
                            _buildUpcomingDeadlines(context),
                            SizedBox(height: 3.h), // Bottom padding
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to add note page
          _showAddNoteDialog(context);
        },
        backgroundColor: const Color(0xFF6366F1),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hi, Faris!',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1F2937),
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          'You have some notes to review today!',
          style: TextStyle(
            fontSize: 14.sp,
            color: const Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }

  Widget _buildNotesSection(BuildContext context) {
    return Column(
      children: [
        // Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Notes',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1F2937),
              ),
            ),
            TextButton(
              onPressed: () {
                // TODO: Show all notes
              },
              child: Text(
                'See all',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: const Color(0xFF6366F1),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        
        // Notes Grid with fixed height
        SizedBox(
          height: 40.h, // Fixed height to prevent overflow
          child: BlocBuilder<NotesCubit, NotesState>(
            builder: (context, state) {
              if (state is NotesLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              
              if (state is NotesError) {
                return _buildErrorState(context, state);
              }
              
              if (state is NotesLoaded) {
                return NotesGridView(notes: state.notes);
              }
              
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(BuildContext context, NotesError state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 15.w,
            color: Colors.red,
          ),
          SizedBox(height: 2.h),
          Text(
            state.message,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.red,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.h),
          ElevatedButton(
            onPressed: () {
              context.read<NotesCubit>().loadNotes();
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  void _showAddNoteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Note'),
        content: const Text('Add note functionality will be implemented soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingDeadlines(BuildContext context) {
    return Column(
      children: [
        // Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Upcoming Deadlines',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1F2937),
              ),
            ),
            TextButton(
              onPressed: () {
                // TODO: Show all deadlines
              },
              child: Text(
                'See all',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: const Color(0xFF6366F1),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        
        // Deadline Cards
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildDeadlineCard(
                title: 'Analytic dashboard design',
                project: 'Circles project',
                time: 'Today, 10:00am',
                color: const Color(0xFFFEF2F2),
                borderColor: const Color(0xFFEF4444),
              ),
              const SizedBox(width: 16),
              _buildDeadlineCard(
                title: 'Contact us section on landing page',
                project: 'Circles project',
                time: 'Today, 15:00pm',
                color: const Color(0xFFFEF2F2),
                borderColor: const Color(0xFFEF4444),
              ),
              const SizedBox(width: 16),
              _buildDeadlineCard(
                title: 'Design references for the App',
                project: 'Circles project',
                time: 'Tomorrow, 09:00am',
                color: const Color(0xFFFFF7ED),
                borderColor: const Color(0xFFF59E0B),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDeadlineCard({
    required String title,
    required String project,
    required String time,
    required Color color,
    required Color borderColor,
  }) {
    return Container(
      width: 280, // Fixed width for horizontal scroll
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFF1F5F9),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                'on ',
                style: TextStyle(
                  fontSize: 11,
                  color: const Color(0xFF9CA3AF),
                ),
              ),
              Text(
                project,
                style: TextStyle(
                  fontSize: 11,
                  color: const Color(0xFF6B7280),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: borderColor.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Text(
              time,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: borderColor.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
