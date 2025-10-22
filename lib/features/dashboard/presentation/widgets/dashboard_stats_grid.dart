import 'package:flutter/material.dart';

import '../../../../core/base/base_stateless_widget.dart';
import '../../domain/entities/dashboard_stats.dart';

/// Dashboard statistics grid
class DashboardStatsGrid extends BaseStatelessWidget {

  // ignore: public_member_api_docs
  const DashboardStatsGrid({
    super.key,
    this.stats,
  });
  /// Dashboard statistics data
  final DashboardStats? stats;

  @override
  Widget build(BuildContext context) {
    final responsiveInfo = getResponsiveInfo(context);
    
    // For mobile: 2x2 grid
    if (responsiveInfo.isMobile) {
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
                  color: const Color(0xFF6366F1),
                  icon: Icons.description_outlined,
                  isMobile: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  context: context,
                  title: 'Today',
                  value: stats?.todayNotes.toString() ?? '0',
                  subtitle: 'New notes',
                  color: const Color(0xFF10B981),
                  icon: Icons.today_outlined,
                  isMobile: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context: context,
                  title: 'Categories',
                  value: stats?.totalCategories.toString() ?? '0',
                  subtitle: 'Active',
                  color: const Color(0xFFF59E0B),
                  icon: Icons.folder_outlined,
                  isMobile: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  context: context,
                  title: 'Pinned',
                  value: stats?.pinnedNotes.toString() ?? '0',
                  subtitle: 'Important',
                  color: const Color(0xFFEF4444),
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
                  color: const Color(0xFF6366F1),
                  icon: Icons.description_outlined,
                  isMobile: false,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  context: context,
                  title: 'Today',
                  value: stats?.todayNotes.toString() ?? '0',
                  subtitle: 'New notes',
                  color: const Color(0xFF10B981),
                  icon: Icons.today_outlined,
                  isMobile: false,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context: context,
                  title: 'Categories',
                  value: stats?.totalCategories.toString() ?? '0',
                  subtitle: 'Active',
                  color: const Color(0xFFF59E0B),
                  icon: Icons.folder_outlined,
                  isMobile: false,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  context: context,
                  title: 'Pinned',
                  value: stats?.pinnedNotes.toString() ?? '0',
                  subtitle: 'Important',
                  color: const Color(0xFFEF4444),
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
            color: const Color(0xFF6366F1),
            icon: Icons.description_outlined,
            isMobile: false,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _buildStatCard(
            context: context,
            title: 'Today',
            value: stats?.todayNotes.toString() ?? '0',
            subtitle: 'New notes',
            color: const Color(0xFF10B981),
            icon: Icons.today_outlined,
            isMobile: false,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _buildStatCard(
            context: context,
            title: 'Categories',
            value: stats?.totalCategories.toString() ?? '0',
            subtitle: 'Active',
            color: const Color(0xFFF59E0B),
            icon: Icons.folder_outlined,
            isMobile: false,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _buildStatCard(
            context: context,
            title: 'Pinned',
            value: stats?.pinnedNotes.toString() ?? '0',
            subtitle: 'Important',
            color: const Color(0xFFEF4444),
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
    final padding = isMobile ? 12.0 : 16.0;
    final titleFontSize = isMobile ? 11.0 : 13.0;
    final valueFontSize = isMobile ? 20.0 : 28.0;
    final subtitleFontSize = isMobile ? 9.0 : 11.0;
    final iconSize = isMobile ? 16.0 : 20.0;
    
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFE5E7EB),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha:  0.02),
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
                    color: const Color(0xFF6B7280),
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: EdgeInsets.all(isMobile ? 6 : 8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha:  0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: iconSize,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: valueFontSize,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: subtitleFontSize,
              color: const Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
      ),
    );
  }
}
