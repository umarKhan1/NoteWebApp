import 'package:flutter_test/flutter_test.dart';
import 'package:notewebapp/features/dashboard/domain/entities/activity.dart';
import 'package:notewebapp/features/dashboard/domain/entities/dashboard_stats.dart';
import 'package:notewebapp/features/dashboard/presentation/cubit/dashboard_state.dart';

void main() {
  group('DashboardState', () {
    final mockStats = const DashboardStats(
      totalNotes: 10,
      todayNotes: 3,
      totalCategories: 5,
      pinnedNotes: 2,
    );

    test('DashboardInitial state', () {
      final state = DashboardInitial();
      expect(state, isA<DashboardInitial>());
    });

    test('DashboardLoading state', () {
      final state = DashboardLoading();
      expect(state, isA<DashboardLoading>());
    });

    test('DashboardLoaded state with activities', () {
      final activities = [
        Activity(
          id: '1',
          type: ActivityType.noteCreated,
          title: 'Note 1',
          description: 'Created Note 1',
          timestamp: DateTime.now(),
        ),
        Activity(
          id: '2',
          type: ActivityType.noteUpdated,
          title: 'Note 2',
          description: 'Updated Note 2',
          timestamp: DateTime.now(),
        ),
      ];

      final state = DashboardLoaded(
        stats: mockStats,
        recentActivity: activities,
      );

      expect(state, isA<DashboardLoaded>());
      expect(state.recentActivity.length, 2);
      expect(state.recentActivity[0].type, ActivityType.noteCreated);
      expect(state.recentActivity[1].type, ActivityType.noteUpdated);
    });

    test('DashboardLoaded state with empty activities', () {
      final state = DashboardLoaded(stats: mockStats, recentActivity: const []);

      expect(state.recentActivity.isEmpty, true);
      expect(state.recentActivity.length, 0);
    });

    test('DashboardError state', () {
      const message = 'Failed to load dashboard';
      final state = const DashboardError(message);

      expect(state, isA<DashboardError>());
      expect(state.message, message);
    });

    test('DashboardLoaded preserves activity order', () {
      final now = DateTime.now();
      final activities = [
        Activity(
          id: '1',
          type: ActivityType.noteCreated,
          title: 'First',
          description: 'First activity',
          timestamp: now.subtract(const Duration(minutes: 5)),
        ),
        Activity(
          id: '2',
          type: ActivityType.noteUpdated,
          title: 'Second',
          description: 'Second activity',
          timestamp: now.subtract(const Duration(minutes: 2)),
        ),
        Activity(
          id: '3',
          type: ActivityType.notePinned,
          title: 'Third',
          description: 'Third activity',
          timestamp: now,
        ),
      ];

      final state = DashboardLoaded(
        stats: mockStats,
        recentActivity: activities,
      );

      expect(state.recentActivity[0].title, 'First');
      expect(state.recentActivity[1].title, 'Second');
      expect(state.recentActivity[2].title, 'Third');
    });

    test('Multiple DashboardLoaded states can have different activities', () {
      final activities1 = [
        Activity(
          id: '1',
          type: ActivityType.noteCreated,
          title: 'Note A',
          description: 'Created A',
          timestamp: DateTime.now(),
        ),
      ];

      final activities2 = [
        Activity(
          id: '2',
          type: ActivityType.noteDeleted,
          title: 'Note B',
          description: 'Deleted B',
          timestamp: DateTime.now(),
        ),
        Activity(
          id: '3',
          type: ActivityType.notePinned,
          title: 'Note C',
          description: 'Pinned C',
          timestamp: DateTime.now(),
        ),
      ];

      final state1 = DashboardLoaded(
        stats: mockStats,
        recentActivity: activities1,
      );
      final state2 = DashboardLoaded(
        stats: mockStats,
        recentActivity: activities2,
      );

      expect(state1.recentActivity.length, 1);
      expect(state2.recentActivity.length, 2);
      expect(state1.recentActivity[0].title, 'Note A');
      expect(state2.recentActivity[0].title, 'Note B');
    });

    test('DashboardLoaded limits to 5 activities for dashboard display', () {
      final activities = List.generate(
        10,
        (i) => Activity(
          id: '$i',
          type: ActivityType.noteCreated,
          title: 'Note $i',
          description: 'Created Note $i',
          timestamp: DateTime.now().subtract(Duration(minutes: i)),
        ),
      );

      // Dashboard should only display first 5
      final displayActivities = activities.take(5).toList();
      final state = DashboardLoaded(
        stats: mockStats,
        recentActivity: displayActivities,
      );

      expect(state.recentActivity.length, 5);
    });
  });
}
