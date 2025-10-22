import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

/// Desktop sidebar navigation for the dashboard
class DashboardSidebar extends StatefulWidget {
  const DashboardSidebar({super.key});

  @override
  State<DashboardSidebar> createState() => _DashboardSidebarState();
}

class _DashboardSidebarState extends State<DashboardSidebar> {
  bool? _isExpanded; // null means auto-determine based on screen size
  String? hoveredItem;

  bool get isExpanded {
    if (_isExpanded != null) return _isExpanded!;
    // Auto-collapse on smaller screens or when screen width is less than 1200px
    final screenWidth = MediaQuery.of(context).size.width;
    return Device.screenType == ScreenType.desktop && screenWidth > 1200;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Responsive behavior - auto-collapse below 1200px
    final shouldExpand = _isExpanded ?? (screenWidth >= 1200);
    final sidebarWidth = shouldExpand ? 260.0 : 72.0;
    
    return Container(
      width: sidebarWidth,
      height: screenHeight,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(
            color: Color(0xFFF1F5F9),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 4,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Logo/Header
            _buildHeader(shouldExpand, primaryColor),
            
            // Main Menu
            Expanded(
              child: _buildMainMenu(shouldExpand, primaryColor),
            ),
            
            // Bottom Section
            _buildBottomSection(shouldExpand, primaryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool shouldExpand, Color primaryColor) {
    return Container(
      padding: EdgeInsets.all(shouldExpand ? 20 : 16),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryColor, primaryColor.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.auto_awesome_outlined,
              color: Colors.white,
              size: 20,
            ),
          ),
          if (shouldExpand) ...[
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'COCUS Notes',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F2937),
                  letterSpacing: -0.3,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
          if (shouldExpand) const SizedBox(width: 8),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  _isExpanded = !shouldExpand;
                });
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.all(6),
                child: Icon(
                  shouldExpand ? Icons.menu_open : Icons.menu,
                  color: const Color(0xFF6B7280),
                  size: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainMenu(bool shouldExpand, Color primaryColor) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: shouldExpand ? 16 : 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (shouldExpand) ...[
            const Padding(
              padding: EdgeInsets.only(left: 12, bottom: 12, top: 8),
              child: Text(
                'Main Menu',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF9CA3AF),
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ] else ...[
            const SizedBox(height: 16),
          ],
          
          // Navigation Items
          _buildNavItem(
            context,
            icon: Icons.dashboard_outlined,
            title: 'Dashboard',
            isActive: true,
            isExpanded: shouldExpand,
            onTap: () {},
          ),
          _buildNavItem(
            context,
            icon: Icons.description_outlined,
            title: 'All Notes',
            isActive: false,
            isExpanded: shouldExpand,
            onTap: () {},
          ),
          _buildNavItem(
            context,
            icon: Icons.folder_outlined,
            title: 'Categories',
            isActive: false,
            isExpanded: shouldExpand,
            onTap: () {},
          ),
          _buildNavItem(
            context,
            icon: Icons.search_outlined,
            title: 'Search',
            isActive: false,
            isExpanded: shouldExpand,
            onTap: () {},
          ),
          _buildNavItem(
            context,
            icon: Icons.analytics_outlined,
            title: 'Analytics',
            isActive: false,
            isExpanded: shouldExpand,
            onTap: () {},
          ),
          
          const SizedBox(height: 20),
          
          _buildNavItem(
            context,
            icon: Icons.settings_outlined,
            title: 'Settings',
            isActive: false,
            isExpanded: shouldExpand,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection(bool shouldExpand, Color primaryColor) {
    if (shouldExpand) {
      return _buildUserProfile();
    } else {
      return _buildCollapsedProfile();
    }
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required bool isActive,
    required bool isExpanded,
    required VoidCallback onTap,
  }) {
    final isHovered = hoveredItem == title;
    final primaryColor = Theme.of(context).primaryColor; // Use theme.primaryColor
    
    return MouseRegion(
      onEnter: (_) => setState(() => hoveredItem = title),
      onExit: (_) => setState(() => hoveredItem = null),
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              padding: EdgeInsets.symmetric(
                horizontal: isExpanded ? 12 : 0,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: isActive 
                  ? primaryColor // Use theme primary color for active
                  : isHovered
                    ? primaryColor.withOpacity(0.1) // Use theme primary color with opacity for hover
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  if (!isExpanded) const Spacer(),
                  Icon(
                    icon,
                    size: 20,
                    color: isActive 
                      ? Colors.white // White icon for active/selected
                      : isHovered
                        ? primaryColor // Theme primary color for hover
                        : const Color(0xFF6B7280), // Gray for normal
                  ),
                  if (!isExpanded) const Spacer(),
                  if (isExpanded) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: isExpanded ? 1.0 : 0.0,
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                            color: isActive 
                              ? Colors.white // White text for active/selected
                              : isHovered
                                ? primaryColor // Theme primary color for hover
                                : const Color(0xFF6B7280), // Gray text for normal
                            letterSpacing: -0.1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserProfile() {
    final primaryColor = Theme.of(context).primaryColor; // Use theme.primaryColor
    
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor.withOpacity(0.05),
            primaryColor.withOpacity(0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: primaryColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor, primaryColor.withOpacity(0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.3),
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
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Faris',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    Text(
                      'Premium Account',
                      style: TextStyle(
                        fontSize: 10,
                        color: Color(0xFF6B7280),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(
                  Icons.more_vert,
                  color: Color(0xFF6B7280),
                  size: 18,
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
                  // TODO: Handle menu actions
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                // TODO: Download desktop app
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1F2937),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    'Download',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollapsedProfile() {
    final primaryColor = Theme.of(context).primaryColor; // Use theme.primaryColor
    
    return Container(
      margin: const EdgeInsets.all(16),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryColor, primaryColor.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.3),
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
}
