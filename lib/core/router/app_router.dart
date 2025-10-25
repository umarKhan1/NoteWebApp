import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/dashboard/presentation/widgets/dashboard_content.dart';
import '../../features/notes/presentation/widgets/notes_content.dart';
import '../../features/splash/presentation/pages/splash_screen.dart';
import '../../shared/widgets/main_shell.dart';
import 'route_names.dart';

/// Application router configuration using GoRouter for navigation.
class AppRouter {
  /// Private constructor to prevent instantiation.
  AppRouter._();

  /// GoRouter instance for the application.
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    routes: [
      // Splash Route
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // Authentication Routes (standalone pages)
      GoRoute(
        path: RouteNames.login,
        name: RouteNames.loginName,
        builder: (context, state) => const LoginView(),
      ),

      // Shell Route - Contains persistent sidebar
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          // Dashboard Route
          GoRoute(
            path: RouteNames.dashboard,
            name: RouteNames.dashboardName,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const _DashboardContent(),
            ),
          ),

          // Notes Route
          GoRoute(
            path: RouteNames.notes,
            name: RouteNames.notesName,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const _NotesContent(),
            ),
          ),

          // Categories Route
          GoRoute(
            path: '/categories',
            name: 'categories',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const _CategoriesContent(),
            ),
          ),

          // Search Route
          GoRoute(
            path: '/search',
            name: 'search',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const _SearchContent(),
            ),
          ),

          // Analytics Route
          GoRoute(
            path: '/analytics',
            name: 'analytics',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const _AnalyticsContent(),
            ),
          ),

          // Settings Route
          GoRoute(
            path: '/settings',
            name: 'settings',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const _SettingsContent(),
            ),
          ),
        ],
      ),
    ],

    // Error handling
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'The page you requested could not be found.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(RouteNames.login),
              child: const Text('Go to Login'),
            ),
          ],
        ),
      ),
    ),
  );
}

/// Dashboard content widget (without shell)
class _DashboardContent extends StatelessWidget {
  const _DashboardContent();

  @override
  Widget build(BuildContext context) {
    return const DashboardContent();
  }
}

/// Notes content widget (without shell)
class _NotesContent extends StatelessWidget {
  const _NotesContent();

  @override
  Widget build(BuildContext context) {
    return const NotesContent();
  }
}

/// Categories content widget (without shell)
class _CategoriesContent extends StatelessWidget {
  const _CategoriesContent();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.folder_outlined, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Categories Page',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8),
          Text('Categories feature coming soon...'),
        ],
      ),
    );
  }
}

/// Search content widget (without shell)
class _SearchContent extends StatelessWidget {
  const _SearchContent();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_outlined, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Search Page',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8),
          Text('Search feature coming soon...'),
        ],
      ),
    );
  }
}

/// Analytics content widget (without shell)
class _AnalyticsContent extends StatelessWidget {
  const _AnalyticsContent();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.analytics_outlined, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Analytics Page',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8),
          Text('Analytics feature coming soon...'),
        ],
      ),
    );
  }
}

/// Settings content widget (without shell)
class _SettingsContent extends StatelessWidget {
  const _SettingsContent();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.settings_outlined, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Settings Page',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8),
          Text('Settings feature coming soon...'),
        ],
      ),
    );
  }
}
