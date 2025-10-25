import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/note.dart';

/// Service for managing local note persistence using SharedPreferences
class LocalNotesService {
  static const String _notesStorageKey = 'notes_list';
  static late SharedPreferences _prefs;

  /// Initialize the service by loading SharedPreferences instance
  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Load all notes from local storage
  static Future<List<Note>> loadNotes() async {
    try {
      final jsonString = _prefs.getString(_notesStorageKey);
      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }

      final jsonList = json.decode(jsonString) as List;
      return jsonList
          .map((item) => Note.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // Error loading notes from local storage
      return [];
    }
  }

  /// Save notes to local storage
  static Future<bool> saveNotes(List<Note> notes) async {
    try {
      final jsonList = notes.map((note) => note.toJson()).toList();
      final jsonString = json.encode(jsonList);
      return await _prefs.setString(_notesStorageKey, jsonString);
    } catch (e) {
      // Error saving notes to local storage
      return false;
    }
  }

  /// Clear all notes from local storage
  static Future<bool> clearNotes() async {
    try {
      return await _prefs.remove(_notesStorageKey);
    } catch (e) {
      // Error clearing notes from local storage
      return false;
    }
  }
}
