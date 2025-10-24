import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Utility class for managing user information across the application
class UserUtils {
  /// Private constructor to prevent instantiation
  UserUtils._();

  /// Key for storing the current user ID in SharedPreferences
  static const String _currentUserIdKey = 'current_user_id';

  /// Get the current logged-in user ID
  static Future<String?> getCurrentUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString(_currentUserIdKey);
      if (kDebugMode) print('[UserUtils] Retrieved userId: $userId');
      return userId;
    } catch (e) {
      if (kDebugMode) print('[UserUtils] Error: $e');
      return null;
    }
  }

  /// Set the current user ID (call this after successful login)
  static Future<bool> setCurrentUserId(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final result = await prefs.setString(_currentUserIdKey, userId);
      if (kDebugMode) print('[UserUtils] Set userId: $userId');
      return result;
    } catch (e) {
      if (kDebugMode) print('[UserUtils] Error: $e');
      return false;
    }
  }

  /// Clear the current user ID (call this on logout)
  static Future<bool> clearCurrentUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final result = await prefs.remove(_currentUserIdKey);
      if (kDebugMode) print('[UserUtils] Cleared userId');
      return result;
    } catch (e) {
      if (kDebugMode) print('[UserUtils] Error: $e');
      return false;
    }
  }

  /// Get a default user ID if none is set (useful for testing)
  static String getDefaultUserId() {
    return 'user_default_001';
  }
}
