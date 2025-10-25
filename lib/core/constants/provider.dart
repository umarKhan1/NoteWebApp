import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/presentation/cubit/forgot_password_cubit.dart';
import '../../features/auth/presentation/cubit/login_cubit.dart';
import '../../features/auth/presentation/cubit/signup_cubit.dart';
import '../../features/dashboard/data/datasources/activity_local_datasource.dart';
import '../../features/dashboard/data/repositories/activity_repository_impl.dart';
import '../../features/dashboard/data/repositories/dashboard_repository_impl.dart';
import '../../features/dashboard/data/services/mock_dashboard_service.dart';
import '../../features/dashboard/domain/repositories/activity_repository.dart';
import '../../features/dashboard/domain/repositories/dashboard_repository.dart';
import '../../features/dashboard/domain/services/activity_service.dart';
import '../../features/dashboard/domain/usecases/get_recent_activities_usecase.dart';
import '../../features/dashboard/domain/usecases/load_dashboard_usecase.dart';
import '../../features/dashboard/presentation/cubit/dashboard_cubit.dart';
import '../../features/dashboard/presentation/cubit/dashboard_ui_cubit.dart';
import '../../features/notes/data/repositories/notes_repository_impl.dart';
import '../../features/notes/domain/repositories/notes_repository.dart';
import '../../features/notes/domain/usecases/add_note_usecase.dart';
import '../../features/notes/domain/usecases/delete_note_usecase.dart';
import '../../features/notes/domain/usecases/get_notes_usecase.dart';
import '../../features/notes/domain/usecases/update_note_usecase.dart';
import '../../features/notes/presentation/cubit/notes_cubit.dart';
import '../../features/notes/presentation/cubit/notes_ui_cubit.dart';
import '../../shared/cubit/responsive_sidebar_cubit.dart';
import '../../shared/cubit/theme_cubit.dart';

/// Provides a list of application-wide Bloc providers following OOP principles
class ApplicationProviders {
  /// Private constructor to prevent instantiation.
  ApplicationProviders._();
  
  /// Returns a list of Bloc providers used in the application.
  static List<BlocProvider> get providers => [
    BlocProvider<ThemeCubit>(
      create: (context) => ThemeCubit(),
    ),
    BlocProvider<LoginCubit>(
      create: (context) => LoginCubit(),
    ),
    BlocProvider<SignupCubit>(
      create: (context) => SignupCubit(),
    ),
    BlocProvider<ForgotPasswordCubit>(
      create: (context) => ForgotPasswordCubit(),
    ),
    BlocProvider<DashboardCubit>(
      create: (context) => _createDashboardCubit(),
    ),
    BlocProvider<DashboardUiCubit>(
      create: (context) => DashboardUiCubit(),
    ),
    BlocProvider<ResponsiveSidebarCubit>(
      create: (context) => ResponsiveSidebarCubit(),
    ),
    BlocProvider<NotesCubit>(
      create: (context) => _createNotesCubit(context),
    ),
    BlocProvider<NotesUiCubit>(
      create: (context) => NotesUiCubit(),
    ),
  ];
  
  /// Creates dashboard cubit with proper dependency injection
  static DashboardCubit _createDashboardCubit() {
    // Service layer
    final dashboardService = MockDashboardService();
    
    // Repository layer  
    final DashboardRepository repository = DashboardRepositoryImpl(dashboardService);
    final ActivityRepository activityRepository = ActivityRepositoryImpl(
      ActivityLocalDatasource(),
    );
    
    // Use case layer
    final loadDashboardUseCase = LoadDashboardUseCase(repository);
    final getRecentActivitiesUseCase = GetRecentActivitiesUseCase(activityRepository);
    
    // Presentation layer
    return DashboardCubit(loadDashboardUseCase, getRecentActivitiesUseCase);
  }
  
  /// Creates notes cubit with proper dependency injection
  static NotesCubit _createNotesCubit(BuildContext context) {
    // Notes repository
    final NotesRepository notesRepository = NotesRepositoryImpl();
    
    // Notes use cases
    final getNotesUseCase = GetNotesUseCase(notesRepository);
    final createNoteUseCase = CreateNoteUseCase(notesRepository);
    final updateNoteUseCase = UpdateNoteUseCase(notesRepository);
    final deleteNoteUseCase = DeleteNoteUseCase(notesRepository);
    
    // Activity service for logging
    final ActivityRepository activityRepository = ActivityRepositoryImpl(
      ActivityLocalDatasource(),
    );
    final activityService = ActivityService(activityRepository);
    
    // Get dashboard cubit for activity refresh callbacks
    final dashboardCubit = context.read<DashboardCubit>();
    
    // Return notes cubit with all dependencies
    return NotesCubit(
      getNotesUseCase: getNotesUseCase,
      createNoteUseCase: createNoteUseCase,
      updateNoteUseCase: updateNoteUseCase,
      deleteNoteUseCase: deleteNoteUseCase,
      activityService: activityService,
      dashboardCubit: dashboardCubit,
    );
  }
}