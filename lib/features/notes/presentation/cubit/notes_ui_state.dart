import 'package:equatable/equatable.dart';

/// State for notes UI
class NotesUiState extends Equatable {
  /// Creates a [NotesUiState].
  const NotesUiState({
    this.sidebarExpanded = true,
  });

  /// Whether the sidebar is expanded
  final bool sidebarExpanded;

  /// Creates a copy of this state with the given fields replaced
  NotesUiState copyWith({
    bool? sidebarExpanded,
  }) {
    return NotesUiState(
      sidebarExpanded: sidebarExpanded ?? this.sidebarExpanded,
    );
  }

  @override
  List<Object?> get props => [sidebarExpanded];
}
