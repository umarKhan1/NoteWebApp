import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'responsive_sidebar.dart';

class MainShell extends StatefulWidget {
  const MainShell({
    super.key,
    required this.child,
  });

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
    } else if (currentPath.contains('/categories')) {
      pageTitle = 'Categories';
    } else if (currentPath.contains('/search')) {
      pageTitle = 'Search';
    } else if (currentPath.contains('/analytics')) {
      pageTitle = 'Analytics';
    } else if (currentPath.contains('/settings')) {
      pageTitle = 'Settings';
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
            color: theme.colorScheme.outline.withOpacity(0.2),
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
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
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

    return Row(
      children: [
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.notifications_outlined,
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.search,
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        if (currentPath.contains('/notes')) ...[
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.add,
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ],
    );
  }
}
