import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/user_utils.dart';
import '../../data/repositories/notes_repository_impl.dart';
import '../../domain/entities/note.dart';
import '../../domain/usecases/add_note_usecase.dart';
import '../../domain/usecases/delete_note_usecase.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../domain/usecases/get_note_by_id_usecase.dart';
import '../../domain/usecases/get_notes_by_category_usecase.dart';
import '../../domain/usecases/get_notes_usecase.dart';
import '../../domain/usecases/search_notes_usecase.dart';
import '../../domain/usecases/toggle_pin_note_usecase.dart';
import '../../domain/usecases/update_note_usecase.dart';
import '../../../dashboard/domain/services/activity_service.dart';
import '../../../dashboard/presentation/cubit/dashboard_cubit.dart';
import 'notes_state.dart';

/// Cubit for managing notes state and operations.
/// 
/// This cubit handles all notes-related business logic including
/// CRUD operations, searching, filtering, and state management
/// using the clean architecture pattern with use cases.
/// 
/// It also integrates with ActivityService to track note operations
/// for the admin dashboard.
class NotesCubit extends Cubit<NotesState> {
  // Use cases for notes operations
  late final GetNotesUseCase _getNotesUseCase;
  late final CreateNoteUseCase _createNoteUseCase;
  late final UpdateNoteUseCase _updateNoteUseCase;
  late final DeleteNoteUseCase _deleteNoteUseCase;
  late final SearchNotesUseCase _searchNotesUseCase;
  late final GetNoteByIdUseCase _getNoteByIdUseCase;
  late final GetNotesByCategoryUseCase _getNotesByCategoryUseCase;
  late final TogglePinNoteUseCase _togglePinNoteUseCase;
  late final GetCategoriesUseCase _getCategoriesUseCase;
  
  // Activity service for tracking operations
  final ActivityService? _activityService;
  
  // Dashboard cubit for refreshing activities
  final DashboardCubit? _dashboardCubit;
  
  /// Static callback to refresh dashboard after note operations (fallback)
  static Future<void> Function()? onNoteOperationCompleted;

  /// Creates a new instance of [NotesCubit]
  /// 
  /// Accepts optional [ActivityService] for activity tracking and [DashboardCubit] for refreshing.
  /// Initializes with [NotesInitial] state and sets up all use cases
  /// with the repository implementation.
  NotesCubit({
    ActivityService? activityService,
    DashboardCubit? dashboardCubit,
  }) 
      : _activityService = activityService,
        _dashboardCubit = dashboardCubit,
        super(const NotesInitial()) {
    // Initialize use cases with repository
    final repository = NotesRepositoryImpl();
    _getNotesUseCase = GetNotesUseCase(repository);
    _createNoteUseCase = CreateNoteUseCase(repository);
    _updateNoteUseCase = UpdateNoteUseCase(repository);
    _deleteNoteUseCase = DeleteNoteUseCase(repository);
    _searchNotesUseCase = SearchNotesUseCase(repository);
    _getNoteByIdUseCase = GetNoteByIdUseCase(repository);
    _getNotesByCategoryUseCase = GetNotesByCategoryUseCase(repository);
    _togglePinNoteUseCase = TogglePinNoteUseCase(repository);
    _getCategoriesUseCase = GetCategoriesUseCase(repository);
  }

  /// Load all notes
  Future<void> loadNotes() async {
    try {
      emit(const NotesLoading());
      final notes = await _getNotesUseCase();
      emit(NotesLoaded(notes: notes));
    } catch (e) {
      emit(NotesError(
        message: 'Failed to load notes',
        details: e.toString(),
      ));
    }
  }

  /// Create a new note and log activity
  Future<void> createNote({
    required String title,
    required String content,
    String? category,
    bool isPinned = false,
    String? color,
  }) async {
    try {
      final currentState = state;
      List<Note> currentNotes = [];
      
      if (currentState is NotesLoaded) {
        currentNotes = currentState.notes;
        emit(NotesOperationInProgress(
          notes: currentNotes,
          operation: 'Creating note...',
        ));
      } else {
        emit(const NotesOperationInProgress(operation: 'Creating note...'));
      }

      await _createNoteUseCase(CreateNoteParams(
        title: title,
        content: content,
        category: category,
        isPinned: isPinned,
        color: color,
      ));

      // Log activity if service is available
      await _logNoteCreatedActivity(title);

      // Reload all notes to get the updated list
      await loadNotes();
      
      // Refresh dashboard to show new activity
      await _refreshDashboard();
    } catch (e) {
      emit(NotesError(
        message: 'Failed to create note',
        details: e.toString(),
      ));
    }
  }

  /// Helper to refresh dashboard from anywhere
  Future<void> _refreshDashboard() async {
    try {
      // Use injected DashboardCubit first, then fallback to callback
      if (_dashboardCubit != null) {
        await _dashboardCubit.refreshActivities();
      } else if (onNoteOperationCompleted != null) {
        await onNoteOperationCompleted!.call();
      }
      // Small delay to ensure state propagates in web
      await Future.delayed(const Duration(milliseconds: 100));
    } catch (e) {
      if (kDebugMode) print('[Activity] Refresh error: $e');
    }
  }

  /// Update an existing note and log activity
  Future<void> updateNote({
    required String id,
    String? title,
    String? content,
    String? category,
    bool? isPinned,
    String? color,
  }) async {
    try {
      final currentState = state;
      if (currentState is NotesLoaded) {
        emit(NotesOperationInProgress(
          notes: currentState.notes,
          operation: 'Updating note...',
        ));
      } else {
        emit(const NotesOperationInProgress(operation: 'Updating note...'));
      }

      // Get the note before updating to get its title
      final oldNote = await _getNoteByIdUseCase(id);

      await _updateNoteUseCase(UpdateNoteParams(
        id: id,
        title: title,
        content: content,
        category: category,
        isPinned: isPinned,
        color: color,
      ));

      // Log activity if service is available
      final noteTitle = title ?? oldNote?.title ?? 'Unknown';
      await _logNoteUpdatedActivity(noteTitle, id);

      // Reload all notes to get the updated list
      await loadNotes();
      
      // Refresh dashboard to show updated activity
      await _refreshDashboard();
    } catch (e) {
      emit(NotesError(
        message: 'Failed to update note',
        details: e.toString(),
      ));
    }
  }

  /// Delete a note and log activity
  Future<void> deleteNote(String id) async {
    try {
      final currentState = state;
      if (currentState is NotesLoaded) {
        emit(NotesOperationInProgress(
          notes: currentState.notes,
          operation: 'Deleting note...',
        ));
      } else {
        emit(const NotesOperationInProgress(operation: 'Deleting note...'));
      }

      // Get the note before deleting to get its title
      final note = await _getNoteByIdUseCase(id);

      final success = await _deleteNoteUseCase(id);
      if (!success) {
        throw Exception('Note not found');
      }

      // Log activity if service is available
      final noteTitle = note?.title ?? 'Unknown';
      await _logNoteDeletedActivity(noteTitle, id);

      // Reload all notes to get the updated list
      await loadNotes();
      
      // Refresh dashboard to show deleted activity
      await _refreshDashboard();
    } catch (e) {
      emit(NotesError(
        message: 'Failed to delete note',
        details: e.toString(),
      ));
    }
  }

  /// Search notes by query
  Future<void> searchNotes(String query) async {
    try {
      emit(const NotesLoading());
      final notes = await _searchNotesUseCase(query);
      emit(NotesLoaded(
        notes: notes,
        searchQuery: query.isEmpty ? null : query,
      ));
    } catch (e) {
      emit(NotesError(
        message: 'Failed to search notes',
        details: e.toString(),
      ));
    }
  }

  /// Filter notes by category
  Future<void> filterByCategory(String category) async {
    try {
      emit(const NotesLoading());
      final notes = await _getNotesByCategoryUseCase(category);
      emit(NotesLoaded(
        notes: notes,
        categoryFilter: category,
      ));
    } catch (e) {
      emit(NotesError(
        message: 'Failed to filter notes by category',
        details: e.toString(),
      ));
    }
  }

  /// Toggle pin status of a note and log activity
  Future<void> togglePinNote(String id) async {
    try {
      final currentState = state;
      if (currentState is NotesLoaded) {
        emit(NotesOperationInProgress(
          notes: currentState.notes,
          operation: 'Updating note...',
        ));
      }

      // Get the note before toggling to get its title and current pin state
      final note = await _getNoteByIdUseCase(id);
      final isPinning = !(note?.isPinned ?? false);

      await _togglePinNoteUseCase(id);

      // Log activity if service is available
      final noteTitle = note?.title ?? 'Unknown';
      if (isPinning) {
        await _logNotePinnedActivity(noteTitle, id);
      } else {
        await _logNoteUnpinnedActivity(noteTitle, id);
      }

      await loadNotes();
      
      // Refresh dashboard to show pin/unpin activity
      await _refreshDashboard();
    } catch (e) {
      emit(NotesError(
        message: 'Failed to update note',
        details: e.toString(),
      ));
    }
  }

  /// Clear any filters and show all notes
  Future<void> clearFilters() async {
    await loadNotes();
  }

  /// Get a specific note by ID (for editing)
  Future<Note?> getNoteById(String id) async {
    try {
      return await _getNoteByIdUseCase(id);
    } catch (e) {
      return null;
    }
  }

  /// Get all available categories
  Future<List<String>> getCategories() async {
    try {
      return await _getCategoriesUseCase();
    } catch (e) {
      return [];
    }
  }

  // ============= Activity Logging Methods =============

  /// Log note created activity
  Future<void> _logNoteCreatedActivity(String noteTitle) async {
    if (_activityService == null) return;
    
    try {
      final userId = await UserUtils.getCurrentUserId() ?? 
                     UserUtils.getDefaultUserId();
      final noteId = DateTime.now().millisecondsSinceEpoch.toString();
      await _activityService.logNoteCreated(userId, noteTitle, noteId);
    } catch (e) {
      if (kDebugMode) print('[Activity] Error logging create: $e');
    }
  }

  /// Log note updated activity
  Future<void> _logNoteUpdatedActivity(String noteTitle, String noteId) async {
    if (_activityService == null) return;
    
    try {
      final userId = await UserUtils.getCurrentUserId() ?? 
                     UserUtils.getDefaultUserId();
      await _activityService.logNoteUpdated(userId, noteTitle, noteId);
    } catch (e) {
      if (kDebugMode) print('[Activity] Error logging update: $e');
    }
  }

  /// Log note deleted activity
  Future<void> _logNoteDeletedActivity(String noteTitle, String noteId) async {
    if (_activityService == null) return;
    
    try {
      final userId = await UserUtils.getCurrentUserId() ?? 
                     UserUtils.getDefaultUserId();
      await _activityService.logNoteDeleted(userId, noteTitle);
    } catch (e) {
      if (kDebugMode) print('[Activity] Error logging delete: $e');
    }
  }

  /// Log note pinned activity
  Future<void> _logNotePinnedActivity(String noteTitle, String noteId) async {
    if (_activityService == null) return;
    
    try {
      final userId = await UserUtils.getCurrentUserId() ?? 
                     UserUtils.getDefaultUserId();
      await _activityService.logNotePinned(userId, noteTitle, noteId);
    } catch (e) {
      if (kDebugMode) print('[Activity] Error logging pin: $e');
    }
  }

  /// Log note unpinned activity
  Future<void> _logNoteUnpinnedActivity(String noteTitle, String noteId) async {
    if (_activityService == null) return;
    
    try {
      final userId = await UserUtils.getCurrentUserId() ?? 
                     UserUtils.getDefaultUserId();
      await _activityService.logNoteUnpinned(userId, noteTitle, noteId);
    } catch (e) {
      if (kDebugMode) print('[Activity] Error logging unpin: $e');
    }
  }
}
