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
/// such as search queries or filter operations.
class NotesLoaded extends NotesState {
  /// Creates a new loaded notes state
  const NotesLoaded({
    required this.notes,
    List<Note>? allNotes,
    this.query,
    this.selectedCategory,
    this.sortBy,
  }) : allNotes = allNotes ?? const [];

  /// All notes (never modified by search/filter)
  final List<Note> allNotes;

  /// Visible notes after applying search, filter, and sort
  final List<Note> notes;

  /// Current search query
  final String? query;

  /// Selected category for filter
  final String? selectedCategory;

  /// Current sort option
  final Object? sortBy;

  /// Create a copy of this state with updated values
  NotesLoaded copyWith({
    List<Note>? notes,
    List<Note>? allNotes,
    String? query,
    String? selectedCategory,
    Object? sortBy,
    bool clearQuery = false,
    bool clearFilter = false,
  }) {
    return NotesLoaded(
      notes: notes ?? this.notes,
      allNotes: allNotes ?? this.allNotes,
      query: clearQuery ? null : (query ?? this.query),
      selectedCategory: clearFilter
          ? null
          : (selectedCategory ?? this.selectedCategory),
      sortBy: sortBy ?? this.sortBy,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NotesLoaded &&
        other.notes == notes &&
        other.allNotes == allNotes &&
        other.query == query &&
        other.selectedCategory == selectedCategory &&
        other.sortBy == sortBy;
  }

  @override
  int get hashCode =>
      notes.hashCode ^
      allNotes.hashCode ^
      query.hashCode ^
      selectedCategory.hashCode ^
      sortBy.hashCode;
}

/// State when there's an error loading or managing notes.
///
/// This state represents any error condition that occurs during
/// notes operations, including loading, creating, updating, or deleting notes.
class NotesError extends NotesState {
  /// Creates a new error notes state
  const NotesError({required this.message, this.details});

  /// Error message for display to the user
  final String message;

  /// Optional error details for debugging purposes
  final String? details;

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
  /// Creates a new operation in progress state
  const NotesOperationInProgress({this.notes, required this.operation});

  /// Current notes list (if available)
  final List<Note>? notes;

  /// Type of operation being performed
  final String operation;

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
