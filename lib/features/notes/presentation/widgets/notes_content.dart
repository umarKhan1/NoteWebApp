import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/base/base_stateless_widget.dart';
import '../../../../shared/extensions/widget_extensions.dart';
import '../cubit/notes_cubit.dart';
import '../cubit/notes_state.dart';
import '../widgets/notes_list/notes_empty_state.dart';
import '../widgets/notes_list/notes_list_item.dart';
import '../widgets/notes_list/notes_loading_shimmer.dart';

/// Notes content widget without shell/sidebar
class NotesContent extends BaseStatelessWidget {
  /// Creates a [NotesContent].
  const NotesContent({super.key});

  @override
  Widget build(BuildContext context) {
    final responsiveInfo = getResponsiveInfo(context);
    final theme = getTheme(context);
    final isMobile = responsiveInfo.isMobile;
    
    return BlocBuilder<NotesCubit, NotesState>(
      builder: (context, state) {
        return SingleChildScrollView(
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
        );
      },
    );
  }

  Widget _buildNotesGrid(BuildContext context, NotesLoaded state, bool isMobile) {
    if (state.notes.isEmpty) {
      return const NotesEmptyState();
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isMobile ? 1 : (context.mounted ? 
          (MediaQuery.of(context).size.width > 1200 ? 3 : 2) : 2),
        childAspectRatio: isMobile ? 4 : 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: state.notes.length,
      itemBuilder: (context, index) {
        final note = state.notes[index];
        return NotesListItem(
          note: note,
          onTap: () {
            // TODO: Navigate to note detail
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
        );
      },
    );
  }
}
