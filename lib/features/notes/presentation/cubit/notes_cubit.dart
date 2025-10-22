import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/services/mock_notes_service.dart';
import '../../domain/entities/note.dart';
import 'notes_state.dart';

/// Cubit for managing notes state and operations
class NotesCubit extends Cubit<NotesState> {
  NotesCubit() : super(const NotesInitial());

  /// Load all notes
  Future<void> loadNotes() async {
    try {
      emit(const NotesLoading());
      final notes = await MockNotesService.getAllNotes();
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

      await MockNotesService.createNote(
        title: title,
        content: content,
        category: category,
        isPinned: isPinned,
        color: color,
      );

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

      await MockNotesService.updateNote(
        id: id,
        title: title,
        content: content,
        category: category,
        isPinned: isPinned,
        color: color,
      );

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

      final success = await MockNotesService.deleteNote(id);
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
      final notes = await MockNotesService.searchNotes(query);
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
      final notes = await MockNotesService.getNotesByCategory(category);
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
      } else {
        emit(const NotesOperationInProgress(operation: 'Updating note...'));
      }

      await MockNotesService.togglePinNote(id);

      // Reload all notes to get the updated list
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
      return await MockNotesService.getNoteById(id);
    } catch (e) {
      return null;
    }
  }

  /// Get all available categories
  Future<List<String>> getCategories() async {
    try {
      return await MockNotesService.getCategories();
    } catch (e) {
      return [];
    }
  }
}
