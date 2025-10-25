import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/base/base_stateless_widget.dart';
import '../../../core/constants/app_strings.dart';
import '../../cubit/theme_cubit.dart';

/// Sidebar header widget with logo and toggle button
class SidebarHeader extends BaseStatelessWidget {
  /// Creates a [SidebarHeader].
  const SidebarHeader({
    super.key,
    required this.isExpanded,
    required this.showText,
    required this.onToggle,
    required this.screenWidth,
  });

  /// Whether the sidebar is expanded
  final bool isExpanded;
  
  /// Whether to show text labels
  final bool showText;
  
  /// Toggle callback
  final VoidCallback? onToggle;
  
  /// Current screen width
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    final theme = getTheme(context);
    final responsive = getResponsiveInfo(context);
    
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Top row: Title and toggle button
          Row(
            children: [
              if (showText) ...[
                _buildTitle(theme),
              ],
              if (!responsive.isMobile) ...[
                const SizedBox(width: 8),
                _buildToggleButton(theme),
              ],
            ],
          ),
          const SizedBox(height: 16),
          // Light/Dark mode toggle
          if (showText) _buildThemeToggle(theme, context),
        ],
      ),
    );
  }
  
  
  
  /// Builds the app title
  Widget _buildTitle(ThemeData theme) {
    return Expanded(
      child: Text(
        AppStrings.sidebarAppName,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: theme.colorScheme.onSurface,
          letterSpacing: -0.1,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
  
  /// Builds the toggle button
  Widget _buildToggleButton(ThemeData theme) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.all(6),
          child: Icon(
            isExpanded ? Icons.menu_open : Icons.menu,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            size: 18,
          ),
        ),
      ),
    );
  }

  /// Builds the theme toggle (Light/Dark mode)
  Widget _buildThemeToggle(ThemeData theme, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Light mode button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                context.read<ThemeCubit>().setLightTheme();
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.brightness == Brightness.light
                      ? theme.colorScheme.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.light_mode,
                  size: 18,
                  color: theme.brightness == Brightness.light
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          // Dark mode button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                context.read<ThemeCubit>().setDarkTheme();
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.brightness == Brightness.dark
                      ? theme.colorScheme.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.dark_mode,
                  size: 18,
                  color: theme.brightness == Brightness.dark
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
