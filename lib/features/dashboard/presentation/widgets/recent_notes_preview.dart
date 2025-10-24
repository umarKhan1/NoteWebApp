import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/base/base_stateless_widget.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../notes/domain/entities/note.dart';
import '../../../notes/presentation/cubit/notes_cubit.dart';
import '../../../notes/presentation/cubit/notes_state.dart';
import '../../../notes/presentation/widgets/note_detail/note_detail_modal.dart';
import 'all_notes_panel.dart';

/// Recent notes preview widget
class RecentNotesPreview extends BaseStatelessWidget {
  /// Creates a [RecentNotesPreview].
  const RecentNotesPreview({super.key});

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
          color: theme.colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.05),
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
                AppStrings.recentNotes,
                style: TextStyle(
                  fontSize: responsiveInfo.isMobile ? 14 : 16,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              TextButton(
                onPressed: () => _showAllNotesPanel(context),
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
                return const SizedBox(
                  height: 220,
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              
              if (state is NotesError) {
                return _buildErrorState();
              }
              
              if (state is NotesLoaded && state.notes.isNotEmpty) {
                // Filter non-pinned notes and sort by date
                final recentNotes = state.notes
                  .where((note) => !note.isPinned)
                  .toList()
                  ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
                
                if (recentNotes.isEmpty) {
                  return _buildEmptyState();
                }
                
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      recentNotes.length,
                      (index) => Padding(
                        padding: EdgeInsets.only(
                          right: 12,
                          left: index == 0 ? 0 : 0,
                        ),
                        child: SizedBox(
                          width: 250,
                          height: 220,
                          child: _buildNoteCard(
                            context: context,
                            note: recentNotes[index],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }
              
              return _buildEmptyState();
            },
          ),
        ],
      ),
    );
  }

  void _showAllNotesPanel(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withOpacity(0.3),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (BuildContext buildContext, Animation animation,
          Animation secondaryAnimation) {
        return SizedBox.expand(
          child: AllNotesPanel(
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

  Widget _buildNoteCard({
    required BuildContext context,
    required Note note,
  }) {
    final noteColors = _getNoteColors(note.color);
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            noteColors.primary,
            noteColors.secondary,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: noteColors.primary.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => NoteDetailModal.show(context, note),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with category badge
                if (note.category != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.4),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      note.category!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                // Title
                Text(
                  note.title.isEmpty ? AppStrings.untitledNote : note.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                // Content preview
                if (note.content.isNotEmpty) ...[
                  Expanded(
                    child: Text(
                      note.content.trim(),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12,
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 8),
                ] else
                  const Spacer(),
                // Footer with date
                Text(
                  _formatDate(note.updatedAt),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 10,
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
        final color = Color(int.parse('FF${colorHex.replaceFirst('#', '')}', radix: 16));
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

  Widget _buildEmptyState() {
    return Builder(
      builder: (context) {
        final theme = getTheme(context);
        return Container(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: Lottie.asset(
                  AppAssets.notesAnimation,
                  repeat: true,
                  animate: true,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                AppStrings.noNotesYet,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                AppStrings.createFirstNote,
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
            ],
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
                AppStrings.failedToLoadNotes,
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
