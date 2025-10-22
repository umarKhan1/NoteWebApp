import '../../domain/entities/note.dart';

/// Abstract base class for all notes states
abstract class NotesState {
  const NotesState();
}

/// Initial state when the notes feature is first loaded
class NotesInitial extends NotesState {
  const NotesInitial();
}

/// State when notes are being loaded
class NotesLoading extends NotesState {
  const NotesLoading();
}

/// State when notes are successfully loaded
class NotesLoaded extends NotesState {
  /// List of notes
  final List<Note> notes;
  
  /// Optional search query if filtering is applied
  final String? searchQuery;
  
  /// Optional category filter
  final String? categoryFilter;

  const NotesLoaded({
    required this.notes,
    this.searchQuery,
    this.categoryFilter,
  });

  /// Create a copy of this state with updated values
  NotesLoaded copyWith({
    List<Note>? notes,
    String? searchQuery,
    String? categoryFilter,
    bool clearSearchQuery = false,
    bool clearCategoryFilter = false,
  }) {
    return NotesLoaded(
      notes: notes ?? this.notes,
      searchQuery: clearSearchQuery ? null : (searchQuery ?? this.searchQuery),
      categoryFilter: clearCategoryFilter ? null : (categoryFilter ?? this.categoryFilter),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is NotesLoaded &&
        other.notes == notes &&
        other.searchQuery == searchQuery &&
        other.categoryFilter == categoryFilter;
  }

  @override
  int get hashCode => notes.hashCode ^ searchQuery.hashCode ^ categoryFilter.hashCode;
}

/// State when there's an error loading or managing notes
class NotesError extends NotesState {
  /// Error message
  final String message;
  
  /// Optional error details for debugging
  final String? details;

  const NotesError({
    required this.message,
    this.details,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is NotesError &&
        other.message == message &&
        other.details == details;
  }

  @override
  int get hashCode => message.hashCode ^ details.hashCode;
}

/// State when a note operation (create, update, delete) is in progress
class NotesOperationInProgress extends NotesState {
  /// Current notes list (if available)
  final List<Note>? notes;
  
  /// Type of operation being performed
  final String operation;

  const NotesOperationInProgress({
    this.notes,
    required this.operation,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is NotesOperationInProgress &&
        other.notes == notes &&
        other.operation == operation;
  }

  @override
  int get hashCode => notes.hashCode ^ operation.hashCode;
}
