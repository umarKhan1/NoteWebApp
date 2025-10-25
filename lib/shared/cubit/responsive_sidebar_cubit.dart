import 'package:flutter_bloc/flutter_bloc.dart';

import 'responsive_sidebar_state.dart';

/// Cubit for managing responsive sidebar state
class ResponsiveSidebarCubit extends Cubit<ResponsiveSidebarState> {
  /// Creates a new instance of [ResponsiveSidebarCubit]
  ResponsiveSidebarCubit() : super(const ResponsiveSidebarState());

  /// Sets the hovered navigation item
  void setHoveredItem(String item) {
    emit(state.copyWith(hoveredItem: item));
  }

  /// Clears the hovered navigation item
  void clearHoveredItem() {
    emit(state.clearHover());
  }
}
