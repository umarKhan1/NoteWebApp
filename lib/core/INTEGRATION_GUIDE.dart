/// Integration Guide for API Connection
///
/// TOMORROW'S SETUP (Step by step):
///
/// 1. Update providers in lib/core/constants/provider.dart:
///    ```dart
///    final httpClient = HttpClient();
///    final notesApiService = NotesApiService(httpClient);
///    final authApiService = AuthApiService(httpClient);
///    ```
///
/// 2. Replace mock repository calls with API calls:
///    - In NoteRepositoryImpl: Replace local storage calls with:
///      ```dart
///      final notes = await _notesApiService.getNotes();
///      ```
///    - In AuthRepositoryImpl: Replace mock calls with:
///      ```dart
///      final response = await _authApiService.login(email, password);
///      final token = response['token'];
///      httpClient.setToken(token);
///      ```
///
/// 3. Handle Token Management:
///    - Store token in SharedPreferences after login
///    - Load and set token in HttpClient when app starts
///    - Clear token on logout
///
/// 4. Update Base URL:
///    - Change `_baseUrl` in HttpClient to match your backend
///    - Example: `http://your-api.com/api` or `http://localhost:3000/api`
///
/// API ENDPOINTS NEEDED (Backend):
///    GET    /api/notes - Get all notes
///    POST   /api/notes - Create note
///    PUT    /api/notes/:id - Update note
///    DELETE /api/notes/:id - Delete note
///    GET    /api/auth/login - Login
///    POST   /api/auth/register - Register
///    GET    /api/auth/me - Get current user
///
/// CURRENT STATUS:
/// ✅ UI: Search/Filter/Sort - FULLY FUNCTIONAL
/// ✅ Search - Real-time with animation
/// ✅ Filter - By category with dynamic chips
/// ✅ Sort - 5 options (Recent, Old, A-Z, Z-A, Pinned)
/// ✅ Activity Tracking - Working on dashboard
/// ✅ Network Layer - Ready (HttpClient, API Services)
/// ✅ Architecture - Clean, OOP, SOLID principles
///
/// WHAT'S READY TO CONNECT:
/// - NotesApiService: All note CRUD operations
/// - AuthApiService: Login, Register, Token refresh
/// - HttpClient: Handles requests, timeouts, errors
/// - Exception Handling: NetworkException, UnauthorizedException, etc.
///
/// TODO TOMORROW:
/// 1. Update providers.dart to instantiate HTTP clients and API services
/// 2. Update repositories to call API services instead of mock data
/// 3. Set backend base URL in HttpClient
/// 4. Test each endpoint
/// 5. Handle token management (login/logout flow)
/// 6. Add error handling UI (loading, error states)
///
class IntegrationGuide {
  // This file is just documentation in code format
  // See the API services in lib/core/services/api/
}
