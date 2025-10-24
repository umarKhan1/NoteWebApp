import 'package:flutter_bloc/flutter_bloc.dart';

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
import 'notes_state.dart';

/// Cubit for managing notes state and operations.
/// 
/// This cubit handles all notes-related business logic including
/// CRUD operations, searching, filtering, and state management
/// using the clean architecture pattern with use cases.
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

  /// Creates a new instance of [NotesCubit]
  /// 
  /// Initializes with [NotesInitial] state and sets up all use cases
  /// with the repository implementation.
  NotesCubit() : super(const NotesInitial()) {
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

  /// Create a new note
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

      // Reload all notes to get the updated list
      await loadNotes();
    } catch (e) {
      emit(NotesError(
        message: 'Failed to create note',
        details: e.toString(),
      ));
    }
  }

  /// Update an existing note
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

      await _updateNoteUseCase(UpdateNoteParams(
        id: id,
        title: title,
        content: content,
        category: category,
        isPinned: isPinned,
        color: color,
      ));

      // Reload all notes to get the updated list
      await loadNotes();
    } catch (e) {
      emit(NotesError(
        message: 'Failed to update note',
        details: e.toString(),
      ));
    }
  }

  /// Delete a note
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

      final success = await _deleteNoteUseCase(id);
      if (!success) {
        throw Exception('Note not found');
      }

      // Reload all notes to get the updated list
      await loadNotes();
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

  /// Toggle pin status of a note
  Future<void> togglePinNote(String id) async {
    try {
      final currentState = state;
      if (currentState is NotesLoaded) {
        emit(NotesOperationInProgress(
          notes: currentState.notes,
          operation: 'Updating note...',
        ));
      }

      await _togglePinNoteUseCase(id);
      await loadNotes();
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
}
