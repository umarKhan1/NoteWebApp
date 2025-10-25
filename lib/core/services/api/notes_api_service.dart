import '../../network/http_client.dart';

/// API service for notes operations
class NotesApiService {
  /// Creates a new [NotesApiService].
  NotesApiService(this._httpClient);

  /// HTTP client instance
  final HttpClient _httpClient;

  /// Endpoint for notes
  static const String _endpoint = '/notes';

  /// Get all notes
  Future<List<dynamic>> getNotes() async {
    try {
      final response = await _httpClient.get(_endpoint);
      return response is List ? response : [];
    } catch (e) {
      rethrow;
    }
  }

  /// Get note by ID
  Future<Map<String, dynamic>> getNoteById(String id) async {
    try {
      final response = await _httpClient.get('$_endpoint/$id');
      return response as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  /// Create note
  Future<Map<String, dynamic>> createNote({
    required String title,
    required String content,
    required String category,
    required bool isPinned,
  }) async {
    try {
      final response = await _httpClient.post(
        _endpoint,
        body: {
          'title': title,
          'content': content,
          'category': category,
          'isPinned': isPinned,
        },
      );
      return response as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  /// Update note
  Future<Map<String, dynamic>> updateNote({
    required String id,
    required String title,
    required String content,
    required String category,
    required bool isPinned,
  }) async {
    try {
      final response = await _httpClient.put(
        '$_endpoint/$id',
        body: {
          'title': title,
          'content': content,
          'category': category,
          'isPinned': isPinned,
        },
      );
      return response as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  /// Delete note
  Future<void> deleteNote(String id) async {
    try {
      await _httpClient.delete('$_endpoint/$id');
    } catch (e) {
      rethrow;
    }
  }

  /// Search notes
  Future<List<dynamic>> searchNotes(String query) async {
    try {
      final response = await _httpClient.get('$_endpoint/search?q=$query');
      return response is List ? response : [];
    } catch (e) {
      rethrow;
    }
  }

  /// Get notes by category
  Future<List<dynamic>> getNotesByCategory(String category) async {
    try {
      final response = await _httpClient.get('$_endpoint/category/$category');
      return response is List ? response : [];
    } catch (e) {
      rethrow;
    }
  }
}
