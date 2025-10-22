import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../domain/entities/note.dart';
import 'note_card.dart';

/// Grid view for displaying notes in cards
class NotesGridView extends StatelessWidget {
  /// List of notes to display
  final List<Note> notes;
  
  const NotesGridView({
    super.key,
    required this.notes,
  });

  @override
  Widget build(BuildContext context) {
    if (notes.isEmpty) {
      return _buildEmptyState(context);
    }

    final isDesktop = Device.screenType == ScreenType.desktop;
    final isTablet = Device.screenType == ScreenType.tablet;
    
    int crossAxisCount;
    double childAspectRatio;
    
    if (isDesktop) {
      crossAxisCount = 4; // More cards on desktop
      childAspectRatio = 2.3; // Slightly wider
    } else if (isTablet) {
      crossAxisCount = 3;
      childAspectRatio = 2.1;
    } else {
      crossAxisCount = 2; // Two columns on mobile
      childAspectRatio = 1.8;
    }

    return GridView.builder(
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: notes.length > 8 ? 8 : notes.length, // Show max 8 notes
      itemBuilder: (context, index) {
        final note = notes[index];
        return NoteCard(
          note: note,
          onTap: () {
            // TODO: Navigate to note detail
          },
          onEdit: () {
            // TODO: Navigate to edit note
          },
          onDelete: () {
            // TODO: Show delete confirmation
          },
          onTogglePin: () {
            // TODO: Toggle pin status
          },
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.note_add_outlined,
            size: 15.w,
            color: const Color(0xFF9CA3AF),
          ),
          SizedBox(height: 2.h),
          Text(
            'No notes yet',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF6B7280),
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Create your first note to get started',
            style: TextStyle(
              fontSize: 13.sp,
              color: const Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }
}
