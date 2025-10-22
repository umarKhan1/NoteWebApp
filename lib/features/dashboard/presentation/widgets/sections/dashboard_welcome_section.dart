import 'package:flutter/material.dart';

import '../../../../../core/constants/app_strings.dart';

/// Welcome section widget for dashboard
class DashboardWelcomeSection extends StatelessWidget {
  /// Creates a [DashboardWelcomeSection].
  const DashboardWelcomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.welcomeMessage,
          style: TextStyle(
            fontSize: isMobile ? 20 : 24,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          AppStrings.dashboardSubtitle,
          style: TextStyle(
            fontSize: isMobile ? 13 : 14,
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}
