import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/base/base_stateless_widget.dart';
import '../cubit/responsive_sidebar_cubit.dart';
import 'sidebar/sidebar_header.dart';
import 'sidebar/sidebar_navigation_menu.dart';
import 'sidebar/sidebar_user_profile.dart';

/// Responsive sidebar navigation widget
class ResponsiveSidebar extends BaseStatelessWidget {
  /// Creates a [ResponsiveSidebar].
  const ResponsiveSidebar({
    super.key,
    required this.isExpanded,
    this.onToggle,
    required this.currentPath,
  });
  
  /// Whether sidebar is expanded on desktop
  final bool isExpanded;
  
  /// Callback when expand/collapse is toggled
  final VoidCallback? onToggle;
  
  /// Current route path
  final String currentPath;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ResponsiveSidebarCubit(),
      child: _ResponsiveSidebarView(
        isExpanded: isExpanded,
        onToggle: onToggle,
        currentPath: currentPath,
      ),
    );
  }
}

class _ResponsiveSidebarView extends BaseStatelessWidget {
  const _ResponsiveSidebarView({
    required this.isExpanded,
    this.onToggle,
    required this.currentPath,
  });

  final bool isExpanded;
  final VoidCallback? onToggle;
  final String currentPath;

  @override
  Widget build(BuildContext context) {
    final theme = getTheme(context);
    final screenSize = getScreenSize(context);
    final screenWidth = screenSize.width;
    
    // Responsive widths
    double sidebarWidth;
    if (screenWidth < 768) {
      // Mobile: Use full drawer width when in drawer, otherwise minimal
      sidebarWidth = isExpanded ? 260 : 60;
    } else if (screenWidth < 1200) {
      // Tablet: collapsed by default
      sidebarWidth = isExpanded ? 240 : 60;
    } else {
      // Desktop: expanded by default
      sidebarWidth = isExpanded ? 260 : 72;
    }

    final showText = isExpanded;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: sidebarWidth,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          right: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                SidebarHeader(
                  isExpanded: isExpanded,
                  showText: showText,
                  onToggle: onToggle,
                  screenWidth: screenWidth,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraints.maxHeight),
                      child: IntrinsicHeight(
                        child: Column(
                          children: [
                            SidebarNavigationMenu(
                              showText: showText,
                              currentPath: currentPath,
                            ),
                            const Spacer(),
                            SidebarUserProfile(showText: showText),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
