import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../shared/widgets/responsive_sidebar.dart';
import '../cubit/notes_cubit.dart';
import '../cubit/notes_state.dart';
import '../cubit/notes_ui_cubit.dart';
import '../cubit/notes_ui_state.dart';
import '../widgets/note_detail/note_detail_modal.dart';
import '../widgets/notes_list/notes_empty_state.dart';
import '../widgets/notes_list/notes_list_item.dart';
import '../widgets/notes_list/notes_loading_shimmer.dart';

/// Notes list page displaying all user notes
class NotesListPage extends StatelessWidget {
  // ignore: public_member_api_docs
  const NotesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _NotesView();
  }
}

class _NotesView extends StatefulWidget {
  const _NotesView();

  @override
  State<_NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<_NotesView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // Load notes when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotesCubit>().loadNotes();
      
      // Initialize sidebar state based on screen size
      final screenWidth = MediaQuery.of(context).size.width;
      context.read<NotesUiCubit>().initializeSidebar(screenWidth);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final showSidebar = !isMobile;

    return BlocBuilder<NotesUiCubit, NotesUiState>(
      builder: (context, uiState) {
          return Scaffold(
            key: _scaffoldKey,
            backgroundColor: theme.colorScheme.surface,
            drawer: isMobile 
              ? Drawer(
                  child: ResponsiveSidebar(
                    isExpanded: true,
                    currentPath: '/notes',
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
                    currentPath: '/notes',
                    onToggle: () => context.read<NotesUiCubit>().toggleSidebar(),
                  ),
                
                // Main Content
                Expanded(
                  child: Column(
                    children: [
                      // Header
                      _buildNotesHeader(isMobile),
                      
                      // Content
                      Expanded(
                        child: _buildNotesContent(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
  }

  Widget _buildNotesHeader(bool isMobile) {
    final theme = Theme.of(context);
    
    return Container(
      height: 70,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 24, 
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Menu button for mobile
          if (isMobile) ...[
            IconButton(
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              icon: Icon(
                Icons.menu,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(width: 8),
          ],
          
          // Title
          Text(
            AppStrings.notes,
            style: TextStyle(
              fontSize: isMobile ? 16 : 18,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          
          const Spacer(),
          
          // Actions
          IconButton(
            onPressed: () {
              // TODO: Implement search
            },
            icon: Icon(
              Icons.search,
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {
              // TODO: Implement add note
            },
            icon: Icon(
              Icons.add,
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesContent() {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          AppStrings.notesTitle,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            onPressed: () {
          
            },
          ),
          IconButton(
            icon: Icon(
              Icons.filter_list,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            onPressed: () {
        
            },
          ),
        ],
      ),
      body: BlocBuilder<NotesCubit, NotesState>(
        builder: (context, state) {
          if (state is NotesInitial || state is NotesLoading) {
            return const NotesLoadingShimmer();
          }
          
          if (state is NotesError) {
            return _buildErrorState(context, state);
          }
          
          if (state is NotesLoaded) {
            if (state.notes.isEmpty) {
              return const NotesEmptyState();
            }
            
            return buildNotesGrid(context, state);
          }
          
          if (state is NotesOperationInProgress && state.notes != null) {
            return buildNotesGrid(context, NotesLoaded(notes: state.notes!));
          }
          
          return const NotesLoadingShimmer();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
        
          _showAddNoteDialog(context);
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, NotesError state) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 15.w,
              color: Theme.of(context).colorScheme.error,
            ),
            SizedBox(height: 2.h),
            Text(
              state.message,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            ElevatedButton(
              onPressed: () {
                context.read<NotesCubit>().loadNotes();
              },
              child: const Text(AppStrings.tryAgain),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNotesGrid(BuildContext context, NotesLoaded state) {
    final isTablet = Device.screenType == ScreenType.tablet;
    final crossAxisCount = isTablet ? 3 : 2;
    
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<NotesCubit>().loadNotes();
      },
      child: Padding(
        padding: EdgeInsets.all(2.w),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 2.w,
            mainAxisSpacing: 2.w,
            childAspectRatio: isTablet ? 1.2 : 0.8,
          ),
          itemCount: state.notes.length,
          itemBuilder: (context, index) {
            final note = state.notes[index];
            return NotesListItem(
              note: note,
              onTap: () {
                NoteDetailModal.show(context, note);
              },
              onEdit: () {
              
              },
              onDelete: () {
                _showDeleteConfirmation(context, note.id, note.title);
              },
              onTogglePin: () {
                context.read<NotesCubit>().togglePinNote(note.id);
              },
            );
          },
        ),
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

  void showEditNoteDialog(BuildContext context, note) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Note'),
        content: const Text('Edit note functionality will be implemented soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String noteId, String noteTitle) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Note'),
        content: Text('Are you sure you want to delete "$noteTitle"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<NotesCubit>().deleteNote(noteId);
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
