import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

/// Header widget for the dashboard
class DashboardHeader extends StatelessWidget {
  /// Callback for menu button (mobile only)
  final VoidCallback? onMenuPressed;
  
  const DashboardHeader({
    super.key,
    this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = Device.screenType == ScreenType.desktop;
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 3.w : 4.w,
        vertical: 2.h,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Mobile menu button
          if (!isDesktop && onMenuPressed != null) ...[
            IconButton(
              onPressed: onMenuPressed,
              icon: const Icon(
                Icons.menu,
                color: Color(0xFF1F2937),
              ),
            ),
            SizedBox(width: 2.w),
          ],
          
          // Search Bar
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFFE5E7EB),
                  width: 1,
                ),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xFF9CA3AF),
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFF9CA3AF),
                    size: 20,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 3.w,
                    vertical: 1.h,
                  ),
                ),
                onChanged: (value) {
                  // TODO: Implement search
                },
              ),
            ),
          ),
          
          SizedBox(width: 3.w),
          
          // Filter Button
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFFE5E7EB),
                width: 1,
              ),
            ),
            child: IconButton(
              onPressed: () {
                // TODO: Implement filter
              },
              icon: const Icon(
                Icons.tune,
                color: Color(0xFF6B7280),
                size: 20,
              ),
            ),
          ),
          
          SizedBox(width: 2.w),
          
          // Notifications
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFFE5E7EB),
                width: 1,
              ),
            ),
            child: IconButton(
              onPressed: () {
                // TODO: Implement notifications
              },
              icon: const Icon(
                Icons.notifications_outlined,
                color: Color(0xFF6B7280),
                size: 20,
              ),
            ),
          ),
          
          // Only show profile on desktop (mobile has it in drawer)
          if (isDesktop) ...[
            SizedBox(width: 2.w),
            // User Profile
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: const Color(0xFF6366F1),
                  child: Text(
                    'F',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 2.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Faris',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                    Text(
                      'Premium Account',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 1.w),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: Color(0xFF6B7280),
                  size: 16,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
