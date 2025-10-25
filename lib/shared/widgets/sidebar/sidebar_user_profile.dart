import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/base/base_stateless_widget.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/router/route_names.dart';

/// Sidebar user profile widget
class SidebarUserProfile extends BaseStatelessWidget {
  /// Creates a [SidebarUserProfile].
  const SidebarUserProfile({
    super.key,
    required this.showText,
  });

  /// Whether to show text labels
  final bool showText;

  @override
  Widget build(BuildContext context) {
    final theme = getTheme(context);
    
    if (!showText) {
      return Container(
        margin: const EdgeInsets.all(12),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [theme.primaryColor, theme.primaryColor.withValues(alpha: 0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: theme.primaryColor.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Center(
            child: Text(
              'F',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.primaryColor.withValues(alpha: 0.05),
            theme.primaryColor.withValues(alpha: 0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.primaryColor.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [theme.primaryColor, theme.primaryColor.withValues(alpha: 0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'F',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppStrings.userName,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  AppStrings.userPlan,
                  style: TextStyle(
                    fontSize: 10,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              size: 16,
            ),
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: AppStrings.profile,
                child: Text(AppStrings.profile),
              ),
              const PopupMenuItem<String>(
                value: AppStrings.logout,
                child: Text(AppStrings.logout),
              ),
            ],
            onSelected: (value) {
              if (value == AppStrings.logout) {
                context.go(RouteNames.login);
              }
            },
          ),
        ],
      ),
    );
  }
}
