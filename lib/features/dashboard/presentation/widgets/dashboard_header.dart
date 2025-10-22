import 'package:flutter/material.dart';

import '../../../../core/base/base_stateless_widget.dart';

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
    
    return Container(
      height: 70,
      padding: EdgeInsets.symmetric(
        horizontal: responsiveInfo.isMobile ? 16 : 24, 
        vertical: 8,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFF1F5F9),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Menu button for mobile
          if (onMenuPressed != null) ...[
            IconButton(
              onPressed: onMenuPressed,
              icon: const Icon(
                Icons.menu,
                color: Color(0xFF6B7280),
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
              color: const Color(0xFF1F2937),
            ),
          ),
          
          const Spacer(),
          
          // Actions
          IconButton(
            onPressed: () {
            
            },
            icon: const Icon(
              Icons.notifications_outlined,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {
           
            },
            icon: const Icon(
              Icons.search,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }
}
