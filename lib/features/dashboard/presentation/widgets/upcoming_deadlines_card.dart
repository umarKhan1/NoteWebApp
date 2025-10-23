import 'package:flutter/material.dart';

import '../../../../core/base/base_stateless_widget.dart';

/// Upcoming deadlines card widget
class UpcomingDeadlinesCard extends BaseStatelessWidget {
  const UpcomingDeadlinesCard({super.key});

  @override
  Widget build(BuildContext context) {
    final responsiveInfo = getResponsiveInfo(context);
    final theme = getTheme(context);
    final deadlines = [
      {
        'title': 'Submit project proposal',
        'project': 'Mobile App Project',
        'time': 'Today, 2:00 PM',
        'priority': 'high',
      },
      {
        'title': 'Review design mockups',
        'project': 'Website Redesign',
        'time': 'Tomorrow, 10:00 AM',
        'priority': 'medium',
      },
      {
        'title': 'Team meeting preparation',
        'project': 'Sprint Planning',
        'time': 'Oct 24, 9:00 AM',
        'priority': 'low',
      },
    ];

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
            color: theme.shadowColor.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Upcoming Deadlines',
                style: TextStyle(
                  fontSize: responsiveInfo.isMobile ? 14 : 16,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Show all deadlines
                },
                child: Text(
                  'View all',
                  style: TextStyle(
                    fontSize: responsiveInfo.isMobile ? 11 : 12,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          ...deadlines.map((deadline) => _buildDeadlineItem(
            context: context,
            title: deadline['title']!,
            project: deadline['project']!,
            time: deadline['time']!,
            priority: deadline['priority']!,
          )),
        ],
      ),
    );
  }

  Widget _buildDeadlineItem({
    required BuildContext context,
    required String title,
    required String project,
    required String time,
    required String priority,
  }) {
    final theme = getTheme(context);
    Color priorityColor;
    Color priorityBgColor;
    
    switch (priority) {
      case 'high':
        priorityColor = const Color(0xFFEF4444);
        priorityBgColor = const Color(0xFFFEF2F2);
        break;
      case 'medium':
        priorityColor = const Color(0xFFF59E0B);
        priorityBgColor = const Color(0xFFFFF7ED);
        break;
      case 'low':
        priorityColor = const Color(0xFF10B981);
        priorityBgColor = const Color(0xFFF0FDF4);
        break;
      default:
        priorityColor = const Color(0xFF6B7280);
        priorityBgColor = const Color(0xFFF9FAFB);
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFFE5E7EB),
            width: 0.5,
          ),
        ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 40,
            decoration: BoxDecoration(
              color: priorityColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'on $project',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: priorityBgColor,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: priorityColor.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    time,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: priorityColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              // TODO: Navigate to deadline details
            },
            icon: Icon(
              Icons.more_vert,
              color: Colors.grey.shade400,
              size: 16,
            ),
          ),
        ],
      ),
      ),
    );
  }
}
