import 'package:flutter/material.dart';

import '../../../../core/base/base_stateless_widget.dart';
import '../../../../core/constants/app_animations.dart';
import '../../../../shared/extensions/widget_extensions.dart';
import '../../../../shared/widgets/animations/animation_widgets.dart';
import '../../domain/entities/dashboard_stats.dart';

/// Dashboard statistics grid
class DashboardStatsGrid extends BaseStatelessWidget {
  // ignore: public_member_api_docs
  const DashboardStatsGrid({super.key, this.stats});

  /// Dashboard statistics data
  final DashboardStats? stats;

  @override
  Widget build(BuildContext context) {
    final responsiveInfo = getResponsiveInfo(context);
    final theme = getTheme(context);

    // Return empty container if no stats
    if (stats == null) {
      return const SizedBox.shrink();
    }

    // For mobile: 2x2 grid
    if (responsiveInfo.isMobile) {
      return StaggeredListAnimation(
        staggerDelay: AppAnimations.shortStagger,
        children: [
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context: context,
                  title: 'Total Notes',
                  value: stats?.totalNotes.toString() ?? '0',
                  subtitle: 'All notes',
                  color: theme.colorScheme.primary,
                  icon: Icons.description_outlined,
                  isMobile: true,
                ),
              ),
              AppSpacing.sm.horizontalSpace,
              Expanded(
                child: _buildStatCard(
                  context: context,
                  title: 'Today',
                  value: stats?.todayNotes.toString() ?? '0',
                  subtitle: 'New notes',
                  color: _getAccentColor(theme, 0),
                  icon: Icons.today_outlined,
                  isMobile: true,
                ),
              ),
            ],
          ),
          AppSpacing.sm.verticalSpace,
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context: context,
                  title: 'Categories',
                  value: stats?.totalCategories.toString() ?? '0',
                  subtitle: 'Active',
                  color: _getAccentColor(theme, 1),
                  icon: Icons.folder_outlined,
                  isMobile: true,
                ),
              ),
              AppSpacing.sm.horizontalSpace,
              Expanded(
                child: _buildStatCard(
                  context: context,
                  title: 'Pinned',
                  value: stats?.pinnedNotes.toString() ?? '0',
                  subtitle: 'Important',
                  color: _getAccentColor(theme, 2),
                  icon: Icons.push_pin_outlined,
                  isMobile: true,
                ),
              ),
            ],
          ),
        ],
      );
    }

    // For tablet: 2x2 grid with larger cards
    if (responsiveInfo.isTablet) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context: context,
                  title: 'Total Notes',
                  value: stats?.totalNotes.toString() ?? '0',
                  subtitle: 'All notes',
                  color: theme.colorScheme.primary,
                  icon: Icons.description_outlined,
                  isMobile: false,
                ),
              ),
              AppSpacing.md.horizontalSpace,
              Expanded(
                child: _buildStatCard(
                  context: context,
                  title: 'Today',
                  value: stats?.todayNotes.toString() ?? '0',
                  subtitle: 'New notes',
                  color: _getAccentColor(theme, 0),
                  icon: Icons.today_outlined,
                  isMobile: false,
                ),
              ),
            ],
          ),
          AppSpacing.md.verticalSpace,
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context: context,
                  title: 'Categories',
                  value: stats?.totalCategories.toString() ?? '0',
                  subtitle: 'Active',
                  color: _getAccentColor(theme, 1),
                  icon: Icons.folder_outlined,
                  isMobile: false,
                ),
              ),
              AppSpacing.md.horizontalSpace,
              Expanded(
                child: _buildStatCard(
                  context: context,
                  title: 'Pinned',
                  value: stats?.pinnedNotes.toString() ?? '0',
                  subtitle: 'Important',
                  color: _getAccentColor(theme, 2),
                  icon: Icons.push_pin_outlined,
                  isMobile: false,
                ),
              ),
            ],
          ),
        ],
      );
    }

    // For desktop: Single row with 4 cards
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context: context,
            title: 'Total Notes',
            value: stats?.totalNotes.toString() ?? '0',
            subtitle: 'All notes',
            color: theme.colorScheme.primary,
            icon: Icons.description_outlined,
            isMobile: false,
          ),
        ),
        AppSpacing.lg.horizontalSpace,
        Expanded(
          child: _buildStatCard(
            context: context,
            title: 'Today',
            value: stats?.todayNotes.toString() ?? '0',
            subtitle: 'New notes',
            color: _getAccentColor(theme, 0),
            icon: Icons.today_outlined,
            isMobile: false,
          ),
        ),
        AppSpacing.lg.horizontalSpace,
        Expanded(
          child: _buildStatCard(
            context: context,
            title: 'Categories',
            value: stats?.totalCategories.toString() ?? '0',
            subtitle: 'Active',
            color: _getAccentColor(theme, 1),
            icon: Icons.folder_outlined,
            isMobile: false,
          ),
        ),
        AppSpacing.lg.horizontalSpace,
        Expanded(
          child: _buildStatCard(
            context: context,
            title: 'Pinned',
            value: stats?.pinnedNotes.toString() ?? '0',
            subtitle: 'Important',
            color: _getAccentColor(theme, 2),
            icon: Icons.push_pin_outlined,
            isMobile: false,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required BuildContext context,
    required String title,
    required String value,
    required String subtitle,
    required Color color,
    required IconData icon,
    required bool isMobile,
  }) {
    final theme = getTheme(context);
    final padding = isMobile ? 12.0 : 16.0;
    final titleFontSize = isMobile ? 11.0 : 13.0;
    final valueFontSize = isMobile ? 20.0 : 28.0;
    final subtitleFontSize = isMobile ? 9.0 : 11.0;
    final iconSize = isMobile ? 16.0 : 20.0;

    return ScaleInAnimation(
      duration: AppAnimations.normal,
      curve: AppAnimations.fastOutSlowIn,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withValues(alpha: 0.05),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: titleFontSize,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.all(isMobile ? 6 : 8),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, size: iconSize, color: color),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: valueFontSize,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: subtitleFontSize,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Gets accent color based on theme and index
  Color _getAccentColor(ThemeData theme, int index) {
    final isDark = theme.brightness == Brightness.dark;

    // Use theme-appropriate colors
    const lightColors = [
      Color(0xFF10B981), // Green
      Color(0xFFF59E0B), // Amber
      Color(0xFFEF4444), // Red
    ];

    const darkColors = [
      Color(0xFF34D399), // Green (lighter for dark theme)
      Color(0xFFFBBF24), // Amber (lighter for dark theme)
      Color(0xFFF87171), // Red (lighter for dark theme)
    ];

    final colors = isDark ? darkColors : lightColors;
    return colors[index % colors.length];
  }
}
