import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_constants.dart';

/// Splash screen widget showing app logo animation and branding
class SplashScreen extends StatefulWidget {
  /// Creates a [SplashScreen].
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _titleAnimationController;
  late Animation<double> _titleOpacity;
  late Animation<Offset> _titleSlide;

  @override
  void initState() {
    super.initState();
    _setupTitleAnimation();
    _navigateToHome();
  }

  /// Setup animation for app title
  void _setupTitleAnimation() {
    _titleAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _titleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _titleAnimationController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeInOut),
      ),
    );

    _titleSlide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(
      CurvedAnimation(
        parent: _titleAnimationController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _titleAnimationController.forward();
  }

  /// Navigate to home after splash duration
  void _navigateToHome() {
    Future.delayed(const Duration(seconds: AppConstants.splashDurationSeconds), () {
      if (mounted) {
        context.go('/');
      }
    });
  }

  @override
  void dispose() {
    _titleAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final isMobile = screenSize.width < 600;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Lottie Animation
              Lottie.asset(
                AppAssets.learningAnimation,
                height: isMobile ? 200 : 280,
                width: isMobile ? 200 : 280,
                fit: BoxFit.contain,
              ),
              SizedBox(height: isMobile ? 32 : 48),

              // Animated Title
              SlideTransition(
                position: _titleSlide,
                child: FadeTransition(
                  opacity: _titleOpacity,
                  child: Column(
                    children: [
                      Text(
                        AppConstants.appName,
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontSize: isMobile ? 32 : 48,
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: isMobile ? 8 : 12),
                      Text(
                        AppConstants.splashTagline,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
