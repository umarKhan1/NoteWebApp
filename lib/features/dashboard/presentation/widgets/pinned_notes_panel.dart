import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/base/base_stateless_widget.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../notes/domain/entities/note.dart';
import '../../../notes/presentation/cubit/notes_cubit.dart';
import '../../../notes/presentation/cubit/notes_state.dart';
import '../../../notes/presentation/widgets/note_detail/note_detail_modal.dart';

/// Pinned notes panel widget shown as an overlay
class PinnedNotesPanel extends BaseStatelessWidget {
  /// Creates a [PinnedNotesPanel].
  const PinnedNotesPanel({
    super.key,
    required this.onClose,
  });

  /// Callback when panel is closed
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final responsiveInfo = getResponsiveInfo(context);
    final theme = getTheme(context);
    final screenWidth = MediaQuery.of(context).size.width;

    // Panel width - adjust based on screen size
    final panelWidth = responsiveInfo.isMobile
        ? screenWidth
        : screenWidth < 1200
            ? screenWidth * 0.4
            : screenWidth * 0.35;

    return GestureDetector(
      onTap: onClose,
      child: Container(
        color: Colors.black.withValues(alpha: 0.3),
        child: Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () {}, // Prevent closing when tapping on the panel
            child: Container(
              width: panelWidth,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withValues(alpha: 0.2),
                    blurRadius: 12,
                    offset: const Offset(-2, 0),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: theme.colorScheme.outline.withValues(alpha: 0.1),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Pinned Notes',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            color: theme.colorScheme.onSurface,
                          ),
                          onPressed: onClose,
                          iconSize: 24,
                        ),
                      ],
                    ),
                  ),

                  // Notes List
                  Expanded(
                    child: BlocBuilder<NotesCubit, NotesState>(
                      builder: (context, state) {
                        if (state is NotesLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (state is NotesError) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 48,
                                  color: theme.colorScheme.error,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  AppStrings.failedToLoadNotes,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: theme.colorScheme.error,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        if (state is NotesLoaded && state.notes.isNotEmpty) {
                          // Filter pinned notes and sort by date
                          final pinnedNotes = state.notes
                              .where((note) => note.isPinned)
                              .toList()
                            ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

                          if (pinnedNotes.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.push_pin_outlined,
                                    size: 48,
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.3),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'No pinned notes',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: theme.colorScheme.onSurface
                                          .withValues(alpha: 0.5),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          return ListView.builder(
                            itemCount: pinnedNotes.length,
                            itemBuilder: (context, index) {
                              final note = pinnedNotes[index];
                              return _buildPinnedNoteItem(
                                context: context,
                                note: note,
                                theme: theme,
                              );
                            },
                          );
                        }

                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.push_pin_outlined,
                                size: 48,
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.3),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'No pinned notes',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: theme.colorScheme.onSurface
                                      .withValues(alpha: 0.5),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPinnedNoteItem({
    required BuildContext context,
    required Note note,
    required ThemeData theme,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            NoteDetailModal.show(context, note);
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Red pinned badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.push_pin,
                        size: 12,
                        color: Colors.white,
                      ),
                      SizedBox(width: 4),
                      Text(
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
                        note.title.isEmpty
                            ? AppStrings.untitledNote
                            : note.title,
                        style: TextStyle(
                          fontSize: 13,
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
                            fontSize: 11,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: 4),
                      Text(
                        _formatDate(note.updatedAt),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color:
                              theme.colorScheme.onSurface.withValues(alpha:0.5),
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
