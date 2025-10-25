import 'package:flutter_test/flutter_test.dart';
import 'package:notewebapp/core/utils/user_utils.dart';

void main() {
  group('UserUtils', () {
    test('getDefaultUserId should return a valid default user ID', () {
      // Act
      final userId = UserUtils.getDefaultUserId();

      // Assert
      expect(userId, isNotEmpty);
      expect(userId, isA<String>());
      expect(userId, equals('user_default_001'));
    });

    test('getDefaultUserId should be consistent', () {
      // Act
      final userId1 = UserUtils.getDefaultUserId();
      final userId2 = UserUtils.getDefaultUserId();

      // Assert
      expect(userId1, equals(userId2));
    });

    test('getDefaultUserId should not be null or empty', () {
      // Act
      final userId = UserUtils.getDefaultUserId();

      // Assert
      expect(userId.isNotEmpty, true);
      expect(userId.length, greaterThan(0));
    });

    test('Default user ID should follow naming convention', () {
      // Act
      final userId = UserUtils.getDefaultUserId();

      // Assert
      expect(userId.contains('user'), true);
      expect(userId, matches(RegExp(r'^user_.*')));
    });
  });
}
