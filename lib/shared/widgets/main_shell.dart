import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/base/base_stateless_widget.dart';
import 'responsive_sidebar.dart';

/// Main shell that contains the persistent sidebar and dynamic content
class MainShell extends BaseStatelessWidget {
  /// Creates a [MainShell].
  const MainShell({
    super.key,
    required this.child,
  });

  /// The child widget (main content area)
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = getTheme(context);
    final responsiveInfo = getResponsiveInfo(context);
    final isMobile = responsiveInfo.isMobile;
    final showSidebar = !isMobile;

    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final currentPath = GoRouterState.of(context).uri.path;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: theme.colorScheme.surface,
      drawer: isMobile 
        ? Drawer(
            child: ResponsiveSidebar(
              isExpanded: true,
              currentPath: currentPath,
              onToggle: () => Navigator.of(context).pop(),
            ),
          )
        : null,
      body: Row(
        children: [
          // Desktop/Tablet Sidebar (persistent)
          if (showSidebar)
            ResponsiveSidebar(
              isExpanded: true, // Keep sidebar always expanded for now
              currentPath: currentPath,
              onToggle: () {
                // Optional: Toggle sidebar functionality
              },
            ),
          
          // Main Content Area (this changes with navigation)
          Expanded(
            child: Column(
              children: [
                // Header
                _buildHeader(context, isMobile, scaffoldKey, currentPath),
                
                // Dynamic Content
                Expanded(
                  child: child,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isMobile, GlobalKey<ScaffoldState> scaffoldKey, String currentPath) {
    final theme = getTheme(context);
    
    // Determine page title based on current path
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
        horizontal: isMobile ? 16 : 24, 
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
          // Menu button for mobile
          if (isMobile) ...[
            IconButton(
              onPressed: () => scaffoldKey.currentState?.openDrawer(),
              icon: Icon(
                Icons.menu,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(width: 8),
          ],
          
          // Title
          Text(
            pageTitle,
            style: TextStyle(
              fontSize: isMobile ? 16 : 18,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          
          const Spacer(),
          
          // Actions (page-specific actions can be added here)
          _buildPageActions(context, currentPath, isMobile),
        ],
      ),
    );
  }

  Widget _buildPageActions(BuildContext context, String currentPath, bool isMobile) {
    final theme = getTheme(context);
    
    return Row(
      children: [
        // Common actions
        IconButton(
          onPressed: () {
            // TODO: Implement notifications
          },
          icon: Icon(
            Icons.notifications_outlined,
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: () {
            // TODO: Implement search
          },
          icon: Icon(
            Icons.search,
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        
        // Page-specific actions
        if (currentPath.contains('/notes')) ...[
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {
              // TODO: Implement add note
            },
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
