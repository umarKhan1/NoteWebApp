import 'package:flutter_test/flutter_test.dart';
import 'package:notewebapp/features/dashboard/domain/entities/activity.dart';
import 'package:notewebapp/features/dashboard/domain/repositories/activity_repository.dart';
import 'package:notewebapp/features/dashboard/domain/services/activity_service.dart';

class FakeActivityRepository implements ActivityRepository {
  final List<Activity> _activities = [];

  @override
  Future<void> logActivity(String userId, Activity activity) async {
    _activities.add(activity);
  }

  @override
  Future<List<Activity>> getActivities(String userId) async {
    return _activities;
  }

  @override
  Future<List<Activity>> getRecentActivities(
    String userId, {
    int limit = 10,
  }) async {
    return _activities.take(limit).toList();
  }

  @override
  Future<void> clearActivities(String userId) async {
    _activities.clear();
  }

  @override
  Future<void> deleteActivity(String userId, String activityId) async {
    _activities.removeWhere((a) => a.id == activityId);
  }

  @override
  Future<int> getActivityCount(String userId) async {
    return _activities.length;
  }
}

void main() {
  group('ActivityService', () {
    late ActivityService activityService;
    late FakeActivityRepository fakeRepository;

    setUp(() {
      fakeRepository = FakeActivityRepository();
      activityService = ActivityService(fakeRepository);
    });

    test('logNoteCreated should create an activity', () async {
      await activityService.logNoteCreated('user1', 'Test Note', 'note1');

      final activities = await fakeRepository.getActivities('user1');
      expect(activities.length, 1);
      expect(activities[0].type, ActivityType.noteCreated);
      expect(activities[0].title, 'Test Note');
    });

    test('logNoteUpdated should create an activity', () async {
      await activityService.logNoteUpdated('user1', 'Updated Note', 'note1');

      final activities = await fakeRepository.getActivities('user1');
      expect(activities.length, 1);
      expect(activities[0].type, ActivityType.noteUpdated);
      expect(activities[0].title, 'Updated Note');
    });

    test('logNoteDeleted should create an activity', () async {
      await activityService.logNoteDeleted('user1', 'Deleted Note');

      final activities = await fakeRepository.getActivities('user1');
      expect(activities.length, 1);
      expect(activities[0].type, ActivityType.noteDeleted);
      expect(activities[0].title, 'Deleted Note');
    });

    test('logNotePinned should create an activity', () async {
      await activityService.logNotePinned('user1', 'Pinned Note', 'note1');

      final activities = await fakeRepository.getActivities('user1');
      expect(activities.length, 1);
      expect(activities[0].type, ActivityType.notePinned);
      expect(activities[0].title, 'Pinned Note');
    });

    test('logNoteUnpinned should create an activity', () async {
      await activityService.logNoteUnpinned('user1', 'Unpinned Note', 'note1');

      final activities = await fakeRepository.getActivities('user1');
      expect(activities.length, 1);
      expect(activities[0].type, ActivityType.noteUnpinned);
      expect(activities[0].title, 'Unpinned Note');
    });

    test('multiple activities should be logged independently', () async {
      await activityService.logNoteCreated('user1', 'Note 1', 'note1');
      await activityService.logNoteUpdated('user1', 'Note 1 Updated', 'note1');
      await activityService.logNotePinned('user1', 'Note 1 Updated', 'note1');

      final activities = await fakeRepository.getActivities('user1');
      expect(activities.length, 3);
      expect(activities[0].type, ActivityType.noteCreated);
      expect(activities[1].type, ActivityType.noteUpdated);
      expect(activities[2].type, ActivityType.notePinned);
    });

    test('activity description should include note title', () async {
      await activityService.logNoteCreated('user1', 'My Test Note', 'note1');

      final activities = await fakeRepository.getActivities('user1');
      expect(activities[0].description, contains('My Test Note'));
    });

    test('activity should have a timestamp', () async {
      final beforeTime = DateTime.now();
      await activityService.logNoteCreated('user1', 'Test Note', 'note1');
      final afterTime = DateTime.now();

      final activities = await fakeRepository.getActivities('user1');
      expect(activities[0].timestamp, isNotNull);
      // ignore: prefer_const_constructors
      expect(
        activities[0].timestamp.isAfter(
          beforeTime.subtract(const Duration(seconds: 1)),
        ),
        true,
      );
      expect(
        activities[0].timestamp.isBefore(
          afterTime.add(const Duration(seconds: 1)),
        ),
        true,
      );
    });

    test('logCustomActivity should log custom activity', () async {
      final customActivity = Activity(
        id: 'test-id',
        type: ActivityType.noteCreated,
        title: 'Custom Activity',
        description: 'This is a custom activity',
        timestamp: DateTime.now(),
      );

      await activityService.logCustomActivity('user1', customActivity);

      final activities = await fakeRepository.getActivities('user1');
      expect(activities.length, 1);
      expect(activities[0].title, 'Custom Activity');
      expect(activities[0].description, 'This is a custom activity');
    });
  });
}
