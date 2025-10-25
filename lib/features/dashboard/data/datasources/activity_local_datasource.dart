import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/activity_model.dart';

/// Local datasource for activity management using SharedPreferences
class ActivityLocalDatasource {
  /// Base key for storing activities
  static const String _baseKey = 'activities_';
  
  /// Maximum number of activities to store per user
  static const int _maxActivities = 50;
  
  /// Default limit for recent activities
  static const int _defaultLimit = 10;

  /// Get user-specific storage key
  String _getKeyForUser(String userId) => '$_baseKey$userId';

  /// Save an activity for a specific user
  Future<void> saveActivity(
    String userId,
    ActivityModel activity,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = _getKeyForUser(userId);

      // Get existing activities
      final json = prefs.getString(key) ?? '[]';
      final List activities = jsonDecode(json) as List;

      // Insert new activity at the beginning (most recent first)
      activities.insert(0, activity.toJson());

      // Keep only the last _maxActivities
      if (activities.length > _maxActivities) {
        activities.removeRange(_maxActivities, activities.length);
      }

      // Save back to SharedPreferences
      await prefs.setString(key, jsonEncode(activities));
      if (kDebugMode) {
        final type = activity.type.toString().split('.').last;
        print('[Activity] $type ${activity.title} ${activity.timestamp}');
      }
    } catch (e) {
      if (kDebugMode) print('[Activity] Error: $e');
      throw ActivityDatasourceException(
        'Failed to save activity: ${e.toString()}',
      );
    }
  }

  /// Get all activities for a specific user
  Future<List<ActivityModel>> getActivities(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = _getKeyForUser(userId);

      final json = prefs.getString(key) ?? '[]';
      final List activities = jsonDecode(json) as List;

      final result = activities
          .map((a) => ActivityModel.fromJson(a as Map<String, dynamic>))
          .toList();
      
      return result;
    } catch (e) {
      throw ActivityDatasourceException(
        'Failed to get activities: ${e.toString()}',
      );
    }
  }

  /// Get recent activities for a specific user (with limit)
  Future<List<ActivityModel>> getRecentActivities(
    String userId, {
    int limit = _defaultLimit,
  }) async {
    try {
      final activities = await getActivities(userId);
      // Already sorted by timestamp desc (most recent first)
      return activities.take(limit).toList();
    } catch (e) {
      throw ActivityDatasourceException(
        'Failed to get recent activities: ${e.toString()}',
      );
    }
  }

  /// Clear all activities for a specific user
  Future<void> clearActivities(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = _getKeyForUser(userId);
      await prefs.remove(key);
    } catch (e) {
      throw ActivityDatasourceException(
        'Failed to clear activities: ${e.toString()}',
      );
    }
  }

  /// Delete a specific activity
  Future<void> deleteActivity(String userId, String activityId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = _getKeyForUser(userId);

      final json = prefs.getString(key) ?? '[]';
      final List activities = jsonDecode(json) as List;

      activities.removeWhere((a) => (a as Map<String, dynamic>)['id'] == activityId);

      await prefs.setString(key, jsonEncode(activities));
    } catch (e) {
      throw ActivityDatasourceException(
        'Failed to delete activity: ${e.toString()}',
      );
    }
  }

  /// Get activity count for a user
  Future<int> getActivityCount(String userId) async {
    try {
      final activities = await getActivities(userId);
      return activities.length;
    } catch (e) {
      throw ActivityDatasourceException(
        'Failed to get activity count: ${e.toString()}',
      );
    }
  }
}

/// Exception thrown by activity datasource
class ActivityDatasourceException implements Exception {
  /// Creates an [ActivityDatasourceException]
  const ActivityDatasourceException(this.message);

  /// Error message
  final String message;

  @override
  String toString() => 'ActivityDatasourceException: $message';
}
