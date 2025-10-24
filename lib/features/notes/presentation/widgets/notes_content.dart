import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/base/base_stateless_widget.dart';
import '../../../../shared/extensions/widget_extensions.dart';
import '../cubit/notes_cubit.dart';
import '../cubit/notes_state.dart';

import '../widgets/note_detail/note_detail_modal.dart';
import '../widgets/notes_list/add_note_bottom_sheet.dart';
import '../widgets/notes_list/notes_empty_state.dart';
import '../widgets/notes_list/notes_list_item.dart';
import '../widgets/notes_list/notes_loading_shimmer.dart';

/// Notes content widget without shell/sidebar
class NotesContent extends BaseStatelessWidget {
  /// Creates a [NotesContent].
  const NotesContent({super.key});

  void _showAddNoteDialog(BuildContext context) {
    AddNoteBottomSheet.show(context);
  }

  @override
  Widget build(BuildContext context) {
    final responsiveInfo = getResponsiveInfo(context);
    final theme = getTheme(context);
    final isMobile = responsiveInfo.isMobile;
    
    return BlocBuilder<NotesCubit, NotesState>(
      builder: (context, state) {
        // Load notes on first build
        if (state is NotesInitial) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<NotesCubit>().loadNotes();
          });
        }
        return Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.all(isMobile ? 16 : 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              // Page header info
              Text(
                'Organize your thoughts and ideas',
                style: TextStyle(
                  fontSize: isMobile ? 14 : 16,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              
              AppSpacing.lg.verticalSpace,
              
              // Notes content based on state
              if (state is NotesLoading)
                const NotesLoadingShimmer()
              else if (state is NotesError)
                Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: AppSpacing.massive,
                        color: theme.colorScheme.error,
                      ),
                      AppSpacing.md.verticalSpace,
                      Text(
                        'Failed to load notes',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.error,
                        ),
                      ),
                      AppSpacing.sm.verticalSpace,
                      Text(
                        state.message,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                      AppSpacing.md.verticalSpace,
                      ElevatedButton(
                        onPressed: () => context.read<NotesCubit>().loadNotes(),
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                )
              else if (state is NotesLoaded)
                _buildNotesGrid(context, state, isMobile)
              else
                const NotesEmptyState(),
                ],
              ),
            ),
            
            // Floating Action Button (only show when there are notes)
            if (state is NotesLoaded && state.notes.isNotEmpty)
              Positioned(
                bottom: isMobile ? 16 : 24,
                right: isMobile ? 16 : 24,
                child: FloatingActionButton(
                  onPressed: () => _showAddNoteDialog(context),
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  child: const Icon(Icons.add),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildNotesGrid(BuildContext context, NotesLoaded state, bool isMobile) {
    if (state.notes.isEmpty) {
      return const NotesEmptyState();
    }

    // Use the same layout system for all screen sizes
    return _buildStandardGridLayout(context, state);
  }

  Widget _buildStandardGridLayout(BuildContext context, NotesLoaded state) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = _getCrossAxisCount(screenWidth);

    // Sort notes: pinned notes first, then unpinned
    final sortedNotes = [...state.notes]..sort((a, b) {
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      return 0;
    });

    return LayoutBuilder(
      builder: (context, constraints) {
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: sortedNotes.map((note) {
            final itemWidth = (constraints.maxWidth - (16 * (crossAxisCount - 1))) / crossAxisCount;
            
            return SizedBox(
              width: itemWidth,
              child: NotesListItem(
                note: note,
                onTap: () {
                  NoteDetailModal.show(context, note);
                },
                onEdit: () {
                  // TODO: Navigate to note edit
                },
                onDelete: () {
                  // TODO: Show delete confirmation
                },
                onTogglePin: () {
                  // TODO: Toggle pin status
                },
              ),
            );
          }).toList(),
        );
      },
    );
  }

  int _getCrossAxisCount(double screenWidth) {
    if (screenWidth < 600) {
      return 1; // Mobile: single column
    } else if (screenWidth < 900) {
      return 2; // Tablet: two columns
    } else if (screenWidth < 1200) {
      return 3; // Small desktop: three columns
    } else {
      return 4; // Large desktop: four columns
    }
  }
}
