import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/user_utils.dart';
import '../../../dashboard/domain/services/activity_service.dart';
import '../../../dashboard/presentation/cubit/dashboard_cubit.dart';
import '../../domain/entities/note.dart';
import '../../domain/usecases/add_note_usecase.dart';
import '../../domain/usecases/delete_note_usecase.dart';
import '../../domain/usecases/get_notes_usecase.dart';
import '../../domain/usecases/update_note_usecase.dart';
import 'notes_state.dart';

/// Cubit for managing notes operations and state
class NotesCubit extends Cubit<NotesState> {
  /// Creates a new [NotesCubit].
  NotesCubit({
    required GetNotesUseCase getNotesUseCase,
    required CreateNoteUseCase createNoteUseCase,
    required UpdateNoteUseCase updateNoteUseCase,
    required DeleteNoteUseCase deleteNoteUseCase,
    ActivityService? activityService,
    DashboardCubit? dashboardCubit,
  }) : _getNotesUseCase = getNotesUseCase,
       _createNoteUseCase = createNoteUseCase,
       _updateNoteUseCase = updateNoteUseCase,
       _deleteNoteUseCase = deleteNoteUseCase,
       _activityService = activityService,
       _dashboardCubit = dashboardCubit,
       super(const NotesInitial());

  final GetNotesUseCase _getNotesUseCase;
  final CreateNoteUseCase _createNoteUseCase;
  final UpdateNoteUseCase _updateNoteUseCase;
  final DeleteNoteUseCase _deleteNoteUseCase;
  final ActivityService? _activityService;
  final DashboardCubit? _dashboardCubit;

  // Single source of truth
  List<Note> _allNotes = [];
  String _query = '';
  String? _selectedCategory;
  NoteSortBy _sortBy = NoteSortBy.recentlyUpdated;

  /// Gets all notes
  List<Note> get allNotes => _allNotes;

  /// Gets visible notes
  List<Note> get visibleNotes =>
      (state is NotesLoaded) ? (state as NotesLoaded).notes : [];

  /// Gets current query
  String get query => _query;

  /// Gets selected category
  String? get selectedCategory => _selectedCategory;

  /// Gets current sort
  NoteSortBy get sortBy => _sortBy;

  /// Loads all notes for the current user
  Future<void> loadNotes() async {
    try {
      emit(const NotesLoading());

      final notes = await _getNotesUseCase();

      _allNotes = notes;
      _query = '';
      _selectedCategory = null;
      _sortBy = NoteSortBy.recentlyUpdated;

      if (kDebugMode) {
        developer.log('Loaded ${notes.length} notes', name: 'NotesCubit');
      }

      _rebuildVisible();
    } catch (e) {
      if (kDebugMode) {
        developer.log('Error loading notes: $e', name: 'NotesCubit', error: e);
      }
      emit(NotesError(message: e.toString()));
    }
  }

  /// Rebuilds visible notes from all notes with current filters and sort
  void _rebuildVisible() {
    // Start from all notes
    var visible = List<Note>.from(_allNotes);

    // Apply search query on title and content
    if (_query.isNotEmpty) {
      final queryLower = _query.toLowerCase();
      visible = visible
          .where(
            (note) =>
                note.title.toLowerCase().contains(queryLower) ||
                note.content.toLowerCase().contains(queryLower) ||
                (note.category?.toLowerCase().contains(queryLower) ?? false),
          )
          .toList();
    }

    // Apply category filter
    if (_selectedCategory != null) {
      visible = visible
          .where(
            (note) =>
                note.category?.toLowerCase() ==
                _selectedCategory!.toLowerCase(),
          )
          .toList();
    }

    // Apply sorting
    switch (_sortBy) {
      case NoteSortBy.recentlyUpdated:
        visible.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        break;
      case NoteSortBy.oldestFirst:
        visible.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case NoteSortBy.titleAtoZ:
        visible.sort((a, b) => a.title.compareTo(b.title));
        break;
      case NoteSortBy.titleZtoA:
        visible.sort((a, b) => b.title.compareTo(a.title));
        break;
      case NoteSortBy.pinnedFirst:
        visible.sort((a, b) {
          if (a.isPinned != b.isPinned) {
            return a.isPinned ? -1 : 1;
          }
          return b.updatedAt.compareTo(a.updatedAt);
        });
        break;
    }

    emit(
      NotesLoaded(
        notes: visible,
        allNotes: _allNotes,
        query: _query.isEmpty ? null : _query,
        selectedCategory: _selectedCategory,
        sortBy: _sortBy,
      ),
    );
  }

  /// Creates a new note
  Future<void> createNote({
    required String title,
    required String content,
    required String category,
    required bool isPinned,
    String? imageBase64,
    String? imageName,
  }) async {
    try {
      final userId =
          await UserUtils.getCurrentUserId() ?? UserUtils.getDefaultUserId();

      final note = await _createNoteUseCase(
        CreateNoteParams(
          title: title,
          content: content,
          category: category,
          isPinned: isPinned,
          imageBase64: imageBase64,
          imageName: imageName,
        ),
      );

      // Log activity
      await _activityService?.logNoteCreated(userId, title, note.id);

      if (kDebugMode) {
        developer.log('[Activity] create $title', name: 'NotesCubit');
      }

      // Refresh dashboard stats and activities in real-time
      await _dashboardCubit?.refreshStats();

      // Reload notes to reflect changes
      await loadNotes();
    } catch (e) {
      if (kDebugMode) {
        developer.log('Error creating note: $e', name: 'NotesCubit', error: e);
      }
      emit(NotesError(message: e.toString()));
    }
  }

  /// Updates an existing note
  Future<void> updateNote({
    required String id,
    required String title,
    required String content,
    required String category,
    required bool isPinned,
    String? imageBase64,
    String? imageName,
  }) async {
    try {
      final userId =
          await UserUtils.getCurrentUserId() ?? UserUtils.getDefaultUserId();

      await _updateNoteUseCase(
        UpdateNoteParams(
          id: id,
          title: title,
          content: content,
          category: category,
          isPinned: isPinned,
          imageBase64: imageBase64,
          imageName: imageName,
        ),
      );

      // Log activity
      await _activityService?.logNoteUpdated(userId, title, id);

      if (kDebugMode) {
        developer.log('[Activity] update $title', name: 'NotesCubit');
      }

      // Refresh dashboard stats and activities in real-time
      await _dashboardCubit?.refreshStats();

      // Reload notes to reflect changes
      await loadNotes();
    } catch (e) {
      if (kDebugMode) {
        developer.log('Error updating note: $e', name: 'NotesCubit', error: e);
      }
      emit(NotesError(message: e.toString()));
    }
  }

  /// Deletes a note
  Future<void> deleteNote(String noteId) async {
    try {
      final userId =
          await UserUtils.getCurrentUserId() ?? UserUtils.getDefaultUserId();

      // Get the note title before deleting (for activity logging)
      String noteTitle = 'Note';
      if (state is NotesLoaded) {
        final currentNotes = (state as NotesLoaded).notes;
        final noteIndex = currentNotes.indexWhere((n) => n.id == noteId);
        if (noteIndex != -1) {
          noteTitle = currentNotes[noteIndex].title;
        }
      }

      await _deleteNoteUseCase(noteId);

      // Log activity
      await _activityService?.logNoteDeleted(userId, noteTitle);

      if (kDebugMode) {
        developer.log('[Activity] delete $noteTitle', name: 'NotesCubit');
      }

      // Refresh dashboard stats and activities in real-time
      await _dashboardCubit?.refreshStats();

      // Reload notes to reflect changes
      await loadNotes();
    } catch (e) {
      if (kDebugMode) {
        developer.log('Error deleting note: $e', name: 'NotesCubit', error: e);
      }
      emit(NotesError(message: e.toString()));
    }
  }

  /// Toggles the pinned state of a note (alias for togglePinned)
  Future<void> togglePinNote(String noteId) async {
    if (state is NotesLoaded) {
      final currentNotes = (state as NotesLoaded).notes;
      final noteIndex = currentNotes.indexWhere((n) => n.id == noteId);

      if (noteIndex != -1) {
        final note = currentNotes[noteIndex];
        await togglePinned(noteId, note.isPinned);
      }
    }
  }

  /// Toggles the pinned state of a note
  Future<void> togglePinned(String noteId, bool currentPinned) async {
    try {
      final userId =
          await UserUtils.getCurrentUserId() ?? UserUtils.getDefaultUserId();

      if (state is NotesLoaded) {
        final currentNotes = (state as NotesLoaded).notes;
        final noteIndex = currentNotes.indexWhere((n) => n.id == noteId);

        if (noteIndex != -1) {
          final note = currentNotes[noteIndex];

          await _updateNoteUseCase(
            UpdateNoteParams(
              id: noteId,
              title: note.title,
              content: note.content,
              category: note.category,
              isPinned: !currentPinned,
            ),
          );

          // Log activity
          if (currentPinned) {
            await _activityService?.logNoteUnpinned(userId, note.title, noteId);
            if (kDebugMode) {
              print('[Activity] unpin ${note.title} ${DateTime.now()}');
            }
          } else {
            await _activityService?.logNotePinned(userId, note.title, noteId);
            if (kDebugMode) {
              print('[Activity] pin ${note.title} ${DateTime.now()}');
            }
          }

          // Refresh dashboard stats and activities in real-time
          await _dashboardCubit?.refreshStats();

          // Reload notes to reflect changes
          await loadNotes();
        }
      }
    } catch (e) {
      if (kDebugMode) {
        developer.log('Error toggling pin: $e', name: 'NotesCubit', error: e);
      }
      emit(NotesError(message: e.toString()));
    }
  }

  /// Searches notes based on query
  void searchNotes(String query) {
    _query = query;
    _rebuildVisible();
  }

  /// Filters notes by category
  void filterByCategory(String? category) {
    _selectedCategory = category;
    _rebuildVisible();
  }

  /// Clears filter
  void clearFilter() {
    _selectedCategory = null;
    _rebuildVisible();
  }

  /// Sorts notes by different criteria
  void sortNotes(NoteSortBy sortBy) {
    _sortBy = sortBy;
    _rebuildVisible();
  }

  /// Resets all filters and search
  void resetFilters() {
    _query = '';
    _selectedCategory = null;
    _sortBy = NoteSortBy.recentlyUpdated;
    _rebuildVisible();
  }

  /// Resets all filters, search, and sort
  void resetAll() {
    resetFilters();
  }
}

/// Enum for sorting options
enum NoteSortBy {
  /// Sort by most recently updated
  recentlyUpdated,

  /// Sort by oldest first
  oldestFirst,

  /// Sort by title A to Z
  titleAtoZ,

  /// Sort by title Z to A
  titleZtoA,

  /// Sort with pinned notes first
  pinnedFirst,
}
