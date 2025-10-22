import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/router/route_names.dart';

/// Mobile drawer navigation for the dashboard
class DashboardMobileDrawer extends StatelessWidget {
  const DashboardMobileDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Color(0xFF6366F1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.note_alt,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'COCUS Notes',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1F2937),
                    ),
                  ),
                ],
              ),
            ),
            
            Divider(color: const Color(0xFFE5E7EB)),
            
            // Navigation Items
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 2.h),
                    
                    _buildNavItem(
                      context,
                      icon: Icons.dashboard,
                      title: 'Dashboard',
                      isActive: true,
                      onTap: () => Navigator.of(context).pop(),
                    ),
                    _buildNavItem(
                      context,
                      icon: Icons.note_outlined,
                      title: 'All Notes',
                      isActive: false,
                      onTap: () => Navigator.of(context).pop(),
                    ),
                    _buildNavItem(
                      context,
                      icon: Icons.folder_outlined,
                      title: 'Categories',
                      isActive: false,
                      onTap: () => Navigator.of(context).pop(),
                    ),
                    _buildNavItem(
                      context,
                      icon: Icons.search,
                      title: 'Search',
                      isActive: false,
                      onTap: () => Navigator.of(context).pop(),
                    ),
                    _buildNavItem(
                      context,
                      icon: Icons.analytics_outlined,
                      title: 'Analytics',
                      isActive: false,
                      onTap: () => Navigator.of(context).pop(),
                    ),
                    _buildNavItem(
                      context,
                      icon: Icons.settings_outlined,
                      title: 'Settings',
                      isActive: false,
                      onTap: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
            ),
            
            // User Profile Section
            Container(
              margin: EdgeInsets.all(3.w),
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(2.w),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: const Color(0xFF6366F1),
                    child: Text(
                      'F',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Faris',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1F2937),
                          ),
                        ),
                        Text(
                          'Premium Account',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: const Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(
                      Icons.more_vert,
                      color: Color(0xFF6B7280),
                      size: 20,
                    ),
                    itemBuilder: (context) => [
                      const PopupMenuItem<String>(
                        value: 'profile',
                        child: Text('Profile'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'logout',
                        child: Text('Logout'),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'logout') {
                        Navigator.of(context).pop();
                        context.go(RouteNames.login);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(2.w),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFFF3F4F6) : Colors.transparent,
              borderRadius: BorderRadius.circular(2.w),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 22,
                  color: isActive 
                    ? const Color(0xFF1F2937)
                    : const Color(0xFF6B7280),
                ),
                SizedBox(width: 4.w),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                    color: isActive 
                      ? const Color(0xFF1F2937)
                      : const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
