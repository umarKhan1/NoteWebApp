import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'core/constants/app_strings.dart';
import 'core/constants/provider.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'shared/cubit/theme_cubit.dart';
import 'shared/cubit/theme_state.dart';

/// Entry point of the application.
void main() {
  runApp(const MyApp());
}

/// Main application widget that sets up the MaterialApp.
class MyApp extends StatelessWidget {
  /// Creates a new instance of [MyApp].
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return MultiBlocProvider(
          providers: ApplicationProviders.providers,
          child: BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, themeState) {
              return MaterialApp.router(
                title: AppStrings.appName,
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeState.themeMode,
                routerConfig: AppRouter.router,
              );
            },
          ),
        );
      },
    );
  }
}

