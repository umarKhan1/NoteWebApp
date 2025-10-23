import 'package:flutter/material.dart';

import '../../../../core/base/base_stateless_widget.dart';
import '../../../../core/constants/app_animations.dart';
import '../../../../shared/widgets/animations/animation_widgets.dart';

/// Dashboard header with menu and actions
class DashboardHeader extends BaseStatelessWidget {

  // ignore: public_member_api_docs
  const DashboardHeader({
    super.key,
    this.onMenuPressed,
  });
  /// Callback for menu button press (mobile)
  final VoidCallback? onMenuPressed;

  @override
  Widget build(BuildContext context) {
    final responsiveInfo = getResponsiveInfo(context);
    final theme = getTheme(context);
    
    return Container(
      height: 70,
      padding: EdgeInsets.symmetric(
        horizontal: responsiveInfo.isMobile ? 16 : 24, 
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
      child: FadeInAnimation(
        duration: AppAnimations.normal,
        child: Row(
          children: [
            // Menu button for mobile
            if (onMenuPressed != null) ...[
              IconButton(
                onPressed: onMenuPressed,
                icon: Icon(
                  Icons.menu,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(width: 8),
            ],
            
            // Title
            Text(
              'Dashboard',
              style: TextStyle(
                fontSize: responsiveInfo.isMobile ? 16 : 18,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            
            const Spacer(),
            
            // Actions
            IconButton(
              onPressed: () {
              
              },
              icon: Icon(
                Icons.notifications_outlined,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () {
             
              },
              icon: Icon(
                Icons.search,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
