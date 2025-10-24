import '../../domain/entities/note.dart';

/// Abstract base class for all notes states.
/// 
/// This class serves as the foundation for all possible states
/// in the notes feature, following the BLoC pattern.
abstract class NotesState {
  /// Creates a new notes state
  const NotesState();
}

/// Initial state when the notes feature is first loaded.
/// 
/// This represents the state before any notes data has been loaded
/// or any operations have been performed.
class NotesInitial extends NotesState {
  /// Creates a new initial notes state
  const NotesInitial();
}

/// State when notes are being loaded.
/// 
/// This state indicates that a notes operation is in progress,
/// such as fetching notes from the repository.
class NotesLoading extends NotesState {
  /// Creates a new loading notes state
  const NotesLoading();
}

/// State when notes are successfully loaded.
/// 
/// This state contains the loaded notes data and any applied filters
/// such as search queries or category filters.
class NotesLoaded extends NotesState {
  /// List of loaded notes
  final List<Note> notes;
  
  /// Optional search query if filtering is applied
  final String? searchQuery;
  
  /// Optional category filter
  final String? categoryFilter;

  /// Creates a new loaded notes state
  const NotesLoaded({
    required this.notes,
    this.searchQuery,
    this.categoryFilter,
  });

  /// Create a copy of this state with updated values
  /// 
  /// This method allows for immutable state updates by creating
  /// a new instance with modified properties.
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

/// State when there's an error loading or managing notes.
/// 
/// This state represents any error condition that occurs during
/// notes operations, including loading, creating, updating, or deleting notes.
class NotesError extends NotesState {
  /// Error message for display to the user
  final String message;
  
  /// Optional error details for debugging purposes
  final String? details;

  /// Creates a new error notes state
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

/// State when a note operation (create, update, delete) is in progress.
/// 
/// This state maintains the current notes list while indicating that
/// an operation is being performed in the background.
class NotesOperationInProgress extends NotesState {
  /// Current notes list (if available)
  final List<Note>? notes;
  
  /// Type of operation being performed
  final String operation;

  /// Creates a new operation in progress state
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
