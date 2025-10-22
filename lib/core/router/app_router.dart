import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/notes/presentation/pages/notes_list_page.dart';
import 'route_names.dart';

/// Application router configuration using GoRouter for navigation.
class AppRouter {
  /// Private constructor to prevent instantiation.
  AppRouter._();

  /// GoRouter instance for the application.
  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.login,
    debugLogDiagnostics: true,
    routes: [
      // Authentication Routes
      GoRoute(
        path: RouteNames.login,
        name: RouteNames.loginName,
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: RouteNames.signup,
        name: RouteNames.signupName,
        builder: (context, state) => const SignupView(),
      ),
      GoRoute(
        path: RouteNames.forgotPassword,
        name: RouteNames.forgotPasswordName,
        builder: (context, state) => const ForgotPasswordView(),
      ),
      
      // Dashboard Routes
      GoRoute(
        path: RouteNames.dashboard,
        name: RouteNames.dashboardName,
        builder: (context, state) => const DashboardPage(),
      ),
      
      // Notes Routes
      GoRoute(
        path: RouteNames.notes,
        name: RouteNames.notesName,
        builder: (context, state) => const NotesListPage(),
      ),
      
      // TODO: Add more routes here (profile, etc.)
    ],
    
    // Error handling
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
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
