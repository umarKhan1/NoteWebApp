import '../../../notes/data/services/mock_notes_service.dart';
import '../../domain/entities/dashboard_stats.dart';

/// Mock service for dashboard data (dynamically calculated from persisted notes)
class MockDashboardService {
  /// Get dashboard statistics (calculated from persisted notes)
  Future<DashboardStats> getDashboardStats() async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Load all notes from persistent storage
    final allNotes = await MockNotesService.getAllNotes();

    // Calculate total notes
    final totalNotes = allNotes.length;

    // Calculate today's notes
    final today = DateTime.now();
    final todayNotes = allNotes.where((note) {
      final noteDate = note.createdAt;
      return noteDate.year == today.year &&
          noteDate.month == today.month &&
          noteDate.day == today.day;
    }).length;

    // Calculate unique categories
    final categories = <String>{};
    for (final note in allNotes) {
      if (note.category != null && note.category!.isNotEmpty) {
        categories.add(note.category!);
      }
    }
    final totalCategories = categories.length;

    // Calculate pinned notes
    final pinnedNotes = allNotes.where((note) => note.isPinned).length;

    return DashboardStats(
      totalNotes: totalNotes,
      todayNotes: todayNotes,
      totalCategories: totalCategories,
      pinnedNotes: pinnedNotes,
    );
  }

  /// Get recent activity (calculated from persisted notes)
  Future<List<String>> getRecentActivity() async {
    await Future.delayed(const Duration(milliseconds: 300));

    // Load all notes from persistent storage
    final allNotes = await MockNotesService.getAllNotes();

    // Return empty list if no notes (caller will handle display)
    if (allNotes.isEmpty) {
      return [];
    }

    // Sort by updated date (most recent first)
    final sortedNotes = List.from(allNotes)
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    // Generate activity messages from recent notes (up to 10)
    final activities = <String>[];
    for (
      var i = 0;
      i < (sortedNotes.length > 10 ? 10 : sortedNotes.length);
      i++
    ) {
      final note = sortedNotes[i];

      // Truncate title if too long
      final displayTitle = note.title.length > 30
          ? '${note.title.substring(0, 27)}...'
          : note.title;

      // Check if it was created today or updated today
      final today = DateTime.now();
      final isToday =
          note.updatedAt.year == today.year &&
          note.updatedAt.month == today.month &&
          note.updatedAt.day == today.day;

      if (isToday) {
        if (note.isPinned) {
          activities.add('Pinned "$displayTitle"');
        } else {
          activities.add('Updated "$displayTitle"');
        }
      } else {
        activities.add('Created "$displayTitle"');
      }
    }

    return activities;
  }
}
