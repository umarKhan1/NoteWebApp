import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/notes/presentation/cubit/notes_cubit.dart';
import '../../features/notes/presentation/widgets/category_filter_popover.dart';
import '../../features/notes/presentation/widgets/sort_popover.dart';
import 'responsive_sidebar.dart';
/// Main shell widget with responsive sidebar and header
class MainShell extends StatefulWidget {
  /// Creates a [MainShell].
  const MainShell({
    super.key,
    required this.child,
  });
  /// The child widget to display in the main content area.
  final Widget child;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  bool _isTabletSidebarExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;

    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1200;
    final showSidebar = !isMobile;

    const double desktopSidebarWidth = 280;
    const double tabletCollapsedWidth = 88;
    const double tabletExpandedWidth = 260;
    final double sidebarWidth = isTablet
        ? (_isTabletSidebarExpanded ? tabletExpandedWidth : tabletCollapsedWidth)
        : desktopSidebarWidth;

    final currentPath = GoRouterState.of(context).uri.path;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      restorationId: 'main_scaffold',
      drawerEnableOpenDragGesture: isMobile,
      drawerEdgeDragWidth: isMobile ? 24 : 0,
      drawer: isMobile
          ? SizedBox(
              width: size.width * 0.86,
              child: Drawer(
                backgroundColor: theme.colorScheme.surface,
                child: SafeArea(
                  child: ResponsiveSidebar(
                    isExpanded: true,
                    currentPath: currentPath,
                    onToggle: () {
                      Scaffold.maybeOf(context)?.closeDrawer();
                    },
                  ),
                ),
              ),
            )
          : null,
      body: SafeArea(
        child: Row(
          children: [
            if (showSidebar)
              SizedBox(
                width: sidebarWidth,
                // keep it simple and bounded to avoid layout asserts
                child: ResponsiveSidebar(
                  isExpanded: isTablet ? _isTabletSidebarExpanded : true,
                  currentPath: currentPath,
                  onToggle: isTablet
                      ? () {
                          setState(() {
                            _isTabletSidebarExpanded = !_isTabletSidebarExpanded;
                          });
                        }
                      : null,
                ),
              ),
            Expanded(
              child: Column(
                children: [
                  _buildHeader(context, isMobile, currentPath),
                  Expanded(child: widget.child),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isMobile, String currentPath) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 768 && screenWidth < 1200;

    String pageTitle = 'Dashboard';
    if (currentPath.contains('/notes')) {
      pageTitle = 'All Notes';
    }

    return Container(
      height: 70,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : (isTablet ? 16 : 24),
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          if (isMobile) ...[
            Builder(
              builder: (buttonContext) => IconButton(
                onPressed: () {
                  FocusScope.of(buttonContext).unfocus();
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Scaffold.maybeOf(buttonContext)?.openDrawer();
                  });
                },
                icon: Icon(
                  Icons.menu,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                tooltip: 'Open navigation menu',
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Text(
              pageTitle,
              style: TextStyle(
                fontSize: isMobile ? 16 : (isTablet ? 16 : 18),
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Spacer(),
          _buildPageActions(context, currentPath, isMobile, isTablet),
        ],
      ),
    );
  }

  Widget _buildPageActions(
    BuildContext context,
    String currentPath,
    bool isMobile,
    bool isTablet,
  ) {
    final theme = Theme.of(context);

    // For notes page, show Search/Filter/Sort UI
    if (currentPath.contains('/notes')) {
      return _NotesHeaderActions(theme: theme);
    }

    // For other pages, show default icons
    return const SizedBox();}
}

class _NotesHeaderActions extends StatefulWidget {

  const _NotesHeaderActions({required this.theme});
  final ThemeData theme;

  @override
  State<_NotesHeaderActions> createState() => _NotesHeaderActionsState();
}

class _NotesHeaderActionsState extends State<_NotesHeaderActions> {
  late TextEditingController _searchController;
  bool _isSearchExpanded = false;
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearchExpanded = !_isSearchExpanded;
      if (!_isSearchExpanded) {
        _searchController.clear();
        context.read<NotesCubit>().resetFilters();
      }
    });
  }

  void _onSearchChanged(String query) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      context.read<NotesCubit>().searchNotes(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Search field (appears when expanded)
        if (_isSearchExpanded)
          SizedBox(
            width: 200,
            height: 40,
            child: TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search notes...',
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 20),
                        onPressed: () {
                          _searchController.clear();
                          context.read<NotesCubit>().resetFilters();
                          setState(() {});
                        },
                      )
                    : null,
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              ),
              onChanged: (value) {
                _onSearchChanged(value);
                setState(() {});
              },
            ),
          )
        else
          const SizedBox(width: 0),
        const SizedBox(width: 8),
        // Search icon
        SizedBox(
          width: 40,
          height: 40,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _toggleSearch,
              borderRadius: BorderRadius.circular(8),
              child: Icon(
                Icons.search,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                size: 22,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Filter menu
        _FilterMenuAnchor(),
        const SizedBox(width: 8),
        // Sort menu
        _SortMenuAnchor(),
        const SizedBox(width: 8),
      ],
    );
  }
}

class _FilterMenuAnchor extends StatefulWidget {
  @override
  State<_FilterMenuAnchor> createState() => _FilterMenuAnchorState();
}

class _FilterMenuAnchorState extends State<_FilterMenuAnchor> {
  final _anchorKey = GlobalKey();
  late OverlayEntry? _overlayEntry;

  void _showFilterMenu() {
    final cubit = context.read<NotesCubit>();
    final renderBox =
        _anchorKey.currentContext?.findRenderObject() as RenderBox?;
    final size = renderBox?.size ?? const Size(40, 40);
    final offset = renderBox?.localToGlobal(Offset.zero) ?? Offset.zero;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx - 280 + size.width,
        top: offset.dy + size.height + 8,
        child: Material(
          color: Colors.transparent,
          child: CategoryFilterPopover(
            initialCategory: cubit.selectedCategory,
            onApply: () {
              _overlayEntry?.remove();
              _overlayEntry = null;
            },
            onCancel: () {
              _overlayEntry?.remove();
              _overlayEntry = null;
            },
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      key: _anchorKey,
      width: 40,
      height: 40,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _showFilterMenu,
          borderRadius: BorderRadius.circular(8),
          child: Icon(
            Icons.tune,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            size: 22,
          ),
        ),
      ),
    );
  }
}

class _SortMenuAnchor extends StatefulWidget {
  @override
  State<_SortMenuAnchor> createState() => _SortMenuAnchorState();
}

class _SortMenuAnchorState extends State<_SortMenuAnchor> {
  final _anchorKey = GlobalKey();
  late OverlayEntry? _overlayEntry;

  void _showSortMenu() {
    final cubit = context.read<NotesCubit>();
    final renderBox =
        _anchorKey.currentContext?.findRenderObject() as RenderBox?;
    final size = renderBox?.size ?? const Size(40, 40);
    final offset = renderBox?.localToGlobal(Offset.zero) ?? Offset.zero;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx - 280 + size.width,
        top: offset.dy + size.height + 8,
        child: Material(
          color: Colors.transparent,
          child: SortPopover(
            initialSort: cubit.sortBy as NoteSortBy?,
            onApply: () {
              _overlayEntry?.remove();
              _overlayEntry = null;
            },
            onCancel: () {
              _overlayEntry?.remove();
              _overlayEntry = null;
            },
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      key: _anchorKey,
      width: 40,
      height: 40,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _showSortMenu,
          borderRadius: BorderRadius.circular(8),
          child: Icon(
            Icons.sort,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            size: 22,
          ),
        ),
      ),
    );
  }
}