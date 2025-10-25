import 'package:flutter_test/flutter_test.dart';
import 'package:notewebapp/features/dashboard/data/services/mock_dashboard_service.dart';
import 'package:notewebapp/features/notes/data/services/local_notes_service.dart';
import 'package:notewebapp/features/notes/data/services/mock_notes_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('MockDashboardService Tests', () {
    final dashboardService = MockDashboardService();

    setUp(() async {
      // Initialize SharedPreferences for testing
      SharedPreferences.setMockInitialValues({});
      await LocalNotesService.initialize();

      // Clear any existing notes
      await LocalNotesService.clearNotes();

      // Reinitialize MockNotesService
      await MockNotesService.initialize();
    });

    tearDown(() async {
      await LocalNotesService.clearNotes();
    });

    test('getDashboardStats returns zero stats for empty notes list', () async {
      final stats = await dashboardService.getDashboardStats();

      expect(stats.totalNotes, 0);
      expect(stats.todayNotes, 0);
      expect(stats.totalCategories, 0);
      expect(stats.pinnedNotes, 0);
    });

    test('getDashboardStats counts total notes correctly', () async {
      // Create test notes
      await MockNotesService.createNote(title: 'Note 1', content: 'Content 1');
      await MockNotesService.createNote(title: 'Note 2', content: 'Content 2');
      await MockNotesService.createNote(title: 'Note 3', content: 'Content 3');

      final stats = await dashboardService.getDashboardStats();

      expect(stats.totalNotes, 3);
    });

    test('getDashboardStats counts today notes correctly', () async {
      // Create notes for today
      await MockNotesService.createNote(
        title: 'Today Note 1',
        content: 'Content',
      );
      await MockNotesService.createNote(
        title: 'Today Note 2',
        content: 'Content',
      );

      final stats = await dashboardService.getDashboardStats();

      expect(stats.todayNotes, 2);
    });

    test('getDashboardStats counts pinned notes correctly', () async {
      // Create and pin notes
      await MockNotesService.createNote(
        title: 'Pinned Note',
        content: 'Content',
        isPinned: true,
      );
      await MockNotesService.createNote(
        title: 'Unpinned Note',
        content: 'Content',
        isPinned: false,
      );

      final stats = await dashboardService.getDashboardStats();

      expect(stats.pinnedNotes, 1);
    });

    test('getDashboardStats counts categories correctly', () async {
      await MockNotesService.createNote(
        title: 'Work Note',
        content: 'Content',
        category: 'Work',
      );
      await MockNotesService.createNote(
        title: 'Personal Note',
        content: 'Content',
        category: 'Personal',
      );
      await MockNotesService.createNote(
        title: 'Another Work',
        content: 'Content',
        category: 'Work',
      );

      final stats = await dashboardService.getDashboardStats();

      expect(stats.totalCategories, 2);
    });

    test('getDashboardStats persists across service calls', () async {
      // Create notes
      await MockNotesService.createNote(
        title: 'Test Note',
        content: 'Content',
        isPinned: true,
      );

      // Get stats twice
      final stats1 = await dashboardService.getDashboardStats();
      final stats2 = await dashboardService.getDashboardStats();

      expect(stats1.totalNotes, stats2.totalNotes);
      expect(stats1.pinnedNotes, stats2.pinnedNotes);
    });

    test('getRecentActivity returns empty for no notes', () async {
      final activities = await dashboardService.getRecentActivity();

      expect(activities.isEmpty, true);
    });

    test('getRecentActivity generates activities from notes', () async {
      await MockNotesService.createNote(
        title: 'First Note',
        content: 'Content',
      );
      await MockNotesService.createNote(
        title: 'Second Note',
        content: 'Content',
        isPinned: true,
      );

      final activities = await dashboardService.getRecentActivity();

      expect(activities.isNotEmpty, true);
      expect(activities.length, 2);
    });

    test('getRecentActivity truncates long titles', () async {
      await MockNotesService.createNote(
        title: 'This is a very long note title that should be truncated',
        content: 'Content',
      );

      final activities = await dashboardService.getRecentActivity();

      expect(activities[0].contains('...'), true);
    });

    test('getDashboardStats updates after creating new note', () async {
      var stats = await dashboardService.getDashboardStats();
      expect(stats.totalNotes, 0);

      await MockNotesService.createNote(title: 'New Note', content: 'Content');

      stats = await dashboardService.getDashboardStats();
      expect(stats.totalNotes, 1);
    });

    test('getDashboardStats updates after deleting note', () async {
      final note = await MockNotesService.createNote(
        title: 'Note to Delete',
        content: 'Content',
      );

      var stats = await dashboardService.getDashboardStats();
      expect(stats.totalNotes, 1);

      await MockNotesService.deleteNote(note.id);

      stats = await dashboardService.getDashboardStats();
      expect(stats.totalNotes, 0);
    });

    test('getDashboardStats updates after pinning note', () async {
      final note = await MockNotesService.createNote(
        title: 'Test Note',
        content: 'Content',
        isPinned: false,
      );

      var stats = await dashboardService.getDashboardStats();
      expect(stats.pinnedNotes, 0);

      await MockNotesService.togglePinNote(note.id);

      stats = await dashboardService.getDashboardStats();
      expect(stats.pinnedNotes, 1);
    });
  });
}
