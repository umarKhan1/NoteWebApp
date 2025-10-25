import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/base/base_stateless_widget.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/router/route_names.dart';
import '../../cubit/responsive_sidebar_cubit.dart';
import '../../cubit/responsive_sidebar_state.dart';

/// Sidebar navigation menu widget
class SidebarNavigationMenu extends BaseStatelessWidget {
  /// Creates a [SidebarNavigationMenu].
  const SidebarNavigationMenu({
    super.key,
    required this.showText,
    required this.currentPath,
  });

  /// Whether to show text labels
  final bool showText;
  
  /// Current route path
  final String currentPath;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showText) ...[
            Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 16, top: 8),
              child: Text(
                AppStrings.navigation,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
          
          _SidebarNavItem(
            icon: Icons.dashboard_outlined,
            title: AppStrings.dashboard,
            route: RouteNames.dashboard,
            showText: showText,
            currentPath: currentPath,
          ),
          _SidebarNavItem(
            icon: Icons.description_outlined,
            title: AppStrings.allNotes,
            route: RouteNames.notes,
            showText: showText,
            currentPath: currentPath,
          ),
          
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _SidebarNavItem extends StatelessWidget {
  const _SidebarNavItem({
    required this.icon,
    required this.title,
    required this.route,
    required this.showText,
    required this.currentPath,
  });

  final IconData icon;
  final String title;
  final String route;
  final bool showText;
  final String currentPath;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isActive = currentPath == route;
    
    return BlocBuilder<ResponsiveSidebarCubit, ResponsiveSidebarState>(
      builder: (context, state) {
        final isHovered = state.hoveredItem == title;
        
        return MouseRegion(
          onEnter: (_) => context.read<ResponsiveSidebarCubit>().setHoveredItem(title),
          onExit: (_) => context.read<ResponsiveSidebarCubit>().clearHoveredItem(),
          child: Container(
            margin: const EdgeInsets.only(bottom: 4),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => context.go(route),
                borderRadius: BorderRadius.circular(8),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  padding: EdgeInsets.symmetric(
                    horizontal: showText ? 16 : 8,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isActive 
                      ? theme.primaryColor
                      : isHovered
                        ? theme.primaryColor.withValues(alpha: 0.08)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: isActive ? [
                      BoxShadow(
                        color: theme.primaryColor.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ] : null,
                  ),
                  child: showText 
                    ? Row(
                        children: [
                          Icon(
                            icon,
                            size: 20,
                            color: isActive 
                              ? Colors.white
                              : isHovered
                                ? theme.primaryColor
                                : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              title,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                                color: isActive 
                                  ? Colors.white
                                  : isHovered
                                    ? theme.primaryColor
                                    : theme.colorScheme.onSurface.withValues(alpha: 0.7),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      )
                    : Center(
                        child: Icon(
                          icon,
                          size: 20,
                          color: isActive 
                            ? Colors.white
                            : isHovered
                              ? theme.primaryColor
                              : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
