import 'package:flutter/material.dart';

import '../../../core/base/base_stateless_widget.dart';
import '../../../core/constants/app_strings.dart';

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
      child: Row(
        children: [
       
          if (showText) ...[
            const SizedBox(width: 12),
            _buildTitle(theme),
          ],
          if (!responsive.isMobile) ...[
            const SizedBox(width: 8),
            _buildToggleButton(theme),
          ],
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
            color: theme.colorScheme.onSurface.withOpacity(0.6),
            size: 18,
          ),
        ),
      ),
    );
  }
}
