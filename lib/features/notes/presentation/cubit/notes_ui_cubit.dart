import 'package:flutter_bloc/flutter_bloc.dart';

import 'notes_ui_state.dart';

/// Cubit for managing notes UI state
class NotesUiCubit extends Cubit<NotesUiState> {
  /// Creates a new [NotesUiCubit].
  NotesUiCubit() : super(const NotesUiState());

  /// Toggles sidebar expanded state
  void toggleSidebar() {
    emit(state.copyWith(sidebarExpanded: !state.sidebarExpanded));
  }

  /// Sets sidebar expanded state based on screen size
  void setSidebarExpanded(bool expanded) {
    emit(state.copyWith(sidebarExpanded: expanded));
  }

  /// Initializes sidebar state based on screen width
  void initializeSidebar(double screenWidth) {
    final shouldExpand = screenWidth >= 1200;
    emit(state.copyWith(sidebarExpanded: shouldExpand));
  }
}
