import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../cubit/notes_cubit.dart';
import '../../cubit/notes_state.dart';

/// Stats cards section for the dashboard
class DashboardStatsCards extends StatelessWidget {
  const DashboardStatsCards({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesCubit, NotesState>(
      builder: (context, state) {
        int totalNotes = 0;
        int todayNotes = 0;
        int categories = 0;
        
        if (state is NotesLoaded) {
          totalNotes = state.notes.length;
          final today = DateTime.now();
          todayNotes = state.notes.where((note) {
            return note.createdAt.day == today.day &&
                   note.createdAt.month == today.month &&
                   note.createdAt.year == today.year;
          }).length;
          
          categories = state.notes
              .where((note) => note.category != null)
              .map((note) => note.category)
              .toSet()
              .length;
        }
        
        return Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context,
                title: 'Total Notes',
                value: totalNotes.toString(),
                subtitle: 'All notes',
                color: const Color(0xFF6366F1),
                icon: Icons.note_outlined,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: _buildStatCard(
                context,
                title: 'Today',
                value: todayNotes.toString(),
                subtitle: 'New notes',
                color: const Color(0xFF10B981),
                icon: Icons.today_outlined,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: _buildStatCard(
                context,
                title: 'Categories',
                value: categories.toString(),
                subtitle: 'Active',
                color: const Color(0xFFF59E0B),
                icon: Icons.folder_outlined,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required String subtitle,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: const Color(0xFF6B7280),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: EdgeInsets.all(1.w),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(1.w),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: color,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1F2937),
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11.sp,
              color: const Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }
}
