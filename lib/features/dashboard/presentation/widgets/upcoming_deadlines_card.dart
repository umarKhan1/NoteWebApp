import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/base/base_stateless_widget.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../notes/domain/entities/note.dart';
import '../../../notes/presentation/cubit/notes_cubit.dart';
import '../../../notes/presentation/cubit/notes_state.dart';
import '../../../notes/presentation/widgets/note_detail/note_detail_modal.dart';
import 'pinned_notes_panel.dart';

/// Upcoming deadlines card widget
class UpcomingDeadlinesCard extends BaseStatelessWidget {
  /// Creates an [UpcomingDeadlinesCard].
  const UpcomingDeadlinesCard({super.key});

  @override
  Widget build(BuildContext context) {
    final responsiveInfo = getResponsiveInfo(context);
    final theme = getTheme(context);
    final padding = responsiveInfo.isMobile ? 16.0 : 20.0;
    
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pinned Notes',
                style: TextStyle(
                  fontSize: responsiveInfo.isMobile ? 14 : 16,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              TextButton(
                onPressed: () => _showPinnedNotesPanel(context),
                child: Text(
                  AppStrings.viewAll,
                  style: TextStyle(
                    fontSize: responsiveInfo.isMobile ? 11 : 12,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          BlocBuilder<NotesCubit, NotesState>(
            builder: (context, state) {
              if (state is NotesLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              
              if (state is NotesError) {
                return _buildErrorState();
              }
              
              if (state is NotesLoaded && state.notes.isNotEmpty) {
                // Filter pinned notes and sort by date
                final pinnedNotes = state.notes
                  .where((note) => note.isPinned)
                  .toList()
                  ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
                
                if (pinnedNotes.isEmpty) {
                  return _buildEmptyState();
                }
                
                return Column(
                  children: pinnedNotes.map((note) => _buildPinnedNoteItem(
                    context: context,
                    note: note,
                  )).toList(),
                );
              }
              
              return _buildEmptyState();
            },
          ),
        ],
      ),
    );
  }


  void _showPinnedNotesPanel(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (BuildContext buildContext, Animation animation,
          Animation secondaryAnimation) {
        return SizedBox.expand(
          child: PinnedNotesPanel(
            onClose: () => Navigator.of(buildContext).pop(),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
          child: child,
        );
      },
    );
  }

  Widget _buildPinnedNoteItem({
    required BuildContext context,
    required Note note,
  }) {
    final theme = getTheme(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDarkMode 
            ? theme.colorScheme.primary.withValues(alpha: 0.15)
            : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDarkMode 
              ? theme.colorScheme.primary.withValues(alpha: 0.3)
              : theme.colorScheme.outline.withValues(alpha: 0.1),
          width: isDarkMode ? 1.5 : 1,
        ),
        boxShadow: isDarkMode 
            ? [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => NoteDetailModal.show(context, note),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Red pinned badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444), // Red background
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.push_pin,
                        size: 12,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'Pinned',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        note.title.isEmpty ? AppStrings.untitledNote : note.title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (note.category != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          'on ${note.category}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: 6),
                      Text(
                        _formatDate(note.updatedAt),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Builder(
      builder: (context) {
        final theme = getTheme(context);
        return Container(
          padding: const EdgeInsets.all(32),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.push_pin_outlined,
                  size: 48,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                ),
                const SizedBox(height: 12),
                Text(
                  'No pinned notes',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Pin your important notes',
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorState() {
    return Builder(
      builder: (context) {
        final theme = getTheme(context);
        return Container(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: 8),
              Text(
                'Failed to load pinned notes',
                style: TextStyle(
                  fontSize: 14,
                  color: theme.colorScheme.error,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
