import 'package:equatable/equatable.dart';

/// State for responsive sidebar
class ResponsiveSidebarState extends Equatable {
  /// Creates a [ResponsiveSidebarState].
  const ResponsiveSidebarState({this.hoveredItem});

  /// Currently hovered navigation item
  final String? hoveredItem;

  /// Creates a copy of this state with the given fields replaced
  ResponsiveSidebarState copyWith({String? hoveredItem}) {
    return ResponsiveSidebarState(hoveredItem: hoveredItem);
  }

  /// Clears the hovered item
  ResponsiveSidebarState clearHover() {
    return const ResponsiveSidebarState(hoveredItem: null);
  }

  @override
  List<Object?> get props => [hoveredItem];
}
