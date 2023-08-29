import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../lib/models/User.dart'; // Update this import based on your project structure

void main() {
  group('User class tests', () {
    // Could not test fromDocumentSnapshot because it uses a
    // DocumentSnapshot which is a final class and cannot be extended?

    test('User.toMap should convert user to a map', () {
      final user = User(
        uid: 'user123',
        email: 'user@example.com',
        name: 'John Doe',
        creationTimestamp: Timestamp.now(),
        landingPageTitle: 'Welcome to my page',
        landingPageDescription: 'This is my landing page',
        imageURL: 'https://example.com/image.jpg',
      );
      final userMap = user.toMap();

      expect(userMap['uid'], 'user123');
      expect(userMap['email'], 'user@example.com');
      expect(userMap['name'], 'John Doe');
      // Add more assertions for other properties
    });

    // Write more tests for other methods (create, update, delete, getFirstUser)
  });
}
