import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/base/base_stateless_widget.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../notes/domain/entities/note.dart';
import '../../../notes/presentation/cubit/notes_cubit.dart';
import '../../../notes/presentation/cubit/notes_state.dart';
import '../../../notes/presentation/widgets/note_detail/note_detail_modal.dart';

/// All notes panel widget shown as an overlay
class AllNotesPanel extends BaseStatelessWidget {
  /// Creates an [AllNotesPanel].
  const AllNotesPanel({
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
        color: Colors.black.withOpacity(0.3),
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
                    color: theme.shadowColor.withOpacity(0.2),
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
                          color: theme.colorScheme.outline.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppStrings.allNotes,
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
                          // Sort notes: pinned first, then by date
                          final sortedNotes = List<Note>.from(state.notes)
                            ..sort((a, b) {
                              if (a.isPinned != b.isPinned) {
                                return a.isPinned ? -1 : 1;
                              }
                              return b.updatedAt.compareTo(a.updatedAt);
                            });
                          
                          return ListView.builder(
                            itemCount: sortedNotes.length,
                            itemBuilder: (context, index) {
                              final note = sortedNotes[index];
                              return _buildNoteListItem(
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
                                Icons.notes,
                                size: 48,
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.3),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                AppStrings.noNotesYet,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.5),
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

  Widget _buildNoteListItem({
    required BuildContext context,
    required Note note,
    required ThemeData theme,
  }) {
    final noteColors = _getNoteColors(note.color);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            noteColors.primary,
            noteColors.secondary,
          ],
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: noteColors.primary.withOpacity(0.2),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        note.title.isEmpty 
                            ? AppStrings.untitledNote 
                            : note.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (note.isPinned) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.push_pin,
                              size: 8,
                              color: Colors.white,
                            ),
                            SizedBox(width: 3),
                            Text(
                              'Pinned',
                              style: TextStyle(
                                fontSize: 8,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
                if (note.content.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    note.content.trim(),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 11,
                      height: 1.3,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 4),
                Text(
                  _formatDate(note.updatedAt),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.65),
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Get color palette for notes based on saved color or id
  ({Color primary, Color secondary}) _getNoteColors(String? colorHex) {
    // If color is saved, use it
    if (colorHex != null && colorHex.isNotEmpty) {
      try {
        final color = Color(
          int.parse('FF${colorHex.replaceFirst('#', '')}', radix: 16),
        );
        return (
          primary: color,
          secondary: color.withOpacity(0.7),
        );
      } catch (e) {
        // Fall back to default if parsing fails
      }
    }

    // Default color palettes if no saved color
    const defaultPalettes = [
      (primary: Color(0xFFFF6B6B), secondary: Color(0xFFFFE66D)),
      (primary: Color(0xFF4ECDC4), secondary: Color(0xFF44A08D)),
      (primary: Color(0xFFA8EDEA), secondary: Color(0xFFFED6E3)),
    ];

    return defaultPalettes[0];
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
