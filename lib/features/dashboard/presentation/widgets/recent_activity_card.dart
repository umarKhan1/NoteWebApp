import 'package:flutter/material.dart';

import '../../../../core/base/base_stateless_widget.dart';
import '../../../../core/constants/app_strings.dart';

/// Recent activity card widget
class RecentActivityCard extends BaseStatelessWidget {
  /// List of recent activities
  final List<String> activities;

  const RecentActivityCard({
    super.key,
    required this.activities,
  });

  @override
  Widget build(BuildContext context) {
    final theme = getTheme(context);
    final responsiveInfo = getResponsiveInfo(context);
    final padding = responsiveInfo.isMobile ? 16.0 : 20.0;
    
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  AppStrings.recentActivity,
                  style: TextStyle(
                    fontSize: responsiveInfo.isMobile ? 14 : (responsiveInfo.isTablet ? 15 : 16),
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () {
                  // TODO: Show all activity
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: responsiveInfo.isMobile ? 8 : 12,
                    vertical: 4,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  AppStrings.viewAll,
                  style: TextStyle(
                    fontSize: responsiveInfo.isMobile ? 11 : 12,
                    color: theme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          if (activities.isEmpty)
            _buildEmptyState(responsiveInfo, theme)
          else
            ...activities.take(responsiveInfo.isMobile ? 3 : (responsiveInfo.isTablet ? 4 : 5)).map((activity) => 
              _buildActivityItem(activity, responsiveInfo, theme)),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String activity, ResponsiveInfo responsiveInfo, ThemeData theme) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(responsiveInfo.isMobile ? 10 : 12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: theme.colorScheme.outline.withOpacity(0.1),
            width: 0.5,
          ),
        ),
      child: Row(
        children: [
          Container(
            width: responsiveInfo.isMobile ? 28 : 32,
            height: responsiveInfo.isMobile ? 28 : 32,
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.history,
              color: theme.primaryColor,
              size: responsiveInfo.isMobile ? 14 : 16,
            ),
          ),
          SizedBox(width: responsiveInfo.isMobile ? 8 : 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  activity,
                  style: TextStyle(
                    fontSize: responsiveInfo.isMobile ? 12 : (responsiveInfo.isTablet ? 12 : 13),
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  AppStrings.justNow,
                  style: TextStyle(
                    fontSize: responsiveInfo.isMobile ? 10 : 11,
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildEmptyState(ResponsiveInfo responsiveInfo, ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(responsiveInfo.isMobile ? 24 : 32),
      child: Column(
        children: [
          Icon(
            Icons.history,
            size: responsiveInfo.isMobile ? 40 : 48,
            color: theme.colorScheme.onSurface.withOpacity(0.4),
          ),
          const SizedBox(height: 8),
          Text(
            AppStrings.noRecentActivity,
            style: TextStyle(
              fontSize: responsiveInfo.isMobile ? 12 : 14,
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}
